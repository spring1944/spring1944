-- Author: Tobi Vollebregt
-- License: GNU General Public License v2

--[[
This class is implemented as a single function returning a table with public
interface methods.  Private data is stored in the function's closure.

Public interface:

local WaypointMgr = CreateWaypointMgr()

function WaypointMgr.GameStart()
function WaypointMgr.GameFrame(f)
function WaypointMgr.UnitCreated(unitID, unitDefID, unitTeam, builderID)

function WaypointMgr.GetGameFrameRate()
function WaypointMgr.GetWaypoints()
function WaypointMgr.GetTeamStartPosition(myTeamID)
function WaypointMgr.GetFrontline(myTeamID, myAllyTeamID)
    Returns frontline, previous. Frontline is the set of waypoints adjacent

]]--

function CreateWaypointMgr()

-- constants
local GAIA_TEAM_ID    = Spring.GetGaiaTeamID()
local GAIA_ALLYTEAM_ID      -- initialized later on..
local FLAG_RADIUS     = FLAG_RADIUS
local WAYPOINT_RADIUS = FLAG_RADIUS -- 500
local WAYPOINT_HEIGHT = 100
local REF_UNIT_DEF = UnitDefNames["gerrifle"] -- Reference unit to check paths

-- speedups
local Log = Log
local GetUnitsInBox = Spring.GetUnitsInBox
local GetUnitsInCylinder = Spring.GetUnitsInCylinder
local GetUnitDefID = Spring.GetUnitDefID
local GetUnitTeam = Spring.GetUnitTeam
local GetUnitAllyTeam = Spring.GetUnitAllyTeam
local GetUnitPosition = Spring.GetUnitPosition
local GetGroundHeight = Spring.GetGroundHeight
local TestMoveOrder = Spring.TestMoveOrder
local sqrt = math.sqrt
local floor, ceil = math.floor, math.ceil
local isFlag = gadget.flags

-- class
local WaypointMgr = {}

-- Grid of waypoints to become parsed
local grid = {}
local n_grid_x, n_grid_y = floor(Game.mapSizeX / WAYPOINT_RADIUS),
                           floor(Game.mapSizeZ / WAYPOINT_RADIUS)
for i=1,n_grid_x do
    grid[i] = {}
    for j=1,n_grid_y do
        grid[i][j] = {
            valid = nil,
        }
    end
end
local parse_queue = {}

-- Array containing the waypoints and adjacency relations
-- Format: { { x = x, y = y, z = z, adj = {}, --[[ more properties ]]-- }, ... }
local waypoints = {}
local index = 0      -- where we are with updating waypoints

-- Dictionary mapping unitID of flag to waypoint it is in.
local flags = {}

-- Format: { [team1] = allyTeam1, [team2] = allyTeam2, ... }
local teamToAllyteam = {}

-- caches result of CalculateFrontline..
local frontlineCache = {}

-- caches result of Spring.GetTeamStartPosition
local teamStartPosition = {}


local function GetDist2D(x, z, p, q)
    local dx = x - p
    local dz = z - q
    return sqrt(dx * dx + dz * dz)
end


-- Returns the nearest waypoint to point x, z, and the distance to it.
local function GetNearestWaypoint2D(x, z)
    local minDist = 1.0e9
    local nearest
    for _,p in ipairs(waypoints) do
        local dist = GetDist2D(x, z, p.x, p.z)
        if (dist < minDist) then
            minDist = dist
            nearest = p
        end
    end
    return nearest, minDist
end

-- This calculates the set of waypoints which are
--  1) owned by allies
--  2) adjacent to waypoints non-possesed by allies
--  3) reachable from hq, without going through enemy waypoints
local function CalculateFrontline(myTeamID, myAllyTeamID, dilate)
    if dilate == nil then
        dilate = 1
    end

    -- Get the allied and enemy actual control areas
    local allied, enemy = {}, {}
    local allied_frontier, enemy_frontier = {}, {}
    for _,p in ipairs(waypoints) do
        if p.owner ~= nil then
            if p.owner == myAllyTeamID then
                allied[p] = true
                for a, edge in pairs(p.adj) do
                    if (a.owner ~= myAllyTeamID) then
                        allied_frontier[#allied_frontier + 1] = p
                        break
                    end
                end
            else
                enemy[p] = true
                for a, edge in pairs(p.adj) do
                    if (a.owner ~= p.owner) then
                        enemy_frontier[#enemy_frontier + 1] = p
                        break
                    end
                end
            end
        end
    end

    -- Dilate all the control areas until they collide
    -- Mark as frontline candidates all allied waypoints adjacent to
    -- non-allied ones.
    local marked = {}
    while #allied_frontier + #enemy_frontier > 0 do
        for i=1,#allied_frontier do
            local p = allied_frontier[#allied_frontier]
            allied_frontier[#allied_frontier] = nil
            for a, edge in pairs(p.adj) do
                if allied[a] == nil then
                    if enemy[a] == nil then
                        allied[a] = true
                        table.insert(allied_frontier, 1, a)
                    else
                        marked[p] = true
                    end
                end
            end            
        end
        for i=1,#enemy_frontier do
            local p = enemy_frontier[#enemy_frontier]
            enemy_frontier[#enemy_frontier] = nil
            for a, edge in pairs(p.adj) do
                if enemy[a] == nil then
                    if allied[a] == nil then
                        enemy[a] = true
                        table.insert(enemy_frontier, 1, a)
                    end
                end
            end            
        end
    end

    -- Artificially dilate the allied area to enforce incursion in enemy lines
    for i = 1,dilate do
        for i=1,#allied_frontier do
            local p = allied_frontier[#allied_frontier]
            allied_frontier[#allied_frontier] = nil
            for a, edge in pairs(p.adj) do
                if enemy[a] == true then
                    enemy[a] = nil
                    allied[a] = true
                    table.insert(allied_frontier, 1, a)
                    marked[p] = false
                    marked[a] = true
                end
            end            
        end
    end

    -- mark as blocked all the enemy owned waypoints
    local blocked = enemy

    -- block all edges which connect two frontline waypoints
    -- (ie. prevent units from pathing over the frontline..)
    for p,_ in pairs(marked) do
        for a,edge in pairs(p.adj) do
            if marked[a] then
                blocked[edge] = true
            end
        end
    end

    -- "perform a Dijkstra" starting at HQ
    local hq = teamStartPosition[myTeamID]
    local previous = PathFinder.Dijkstra(waypoints, hq, blocked)

    -- now 'frontline' is intersection between 'marked' and 'previous'
    local frontline = {}
    for p,_ in pairs(marked) do
        if previous[p] then
            frontline[#frontline + 1] = p
        end
    end

    return frontline, previous
end


-- Called everytime a waypoint changes owner.
-- A waypoint changes owner when compared to previous update,
-- a different allyteam now possesses ALL units near the waypoint.
local function WaypointOwnerChange(waypoint, newOwner)
    local oldOwner = waypoint.owner
    waypoint.owner = newOwner

    Log("WaypointOwnerChange ", waypoint.x, ", ", waypoint.z, ": ",
        (oldOwner or "neutral"), " -> ", (newOwner or "neutral"))

    if (oldOwner ~= nil) then
        -- invalidate cache for oldOwner
        for t,at in pairs(teamToAllyteam) do
            if (at == oldOwner) then
                frontlineCache[t] = nil
            end
        end
    end

    if (newOwner ~= nil) then
        -- invalidate cache for newOwner
        for t,at in pairs(teamToAllyteam) do
            if (at == newOwner) then
                frontlineCache[t] = nil
            end
        end
    end
end

local function grid2world(i, j)
    local x, z = (i - 0.5) * WAYPOINT_RADIUS, (j - 0.5) * WAYPOINT_RADIUS
    return x, GetGroundHeight(x, z), z
end

local function world2grid(x, z)
    local i, j = math.floor(x / WAYPOINT_RADIUS) + 1,
                             math.floor(z / WAYPOINT_RADIUS) + 1
    return math.floor(x / WAYPOINT_RADIUS) + 1,
           math.floor(z / WAYPOINT_RADIUS) + 1
end

local function adj_grid_nodes(i, j)
    local nodes = {}
    for ii = i-1,i+1 do
        if ii > 0 and ii <= n_grid_x then
            for jj = j-1,j+1 do
                if jj > 0 and jj <= n_grid_y and not (ii == i and jj == j) then
                    nodes[#nodes + 1] = {ii, jj}
                end
            end
        end
    end
    return nodes
end



--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--
--  Waypoint prototype (Waypoint public interface)
--  TODO: do I actually need this... ?
--

local Waypoint = {}
Waypoint.__index = Waypoint

function Waypoint:GetFriendlyUnitCount(myAllyTeamID)
    return self.allyTeamUnitCount[myAllyTeamID] or 0
end

function Waypoint:GetEnemyUnitCount(myAllyTeamID)
    local sum = 0
    for at,count in pairs(self.allyTeamUnitCount) do
        if (at ~= myAllyTeamID) then
            sum = sum + count
        end
    end
    return sum
end

function Waypoint:AreAllFlagsCappedByAllyTeam(myAllyTeamID)
    for _,f in pairs(self.flags) do
        if (GetUnitAllyTeam(f) ~= myAllyTeamID) then
            return false
        end
    end
    return true
end

local function AddWaypoint(x, y, z)
    local waypoint = {
        x = x, y = y, z = z, --position
        adj = {},            --map of adjacent waypoints -> edge distance
        flags = {},          --array of flag unitIDs
        allyTeamUnitCount = {},
    }
    setmetatable(waypoint, Waypoint)
    waypoints[#waypoints+1] = waypoint
    return waypoint
end

local function GetWaypointDist2D(a, b)
    local dx = a.x - b.x
    local dz = a.z - b.z
    return sqrt(dx * dx + dz * dz)
end

local function AddConnection(a, b)
    local edge = {dist = GetWaypointDist2D(a, b)}
    a.adj[b] = edge
    b.adj[a] = edge
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--
--  WaypointMgr public interface
--

function WaypointMgr.GetGameFrameRate()
    -- returns every how many frames GameFrame should be called.
    -- currently I set this so each waypoint is updated every 30 sec (= 900 frames)
    return math.floor(900 / #waypoints)
end

function WaypointMgr.GetWaypoints()
    return waypoints
end

function WaypointMgr.GetTeamStartPosition(myTeamID)
    return teamStartPosition[myTeamID]
end

function WaypointMgr.GetFrontline(myTeamID, myAllyTeamID)
    if (not frontlineCache[myTeamID]) then
        frontlineCache[myTeamID] = { CalculateFrontline(myTeamID, myAllyTeamID) }
    end
    return unpack(frontlineCache[myTeamID])
end

function WaypointMgr.GetNext(p, dx, dz)
    local waypoint, accuracy = p, 0.0
    for visitor, edge in pairs(p.adj) do
        local dir_x = (visitor.x - p.x) / edge.dist
        local dir_z = (visitor.z - p.z) / edge.dist
        local dot = dx * dir_x + dz * dir_z
        if dot > accuracy then
            waypoint = visitor
            accuracy = dot
        end
    end
    return waypoint
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--
--  The call-in routines
--

function WaypointMgr.GameStart()
    -- Can not run this in the initialization code at the end of this file,
    -- because at that time Spring.GetTeamStartPosition seems to always return 0,0,0.
    for _,t in ipairs(Spring.GetTeamList()) do
        if (t ~= GAIA_TEAM_ID) then
            local x, y, z = Spring.GetTeamStartPosition(t)
            if x and x ~= 0 then
                -- Add a waypoint right there
                local i, j = world2grid(x, z)
                if grid[i][j].valid == nil then
                    grid[i][j].valid = true
                    local gx, gy, gz = grid2world(i, j)
                    grid[i][j].waypoint = AddWaypoint(gx, gy, gz)
                    -- Add the adjacent grid nodes to the parsing queue
                    local candidates = adj_grid_nodes(i, j)
                    for _, c in ipairs(candidates) do
                        if grid[c[1]][c[2]].valid == nil then
                            parse_queue[#parse_queue + 1] = c
                        end
                    end
                end
                teamStartPosition[t] = GetNearestWaypoint2D(x, z)
            end
        end
    end
end

function WaypointMgr.GameFrame(f)
    -- Parse another grid waypoint
    for i=#parse_queue,1,-1 do
        local gi, gj = parse_queue[i][1], parse_queue[i][2]
        parse_queue[i] = nil
        if grid[gi][gj].valid == nil then
            local dst_x, dst_y, dst_z = grid2world(gi, gj)
            -- Assume the point cannot be reached
            grid[gi][gj].valid = false
            -- Look for the connectivity with the adjacent nodes
            local candidates = adj_grid_nodes(gi, gj)
            for _, c in ipairs(candidates) do
                if grid[c[1]][c[2]].valid == true then
                    local src_x, src_y, src_z = grid2world(c[1], c[2])
                    local dx, dy, dz = dst_x - src_x, dst_y - src_y, dst_z - src_z
                    if TestMoveOrder(REF_UNIT_DEF.id, src_x, src_y, src_z, dx, dy, dz) then
                        grid[gi][gj].valid = true
                        if grid[gi][gj].waypoint == nil then
                            grid[gi][gj].waypoint = AddWaypoint(dst_x, dst_y, dst_z)
                        end
                        -- connect the waypoint with the neighbor
                        AddConnection(grid[c[1]][c[2]].waypoint,
                                      grid[gi][gj].waypoint)
                    end
                end
            end

            if grid[gi][gj].valid == true then
                -- Ask to parse the pending adjacent nodes
                for _, c in ipairs(candidates) do
                    if grid[c[1]][c[2]].valid == nil then
                        table.insert(parse_queue, 1, {c[1], c[2]})
                    end
                end
            end

            -- A grid node per frame is enough
            break
        end
    end

    if #waypoints == 0 then
        return
    end

    index = (index % #waypoints) + 1
    --Log("WaypointMgr: updating waypoint ", index)
    local p = waypoints[index]
    p.flags = {}

    -- Update p.allyTeamUnitCount
    -- Box check (as opposed to Rectangle, Sphere, Cylinder),
    -- because this allows us to easily exclude aircraft.
    local x1, y1, z1 = p.x - WAYPOINT_RADIUS, p.y - WAYPOINT_HEIGHT, p.z - WAYPOINT_RADIUS
    local x2, y2, z2 = p.x + WAYPOINT_RADIUS, p.y + WAYPOINT_HEIGHT, p.z + WAYPOINT_RADIUS
    local occupationTeams = {}
    local allyTeamUnitCount = {}
    for _,u in ipairs(GetUnitsInBox(x1, y1, z1, x2, y2, z2)) do
        local ud = GetUnitDefID(u)
        local at = GetUnitAllyTeam(u)
        if isFlag[ud] then
            local x, y, z = GetUnitPosition(u)
            local dist = GetDist2D(x, z, p.x, p.z)
            if (dist < FLAG_RADIUS) then
                p.flags[#p.flags+1] = u
                flags[p] = u
                --Log("Flag ", u, " (", at, ") is near ", p.x, ", ", p.z)
            end
            -- Flags not conquered yet are a special case, and we specifically
            -- want to set it as enemy territory
            if at == GAIA_ALLYTEAM_ID then
                occupationTeams[#occupationTeams + 1] = GAIA_ALLYTEAM_ID
            end
        end
        if at ~= GAIA_ALLYTEAM_ID then
            if allyTeamUnitCount[at] == nil then
                occupationTeams[#occupationTeams + 1] = at
            end
            allyTeamUnitCount[at] = (allyTeamUnitCount[at] or 0) + 1
        end
    end
    p.allyTeamUnitCount = allyTeamUnitCount

    -- Update p.owner. The owner of a way point is whatever team is occupying
    -- it. If no-one is currently occupying the waypoint, we just simply
    -- preserve it. If several teams are disputing a waypoint, is it demoted
    -- to neutral
    local owner = nil
    if #occupationTeams == 0 then
        owner = p.owner
    elseif #occupationTeams == 1 then
        owner = occupationTeams[1]
    end
    
    if (owner ~= p.owner) then
        WaypointOwnerChange(p, owner)
    end
end

--------------------------------------------------------------------------------
--
--  Unit call-ins
--

function WaypointMgr.UnitCreated(unitID, unitDefID, unitTeam, builderID)
    if isFlag[unitDefID] then
        -- This is O(n*m), with n = number of flags and m = number of waypoints.
        local x, y, z = GetUnitPosition(unitID)
        local p, dist = GetNearestWaypoint2D(x, z)
        if (dist < FLAG_RADIUS) then
            p.flags[#p.flags+1] = unitID
            flags[unitID] = p
            Log("Flag ", unitID, " is near ", p.x, ", ", p.z)
        end
    end
end

function WaypointMgr.UnitDestroyed(unitID, unitDefID, unitTeam, attackerID, attackerDefID, attackerTeam)
    if isFlag[unitDefID] then
        local p = flags[unitID]
        if p then
            flags[unitID] = nil
            for i=1,#p.flags do
                if (p.flags[i] == unitID) then
                    table.remove(p.flags, i)
                    break
                end
            end
        end
    end
end

--------------------------------------------------------------------------------
--
--  Initialization
--

do

-- make map of teams to allyTeams
-- this must contain not only AI teams, but also player teams!
for _,t in ipairs(Spring.GetTeamList()) do
    if (t ~= GAIA_TEAM_ID) then
        local _,_,_,_,_,at = Spring.GetTeamInfo(t)
        teamToAllyteam[t] = at
    end
end

-- find GAIA_ALLYTEAM_ID
local _,_,_,_,_,at = Spring.GetTeamInfo(GAIA_TEAM_ID)
GAIA_ALLYTEAM_ID = at

end
return WaypointMgr
end
