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
local GetUnitNoSelect = Spring.GetUnitNoSelect

-- members
local lastWaypoint = 0
local units = {}

local newUnits = {}
local newUnitCount = 0

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
        local frontline, previous = waypointMgr.GetFrontline(myTeamID, myAllyTeamID)
        if #frontline > 0 then
            lastWaypoint = (lastWaypoint % #frontline) + 1
            local target = frontline[lastWaypoint]
            if target then
                PathFinder.GiveOrdersToUnitMap(previous, target, newUnits, CMD.FIGHT, SQUAD_SPREAD)
                for u,_ in pairs(newUnits) do
                    units[u] = target -- remember where we are going for UnitIdle
                end
                newUnits = {}
                newUnitCount = 0
            end
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

    -- give each orders towards the nearest enemy waypoint
    for p,unitArray in pairs(squads) do
        local previous, target = PathFinder.Dijkstra(waypoints, p, {}, function(p)
            return (p.owner ~= myAllyTeamID)
        end)
        local gx, gz = heatmapMgr.FirepowerGradient(target.x, target.z)
        local l2 = gx * gx + gz * gz
        if l2 > FEAR_THRESHOLD * FEAR_THRESHOLD then
            -- Let's retreat
            if myTeamID == 3 then
                Spring.Echo("Grad ", target.x / Game.mapSizeX, target.z / Game.mapSizeZ, gx, gz)
            end
            local l = sqrt(l2)
            target = waypointMgr.GetNext(target, -gx / l, -gz / l)
            if myTeamID == 3 then
                Spring.Echo("Retreat to ", target.x / Game.mapSizeX, target.z / Game.mapSizeZ)
            end
        end
        if target and (target ~= p) then
            PathFinder.GiveOrdersToUnitArray(previous, target, unitArray, CMD.FIGHT, SQUAD_SPREAD)
            for _,u in ipairs(unitArray) do
                units[u] = target --assume next call this unit will be at target
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
