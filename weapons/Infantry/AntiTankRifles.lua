-- Smallarms - Anti-Tank Rifles
 
-- Implementations
-- PTRD (RUS)
Weapon('PTRD'):Extends('ATRifleClass'):Attrs{
  accuracy           = 225,
  name               = [[PTRD]],
  range              = 655,
  reloadtime         = 12,
  rgbColor           = [[0.0 0.7 0.0]],
  soundStart         = [[RUS_PTRD]],
  weaponVelocity     = 2024,
  customparams = {
    armor_penetration_1000m = 16,
    armor_penetration_100m = 35,
  },
  damage = {
    default            = 254,
  },
}

-- Solothurn (ITA)
Weapon('Solothurn'):Extends('ATRifleClass'):Attrs{
  accuracy           = 300,
  name               = [[Solothurn S-18/100 Anti-Tank Rifle]],
  range              = 640,
  reloadtime         = 12,
  rgbColor           = [[0.0 0.7 0.0]],
  soundStart         = [[ITA_Solothurn]],
  weaponVelocity     = 1240,
  customparams = {
    armor_penetration_1000m = 16,
    armor_penetration_100m = 35,
  },
  damage = {
    default            = 402,
  },
}

-- Scoped Solothurn (ITA)
Weapon('ScopedSolothurn'):Extends('Solothurn'):Attrs{
  accuracy           = 150,
  name               = [[Solothurn S-18/1000 Anti-Tank Rifle]],
  range              = 1010,
}


