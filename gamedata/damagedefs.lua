local damagedefs = {
  default = {},
  none = {},
  smallarm = {
    lightbuildings = 0.25,
    bunkers = 0,
    tanks = 0,
    infantry = 10,
    guns = 10,
    planes = 10,
    flag = 0,
    mines = 0,
  },
  explosive = {
    bunkers = 0.25,
    unarmouredvehicles = 2,
    tanks = 0.25,
    flag = 0,
  },
  kinetic = {
    lightbuildings = 0.1,
    bunkers = 0.1,
    flag = 0,
    mines = 0,
  },
  shapedcharge = {
    bunkers = 2,
    flag = 0,
  },
  flame = {
    bunkers = 5,
    flag = 0,
  },
}

return damagedefs