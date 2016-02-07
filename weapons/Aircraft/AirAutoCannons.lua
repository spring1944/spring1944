-- Aircraft - Aircraft Automatic Cannons

-- Implementations

-- Hispano HS.404 20mm (GBR)
Weapon('HS40420mm'):Extends('AutoCannonHE'):Extends('AirAutoCannon'):Attrs{ -- name append
  areaOfEffect       = 10,
  burst              = 3,
  burstrate          = 0.1,
  name               = [[Hispano HS.404 20mm Aircraft Cannon]],
  range              = 900,
  reloadtime         = 1.1,
  soundStart         = [[GBR_20mmAir]],
  weaponVelocity     = 2700,
  damage = {
    default            = 110,
  },
}

-- Mk. 108 30mm (GER)
Weapon('Mk10830mm'):Extends('AutoCannonHE'):Extends('AirAutoCannon'):Attrs{ -- name append
  areaOfEffect       = 25,
  burst              = 3,
  burstRate          = 0.25,
  name               = [[30mm Mk 108 Aircraft Cannon]],
  range              = 700,
  reloadtime         = 3,
  soundStart         = [[GER_30mmAir]],
  sprayAngle         = 100, -- overrides deafult
  weaponVelocity     = 1750,
  damage = {
    default            = 182,
  },
}

-- MG151/20 20mm (GER)
Weapon('MG15120mm'):Extends('AutoCannonHE'):Extends('AirAutoCannon'):Attrs{ -- name append
  areaOfEffect       = 15,
  burst              = 6,
  burstRate          = 0.085,
  name               = [[20mm MG 151/20 Aircraft Cannon]],
  range              = 900,
  reloadtime         = 1.25,
  soundStart         = [[GER_20mmAir]],
  weaponVelocity     = 2000,
  damage = {
    default            = 52,
  },
}

-- MG151/15 15mm (GER)
-- treated like a machinegun in game, but
-- this derives from the above 20mm
Weapon('MG15115mm'):Extends('AutoCannonHE'):Extends('AirAutoCannon'):Attrs{ -- name append
  areaOfEffect       = 8,
  burstRate          = 0.08,
  explosionGenerator = [[custom:Bullet]],
  name               = [[15mm MG 151/15 Aircraft Cannon]],  
  predictBoost       = 0.75,
  reloadTime         = 0.8, -- why so different?
  soundStart         = [[GER_15mmAir]],
  damage = {
    default            = 40,
  },
} 

-- ShVAK 20mm (RUS)
Weapon('ShVAK20mm'):Extends('AutoCannonHE'):Extends('AirAutoCannon'):Attrs{ -- name append
  areaOfEffect       = 10,
  burst              = 3,
  burstRate          = 0.085,
  name               = [[20mm ShVAK Aircraft Cannon]],
  range              = 900,
  reloadtime         = 1,
  soundStart         = [[RUS_20mm]],
  weaponVelocity     = 2600,
  damage = {
    default            = 67,
  },
}

-- VYa 23mm (RUS)
Weapon('VYa23mm'):Extends('AutoCannonHE'):Extends('AirAutoCannon'):Attrs{ -- name append
  areaOfEffect       = 14,
  burst              = 3,
  burstRate          = 0.085,
  name               = [[23mm VYa Aircraft Cannon]],
  range              = 900,
  reloadtime         = 1,
  soundStart         = [[RUS_20mm]],
  weaponVelocity     = 2600,
  damage = {
    default            = 110,
  },
}

-- Ho-5 20mm AP (JPN)
Weapon('Ho520mmAP'):Extends('AutoCannonAP'):Extends('AirAutoCannon'):Attrs{ -- name append
  burst              = 5,
  burstRate          = 0.091,
  name               = [[Ho-5 20mm Cannon AP]],
  range              = 830,
  reloadTime         = 0.8,
  soundStart         = [[JPN_20mmAir]],
  weaponVelocity     = 1800,
  customparams = {
    armor_penetration_1000m  = 6,
    armor_penetration_100m   = 28,
  },
  damage = {
    default            = 305,
  },
}

-- Ho-5 20mm HE (JPN) 
Weapon('Ho520mmHE'):Extends('AutoCannonHE'):Extends('AirAutoCannon'):Attrs{ -- name append
  burst              = 5,
  areaOfEffect       = 6,
  burstRate          = 0.091,
  name               = [[Ho-5 20mm Cannon HE]],
  range              = 830,
  reloadTime         = 0.8,
  soundStart         = [[JPN_20mmAir]],
  weaponVelocity     = 1800,
  damage = {
    default            = 54,
  },
}

-- Return only the full weapons
