-- Author: Tobi Vollebregt
-- License: GNU General Public License v2

--[[
This class is implemented as a single function returning a table with public
interface methods.  Private data is stored in the function's closure.

Public interface:

function CombatMgr.GameFrame(f)
function CombatMgr.UnitFinished(unitID, unitDefID, unitTeam)
function CombatMgr.UnitDestroyed(unitID, unitDefID, unitTeam, attackerID, attackerDefID, attackerTeam)
]]--

function CreateCombatMgr(myTeamID, myAllyTeamID, heatmapMgr, Log)

-- Can not manage combat if we don't have waypoints..
if (not gadget.waypointMgr) then
    return false
end

local CombatMgr = {}

-- constants
local SQUAD_SIZE = SQUAD_SIZE
local SQUAD_SPREAD = 250
local FEAR_THRESHOLD = 0.2 + 0.8 * math.random()  -- [0.2, 1.0]

-- speedups
local sqrt = math.sqrt
local waypointMgr = gadget.waypointMgr
local waypoints = waypointMgr.GetWaypoints()
local intelligence = gadget.intelligences[myTeamID]
local GetUnitNoSelect = Spring.GetUnitNoSelect
local GetUnitPosition = Spring.GetUnitPosition

-- members
local lastWaypoint = 0
local units = {}

local newUnits = {}
local newUnitCount = 0

local function avgPosUnitMap(units)
    local x, z = 0, 0, 0
    for u, _ in pairs(units) do
        local xx, _, zz = GetUnitPosition(u)
        x, z = x + xx, z + zz
    end
    return x, z
end

local function avgPosUnitArray(units)
    local x, z = 0, 0, 0
    for _, u in ipairs(units) do
        local xx, _, zz = GetUnitPosition(u)
        x, z = x + xx, z + zz
    end
    return x, z
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--
--  The call-in routines
--

function CombatMgr.GameFrame(f)
    if newUnitCount >= SQUAD_SIZE then
        -- Don't use units which user wouldn't be able to use..
        for u,_ in pairs(newUnits) do
            if GetUnitNoSelect(u) then
                newUnits[u] = nil
                newUnitCount = newUnitCount - 1
            end
        end
    end

    if newUnitCount >= SQUAD_SIZE then
        local x, z = avgPosUnitMap(newUnits)
        local target, previous = intelligence.GetTarget(x, z)
        if target ~= nil then
            PathFinder.GiveOrdersToUnitMap(previous, target, newUnits, CMD.FIGHT, SQUAD_SPREAD)
            for u,_ in pairs(newUnits) do
                units[u] = target -- remember where we are going for UnitIdle
            end
            newUnits = {}
            newUnitCount = 0
        end
    end

    -- move in every 10 seconds, with a lag of 0.5 seconds for each team
    if (f + 15 * myTeamID) % 600 >= 128 then return end

    Log("GO GO GO")

    -- make temporary data structure of squads (units at or moving towards same waypoint)
    local squads = {} -- waypoint -> array of unitIDs
    for u,p in pairs(units) do
        local squad = (squads[p] or {})
        squad[#squad+1] = u
        squads[p] = squad
    end

    -- give each orders towards the nearest relevant waypoint
    for p,unitArray in pairs(squads) do
        local x, z = avgPosUnitMap(newUnits)
        local target, previous = intelligence.GetTarget(x, z)
        if target ~= nil then
            for i = 1, 3 do
                local gx, gz = heatmapMgr.FirepowerGradient(target.x, target.z)
                local l2 = gx * gx + gz * gz
                if l2 < FEAR_THRESHOLD * FEAR_THRESHOLD then
                    break
                end
                -- Let's retreat
                local l = sqrt(l2)
                target = waypointMgr.GetNext(target, -gx / l, -gz / l)
                
            end
            if target and (target ~= p) then
                PathFinder.GiveOrdersToUnitArray(previous, target, unitArray, CMD.FIGHT, SQUAD_SPREAD)
                for _,u in ipairs(unitArray) do
                    units[u] = target --assume next call this unit will be at target
                end
            end
        end
    end
end

--------------------------------------------------------------------------------
--
--  Unit call-ins
--

function CombatMgr.UnitFinished(unitID, unitDefID, unitTeam)
    -- if it's a mobile unit, give it orders towards frontline
    if waypointMgr and UnitDefs[unitDefID].speed ~= 0 then
        newUnits[unitID] = true
        newUnitCount = newUnitCount + 1

        return true --signal Team.UnitFinished that we will control this unit
    end
end

function CombatMgr.UnitDestroyed(unitID, unitDefID, unitTeam, attackerID, attackerDefID, attackerTeam)
    units[unitID] = nil
    if newUnits[unitID] then
        newUnits[unitID] = nil
        newUnitCount = newUnitCount - 1
    end
end

--------------------------------------------------------------------------------
--
--  Initialization
--

return CombatMgr
end
