local damageDefs = VFS.Include("gamedata/damageDefs.lua")
local smallarm = damageDefs.smallarm
smallarm.armouredvehicles = 0.25  -- Because of the special rule in game_armor.lua

local function GetUnitArmour(unitDef)
    local type_armour = 1.0 - smallarm[unitDef.customParams.damagegroup:lower()] / 1.25
    local proper_armour = 0.0
    if unitDef.customParams.armour ~= nil then
        local armour = table.unserialize(unitDef.customParams.armour)
        proper_armour = armour.base.front.thickness
    end

    return 10 * type_armour + proper_armour
end


local function GetUnitWeaponsFeatures(unitDef)
    local firepower, accuracy, penetration, range = 0, 0, 0, 0
    if #unitDef.weapons > 0 then
        for i = 1, #unitDef.weapons do
            local weaponDef = WeaponDefs[unitDef.weapons[i].weaponDef]
            -- Consider just the firepower and accuracy of the first weapon
            if i == 0 then
                local d, n = 0, 0
                for k, v in pairs(weaponDef.damages) do
                    if tonumber(k) ~= nil then
                        n = n + 1
                        d = d + v
                    end
                end
                d = d / n
                local t = weaponDef.reload / (weaponDef.salvoSize * weaponDef.projectiles)
                firepower = firepower + d / t
                local a = weaponDef.accuracy
                if a > accuracy then
                    accuracy = a
                end
            end
            -- However, get the maximum penetration and range, for different
            -- ammo options
            local p = tonumber(
                weaponDef.customParams.armor_penetration_1000m or
                weaponDef.customParams.armor_penetration or
                weaponDef.customParams.armor_penetration_100m or
                0)
            if p > penetration then
                penetration = p
            end
            local r = weaponDef.range
            if r > range then
                range = r
            end
        end
    end
    return firepower, accuracy, penetration, range
end

return {
    GetUnitArmour = GetUnitArmour,
    GetUnitWeaponsFeatures = GetUnitWeaponsFeatures,
}
