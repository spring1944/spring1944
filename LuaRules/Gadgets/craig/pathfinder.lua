-- Author: Tobi Vollebregt
-- License: GNU General Public License v2

--[[
Public interface:

function PathFinder.Dijkstra(graph, source, blocked, predicate))
    Returns a dictionary which gives for each vertex the previous vertex
    in a shortest path from source to that vertex, never moving over vertices
    in the blocked set.
    If predicate is given, it calls this function for every vertex u that is
    going to be processed.  If it returns anything evaluating to true Dijkstra
    will immediately return previous, u.  (This can be used to search for
    nearest waypoint for which a certain condition holds.)

function PathFinder.ReverseShortestPath(previous, target)
    Builds an array containing all vertices on the path from target to source.
    Usage: 'local rpath = ReverseShortestPath(Dijkstra(graph, source), target)'

function PathFinder.ShortestPath(previous, target)
    Builds an array containing all vertices on the path from source to target.
    Usage: 'local path = ShortestPath(Dijkstra(graph, source), target)'

function PathFinder.PathIterator(previous, target)
    Equivalent to ipairs(ShortestPath(previous, target)), but less allocations.
    Usage: 'for index, vertex in PathIterator(Dijkstra(graph, source), target)'

function PathFinder.GiveOrdersToUnit(previous, target, unitID, cmd, spread)
function PathFinder.GiveOrdersToUnitArray(previous, target, unitArray, cmd, spread)
function PathFinder.GiveOrdersToUnitMap(previous, target, unitMap, cmd, spread)
    Queues up cmds from the source which was used to generate 'previous' to
    target for the given unit.
    The second two functions which give orders to multiple units also calculate
    the lowest unit speed in the group, and give a CMD.SET_WANTED_MAX_SPEED.

The Dijkstra and ShortestPath functions have been separated because Dijkstra
generates the shortest path from source to all vertices in the graph at once.
]]--

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--
--  From gadgets.lua: Reverse integer iterator for reversing reverse paths
--

local function rev_iter(t, key)
  if (key <= 1) then
    return nil
  else
    local nkey = key - 1
    return nkey, t[nkey]
  end
end

local function ripairs(t)
  return rev_iter, t, (1 + #t)
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

PathFinder = {}


local function ExtractMin(dist, q)
    local minDist = 1.0e9
    local nearest = nil
    -- TODO: this is the most naive implementation, bumping up the complexity
    -- of Dijkstra below to O(n^2) with n = number of vertices in the graph.
    -- http://en.wikipedia.org/wiki/Dijkstra%27s_algorithm
    -- http://lua-users.org/lists/lua-l/2008-03/msg00534.html
    for v,_ in pairs(q) do
        if (dist[v] < minDist) then
            minDist = dist[v]
            nearest = v
        end
    end
    return nearest
end


function PathFinder.Dijkstra(graph, source, blocked, predicate)
    local previous = {} -- maps waypoint to previous waypoint on shortest path
    local dist = {}     -- maps waypoint to shortest distance to it
    local q = {}        -- set of all waypoints which still need to be processed

    blocked = (blocked or {})
    if blocked[source] then
        return previous
    end

    for _,v in ipairs(graph) do
        if (not blocked[v]) then
            q[v] = true
            dist[v] = 1.0e9
        end
    end
    dist[source] = 0

    while true do
        local u = ExtractMin(dist, q)
        if (u == nil) then
            return previous
        end
        if (predicate ~= nil) and predicate(u) then
            return previous, u
        end
        q[u] = nil
        for v,edge in pairs(u.adj) do
            if (not blocked[v]) and (not blocked[edge]) then
                local alt = dist[u] + edge.dist
                if (alt < dist[v]) then
                    dist[v] = alt
                    previous[v] = u
                end
            end
        end
    end
end


function PathFinder.ReverseShortestPath(previous, target)
    local path = {}
    while (previous[target] ~= nil) do
        path[#path+1] = target
        target = previous[target]
    end
    return path
end

local ReverseShortestPath = PathFinder.ReverseShortestPath


function PathFinder.ShortestPath(previous, target)
    local path = {}
    for i,v in ripairs(ReverseShortestPath(previous, target)) do
        path[#path+1] = v
    end
    return path
end


function PathFinder.PathIterator(previous, target)
    local t = ReverseShortestPath(previous, target)
    return rev_iter, t, 1 + #t
end


--------------------------------------------------------------------------------
--
--  Spring specific functions
--

--speedups
local options = {"shift"}
local UnitDefs = UnitDefs
local GetUnitDefID = Spring.GetUnitDefID


local function DoGiveOrdersToUnit(previous, target, unitID, cmd, minMaxSpeed, spread)
    local CMD_SET_WANTED_MAX_SPEED = CMD.SET_WANTED_MAX_SPEED or GG.CustomCommands.GetCmdID("CMD_SET_WANTED_MAX_SPEED")
    if spread then
        local dx = math.random() * spread * 2 - spread
        local dz = math.random() * spread * 2 - spread
        for _,p in PathFinder.PathIterator(previous, target) do
            GiveOrderToUnit(unitID, cmd, {p.x + dx, p.y, p.z + dz}, options)
            GiveOrderToUnit(unitID, CMD_SET_WANTED_MAX_SPEED, {minMaxSpeed}, options)
        end
    else
        for _,p in PathFinder.PathIterator(previous, target) do
            GiveOrderToUnit(unitID, cmd, {p.x, p.y, p.z}, options)
            GiveOrderToUnit(unitID, CMD_SET_WANTED_MAX_SPEED, {minMaxSpeed}, options)
        end
    end
end


function PathFinder.GiveOrdersToUnit(previous, target, unitID, cmd, spread)
    local minMaxSpeed = UnitDefs[GetUnitDefID(unitID)].speed / 30
    return DoGiveOrdersToUnit(previous, target, unitID, cmd, minMaxSpeed, spread)
end


function PathFinder.GiveOrdersToUnitArray(previous, target, unitArray, cmd, spread)
    local minMaxSpeed = 1000
    local slowestUnit
    for _,u in ipairs(unitArray) do
        local speed = UnitDefs[GetUnitDefID(u)].speed
        if (speed < minMaxSpeed) then
            minMaxSpeed = speed
            slowestUnit = u
        end
    end
    minMaxSpeed = minMaxSpeed / 30
    for _,u in ipairs(unitArray) do
        DoGiveOrdersToUnit(previous, target, u, cmd, minMaxSpeed, spread)
    end
end


function PathFinder.GiveOrdersToUnitMap(previous, target, unitMap, cmd, spread)
    local minMaxSpeed = 1000
    local slowestUnit
    for u,_ in pairs(unitMap) do
        local speed = UnitDefs[GetUnitDefID(u)].speed
        if (speed < minMaxSpeed) then
            minMaxSpeed = speed
            slowestUnit = u
        end
    end
    minMaxSpeed = minMaxSpeed / 30
    for u,_ in pairs(unitMap) do
        DoGiveOrdersToUnit(previous, target, u, cmd, minMaxSpeed, spread)
    end
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

-- some test code (not a complete test!)
if false then
    local function Connect(a, b, edge)
        a.adj[b], b.adj[a] = edge, edge
    end

    local a, b, c = { name = "a", adj = {} }, { name = "b", adj = {} }, { name = "c", adj = {} }
    local graph = {a, b, c}
    Connect(a, b, {dist = 10})
    Connect(b, c, {dist = 10})

    local blocked = {}
    --blocked[b] = true        -- block waypoint test
    --blocked[b.adj[c]] = true -- block edge test

    local previous = PathFinder.Dijkstra(graph, a, blocked)

    print("'previous' set:")
    for k,v in pairs(previous) do
        print(k.name, "->", v.name)
    end

    print("reverse shortest path:")
    for i,p in pairs(PathFinder.ReverseShortestPath(previous, c)) do
        print(i, p.name)
    end

    print("shortest path:")
    for i,p in pairs(PathFinder.ShortestPath(previous, c)) do
        print(i, p.name)
    end

    print("shortest path, using iterator:")
    for i,p in PathFinder.PathIterator(previous, c) do
        print(i, p.name)
    end
end

return PathFinder
