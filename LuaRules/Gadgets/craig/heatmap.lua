-- Author: Jose Luis Cercos-Pita
-- License: GNU General Public License v2

--[[
This class is implemented as a single function returning a table with public
interface methods.  Private data is stored in the function's closure.

Public interface:

function HeatmapMgr.GameStart()
function HeatmapMgr.GameFrame(f)
function HeatmapMgr.UnitDestroyed(unitID, unitDefID, unitTeam, attackerID, attackerDefID, attackerTeam)
]]--

local spGetUnitDefID = Spring.GetUnitDefID
local spGetUnitIsDead = Spring.GetUnitIsDead
local spGetUnitAllyTeam = Spring.GetUnitAllyTeam

function CreateHeatmapMgr(myTeamID, myAllyTeamID, Log)

local UNITS_PER_FRAME = 5
-- local F_D, F_P, F_A = 1e-8, 1.0 / 50.0, 1e-8
local F_D, F_P, F_A = 1e-7, 0.2, 1e-7
local F_H = 2e-9
local HeatmapMgr = {}

local armourTypesByKey = {}
local armourTypesById = {}
for i, armourType in ipairs(Game.armorTypes) do
    armourTypesById[i] = armourType
    armourTypesByKey[armourType] = i
end
local units = {}
local intelligence

local function parse_unit(unitID)
    local heats = {}
    if spGetUnitIsDead(unitID) then
        return heats
    end

    local unitDefID = spGetUnitDefID(unitID)
    local unitDef = UnitDefs[unitDefID]
    if  #unitDef.weapons == 0 then
        return heats
    end

    -- Ask intelligence if the unit can be parsed
    -- ...

    -- Get the firepower, which is a combination of the potential damage, d,
    -- the penetration, p, the reloading time, t, and the inaccuracy, a:
    --   firepower = sqrt(F_D * (1 + F_P * p) * d / t - F_A * a)
    -- We need to create a heat source for each weapon
    local allied = spGetUnitAllyTeam(unitID) == myAllyTeamID
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
        local radius = weaponDef.range

        local firepower = math.sqrt(F_D * (1 + F_P * p) * d / t - F_A * a)

        heats[#heats + 1] = {radius = radius}
        if allied then
            heats[#heats].color = {r = 0.0, g = firepower, b = 0.0, a = 0.0}
        else
            heats[#heats].color = {r = firepower, g = 0.0, b = 0.0, a = 0.0}
        end
    end

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
    GG.HeatmapManager:AddHeatmap(HeatmapMgr.hmap_name, parse_unit)
    intelligence = gadget.intelligences[myAllyTeamID]
end

function HeatmapMgr.GameFrame(f)
end

function HeatmapMgr.UnitDestroyed(unitID, unitDefID, unitTeam, attackerID, attackerDefID, attackerTeam)
end

--------------------------------------------------------------------------------
--
--  Call-outs
--

function HeatmapMgr.FirepowerGradient(x, z)
    local heatmap = GG.HeatmapManager:GetHeatmap(HeatmapMgr.hmap_name)
    local gx, gy = heatmap:GetGradient(x, z)
    return gx, gy
end

return HeatmapMgr
end
