-- Smallarms - Infantry Pistols

-- Implementations
-- Enfield No. 2 Mk. I (GBR)
Weapon('Webley'):Extends('PistolClass'):Attrs{
  name               = [[Enfield No. 2 Mk. I]], soundStart         = [[GBR_Webley]],
  damage = {
    default            = 35, -- intended?
  },
}

-- Walter P38 (GER)
Weapon('WaltherP38'):Extends('PistolClass'):Attrs{
  name               = [[Walther P38]],
  soundStart         = [[GER_Walther]],
}

-- M1911A1 Colt (USA)
Weapon('M1911A1Colt'):Extends('PistolClass'):Attrs{
  name               = [[M1911A1 Colt]],
  reloadtime         = 1, -- intended?
  soundStart         = [[US_Colt]],
  sprayAngle         = 50, -- intended?
}

-- Tokarev TT-33 (RUS)
Weapon('TT33'):Extends('PistolClass'):Attrs{
  name               = [[Tokarev TT-33]],
  reloadtime         = 1.5, -- intended?
  soundStart         = [[RUS_TT33]],
  damage = {
    default            = 41, -- intended?
  },
}

-- Beretta M1934 (ITA)
Weapon('BerettaM1934'):Extends('PistolClass'):Attrs{
  name               = [[Beretta M1934]],
  reloadtime         = 1, -- intended?
  soundStart         = [[ITA_BerettaM34]],
  sprayAngle         = 50, -- intended?
}

Weapon('NambuType14'):Extends('PistolClass'):Attrs{
  name               = [[Nambu Type 14 8mm]],
  reloadtime         = 1, -- intended?
  soundStart         = [[ITA_BerettaM34]],
  sprayAngle         = 50, -- intended?
}

-- Return only the full weapons
