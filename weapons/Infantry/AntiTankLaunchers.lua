-- Infantry Anti-Tank Launchers

-- Implementations
-- RCL & Spigot Mortar
-- PIAT(GBR)
Weapon('PIAT'):Extends('RCL_ATLClass'):Attrs{
  areaOfEffect       = 46,
  edgeEffectiveness  = 0.8,
  name               = [[P.I.A.T.]],
  range              = 245,
  soundStart         = [[GBR_PIAT]],
  targetMoveError    = 0.02,
  customparams = {
    armor_penetration  = 100,
  },
  damage = {
    default            = 8800,
  },
}

-- Panzerfasut 60 (GER)
Weapon('Panzerfaust'):Extends('RCL_ATLClass'):Attrs{
  areaOfEffect       = 55,
  edgeEffectiveness  = 0.01, -- ?
  name               = [[Panzerfaust 60]],
  range              = 235,
  soundStart         = [[GER_Panzerfaust]],
  targetMoveError    = 0.1,
  customparams = {
    armor_penetration  = 170, -- wiki says 200?
  },
  damage = {
    default            = 6400, -- less than PIAT?
  }, 
}

-- Rocket Launchers
Weapon('Panzerschrek'):Extends('Rocket_ATLClass'):Attrs{
  name               = [[RPzB 54/1 Panzerschrek]],
  range              = 360,
  soundStart         = [[GER_Panzerschrek]],
  targetMoveError    = 0.1,
  customparams = {
    armor_penetration  = 200,
  },
  damage = {
    default            = 5280, -- same as bazooka?
  },
}

-- M9A1 Bazooka (USA)
Weapon('M9A1Bazooka'):Extends('Rocket_ATLClass'):Attrs{
  name               = [[M9A1 Bazooka]],
  range              = 270,
  soundStart         = [[US_Bazooka]],
  targetMoveError    = 0.075,
  customparams = {
    armor_penetration  = 108,
  },
  damage = {
    default            = 5280,
  },
}

-- Type 4 Rocket Launcher (JPN)
Weapon('Type4AT'):Extends('Rocket_ATLClass'):Attrs{
  name               = [[Type 4 Rocket Launcher]],
  range              = 270,
  soundStart         = [[US_Bazooka]],
  targetMoveError    = 0.075,
  customparams = {
    armor_penetration  = 108,
  },
  damage = {
    default            = 5280,
  },
}

-- Return only the full weapons
