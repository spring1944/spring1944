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

function CreateCombatMgr(myTeamID, myAllyTeamID, heatmapMgr, taxiMgr, Log)

-- Can not manage combat if we don't have waypoints..
if (not gadget.waypointMgr) then
    return false
end

local CombatMgr = {}

-- constants
local SQUAD_SIZE = SQUAD_SIZE
local SQUAD_SPREAD = 500
local FEAR_THRESHOLD = 0.5 + (1.0 - 0.5) * math.random()
local TAXI_DIST = 12.0 * FLAG_RADIUS
local TAXI_ETA = 120.0

-- speedups
local CMD_FIGHT = CMD.FIGHT
local CMD_MOVE = CMD.MOVE
local sqrt, random, min, hugefloat = math.sqrt, math.random, math.min, math.huge
local waypointMgr = gadget.waypointMgr
local waypoints = waypointMgr.GetWaypoints()
local intelligence = gadget.intelligences[myTeamID]
local GetUnitNoSelect   = Spring.GetUnitNoSelect
local GetUnitPosition   = Spring.GetUnitPosition
local GetUnitDefID      = Spring.GetUnitDefID
local GetUnitRulesParam = Spring.GetUnitRulesParam
local GetGroundHeight   = Spring.GetGroundHeight
local GetTeamResources  = Spring.GetTeamResources
-- members
local lastWaypoint = 0
local units = {}

local newUnits = {}
local newUnitCount = 0

local maxAmmo = {}
local supplyRanges = {}
local refilling = {}

local function avgPosUnitMap(units)
    local x, z, n = 0, 0, 0
    for u, _ in pairs(units) do
        local xx, _, zz = GetUnitPosition(u)
        x, z = x + xx, z + zz
        n = n + 1
    end
    return x / n, z / n
end

local function avgPosUnitArray(units)
    local x, z = 0, 0, 0
    for _, u in ipairs(units) do
        local xx, _, zz = GetUnitPosition(u)
        x, z = x + xx, z + zz
    end
    return x / #units, z / #units
end

local function get_spread_vector(unitID, normal, t_radius)
    local nx, nz = unpack(normal)
    local tx, tz = -nz, nx

    local t_spread = random() * t_radius * 2 - t_radius

    local n_radius = 0.25 * t_radius
    local unitDefID = GetUnitDefID(unitID)
    local unitDef = UnitDefs[unitDefID]
    if  #unitDef.weapons > 0 then
        local weaponDef = WeaponDefs[unitDef.weapons[1].weaponDef]
        n_radius = 0.35 + 0.5 * weaponDef.range
    end
    local n_spread = -random() * n_radius

    return n_spread * nx + t_spread * tx, n_spread * nz + t_spread * tz
end

--[[
local function DoGiveOrdersToUnit(p, unitID, cmd, normal, spread, eta)
    local CMD_SET_WANTED_MAX_SPEED = CMD.SET_WANTED_MAX_SPEED or GG.CustomCommands.GetCmdID("CMD_SET_WANTED_MAX_SPEED")
    local dx, dz = get_spread_vector(unitID, normal, spread)
    local x, _, z = GetUnitPosition(unitID)
    local lx, lz = p.x - x, p.z - z
    local l = sqrt(lx * lx + lz * lz)
    local speed = l / eta
    GiveOrderToUnit(unitID, cmd, {p.x + dx, p.y, p.z + dz},  {})
    GiveOrderToUnit(unitID, CMD_SET_WANTED_MAX_SPEED, {speed}, {"shift"})
end
--]]

local function DoGiveOrdersToUnit(p, unitID, cmd, normal, spread)
    local dx, dz = get_spread_vector(unitID, normal, spread)
    GiveOrderToUnit(unitID, cmd, {p.x + dx, p.y, p.z + dz},  {})
end

local function GetUnitETA(unitID, dest)
    local x, z = GetUnitPosition(unitID)
    local dx, dz = dest.x - x, dest.z - z
    local d = sqrt(dx * dx + dz * dz)
    local v = UnitDefs[GetUnitDefID(unitID)].speed
    Spring.Echo("ETA (newUnits)", UnitDefs[GetUnitDefID(unitID)].name, d, v, 0.25 * d / v)
    return 0.25 * d / v
end

local function GiveOrdersToUnitArray(orig, target, unitArray, cmd, normal, spread)
    --[[
    local minMaxSpeed = 1000
    for _, u in ipairs(unitArray) do
        local speed = UnitDefs[GetUnitDefID(u)].speed
        if (speed < minMaxSpeed) then
            minMaxSpeed = speed
        end
    end
    minMaxSpeed = minMaxSpeed / 30
    local lx, lz = target.x - orig.x, target.z - orig.z
    local l = sqrt(lx * lx + lz * lz)    
    local eta = l / minMaxSpeed
    for _,u in ipairs(unitArray) do
        DoGiveOrdersToUnit(target, u, cmd, normal, spread, eta)
    end
    --]]
    for _,u in ipairs(unitArray) do
        DoGiveOrdersToUnit(target, u, cmd, normal, spread)
    end
end

local function GiveOrdersToUnitMap(orig, target, unitMap, cmd, normal, spread)
    local unitArray = {}
    for u, _ in pairs(unitMap) do
        unitArray[#unitArray + 1] = u
    end
    return GiveOrdersToUnitArray(orig, target, unitArray, cmd, normal, spread)
end

local function LookForSupplies()
    local eCurr, eStor = GetTeamResources(myTeamID, "energy")
    if eStor < 1 then
        eStor = 1
    end

    for u,max_ammo in pairs(maxAmmo) do
        if refilling[u] then
            if (GetUnitRulesParam(u, "ammo") == max_ammo) or
               (GetUnitRulesParam(u, "ammo") > 0 and eCurr / eStor < 0.05) then
                -- Back to work!
                refilling[u] = nil
                newUnitCount = newUnitCount + 1
                newUnits[u] = true
            end
        elseif GetUnitRulesParam(u, "ammo") == 0 and GetUnitRulesParam(u, "insupply") == 0 then
            local ux, _, uz = GetUnitPosition(u)
            local x, z, d = nil, nil, hugefloat
            -- Look for the closest supplies provider
            for s, radius in pairs(supplyRanges) do
                local sx, _, sz = GetUnitPosition(s)
                local dx, dz = sx - ux, sz - uz
                local dist = sqrt(dx * dx + dz * dz)
                if dist - 0.5 * radius < d then
                    d = dist - 0.5 * radius
                    x, z = ux + dx * d / dist, uz + dz * d / dist
                end
            end
            if x ~= nil and z ~= nil then
                refilling[u] = true
                units[u] = nil
                local y = GetGroundHeight(x, z)
                Log("Unit ", tostring(u), " go for supplies at [", x, ", ", y, ", ", z, "]")
                GiveOrderToUnit(u, CMD_MOVE, {x, y, z},  {})
            end
        elseif GetUnitRulesParam(u, "ammo") < 0.5 * max_ammo and GetUnitRulesParam(u, "insupply") == 0 then
            taxiMgr.AddSupplyMission(u)
        end
    end    
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

    if gadget.IsDebug(myTeamID) then
        local frontline, normals, _ = waypointMgr.GetFrontline(myTeamID, myAllyTeamID)
        for i = 1,#frontline do
            local x, y, z = frontline[i].x, frontline[i].y, frontline[i].z
            local dx, dy, dz = 15 * normals[i][1], 0, 15 * normals[i][2]
            Spring.MarkerAddPoint(x, y, z)
            Spring.MarkerAddLine(x, y, z, x + dx, y + dy, z+ dz)
        end        
    end

    if newUnitCount >= SQUAD_SIZE then
        local x, z = avgPosUnitMap(newUnits)
        local target, normal, previous = intelligence.GetTarget(x, z)
        if target ~= nil then
            local orig = waypointMgr.GetNearestWaypoint2D(x, z)
            local unitArray, taxiUnitArray = {}, {}
            for u, _ in pairs(newUnits) do
                units[u] = target -- remember where we are going for UnitIdle
                unitArray[#unitArray + 1] = u
                local eta = GetUnitETA(u, target)
                if UnitDefs[GetUnitDefID(u)].mass <= 100 and eta > TAXI_ETA then
                    taxiUnitArray[#taxiUnitArray + 1] = u
                end
            end
            GiveOrdersToUnitArray(orig, target, unitArray, CMD.FIGHT, normal, SQUAD_SPREAD)

            if #taxiUnitArray > 0 then
                -- Don't unload the units straight at the combat line
                target = waypointMgr.GetNext(target, -normal[1], -normal[2])
                target = waypointMgr.GetNext(target, -normal[1], -normal[2])
                taxiMgr.AddTransportMission(taxiUnitArray,
                                            {target.x, target.y, target.z})
            end

            newUnits = {}
            newUnitCount = 0
        end
    end

    -- Ask the units running out of ammo to retreat for supplies
    LookForSupplies()

    -- make temporary data structure of squads (units at or moving towards same waypoint)
    local squads = {} -- waypoint -> array of unitIDs
    for u,p in pairs(units) do
        local squad = (squads[p] or {})
        squad[#squad+1] = u
        squads[p] = squad
    end

    -- give each orders towards the nearest relevant waypoint
    for p,unitArray in pairs(squads) do
        local x, z = avgPosUnitArray(unitArray)
        local target, normal, previous = intelligence.GetTarget(x, z)
        if target ~= nil then
            target = waypointMgr.GetNext(target, normal[1], normal[2])
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
                local orig = waypointMgr.GetNearestWaypoint2D(x, z)
                GiveOrdersToUnitArray(orig, target, unitArray, CMD.FIGHT, normal, SQUAD_SPREAD)
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
    if not waypointMgr then
        return false
    end
    local unitDef = UnitDefs[unitDefID]
    if unitDef.speed ~= 0 then
        -- if it's a mobile unit, give it orders towards frontline
        newUnits[unitID] = true
        newUnitCount = newUnitCount + 1

        if unitDef.customParams.maxammo ~= nil then
            local ammo = tonumber(unitDef.customParams.maxammo)
            if ammo > 0 then
                maxAmmo[unitID] = ammo
            end
        end

        return true --signal Team.UnitFinished that we will control this unit
    elseif unitDef.customParams.supplyrange then
        -- Static ammo supply, save it for later
        supplyRanges[unitID] = unitDef.customParams.supplyrange
    end

    return false
end

function CombatMgr.UnitDestroyed(unitID, unitDefID, unitTeam, attackerID, attackerDefID, attackerTeam)
    units[unitID] = nil
    maxAmmo[unitID] = nil
    supplyRanges[unitID] = nil
    refilling[unitID] = nil
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
