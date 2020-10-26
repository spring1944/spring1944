-- Author: Tobi Vollebregt
-- License: GNU General Public License v2

--[[
This class is implemented as a single function returning a table with public
interface methods.  Private data is stored in the function's closure.

Public interface:

local BaseMgr = CreateBaseMgr(myTeamID, myAllyTeamID, mySide, Log)

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

function CreateBaseMgr(myTeamID, myAllyTeamID, mySide, Log)

local BaseMgr = {}

-- speedups
local random, min, max = math.random, math.min, math.max
local GetUnitDefID = Spring.GetUnitDefID
local GetGameSeconds = Spring.GetGameSeconds

-- Squads
local squadDefs = VFS.Include("LuaRules/Configs/squad_defs.lua")
local sortieDefs = VFS.Include("LuaRules/Configs/sortie_defs.lua")
for name, data in sortieDefs do
    squadDefs[name] = {
        members = data.members
    }
end

-- tools
local buildsiteFinder = VFS.Include("LuaRules/Gadgets/craig/base/buildsite.lua")
local unit_chains = VFS.Include("LuaRules/Gadgets/craig/base/unit_reqs.lua")
local unit_scores = VFS.Include("LuaRules/Gadgets/craig/base/unit_score.lua")

-- Base building capabilities
local myConstructors = {}  -- Units which may build the base
local myFactories = {}     -- Factories already available (to shortcut chains)

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
            if chains[target] == nil or chains[target].metal > chain.metal then
                chains[target] = {
                    builder = u,
                    metal = chain.metal,
                    units = chain.units,
                }
            end
        end
    end

    return chains
end

-- Chain of units to reach the target
local selected_chain = {}
local w_ucost, wccost, w_cap, w_view, w_speed, w_supply, w_armour, w_firepower, w_accuracy, w_penetration, w_range
local n_view = 0

local function __random_bounded(vmin, vmax)
    return vmin + (vmax - vmin) * random()
end

local function UpdateScoreWeights()
    local t = GetGameSeconds() / 900.0 + 1.0
    w_ucost = -__random_bounded(0.0, 0.001) / t
    w_ccost = -__random_bounded(0.0, 0.0003) / t
    w_view = __random_bounded(max(0, 32 - n_view), max(0.25, 128 - n_view))
    w_speed = __random_bounded(0.0, 0.01)
    w_supply = __random_bounded(0.0, 0.05)
    w_armour = __random_bounded(0.0, 0.2 * t)
    w_firepower = __random_bounded(0.0, 0.1)
    w_accuracy = __random_bounded(0.0, 0.02)
    w_penetration = __random_bounded(0.0, 0.05 * t)
    w_range = __random_bounded(0.0, 0.01 * t)
end

local function ChainScore(target, chain)
    local udef = UnitDefNames[target]
    local unit_cost = udef.buildCostMetal
    local chain_cost = chain.metal - unit_cost

    local score = w_ucost * unit_cost + w_ccost * chain_cost
    if squadDefs[udef.name] == nil then
        score = score + GetUnitScore(udef.id,
                                     w_cap, w_view, w_speed, w_supply,
                                     w_armour, w_firepower, w_acccuracy,
                                     w_penetration, w_range)
    else
        for _, member in squadDefs[udef.name] do
            score = score + GetUnitScore(UnitDefNames[member].id,
                                         w_cap, w_view, w_speed, w_supply,
                                         w_armour, w_firepower, w_acccuracy,
                                         w_penetration, w_range)
            
        end
    end
    return score
end

local function SelectNewBuildingChain()
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

local baseBuildOptions = {} -- map of unitDefIDs (buildOption) to unitDefIDs (builders)
local baseBuildOptionsDirty = false
local currentBuildDefID     -- one unitDefID
local currentBuildID        -- one unitID
local currentBuilder        -- one unitID
local bUseClosestBuildSite = true

local function BuildBaseFinished()
    currentBuildDefID = nil
    currentBuildID = nil
    currentBuilder = nil
end

local function BuildBaseInterrupted()
    -- enforce randomized next buildsite, instead of
    -- hopelessly trying again and again on same place
    bUseClosestBuildSite = false
    baseBuildIndex = baseBuildIndex - 1
    return BuildBaseFinished()
end

local function BuildBase()
    if currentBuildDefID then
        if #(Spring.GetUnitCommands(currentBuilder, 1) or {}) == 0 then
            Log(UnitDefs[currentBuildDefID].humanName, " was finished/aborted, but neither UnitFinished nor UnitDestroyed was called")
            BuildBaseInterrupted()
        end
    end

    -- nothing to do if something is still being build
    if currentBuildDefID then return end

    -- fix for infinite loop if baseBuildIndex <= 0
    local count, maxcount = 1, #baseBuildOrder
    local unitDefID
    local newIndex = baseBuildIndex
    repeat
        newIndex = (newIndex % maxcount) + 1
        unitDefID = baseBuildOrder[newIndex]
        count = count + 1
        -- if there's nothing to do anymore because all units are limited,
        -- don't wander around but just wait until there's something to do again.
        if (count > maxcount) then return end
    until
        -- check if Spring would block this build (unit restriction)
        ((Spring.GetTeamUnitDefCount(myTeamID, unitDefID) or 0) < UnitDefs[unitDefID].maxThisUnit and
        -- check if some part of the AI would block this build
        gadget:AllowUnitCreation(unitDefID, nil, myTeamID))

    local builderDefID = baseBuildOptions[unitDefID]
    -- nothing to do if we have no builders available yet who can build this
    if not builderDefID then Log("No builder available for ", UnitDefs[unitDefID].humanName) return end

    local builders = {}
    for u,_ in pairs(myConstructors) do
        if (GetUnitDefID(u) == builderDefID) then
            builders[#builders+1] = u
        end
    end

    -- get a builder that isn't being build
    local builderID
    for _,u in ipairs(builders) do
        local _,_,inBuild = Spring.GetUnitIsStunned(u)
        if not inBuild then builderID = u break end
    end
    builderID = (builderID or builders[1])
    if not builderID then Log("internal error: no builders were found") return end

    -- give the order to the builder, iff we can find a buildsite
    local x,y,z,facing = buildsiteFinder.FindBuildsite(builderID, unitDefID, bUseClosestBuildSite)
    if not x then Log("Could not find buildsite for ", UnitDefs[unitDefID].humanName) return end

    Log("Queueing in place: ", UnitDefs[unitDefID].humanName)
    GiveOrderToUnit(builderID, -unitDefID, {x,y,z,facing}, {})

    -- give guard order to all our other builders
    for u,_ in pairs(myConstructors) do
        if u ~= builderID then
            GiveOrderToUnit(u, CMD.GUARD, {builderID}, {})
        end
    end

    -- finally, register the build as started
    baseBuildIndex = newIndex
    currentBuildDefID = unitDefID
    currentBuilder = builderID

    -- assume next build can safely be close to the builder again
    bUseClosestBuildSite = true
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--
--  The call-in routines
--

function BaseMgr.GameFrame(f)
    if #selected_chain == 0 then
        selected_chain = SelectNewBuildingChain()
        StartChain()
    end
end

--------------------------------------------------------------------------------
--
--  Unit call-ins
--

function BaseMgr.UnitCreated(unitID, unitDefID, unitTeam, builderID)
    buildsiteFinder.UnitCreated(unitID, unitDefID, unitTeam)

    if (not currentBuildID) and (unitDefID == currentBuildDefID) and (builderID == currentBuilder) then
        currentBuildID = unitID
    end
end

function BaseMgr.UnitFinished(unitID, unitDefID, unitTeam)
    if (unitDefID == currentBuildDefID) and ((not currentBuildID) or (unitID == currentBuildID)) then
        Log("CurrentBuild finished")
        BuildBaseFinished()
    end

    -- Upgrade the preferences indicators
    n_view = n_view + UnitDefs[unitDefID].sightDistance / 1000.0

    if unit_reqs.IsConstructor(unitDefID) then
        -- keep track of all builders we've walking around
        myConstructors[unitID] = true
        -- update list of buildings we can build
        for _,bo in ipairs(UnitDefs[unitDefID].buildOptions) do
            if not baseBuildOptions[bo] then
                Log("Base can now build ", UnitDefs[bo].humanName)
                baseBuildOptions[bo] = unitDefID
            end
        end
        -- give the builder a guard order on current builder
        if currentBuilder then
            GiveOrderToUnit(unitID, CMD.GUARD, {currentBuilder}, {})
        end
        return true --signal Team.UnitFinished that we will control this unit
    end

    if unit_reqs.IsFactory(unitDefID) then
        myFactories[unitID] = true
        return false
    end
end

function BaseMgr.UnitDestroyed(unitID, unitDefID, unitTeam, attackerID, attackerDefID, attackerTeam)
    buildsiteFinder.UnitDestroyed(unitID, unitDefID, unitTeam, attackerID, attackerDefID, attackerTeam)

    -- Upgrade the preferences indicators
    n_view = n_view - UnitDefs[unitDefID].sightDistance / 1000.0

    if unit_reqs.IsConstructor(unitDefID) then
        myConstructors[unitID] = nil
        baseBuildOptionsDirty = true
    end

    if unit_reqs.IsFactory(unitDefID) then
        myFactories[unitID] = nil
    end

    -- update base building
    if (unitDefID == currentBuildDefID) and ((not currentBuildID) or (unitID == currentBuildID)) then
        Log("CurrentBuild destroyed")
        BuildBaseInterrupted()
    end
    if unitID == currentBuilder then
        Log("CurrentBuilder destroyed")
        BuildBaseInterrupted()
    end
end

--------------------------------------------------------------------------------
--
--  Initialization
--

if not baseBuildOrder then
    error("C.R.A.I.G. is not configured properly to play as " .. mySide)
end

return BaseMgr
end
