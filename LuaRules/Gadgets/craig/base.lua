-- Author: Tobi Vollebregt
-- License: GNU General Public License v2

--[[
This class is implemented as a single function returning a table with public
interface methods.  Private data is stored in the function's closure.

Public interface:

local BaseMgr = CreateBaseMgr(myTeamID, myAllyTeamID, Log)

function BaseMgr.GameFrame(f)
function BaseMgr.UnitCreated(unitID, unitDefID, unitTeam, builderID)
function BaseMgr.UnitFinished(unitID, unitDefID, unitTeam)
function BaseMgr.UnitDestroyed(unitID, unitDefID, unitTeam, attackerID, attackerDefID, attackerTeam)

Possible improvements:
- Give baseBuilders a GUARD order just after they are finished, so they don't
  wander off towards the enemy first, and then later come back to help building.
  (Take care of them blocking the factory in case they can assist building from
  inside the factory...)
- Rebuild destroyed buildings with higher priority then continuing on BO.
- Split base builder group in two groups when it becomes too big. This would
  allow it to truely expand exponentionally :-)
]]--

function CreateBaseMgr(myTeamID, myAllyTeamID, Log)

local BaseMgr = {}

local MIN_INT, MAX_INT = -2147483648, 2147483648
local MAX_SIMTIME = 30.0 * 60  -- 30 minutes
local METAL_PULL_PUSH_FACTOR = 10.0
local MAX_SQUAD_SIZE = 10.0
local MAX_E_STORAGE = 15000.0
local MAX_FLAG_CAPTURE_CAPACITY = 10.0 * 500
local MAX_LOS_CAPACITY = math.max(Game.mapSizeX, Game.mapSizeZ) / 10.0
local MAX_CONSTRUCTORS = 5.0
local MAX_UNIT_IN_FACTORIES = 5.0

-- If in 1 minute the building chain has not any progress, we are giving up and
-- starting a new one
local CHAIN_GIVING_UP_TIME = 1.0 * 60.0

-- speedups
local CMD_WAIT = CMD.WAIT
local random, min, max = math.random, math.min, math.max
local GetUnitDefID       = Spring.GetUnitDefID
local GetGameSeconds     = Spring.GetGameSeconds
local GetUnitCommands    = Spring.GetUnitCommands
local GetFactoryCommands = Spring.GetFactoryCommands

-- Squads
local squadDefs = VFS.Include("LuaRules/Configs/squad_defs.lua")
local sortieDefs = VFS.Include("LuaRules/Configs/sortie_defs.lua")
for name, data in pairs(sortieDefs) do
    squadDefs[name] = {
        members = data.members
    }
end

-- tools
local buildsiteFinderModule = VFS.Include("LuaRules/Gadgets/craig/base/buildsite.lua")
local unit_chains = VFS.Include("LuaRules/Gadgets/craig/base/unit_reqs.lua")
local unit_scores = VFS.Include("LuaRules/Gadgets/craig/base/unit_score.lua")
local buildsiteFinder = buildsiteFinderModule.CreateBuildsiteFinder(myTeamID)

-- Base building capabilities
local myConstructors = {}    -- Units which may build the base
local myFactories = {}       -- Factories already available, with their queue
local myFactoriesScore = {}  -- Score associated to the factory

local function GetBuildingChains()
    local producers = {}
    for u, _ in pairs(myConstructors) do
        producers[GetUnitDefID(u)] = u
    end
    for u, _ in pairs(myFactories) do
        producers[GetUnitDefID(u)] = u
    end

    local chains = {}
    for unitDefID, unitID in pairs(producers) do
        local subchains = unit_chains.GetBuildCriticalLines(unitDefID)
        for target, chain in pairs(subchains) do
            if (chains[target] == nil) or (chains[target].metal > chain.metal) then
                chains[target] = {
                    builder = unitID,
                    metal = chain.metal,
                    units = chain.units,
                }
            end
        end
    end

    return chains
end

-- Chain of units to reach the target
local selected_chain = nil
local n_view, n_cap, n_constructor = 0, 0, 0
local gann = gadget.base_gann

local function __clamp(v, min_val, max_val)
    min_val = min_val ~= nil and min_val or -1
    max_val = max_val ~= nil and max_val or 1    
    return min(max(v, min_val), max_val)
end

local function __canBuild(builderDefID, unitDefID)
    local children = UnitDefs[builderDefID].buildOptions
    for _, c in ipairs(children) do
        if c == unitDefID or (UnitDefs[c] and (UnitDefs[c].id == unitDefID)) then
            return true
        end
    end
    return false
end

local function GetAllBuilders(unitDefID)
    local builders = {}
    for u,_ in pairs(myConstructors) do
        if __canBuild(GetUnitDefID(u), unitDefID) then
            builders[#builders + 1] = u
        end
    end
    for u,_ in pairs(myFactories) do
        if __canBuild(GetUnitDefID(u), unitDefID) then
            builders[#builders + 1] = u
        end
    end
    return builders
end

local function BasicTraining(unitDef, inputs, score)
    if inputs.construction_capacity < 0.01 and inputs.unit_is_constructor > 0.5 and score < 0.9 then
        Log("  However, it was expected to score > 0.9, because...")
        Log("  construction_capacity = " .. tostring(inputs.construction_capacity))
        Log("  unit_is_constructor = " .. tostring(inputs.unit_is_constructor))
        base_gann.Train(myTeamID, inputs, {score = 1.0})
    elseif inputs.construction_capacity > 0.99 and inputs.unit_is_constructor > 0.5 and score > 0.1 then
        Log("  However, it was expected to score < 0.1, because...")
        Log("  construction_capacity = " .. tostring(inputs.construction_capacity))
        Log("  unit_is_constructor = " .. tostring(inputs.unit_is_constructor))
        base_gann.Train(myTeamID, inputs, {score = 0.0})
    elseif inputs.capturing_capacity > score and inputs.unit_cap > 0.49 then
        Log("  However, it was expected to score > " .. tostring(inputs.capturing_capacity) .. " because...")
        Log("  capturing_capacity = " .. tostring(inputs.capturing_capacity))
        Log("  unit_cap = " .. tostring(inputs.unit_cap))
        base_gann.Train(myTeamID, inputs, {score = inputs.capturing_capacity})
    elseif (1.0 - inputs.los_capacity) * inputs.unit_view > score then
        Log("  However, it was expected to score > " .. tostring((1.0 - inputs.los_capacity) * inputs.unit_view) .. " because...")
        Log("  los_capacity = " .. tostring(inputs.los_capacity))
        Log("  unit_view = " .. tostring(inputs.unit_view))
        base_gann.Train(myTeamID, inputs, {score = (1.0 - inputs.los_capacity) * inputs.unit_view})
    end
end

local function ChainScore(target, chain)
    local unitDef = UnitDefNames[target]

    -- For the time being, ignore air units
    if unitDef.canFly then
        return MIN_INT
    end

    local mCurr, mStor, mPull, mInco = Spring.GetTeamResources(myTeamID, "metal")
    local eCurr, eStor = Spring.GetTeamResources(myTeamID, "energy")

    local score = MIN_INT
    local base_gann_inputs = {
        sim_time = __clamp(Spring.GetGameSeconds() / MAX_SIMTIME),
        metal_curr = __clamp(mCurr / mStor),
        metal_push = __clamp(METAL_PULL_PUSH_FACTOR * mInco / mStor),
        metal_pull = __clamp(METAL_PULL_PUSH_FACTOR * mPull / mStor),
        energy_curr = __clamp(eCurr / eStor),
        energy_storage = __clamp(eStor / MAX_E_STORAGE),
        capturing_capacity = __clamp(n_cap / MAX_FLAG_CAPTURE_CAPACITY),
        los_capacity = __clamp(n_view / MAX_LOS_CAPACITY),
        construction_capacity = __clamp(n_constructor / MAX_CONSTRUCTORS),
        chain_cost = __clamp((chain.metal - unitDef.metalCost) / mStor),
        unit_cost = __clamp(unitDef.metalCost / mStor),
        unit_in_factories = __clamp(#GetAllBuilders(unitDef.id) / MAX_UNIT_IN_FACTORIES),
    }
    if squadDefs[unitDef.name] == nil then
        local firepower, accuracy, penetration, range = unit_scores.GetUnitWeaponsFeatures(unitDef)
        local armour = unit_scores.GetUnitArmour(unitDef)

        base_gann_inputs.squad_size = 1.0 / MAX_SQUAD_SIZE
        base_gann_inputs.unit_storage = __clamp(unitDef.energyStorage / 3000.0)
        base_gann_inputs.unit_is_constructor = unit_chains.IsConstructor(unitDef.id) and 1.0 or 0.0
        base_gann_inputs.unit_cap = __clamp((unitDef.customParams.flagcaprate or 0) / 10.0)
        base_gann_inputs.unit_view = __clamp(unitDef.losRadius / 1000.0 / MAX_SQUAD_SIZE)
        base_gann_inputs.unit_speed = __clamp(unitDef.speed / 20.0)
        base_gann_inputs.unit_armour = __clamp(armour / 200.0)
        base_gann_inputs.unit_firepower = __clamp(firepower / 1000.0)
        base_gann_inputs.unit_accuracy = __clamp(accuracy / 2000.0)
        base_gann_inputs.unit_penetration = __clamp(penetration / 200.0)
        base_gann_inputs.unit_range = __clamp(range / 15000.0)
    else
        base_gann_inputs.squad_size = 0.0
        base_gann_inputs.unit_storage = 0.0
        base_gann_inputs.unit_is_constructor = 0.0
        base_gann_inputs.unit_cap = 0.0
        base_gann_inputs.unit_view = 0.0
        base_gann_inputs.unit_speed = 0.0
        base_gann_inputs.unit_armour = 0.0
        base_gann_inputs.unit_firepower = 0.0
        base_gann_inputs.unit_accuracy = 0.0
        base_gann_inputs.unit_penetration = 0.0
        base_gann_inputs.unit_range = 0.0

        for _, member in ipairs(squadDefs[unitDef.name].members) do
            local udef = UnitDefNames[member]

            -- For the time being, ignore air units
            if UnitDefNames[member].canFly then
                return MIN_INT
            end

            local firepower, accuracy, penetration, range = unit_scores.GetUnitWeaponsFeatures(udef)
            local armour = unit_scores.GetUnitArmour(udef)

            base_gann_inputs.squad_size = base_gann_inputs.squad_size + 1
            if unit_chains.IsConstructor(udef.id) then
                base_gann_inputs.unit_is_constructor = 1.0
            end

            base_gann_inputs.unit_storage = base_gann_inputs.unit_storage +
                    udef.energyStorage
            base_gann_inputs.unit_cap = base_gann_inputs.unit_cap +
                    (unitDef.customParams.flagcaprate or 0)
            base_gann_inputs.unit_view = base_gann_inputs.unit_view +
                    udef.losRadius
            base_gann_inputs.unit_speed = base_gann_inputs.unit_speed +
                    udef.speed
            base_gann_inputs.unit_firepower = base_gann_inputs.unit_firepower +
                    firepower
            base_gann_inputs.unit_accuracy = base_gann_inputs.unit_accuracy +
                    accuracy

            if armour > base_gann_inputs.unit_armour then
                base_gann_inputs.unit_armour = armour
            end
            if penetration > base_gann_inputs.unit_penetration then
                base_gann_inputs.unit_penetration = penetration
            end
            if range > base_gann_inputs.unit_range then
                base_gann_inputs.unit_range = range
            end

        end

        base_gann_inputs.unit_storage = base_gann_inputs.unit_storage / 3000.0
        base_gann_inputs.unit_cap = base_gann_inputs.unit_cap / 10.0

        base_gann_inputs.unit_speed = base_gann_inputs.unit_speed /
                (20.0 * base_gann_inputs.squad_size)
        base_gann_inputs.unit_firepower = base_gann_inputs.unit_firepower /
                (1000.0 * base_gann_inputs.squad_size)
        base_gann_inputs.unit_accuracy = base_gann_inputs.unit_accuracy /
                (2000.0 * base_gann_inputs.squad_size)
        base_gann_inputs.unit_storage = base_gann_inputs.unit_storage / 3000.0

        base_gann_inputs.unit_view = base_gann_inputs.unit_view /
                (1000.0 * MAX_SQUAD_SIZE)
        base_gann_inputs.unit_armour = base_gann_inputs.unit_armour / 200.0
        base_gann_inputs.unit_penetration = base_gann_inputs.unit_penetration / 200.0
        base_gann_inputs.unit_range = base_gann_inputs.unit_range / 15000.0

        base_gann_inputs.squad_size = base_gann_inputs.squad_size / MAX_SQUAD_SIZE
    end

    score = base_gann.Evaluate(myTeamID, base_gann_inputs).score
    Log(unitDef.name .. " scored " .. tostring(score))
    if gadget.IsTraining() then
        BasicTraining(unitDef, base_gann_inputs, score)
    end
    return score
end

local function SelectNewBuildingChain()
    local chains = GetBuildingChains()
    local selected, score = nil, MIN_INT / 2
    for target, chain in pairs(chains) do
        local chain_score = ChainScore(target, chain)
        if chain_score > score then
            selected = chain
            score = chain_score
        end
    end
    return selected
end

-- Map of unitDefIDs (buildOption) to unitDefIDs (builders)
local baseBuildOptions = {}

local function updateBuildOptions(unitDefID)
    if unitDefID == nil then
        baseBuildOptions = {}
        for u,_ in pairs(myConstructors) do
            updateBuildOptions(GetUnitDefID(u))
        end
        for u,_ in pairs(myFactories) do
            updateBuildOptions(GetUnitDefID(u))
        end
        return
    end

    for _,bo in ipairs(UnitDefs[unitDefID].buildOptions) do
        if not baseBuildOptions[bo] then
            Log("Base can now build ", UnitDefs[bo].humanName)
            baseBuildOptions[bo] = unitDefID
        end
    end
end

-- Building stuff
local currentBuildDefID     -- one unitDefID
local currentBuildID        -- one unitID
local currentBuilder        -- one unitID
local useClosestBuildSite = true

local function GetABuilder(unitDefID)
    local builder = nil

    local builder_udefid = baseBuildOptions[unitDefID]
    for u,_ in pairs(myConstructors) do
        if builder_udefid == GetUnitDefID(u) then
            builder = u
            break
        end
    end
    if builder ~= nil then
        for u,_ in pairs(myFactories) do
            if builder_udefid == GetUnitDefID(u) then
                builder = u
                break
            end
        end
    end
    
    return builder
end

local function ResolveMorphingCmd(origDefID, destDefID)
    local morphDefs = GG['morphHandler'].GetMorphDefs()[origDefID]
    if morphDefs == nil then
        return -destDefID
    end
    for _, morphDef in pairs(morphDefs) do
        if morphDef.into == destDefID then
            return morphDef.cmd
        end
    end

    return -destDefID
end

local function StartChain()
    local target_udef = UnitDefNames[selected_chain.units[1]]

    -- Let's try to use the already known builder
    local builder = selected_chain.builder
    if not Spring.ValidUnitID(builder) or Spring.GetUnitIsDead(builder) then
        builder = GetABuilder(target_udef.id)
    end

    if builder == nil then
        -- No way to fulfill the asked building chain. Let's the AI select
        -- another chain in the next GameFrame() call
        selected_chain = nil
        return
    end

    -- Ask all the constructors to aid the builder. This is also valid for
    -- factories, so the constructors may try to repair the factory if it is
    -- damaged by artillery
    for u,_ in pairs(myConstructors) do
        if u ~= builder then
            GiveOrderToUnit(u, CMD.GUARD, {builder}, {})
        end
    end

    -- How to build the unit depends mainly on the kind of builder
    local builderDefID = GetUnitDefID(builder)
    if unit_chains.IsConstructor(builderDefID) then
        local cmd = ResolveMorphingCmd(builderDefID, target_udef.id)
        if cmd == -target_udef.id then
            local x,y,z,facing = buildsiteFinder.FindBuildsite(builder, target_udef.id, useClosestBuildSite)
            if not x then
                Log("Could not find buildsite for " .. target_udef.humanName)
                -- Lets select a different chain
                selected_chain = nil
                return
            end

            Log("Queueing in place: ", target_udef.name, " [", x, ", ", y, ", ", z, "] ", facing)
            GiveOrderToUnit(builder, cmd, {x,y,z,facing}, {})
        else
            Log("Queueing unit morph: ", target_udef.name)
            GiveOrderToUnit(builder, cmd, {}, {})
        end
    else
        local cmd = ResolveMorphingCmd(builderDefID, target_udef.id)
        if cmd == -target_udef.id then
            Log("Queueing in factory: ", target_udef.name)
        else
            Log("Queueing factory morph: ", target_udef.name)
        end
        GiveOrderToUnit(builder, cmd, {}, {})
        -- Regardless it is a morph or a proper unit, we are storing the
        -- unitDefID in the queue. If later on it is created as a unit to be
        -- built, we are then replacing the value by the unitID
        if myFactories[builder] == nil then
            myFactories[builder] = {}
        end
        myFactories[builder][#myFactories[builder] + 1] = -target_udef.id
        myFactoriesScore[builder] = MIN_INT  -- The first factory to wait if we are stalling
    end

    -- Set the starting time, to eventually give up at some point
    selected_chain.start_time = Spring.GetGameSeconds()

    currentBuildDefID = target_udef.id
    currentBuilder = builder
end

local function BuildBaseFinished()
    -- Upgrade the chain
    selected_chain.builder = currentBuildID
    table.remove(selected_chain.units, 1)
    -- Restart the state variables
    useClosestBuildSite = true
    currentBuildDefID = nil
    currentBuildID = nil
    currentBuilder = nil

    if #selected_chain.units > 0 then
        -- Continue the plan
        StartChain()
    else
        -- A new chain shall be selected
        selected_chain = nil
    end
end

local function BuildBaseInterrupted()
    -- enforce randomized next buildsite, instead of
    -- hopelessly trying again and again on same place
    useClosestBuildSite = false
    currentBuildDefID = nil
    currentBuildID = nil
    currentBuilder = nil
    selected_chain.retry = selected_chain.retry - 1
    if selected_chain.retry > 1 then
        StartChain()
    else
        -- No-way... Probably the factory is blocked...
        -- Let's look for a different project
        selected_chain = nil
    end
end

-- Factories handling
local unitBuiltBy = {}

local function IdleFactory(unitID)
    if #myFactories[unitID] > 0 then
        -- We still have work to do...
        return
    end

    -- Evaluate the build options
    local unitDefID = GetUnitDefID(unitID)
    local selected, score = nil, MIN_INT / 2
    for _, optDefID in ipairs(UnitDefs[unitDefID].buildOptions) do
        local optDef = UnitDefs[optDefID]
        local chain_phony = {metal=optDef.metalCost}
        local optName = optDef.name
        local chain_score = ChainScore(optName, chain_phony)
        if chain_score > score then
            selected = optDefID
            score = chain_score
        end
    end

    if selected == nil then
        -- Nothing to do
        return        
    end

    Log("Queueing in factory: ", UnitDefs[selected].name, ", ", UnitDefs[selected].humanName, selected)
    GiveOrderToUnit(unitID, ResolveMorphingCmd(unitDefID, selected), {}, {})

    -- For the time being, add the unitDefID to the queue. Later on, when the
    -- actual unit is created to be built, we are replacing this by the actual
    -- unitID
    myFactories[unitID][#myFactories[unitID] + 1] = -selected
    myFactoriesScore[unitID] = score
end

local function isBuilderIdle(unitID)
    if myFactories[unitID] ~= nil then
        local isIdle = (GetFactoryCommands(unitID, 0) or 0) == 0
        if isIdle then
            myFactories[unitID] = {}
        end
        return isIdle
    elseif myConstructors[unitID] ~= nil then
        return (GetUnitCommands(unitID, 0) or 0) == 0
    end

    return nil
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--
--  The call-in routines
--

local waiting_builders = {}

function BaseMgr.GameFrame(f)
    -- Check if the building chain is not progressing, so we must move to a new
    -- one
    if not currentBuildID and selected_chain and selected_chain.start_time then
        if Spring.GetGameSeconds() - selected_chain.start_time > CHAIN_GIVING_UP_TIME then
            selected_chain = nil
        end
    end

    if selected_chain == nil then
        selected_chain = SelectNewBuildingChain()
        if selected_chain then
            Log("Starting a new chain to reach " .. selected_chain.units[#selected_chain.units])
            selected_chain.retry = 3
            StartChain()
        else
            Log("No way I can build nothing new!!!")
        end
        return
    end

    if currentBuildDefID and isBuilderIdle(currentBuilder) then
        Log(UnitDefs[currentBuildDefID].humanName, " was finished/aborted, but neither UnitFinished nor UnitDestroyed was called")
        BuildBaseInterrupted()
    end

    for u,q in pairs(myFactories) do
        if #q == 0 then
            Log("Factory " .. UnitDefs[GetUnitDefID(u)].name .. " hanged...")
            IdleFactory(u)
        end
    end

    local mCurr, mStor = Spring.GetTeamResources(myTeamID, "metal")
    if mCurr / mStor < 0.05 then
        -- We are stalling, put some units to wait
        if #waiting_builders == 0 then
            -- Let's start putting the constructors in waiting mode
            waiting_builders[1] = {}
            for u, _ in pairs(myConstructors) do
                GiveOrderToUnit(u, CMD_WAIT, {}, {})
                waiting_builders[1][#(waiting_builders[1]) + 1] = u
            end
        else
            -- Look for the worst scored factory to ask it to wait
            local score, factory = MAX_INT, nil
            for u, s in pairs(myFactoriesScore) do
                if s < score then
                    score, factory = s, u
                end
            end
            if factory ~= nil then
                GiveOrderToUnit(factory, CMD_WAIT, {}, {})
                waiting_builders[#waiting_builders + 1] = {factory}
            end
        end
    elseif #waiting_builders > 0 then
        -- We are not stalling anymore, let a factory to start the work again
        for _, u in ipairs(waiting_builders[#(waiting_builders)]) do
            Spring.Echo("Release wait", u)
            GiveOrderToUnit(u, CMD_WAIT, {}, {})
        end
        waiting_builders[#waiting_builders] = nil
    end
end

function BaseMgr.UnitCreated(unitID, unitDefID, unitTeam, builderID)
    buildsiteFinder.UnitCreated(unitID, unitDefID, unitTeam)

    if (not currentBuildID) and (unitDefID == currentBuildDefID) and (builderID == currentBuilder) then
        currentBuildID = unitID
    end

    if myFactories[builderID] ~= nil then
        unitBuiltBy[unitID] = builderID
        -- Replace the unitDefID in the queue by the actual unitID
        for i, udefid in ipairs(myFactories[builderID]) do
            if -udefid == unitDefID then
                myFactories[builderID][i] = unitID
                return
            end
        end
    end
end

function BaseMgr.UnitFinished(unitID, unitDefID, unitTeam)
    if (unitDefID == currentBuildDefID) and ((not currentBuildID) or (unitID == currentBuildID)) then
        Log("CurrentBuild finished")
        BuildBaseFinished()
    end

    local factory = unitBuiltBy[unitID]
    if factory ~= nil then
        unitBuiltBy[unitID] = nil
        if #myFactories[factory] > 0 then
            table.remove(myFactories[factory], 1)
        end
        IdleFactory(factory)
    end

    -- Upgrade the preferences indicators
    n_view = n_view + UnitDefs[unitDefID].losRadius / 1000.0
    n_cap = n_cap + (UnitDefs[unitDefID].customParams.flagcaprate or 0)

    -- Add the new constructors
    if unit_chains.IsConstructor(unitDefID) then
        n_constructor = n_constructor + 1
        myConstructors[unitID] = true
        updateBuildOptions(unitDefID)
        if currentBuilder then
            GiveOrderToUnit(unitID, CMD.GUARD, {currentBuilder}, {})
        end
        return true --signal Team.UnitFinished that we will control this unit
    end

    if unit_chains.IsFactory(unitDefID) then
        Log("New factory: ", UnitDefs[unitDefID].humanName)
        updateBuildOptions(unitDefID)
        if myFactories[unitID] == nil then
            myFactories[unitID] = {}
        end
        IdleFactory(unitID)
        return false
    end
end

function BaseMgr.UnitDestroyed(unitID, unitDefID, unitTeam, attackerID, attackerDefID, attackerTeam)
    buildsiteFinder.UnitDestroyed(unitID, unitDefID, unitTeam, attackerID, attackerDefID, attackerTeam)

    if (currentBuildID ~= nil) and (unitID == currentBuildID) then
        Log("CurrentBuild destroyed")
        BuildBaseInterrupted()
    end

    local factory = unitBuiltBy[unitID]
    if factory ~= nil then
        unitBuiltBy[unitID] = nil
        if #myFactories[factory] > 0 then
            table.remove(myFactories[factory], 1)
        end
        IdleFactory(factory)
    end

    -- Upgrade the preferences indicators
    n_view = n_view - UnitDefs[unitDefID].losRadius / 1000.0
    n_cap = n_cap + (UnitDefs[unitDefID].customParams.flagcaprate or 0)

    if unit_chains.IsConstructor(unitDefID) then
        n_constructor = n_constructor - 1
        myConstructors[unitID] = nil
        updateBuildOptions()
    end
    if unit_chains.IsFactory(unitDefID) then
        myFactories[unitID] = nil
        updateBuildOptions()
    end
end

return BaseMgr
end
