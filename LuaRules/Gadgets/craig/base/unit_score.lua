local damageDefs = VFS.Include("gamedata/damageDefs.lua")
local smallarm = damageDefs.smallarm
smallarm.armouredvehicles = 0.25  -- Because of the special rule in game_armor.lua

function GetUnitScore(unitDefID, w_cap, w_view, w_speed, w_supply,
                                 w_armour, w_firepower, w_accuracy,
                                 w_penetration, w_range)
    local unitDef = UnitDefs[unitDefID]
    local type_armour = 1.0 - smallarm[unitDef.customParams.damageGroup] / 1.25
    local proper_armour = 0.0
    if unitDef.customParams.armour ~= nil then
        extra_armour = unitDef.customParams.armour.base.front.thickness / 10
    end
    local firepower, accuracy, penetration, range = 0, 0, 0, 0
    if #unitDef.weapons > 0 then
        for i = 1, #unitDef.weapons do
            local weaponDef = WeaponDefs[unitDef.weapons[i].weaponDef]
            local d = weaponDef.damage.default or 0
            local t = weaponDef.reload / (weaponDef.salvoSize * weaponDef.projectiles)
            firepower = firepower + d / t 
            local a = 100 / (weaponDef.accuracy > 0 and weaponDef.accuracy or 1)
            if a > accuracy then
                accuracy = a
            end
            local p = (weaponDef.customParams.armor_penetration_1000m or
                       weaponDef.customParams.armor_penetration or
                       weaponDef.customParams.armor_penetration_100m or
                       0) / 10
            if p > penetration then
                penetration = p
            end
            local r = weaponDef.range / 1000
            if r > range then
                range = r
            end
        end
    end
    return w_cap * unitDef.customParams.flagcaprate +
           w_view * unitDef.sightDistance / 1000.0 +
           w_speed * unitDef.speed +
           w_supply * (unitDef.customParams.supplyRange or 0) / 1000.0
           w_armour * (type_armour + proper_armour) +
           w_firepower * firepower +
           w_accuracy * accuracy +
           w_penetration * penetration +
           w_range * range
end

return {
    GetUnitScore = GetUnitScore,
}
