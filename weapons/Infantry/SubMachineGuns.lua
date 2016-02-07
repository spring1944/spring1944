-- Smallarms - Infantry Submachineguns

-- Implementations
-- STEN Mk. II (GBR)
Weapon('STEN'):Extends('SMGClass'):Attrs{
  burstrate          = 0.1,
  name               = [[STEN Mk. II]],
  range              = 300,
  reloadtime         = 1.8,
  soundStart         = [[GBR_STEN]],
}

-- Commando Silenced STEN Mk. IIS (GBR)
-- derives from the above STEN
Weapon('SilencedSten'):Extends('STEN'):Attrs{ -- name append
  burst              = 3,
  movingAccuracy     = 400,
  name               = [[Silenced]],
  range              = 360,
  reloadtime         = 1.2,
  sprayAngle         = 200,
  damage = {
    default            = 80,
  }
}

-- MP.40 (GER)
Weapon('MP40'):Extends('SMGClass'):Attrs{
  burstRate          = 0.12,
  movingAccuracy     = 470, -- intended?
  name               = [[Maschinenpistole 40]],
  range              = 330,
  reloadtime         = 2,
  soundStart         = [[GER_MP40]],
}

-- M1A1 Thompson (USA)
Weapon('Thompson'):Extends('SMGClass'):Attrs{
  burst              = 6,
  burstRate          = 0.086,
  movingAccuracy     = 1170, -- O_o
  name               = [[M1A1 Thompson]],
  range              = 300,
  reloadtime         = 1.7,
  soundStart         = [[US_Thompson]],
  sprayAngle         = 400, -- intended?
  damage = {
    default            = 19, -- intended?
  },
}

-- PPSh (RUS)
Weapon('PPSh'):Extends('SMGClass'):Attrs{
  burst              = 9,
  burstRate          = 0.05,
  movingAccuracy     = 933,
  name               = [[PPsh-1941]],
  range              = 310,
  reloadtime         = 1.5,
  rgbColor           = [[0.3 0.75 0.4]],
  soundStart         = [[RUS_PPsh]],
  sprayAngle         = 500,
}

-- Beretta M38 (ITA)
Weapon('BerettaM38'):Extends('SMGClass'):Attrs{
  burst              = 8,
  burstRate          = 0.086,
  movingAccuracy     = 1300,
  name               = [[Beretta Model 38]],
  range              = 325,
  reloadtime         = 1.7,
  soundStart         = [[ITA_BerettaM38]],
  sprayAngle         = 380,
}

-- FNAB-43 (ITA)
Weapon('FNAB43'):Extends('SMGClass'):Attrs{
  burst              = 5,
  burstRate          = 0.112,
  movingAccuracy     = 1000,
  name               = [[FNAB-43]],
  range              = 340,
  reloadtime         = 1.2,
  soundStart         = [[ITA_Fnab43]],
  sprayAngle         = 300,
  damage = {
    default            = 19, -- intended?
  },
}

Weapon('Type100SMG'):Extends('SMGClass'):Attrs{
  burst              = 5,
  burstRate          = 0.066,
  movingAccuracy     = 1300,
  name               = [[Type 100 Submachinegun]],
  range              = 325,
  reloadtime         = 1.7,
  soundStart         = [[JPN_Type100_SMG]],
  sprayAngle         = 380,
}

-- Return only the full weapons
