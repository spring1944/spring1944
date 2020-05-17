-- Author: Jose Luis Cercos-Pita
-- License: GNU General Public License v2

--[[
This class is implemented as a single function returning a table with public
interface methods.  Private data is stored in the function's closure.

Public interface:

function HeatmapMgr.GameStart()
function HeatmapMgr.GameFrame(f)
function HeatmapMgr.UnitEnteredLos(unitID, unitTeam, allyTeam, unitDefID)
function HeatmapMgr.UnitLeftLos(unitID, unitTeam, allyTeam, unitDefID)
function HeatmapMgr.UnitDestroyed(unitID, unitDefID, unitTeam, attackerID, attackerDefID, attackerTeam)
]]--

function CreateHeatmapMgr(myTeamID, myAllyTeamID, Log)

local UNITS_PER_FRAME = 100
local F_D, F_P, F_A = 1.0 / 20000.0, 1.0 / 200.0, 1.0 / 100000.0
local F_H = 1.0 / 50000.0
local HeatmapMgr = {}

local armourTypesByKey = {}
local armourTypesById = {}
for i, armourType in ipairs(Game.armorTypes) do
    armourTypesById[i] = armourType
    armourTypesByKey[armourType] = i
end
local units = {}

local function parse_unit_heat(unitID, unitDefID)
    local unitDef = UnitDefs[unitDefID]
    local x, y, z = Spring.GetUnitPosition(unitID)
    local heats = {}

    if #unitDef.weapons == 0 then
        -- Nothing interesting for this unit
        return heats
    end

    -- In the red channel we have the firepower, which is a combination of the
    -- potential damage, d, the penetration, p, the reloading time, t, and the
    -- inaccuracy, a:
    --   firepower = F_D * (1 + F_P * p) * d / t - F_A * a
    -- We need to create a heat source for each weapon
    local unit_radius = 1
    for i = 1, #unitDef.weapons do
        local name = tostring(unitID) .. "." .. tostring(i)
        local d = Spring.GetUnitWeaponDamages(
            unitID, i, armourTypesByKey["unarmouredvehicles"])
        local weaponDef = WeaponDefs[unitDef.weapons[i].weaponDef]
        local p = weaponDef.customParams.armor_penetration_1000m or
                  weaponDef.customParams.armor_penetration or
                  weaponDef.customParams.armor_penetration_100m or
                  0
        local t = weaponDef.reload / (weaponDef.salvoSize * weaponDef.projectiles)
        local a = weaponDef.accuracy
        local r = weaponDef.range
        if r > unit_radius then
            unit_radius = r
        end
        heats[name] = {x = x, z = z, radius = r,
                       r = F_D * (1 + F_P * p) * d / t - F_A * a,
                       g = 0.0, b = 0.0, a = 0.0}
    end

    -- In the blue channel we are storing the firepower to vanquish the unit,
    -- as a function of the health points, h, and armors, af, as, ar
    --   resistance = F_H * (1 + F_P * (af + as + ar) / 3) * h
    local name = tostring(unitID)
    local af = unitDef.customParams.armor_front or 0
    local as = unitDef.customParams.armor_side or 0
    local ar = unitDef.customParams.armor_rear or 0
    local a = (af + as + ar) / 3.0
    local h = Spring.GetUnitHealth(unitID)
    heats[name] = {x = x, z = z, radius = unit_radius,
                   g = F_H * (1 + F_P * a) * h,
                   r = 0.0, b = 0.0, a = 0.0}

    return heats
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--
--  The call-in routines
--

function HeatmapMgr.GameStart()
    -- Try to create a Heatmap. This operation would fail if some other allied
    -- team already did the job
    HeatmapMgr.hmap_name = "craig." .. tostring(myAllyTeamID) .. ".ground"
    GG.CreateAIHeatmap(HeatmapMgr.hmap_name, 64, 1.0, 1.0)
end

local first_unit = 1

function HeatmapMgr.GameFrame(f)
    local team_units = Spring.GetTeamUnits(myTeamID)
    if first_unit > #team_units then
        first_unit = 1
    end

    local last_unit = math.min(first_unit + UNITS_PER_FRAME - 1, #team_units)
    for i = first_unit, last_unit do
        local unitID = team_units[i]
        if Spring.ValidUnitID(unitID) and not Spring.GetUnitIsDead(unitID) then
            local unitDefID = Spring.GetUnitDefID(unitID)
            local heats = parse_unit_heat(unitID, unitDefID)
            units[unitID] = heats
            for name, heat in pairs(heats) do
                GG.SetAIHeatmapPump(HeatmapMgr.hmap_name,
                                    name,
                                    heat.x, heat.z,
                                    {r=heat.r, g=heat.g, b=heat.b, a=heat.a},
                                    heat.radius)
            end
        end
    end

    first_unit = last_unit + 1
end

function HeatmapMgr.UnitDestroyed(unitID, unitDefID, unitTeam, attackerID, attackerDefID, attackerTeam)
    if units[unitID] ~= nil then
        for name, _ in pairs(units[unitID]) do
            GG.UnsetAIHeatmapPump(HeatmapMgr.hmap_name, name)
        end

        units[unitID] = nil
    end
end

function HeatmapMgr.UnitEnteredLos(unitID, unitTeam, allyTeam, unitDefID)
end

function HeatmapMgr.UnitLeftLos(unitID, unitTeam, allyTeam, unitDefID)
end

--------------------------------------------------------------------------------
--
--  Initialization
--

return HeatmapMgr
end
