-- Armour - Medium Heavy Gun (85 to 100mm)

-- Implementations

-- KwK36 8.8cm L/56 (GER)
Weapon('KwK88mmL56'):Extends('MediumHeavyGun'):Attrs{
  name               = [[KwK36 8.8cm L/56]],
  range              = 2110,
  reloadTime         = 9.15,
  soundStart         = [[GER_88mm]],
}

Weapon('KwK88mmL56HE'):Extends('MediumHE'):Extends('KwK88mmL56'):Attrs{ -- name append
  areaOfEffect       = 100,
  weaponVelocity     = 1250,
  damage = {
    default            = 1940,
  },  
}
Weapon('KwK88mmL56AP'):Extends('HeavyAP'):Extends('KwK88mmL56'):Attrs{ -- name append
  weaponVelocity     = 1490,
  customparams = {
    armor_penetration_1000m = 100,
    armor_penetration_100m  = 120,
  },
  damage = {
    default            = 3154,
  },
}

-- KwK43 8.8cm L/71 (GER)
Weapon('KwK88mmL71'):Extends('MediumHeavyGun'):Attrs{
  name               = [[KwK43 8.8cm L/71]],
  range              = 2510,
  reloadTime         = 9.75,
  soundStart         = [[GER_88mmL71]],
  customparams = {
    weaponcost    = 26,
  },
}

Weapon('KwK88mmL71HE'):Extends('MediumHE'):Extends('KwK88mmL71'):Attrs{ -- name append
  areaOfEffect       = 96,
  weaponVelocity     = 1250,
  damage = {
    default            = 1740, -- ?
  },  
}
Weapon('KwK88mmL71AP'):Extends('HeavyAP'):Extends('KwK88mmL71'):Attrs{ -- name append
  weaponVelocity     = 2000,
  customparams = {
    armor_penetration_1000m = 165,
    armor_penetration_100m  = 202,
  },
  damage = {
    default            = 3194,
  },
}

-- SK 8.8cm C/30 (GER)
Weapon('SK88mmC30'):Extends('MediumHeavyGun'):Extends('MediumHE'):Attrs{ -- name append
  areaOfEffect       = 85,
  name               = [[8.8cm SK C/30 Naval Gun]],
  range              = 2110,
  reloadTime         = 4, -- 15rpm
  soundStart         = [[GER_88mm]],
  weaponVelocity     = 1250,
  damage = {
    default            = 1275,
  },  
}


-- S-53 85mm (RUS)
Weapon('S5385mm'):Extends('MediumHeavyGun'):Attrs{
  name               = [[S-53 85mm]],
  range              = 1605,
  reloadTime         = 6.75,
  soundStart         = [[RUS_85mm]],
  customparams = {
    weaponcost         = 17,
  },
}

Weapon('S5385mmHE'):Extends('MediumHE'):Extends('S5385mm'):Attrs{ -- name append
  areaOfEffect       = 87,
  weaponVelocity     = 1400,
  damage = {
    default            = 1280,
  },  
}
Weapon('S5385mmAP'):Extends('HeavyAP'):Extends('S5385mm'):Attrs{ -- name append
  weaponVelocity     = 1584,
  customparams = {
    armor_penetration_1000m = 86,
    armor_penetration_100m  = 112,
  },
  damage = {
    default            = 3033,
  },
}


-- D-10 100mm (RUS)
Weapon('D10S100mm'):Extends('MediumHeavyGun'):Attrs{
  name               = [[D-10 100mm]],
  range              = 2260,
  reloadTime         = 10,
  soundStart         = [[RUS_85mm]],
  customparams = {
    weaponcost         = 22,
    cegflare           = "LARGE_MUZZLEFLASH",
  }
}

Weapon('D10S100mmAP'):Extends('HeavyAP'):Extends('D10S100mm'):Attrs{ -- name append
  weaponVelocity     = 1760,
  customparams = {
    armor_penetration_1000m = 146,
    armor_penetration_100m  = 186,
  },
  damage = {
    default            = 3985,
  },
}


-- M3 90mm (USA)
Weapon('M390mm'):Extends('MediumHeavyGun'):Attrs{
  name               = [[M3 90mm]],
  range              = 2110,
  reloadTime         = 9.15,
  soundStart         = [[GER_88mm]],
}

Weapon('M390mmHE'):Extends('MediumHE'):Extends('M390mm'):Attrs{ -- name append
  areaOfEffect       = 100,
  weaponVelocity     = 1250,
  damage = {
    default            = 1940,
  },  
}
Weapon('M390mmAP'):Extends('HeavyAP'):Extends('M390mm'):Attrs{ -- name append
  weaponVelocity     = 1490,
  customparams = {
    armor_penetration_1000m = 107,
    armor_penetration_100m  = 151,
  },
  damage = {
    default            = 3303,
  },
}

-- 90mm Ansaldo 90/53 M41 L/53 (ITA)
Weapon('Ansaldo90mmL53'):Extends('MediumHeavyGun'):Attrs{
  name               = [[90mm Ansaldo 90/53 M41 L/53]],
  range              = 2110,
  reloadTime         = 9.25,
  soundStart         = [[GER_88mm]],
}

Weapon('Ansaldo90mmL53HE'):Extends('MediumHE'):Extends('Ansaldo90mmL53'):Attrs{ -- name append
  areaOfEffect       = 104,
  weaponVelocity     = 1044,
  damage = {
    default            = 3060,
  },  
}
Weapon('Ansaldo90mmL53AP'):Extends('HeavyAP'):Extends('Ansaldo90mmL53'):Attrs{ -- name append
  weaponVelocity     = 1490,
  customparams = {
    armor_penetration_1000m = 90,
    armor_penetration_100m  = 126,
  },
  damage = {
    default            = 3354,
  },
}

-- OTO 100mm/47 1928 Naval gun (ITA)
Weapon('OTO100mmL47HE'):Extends('MediumHeavyGun'):Extends('MediumHE'):Attrs{ -- name append
  areaOfEffect       = 110,
  name               = [[100mm/47 mod.1928 Naval Gun]],
  range              = 1700,
  reloadTime         = 6,
  soundStart         = [[GEN_105mm]],
  weaponVelocity     = 1400,
  damage = {
    default            = 3000,
  },  
}

-- Ansaldo 105mm/25 (ITA)
Weapon('Ansaldo105mmL25'):Extends('MediumHeavyGun'):Attrs{
  name               = [[Ansaldo L/18 75mm Howitzer]],
  range              = 1775,
  reloadTime         = 11.25,
  soundStart         = [[GEN_105mm]],
  customparams = {
    cegflare           = "LARGE_MUZZLEFLASH",
  }
}

Weapon('Ansaldo105mmL25HE'):Extends('MediumHE'):Extends('Ansaldo105mmL25'):Attrs{ -- name append
  areaOfEffect       = 129,
  weaponVelocity     = 900,
   soundHitDry        = [[GEN_Explo_4]],
  damage = {
    default            = 4009,
  },  
}

Weapon('Ansaldo105mmL25HEAT'):Extends('HeavyHEAT'):Extends('Ansaldo105mmL25'):Attrs{ -- name append
  range              = 1153,
  weaponVelocity     = 600,
  customparams = {
    armor_penetration       = 140,
  },
  damage = {
    default            = 3790,
  },
}



-- Return only the full weapons
