local damagedefs = {
  default = {},
  none = {},
  smallarm = {
    infantry = 1,
    guns = 1,
    unarmouredvehicles = 1/4,
    default = 1/8,
    lightbuildings = 1/16,
    bunkers = 0,
    tanks = 0,
    flag = 0,
    mines = 0,
  },
  explosive = {
    infantry = 8,
    unarmouredvehicles = 2,
    armouredvehicles = 1/2,
    guns = 1/2,
    tanks = 1/2,
    bunkers = 1/4,
    flag = 0,
  },
  kinetic = {
    lightbuildings = 1/8,
    bunkers = 1/8,
    flag = 0,
    mines = 0,
  },
  shapedcharge = {
    bunkers = 2,
    flag = 0,
  },
  fire = {
    bunkers = 4,
    unarmouredvehicles = 2,
    tanks = 1/2,
    flag = 0,
  },
}

return damagedefs