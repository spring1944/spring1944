--[[
  format:
  
  damagetype = {
    armortype = damageMod,
    ...
  }
  
  the damage mods are relative to the default damage given in the unit files
  you can change the default damage too, but other damage mods are based off the original
  damage mods other than default given explicitly in the unit files override these
  
  default usually corresponds to armouredvehicles
]]

local damagedefs = {
  default = {},
  none = {
    default = 0,
  },
  smallarm = {
    --[[NOTE - armoredvehicles have a special clause in game_armor.lua which prevents them from taking damage from smallarms EXCEPT for heavy MGs, which still damage them.]]--
    infantry = 1.25,
    guns = 1,
    unarmouredvehicles = 1,
    default = 1/6,
	armouredvehicles = 5/6,
    lightbuildings = 1/16,
    bunkers = 0,
    planes = 2/3,
    lighttanks = 0,
    mediumtanks = 0,
    heavytanks = 0,
	ships = 2/25,
    armouredPlanes = 1/9,
    invincible = 0,
	shipturrets = 1/9,
	hardships = 0,
	shipturrets = 3/7,
    mines = 0,
  },
  explosive = {
	bunkers = 1/2,
	armouredPlanes = 3/5,
    infantry = 3/2,
	ships = 15/7,
	hardships = 1/2,
	shipturrets = 3/5,
    unarmouredvehicles = 1,
    armouredvehicles = 1/2,
    lightbuildings = 4/5,
    guns = 3/5,
    lighttanks = 1/3,
	mediumtanks = 1/3,
	heavytanks = 1/3,
    invincible = 0,
  },
  kinetic = {
	default = 1,
	unarmouredvehicles = 2,
	armouredvehicles = 7/5,
	ships = 1,
	hardships = 5/3,
	shipturrets = 1,
    bunkers = 1/2,
    lightbuildings = 1/16,
	lighttanks = 9/10,
	mediumtanks = 9/10,
	heavytanks = 9/10,
    invincible = 0,
    mines = 0,
  },
  shapedcharge = {
	ships = 1/2,
	hardships = 5/4,
	shipturrets = 2/3,
	lighttanks = 9/10,
	mediumtanks = 9/10,
	heavytanks = 9/10,
    lightbuildings = 1/10,
    invincible = 0,
  },
  fire = {
    bunkers = 4,
    infantry = 4/3,
    guns = 5/4,
	lightbuildings = 3/2,
	ships = 3/2,
	hardships = 1,
	shipturrets = 3/2,
    unarmouredvehicles = 2,
	armouredvehicles = 3/2,
	lighttanks = 1,
    mediumtanks = 3/4,
	heavytanks = 1/2,
    invincible = 0,
  },
  grenade = {
    infantry = 3,
	ships = 2,
	hardships = 1,
	shipturrets = 2,
    unarmouredvehicles = 1,
    armouredvehicles = 1,
    lightbuildings = 2/3,
    guns = 3/4,
    lighttanks = 2/5,
	mediumtanks = 2/5,
	heavytanks = 2/5,
    invincible = 0,
  },
}

return damagedefs
