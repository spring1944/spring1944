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

-- speedups
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
local myConstructors = {}  -- Units which may build the base
local myFactories = {}     -- Factories already available, with their queue

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
local n_view = 0
local evolution = gadget.evolution
local w_ucost
local f_ucost = -0.001
evolution.AddParam("f_ucost_0", 0.5)
evolution.AddParam("f_ucost_t", 0.5)
evolution.AddParam("f_ucost_v", 0.5)
local w_ccost
local f_ccost = -0.0005
evolution.AddParam("f_ccost_0", 0.5)
evolution.AddParam("f_ccost_t", 0.5)
evolution.AddParam("f_ccost_v", 0.5)
local w_cap
local f_cap = 0.01
evolution.AddParam("f_cap_0", 0.5)
evolution.AddParam("f_cap_t", 0.5)
evolution.AddParam("f_cap_v", 0.5)
local w_view
local f_view = 1.0
evolution.AddParam("f_view_0", 0.5)
evolution.AddParam("f_view_t", 0.5)
evolution.AddParam("f_view_v", 0.5)
local w_speed
local f_speed = 0.01
evolution.AddParam("f_speed_0", 0.5)
evolution.AddParam("f_speed_t", 0.5)
local w_supply
local f_supply = 0.05
evolution.AddParam("f_supply_0", 0.5)
evolution.AddParam("f_supply_t", 0.5)
local w_armour
local f_armour = 0.2
evolution.AddParam("f_armour_0", 0.5)
evolution.AddParam("f_armour_t", 0.5)
local w_firepower
local f_firepower = 0.1
evolution.AddParam("f_firepower_0", 0.5)
evolution.AddParam("f_firepower_t", 0.5)
local w_accuracy
local f_accuracy = 0.02
evolution.AddParam("f_accuracy_0", 0.5)
evolution.AddParam("f_accuracy_t", 0.5)
local w_penetration
local f_penetration = 0.05
evolution.AddParam("f_penetration_0", 0.5)
evolution.AddParam("f_penetration_t", 0.5)
local w_range
local f_range = 0.01
evolution.AddParam("f_range_0", 0.5)
evolution.AddParam("f_range_t", 0.5)


local function __evalScoreWeight(factor, name, t, v)
    local v = v or 0
    local w = (evolution.GetParam(myTeamID, name .. "_0") or 0) +
              (evolution.GetParam(myTeamID, name .. "_t") or 0) * t +
              (evolution.GetParam(myTeamID, name .. "_v") or 0) * v
    return factor * w
end

local function __random_bounded(vmin, vmax)
    return vmin + (vmax - vmin) * random()
end

local function UpdateScoreWeights()
    local t = GetGameSeconds() / 900.0 + 1.0
    local mCurr, mStor, mPull, mInco = Spring.GetTeamResources(myTeamID, "metal")
    local eCurr, eStor = Spring.GetTeamResources(myTeamID, "energy")
    w_ucost = __evalScoreWeight(f_ucost, "f_ucost", t, mInco)
    w_ccost = __evalScoreWeight(f_ccost, "f_ccost", t, mInco)
    w_cap = __evalScoreWeight(f_cap, "f_cap", t)
    w_view = __evalScoreWeight(f_view, "f_view", t, n_view / 100)
    w_speed = __evalScoreWeight(f_speed, "f_speed", t)
    w_supply = __evalScoreWeight(f_supply, "f_supply", t)
    w_armour = __evalScoreWeight(f_armour, "f_armour", t)
    w_firepower = __evalScoreWeight(f_firepower, "f_firepower", t)
    w_accuracy = __evalScoreWeight(f_accuracy, "f_accuracy", t)
    w_penetration = __evalScoreWeight(f_penetration, "f_penetration", t)
    w_range = __evalScoreWeight(f_range, "f_range", t)
end

local function ChainScore(target, chain)
    local udef = UnitDefNames[target]
    local unit_cost = udef.metalCost
    local chain_cost = chain.metal - unit_cost

    local score = w_ucost * unit_cost + w_ccost * chain_cost
    if squadDefs[udef.name] == nil then
        score = score + unit_scores.GetUnitScore(udef.id,
                                                 w_cap, w_view, w_speed, w_supply,
                                                 w_armour, w_firepower, w_accuracy,
                                                 w_penetration, w_range)
    else
        for _, member in ipairs(squadDefs[udef.name].members) do
            score = score + unit_scores.GetUnitScore(UnitDefNames[member].id,
                                                     w_cap, w_view, w_speed, w_supply,
                                                     w_armour, w_firepower, w_accuracy,
                                                     w_penetration, w_range)
            
        end
    end
    return score
end

local function SelectNewBuildingChain()
    UpdateScoreWeights()
    local chains = GetBuildingChains()
    local selected, score = nil, 0
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
    if unit_chains.IsConstructor(GetUnitDefID(builder)) then
        local x,y,z,facing = buildsiteFinder.FindBuildsite(builder, target_udef.id, useClosestBuildSite)
        if not x then
            Log("Could not find buildsite for " .. target_udef.humanName)
            -- Lets select a different chain
            selected_chain = nil
            return
        end

        Log("Queueing in place: ", target_udef.humanName, " [", x, ", ", y, ", ", z, "] ", facing)
        GiveOrderToUnit(builder, -target_udef.id, {x,y,z,facing}, {})
    else
        Log("Queueing in factory: ", target_udef.name, ", ", target_udef.humanName)
        GiveOrderToUnit(builder, -target_udef.id, {}, {})
        -- Regardless it is a morph or a proper unit, we are storing the
        -- unitDefID in the queue. If later on it is created as a unit to be
        -- built, we are then replacing the value by the unitID
        if myFactories[builder] == nil then
            myFactories[builder] = {}
        end
        myFactories[builder][#myFactories[builder] + 1] = -target_udef.id
    end

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
    StartChain()
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
    UpdateScoreWeights()
    local selected, score = nil, 0
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
    GiveOrderToUnit(unitID, -selected, {}, {})
    -- For the time being, add the unitDefID to the queue. Later on, when the
    -- actual unit is created to be built, we are replacing this by the actual
    -- unitID
    myFactories[unitID][#myFactories[unitID] + 1] = -selected
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

function BaseMgr.GameFrame(f)
    if selected_chain == nil then
        selected_chain = SelectNewBuildingChain()
        if selected_chain then
            Log("Starting a new chain to reach " .. selected_chain.units[#selected_chain.units])
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

    -- Add the new constructors
    if unit_chains.IsConstructor(unitDefID) then
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
    
    if unit_chains.IsConstructor(unitDefID) then
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
