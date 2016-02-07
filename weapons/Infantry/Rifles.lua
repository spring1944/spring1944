-- Smallarms - Infantry Rifles
-- Implementations

-- SMLE No. 4 Mk. I (GBR)
Weapon('Enfield'):Extends('RifleClass'):Attrs{
  accuracy           = 50, -- overwrites default
  name               = [[Lee-Enfield No. 4 Mk. I]],
  range              = 680,
  reloadtime         = 2.5,
  soundStart         = [[GBR_Enfield]],
}

-- Karabiner 98K (GER)
Weapon('K98k'):Extends('RifleClass'):Attrs{
  name               = [[Karabiner 98k]],
  range              = 665,
  reloadtime         = 2.8,
  soundStart         = [[GER_K98K]],
}

-- M1 Garand (USA)
Weapon('M1Garand'):Extends('RifleClass'):Attrs{
  name               = [[M1 Garand]],
  range              = 535,
  reloadtime         = 1.7,
  soundStart         = [[US_M1garand]],
}

-- M1918A2 BAR (USA) (Possibly a little fudged in here)
Weapon('BAR'):Extends('RifleClass'):Attrs{
  burst              = 3,
  burstrate          = 0.1,
  movingAccuracy     = 2667,
  name               = [[Browning Automatic Rifle]],
  range              = 710,
  reloadtime         = 2.25,
  soundStart         = [[US_BAR]],
  sprayAngle         = 300,
  customparams = {
    fearaoe            = 45,
    fearid             = 301,
  },
}

-- Mosin Nagant M1890/30 (RUS)
Weapon('MosinNagant'):Extends('RifleClass'):Attrs{
  name               = [[Mosin-Nagant]],
  range              = 660,
  reloadtime         = 3,
  rgbColor           = [[0.0 0.7 0.0]], -- overwrites default
  soundStart         = [[RUS_MosinNagant]],
}

-- SVT (USSR)
Weapon('SVT'):Extends('RifleClass'):Attrs{
  name               = [[SVT-40]],
  range              = 535,
  reloadtime         = 2,
  rgbColor           = [[0.0 0.7 0.0]], -- overwrites default
  soundStart         = [[RUS_SVT]],
}


-- Carcano 91/38 (ITA)
Weapon('Mod91'):Extends('RifleClass'):Attrs{
  accuracy           = 95, -- overwrites default
  name               = [[Carcano Mod.91/38]],
  range              = 610,
  reloadtime         = 2.6,
  damage = {
    default            = 30,
  },
  soundStart         = [[ITA_CarcanoM91]],
}

-- Carcano 91/41 (ITA)
Weapon('Mod91_41'):Extends('Mod91'):Attrs{
  accuracy           = 65,
  name               = [[Carcano Mod.91/41]],
  range              = 640,
}

-- Arisaka type 99 (JPN)
Weapon('Arisaka99'):Extends('RifleClass'):Attrs{
  accuracy           = 95, -- overwrites default
  name               = [[Arisaka Type 99]],
  range              = 630,
  reloadtime         = 2.5,
  soundStart         = [[JPN_Arisaka_Type99]],
}





-- Implementations

-- SMLE No. 4 Mk. I (T) (GBR)
Weapon('Enfield_T'):Extends('SniperRifleClass'):Attrs{
  name               = [[Lee-Enfield No. 4 Mk. I Scoped]],
  reloadtime         = 8.5, -- overwrites default
  soundStart         = [[GBR_Enfield]],
}

-- Karabiner 98K Scope (GER)
Weapon('K98kScope'):Extends('SniperRifleClass'):Attrs{
  name               = [[Karabiner 98k Scoped]],
  soundStart         = [[GER_K98K]],
}

-- M1903A4 Springfield (USA)
Weapon('M1903Springfield'):Extends('SniperRifleClass'):Attrs{
  movingAccuracy     = 888, -- intended?
  name               = [[M1903A4 Springfield]],
  soundStart         = [[US_Springfield]],
}

-- Mosin Nagant M1890/30 PU (RUS)
Weapon('MosinNagantPU'):Extends('SniperRifleClass'):Attrs{
  name               = [[Mosin-Nagant PU Scoped]],
  soundStart         = [[RUS_MosinNagant]],
}


-- Carcano 91 Sniper (ITA)
Weapon('Mod91Sniper'):Extends('SniperRifleClass'):Attrs{
  name               = [[Carcano Mod.91 Sniper Model]],
  soundStart         = [[ITA_CarcanoM91]],
}

-- Arisaka type 99 Sniper (JPN)
Weapon('Arisaka99Sniper'):Extends('SniperRifleClass'):Attrs{
  name               = [[Arisaka Type 99 Sniper Model]],
  soundStart         = [[JPN_Arisaka_Type99]],
}

-- Return only the full weapons
