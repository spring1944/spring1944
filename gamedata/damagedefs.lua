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
    infantry = 1.25,
    guns = 1,
    unarmouredvehicles = 1/5,
    default = 1/6,
	armouredvehicles = 1/10,
    lightbuildings = 1/16,
    bunkers = 0,
    lighttanks = 0,
    mediumtanks = 0,
    heavytanks = 0,
    flag = 0,
	ships = 1,
    mines = 0,
  },
  explosive = {
    infantry = 9,
	ships = 2,
    unarmouredvehicles = 1,
    armouredvehicles = 1/3,
    lightbuildings = 2/3,
    guns = 3/4,
    lighttanks = 2/5,
	mediumtanks = 2/5,
	heavytanks = 2/5,
    flag = 0,
  },
  kinetic = {
	default = 6/7,
	ships = 1/2,
    unarmouredvehicles = 1/2,
    bunkers = 1/2,
    lightbuildings = 1/16,
	lighttanks = 1/2,
	mediumtanks = 1/2,
	heavytanks = 1/2,
    flag = 0,
    mines = 0,
  },
  shapedcharge = {
	ships = 2,
    lightbuildings = 1/10,
    flag = 0,
  },
  fire = {
    bunkers = 4,
	lightbuildings = 3/2,
	ships = 3/2,
    unarmouredvehicles = 2,
	armouredvehicles = 3/2,
	lighttanks = 1,
    mediumtanks = 3/4,
	heavytanks = 1/2,
    flag = 0,
  },
  grenade = {
    infantry = 9,
	ships = 2,
    unarmouredvehicles = 1,
    armouredvehicles = 1/3,
    lightbuildings = 2/3,
    guns = 3/4,
    lighttanks = 1/6,
	mediumtanks = 1/3,
	heavytanks = 8/7,
    flag = 0,
  },
}

return damagedefs