-- Armour - Medium Gun (75 to 76mm)

-- Implementations

-- QF 75mm (GBR)
Weapon('QF75mm'):Extends('MediumGun'):Attrs{
  name               = [[QF 75mm Mk.V]],
  range              = 1270,
  reloadTime         = 5.25,
  soundStart         = [[US_75mm]],
}

Weapon('QF75mmHE'):Extends('MediumHE'):Extends('QF75mm'):Attrs{ -- name append
  areaOfEffect       = 88,
  weaponVelocity     = 926,
  damage = {
    default            = 1334,
  },  
}
Weapon('QF75mmAP'):Extends('MediumAP'):Extends('QF75mm'):Attrs{ -- name append
  weaponVelocity     = 1236,
  customparams = {
    armor_penetration_1000m = 52,
    armor_penetration_100m  = 81,
  },
  damage = {
    default            = 2559,
  },
}

-- QF 17pdr 76mm (GBR)
Weapon('QF17Pdr'):Extends('MediumGun'):Attrs{
  name               = [[QF 17Pdr Mk.IV]],
  range              = 1690,
  reloadTime         = 6.75,
  soundStart         = [[US_76mm]],
  customparams = {
    weaponcost    = 19,
  },
}

Weapon('QF17PdrHE'):Extends('MediumHE'):Extends('QF17Pdr'):Attrs{ -- name append
  areaOfEffect       = 90,
  weaponVelocity     = 1768,
  damage = {
    default            = 1420,
  },  
}
Weapon('QF17PdrAP'):Extends('MediumAP'):Extends('QF17Pdr'):Attrs{ -- name append
  weaponVelocity     = 1584,
  customparams = {
    armor_penetration_1000m = 119,
    armor_penetration_100m  = 140,
  },
  damage = {
    default            = 2777,
  },
}

-- KwK 40 75mm L/48 (GER)
Weapon('KwK75mmL48'):Extends('MediumGun'):Attrs{
  name               = [[7.5cm KwK 40 L/48]],
  range              = 1520,
  reloadTime         = 6.45,
  soundStart         = [[GER_75mm]],
  customparams = {
    weaponcost    = 16,
  },  
}

Weapon('KwK75mmL48HE'):Extends('MediumHE'):Extends('KwK75mmL48'):Attrs{ -- name append
  areaOfEffect       = 87,
  weaponVelocity     = 1096,
  damage = {
    default            = 1280,
  },  
}
Weapon('KwK75mmL48AP'):Extends('MediumAP'):Extends('KwK75mmL48'):Attrs{ -- name append
  weaponVelocity     = 1480,
  customparams = {
    armor_penetration_1000m = 81,
    armor_penetration_100m  = 91,
  },
  damage = {
    default            = 2613,
  },
}

-- KwK 42 75mm L/71 (GER)
Weapon('KwK75mmL71'):Extends('MediumGun'):Attrs{
  name               = [[7.5cm KwK 42 L/71]],
  range              = 1860,
  reloadTime         = 7.65,
  soundStart         = [[GER_75mmLong]],
  customparams = {
    weaponcost    = 19,
  },
}

Weapon('KwK75mmL71HE'):Extends('MediumHE'):Extends('KwK75mmL71'):Attrs{ -- name append
  areaOfEffect       = 85,
  weaponVelocity     = 1096,
  damage = {
    default            = 1220,
  },  
}
Weapon('KwK75mmL71AP'):Extends('MediumAP'):Extends('KwK75mmL71'):Attrs{ -- name append
  weaponVelocity     = 1870,
  customparams = {
    armor_penetration_1000m = 111,
    armor_penetration_100m  = 138,
  },
  damage = {
    default            = 2608,
  },
}

-- F-34 76.2mm (RUS)
Weapon('F3476mm'):Extends('MediumGun'):Attrs{
  name               = [[F-34 76.2mm]],
  range              = 1270,
  reloadTime         = 5.25,
  soundStart         = [[RUS_76mm]],
}

Weapon('F3476mmHE'):Extends('MediumHE'):Extends('F3476mm'):Attrs{ -- name append
  areaOfEffect       = 103, -- !
  weaponVelocity     = 926,
  damage = {
    default            = 2160,
  },  
}
Weapon('F3476mmAP'):Extends('MediumAP'):Extends('F3476mm'):Attrs{ -- name append
  weaponVelocity     = 1358,
  customparams = {
    armor_penetration_1000m = 46,
    armor_penetration_100m  = 67,
  },
  damage = {
    default            = 2510,
  },
}

-- ZiS-3 76.2mm (RUS)
Weapon('ZiS376mm'):Extends('MediumGun'):Attrs{
  name               = [[ZiS-3 76.2mm]],
  range              = 1310,
  reloadTime         = 5.25,
  soundStart         = [[RUS_76mm]],
}

Weapon('ZiS376mmHE'):Extends('MediumHE'):Extends('ZiS376mm'):Attrs{ -- name append
  areaOfEffect       = 103, -- !
  weaponVelocity     = 926,
  damage = {
    default            = 2160,
  },  
}
Weapon('ZiS376mmAP'):Extends('MediumAP'):Extends('ZiS376mm'):Attrs{ -- name append
  weaponVelocity     = 1420,
  customparams = {
    armor_penetration_1000m = 47,
    armor_penetration_100m  = 70,
  },
  damage = {
    default            = 2510,
  },
}

-- M3 75mm (USA)
Weapon('M375mm'):Extends('MediumGun'):Attrs{
  name               = [[M3 75mm]],
  range              = 1270,
  reloadTime         = 5.25,
  soundStart         = [[US_75mm]],
}

Weapon('M375mmHE'):Extends('MediumHE'):Extends('M375mm'):Attrs{ -- name append
  areaOfEffect       = 88,
  weaponVelocity     = 926,
  damage = {
    default            = 1334,
  },  
}
Weapon('M375mmAP'):Extends('MediumAP'):Extends('M375mm'):Attrs{ -- name append
  weaponVelocity     = 1176,
  customparams = {
    armor_penetration_1000m = 57,
    armor_penetration_100m  = 71,
  },
  damage = {
    default            = 2557,
  },
}

-- M7 76mm (USA)
Weapon('M7'):Extends('MediumGun'):Attrs{
  name               = [[M7 76.2mm]],
  range              = 1545,
  reloadTime         = 6.75,
  soundStart         = [[US_76mm]],
  customparams = {
    weaponcost    = 16,
  },
}

Weapon('M7HE'):Extends('MediumHE'):Extends('M7'):Attrs{ -- name append
  areaOfEffect       = 74,
  weaponVelocity     = 1646,
  damage = {
    default            = 780,
  },  
}
Weapon('M7AP'):Extends('MediumAP'):Extends('M7'):Attrs{ -- name append
  weaponVelocity     = 1584, -- lower than HE?
  customparams = {
    armor_penetration_1000m = 81,
    armor_penetration_100m  = 100,
  },
  damage = {
    default            = 2646,
  },
}

-- Mk22 3inch (USA)
Weapon('Mk223in50'):Extends('MediumGun'):Extends('MediumHE'):Attrs{
  areaOfEffect       = 80,
  name               = [[Mk22 3in L/50]],
  range              = 2000,
  reloadTime         = 3.5, -- 15 - 20 rounds per minute, as per Russian sources
  soundStart         = [[GEN_105mm]], -- :o
  weaponVelocity     = 926,
  damage = {
    default            = 1152,
  },  
}


-- Ansaldo L/18 75mm (ITA)
Weapon('Ansaldo75mmL18'):Extends('MediumGun'):Attrs{
  name               = [[Ansaldo L/18 75mm Howitzer]],
  range              = 1310,
  reloadTime         = 6.75,
  soundStart         = [[US_75mm]],
}

Weapon('Ansaldo75mmL18HE'):Extends('MediumHE'):Extends('Ansaldo75mmL18'):Attrs{ -- name append
  areaOfEffect       = 94,
  weaponVelocity     = 800,
  damage = {
    default            = 2509,
  },  
}

Weapon('Ansaldo75mmL18HEAT'):Extends('HEAT'):Extends('Ansaldo75mmL18'):Attrs{ -- name append
  range              = 851,
  weaponVelocity     = 600,
  customparams = {
    armor_penetration       = 90,
  },
  damage = {
    default            = 2419,
  },
}

-- Ansaldo L/27 75mm (ITA)
Weapon('Ansaldo75mmL27HE'):Extends('MediumGun'):Extends('MediumHE'):Attrs{ -- name append
  areaOfEffect       = 94,
  name               = [[Ansaldo L/27 75mm Howitzer]],
  range              = 1390,
  reloadTime         = 6.75,
  soundStart         = [[US_75mm]],
  weaponVelocity     = 820,
  damage = {
    default            = 2509,
  },  
}

-- Ansaldo L/34 75mm (ITA)
Weapon('Ansaldo75mmL34'):Extends('MediumGun'):Attrs{
  name               = [[Ansaldo L/34 75mm]],
  range              = 1270,
  reloadTime         = 5.25,
  soundStart         = [[US_75mm]],
}

Weapon('Ansaldo75mmL34HE'):Extends('MediumHE'):Extends('Ansaldo75mmL34'):Attrs{ -- name append
  areaOfEffect       = 104,
  weaponVelocity     = 926,
  damage = {
    default            = 2260,
  },  
}
Weapon('Ansaldo75mmL34AP'):Extends('MediumAP'):Extends('Ansaldo75mmL34'):Attrs{ -- name append
  weaponVelocity     = 1358,
  customparams = {
    armor_penetration_1000m = 51,
    armor_penetration_100m  = 89,
  },
  damage = {
    default            = 2280,
  },
}
Weapon('Ansaldo75mmL34HEAT'):Extends('HEAT'):Extends('Ansaldo75mmL34'):Attrs{ -- name append
  range              = 825,
  weaponVelocity     = 700,
  customparams = {
    armor_penetration       = 120,
  },
  damage = {
    default            = 2010,
  },
}

-- Ansaldo L/46 75mm (ITA) 15 RPM
Weapon('Ansaldo75mmL46'):Extends('MediumGun'):Attrs{
  name               = [[Ansaldo L/46 75mm]],
  range              = 1530,
  reloadTime         = 5.0,
  soundStart         = [[GER_75mmLong]],
  customparams = {
    weaponcost    = 16,
  },  
}

Weapon('Ansaldo75mmL46HE'):Extends('MediumHE'):Extends('Ansaldo75mmL46'):Attrs{ -- name append
  areaOfEffect       = 104,
  weaponVelocity     = 926,
  damage = {
    default            = 1280,
  },  
}

Weapon('Ansaldo75mmL46AP'):Extends('MediumAP'):Extends('Ansaldo75mmL46'):Attrs{ -- name append
  weaponVelocity     = 1358,
  customparams = {
    armor_penetration_1000m = 86,
    armor_penetration_100m  = 98,
  },
  damage = {
    default            = 2613,
  },
}

-- Ansaldo 76/40 Mod. 1916 R.M. Naval gun (ITA)
Weapon('Ansaldo76mmL40HE'):Extends('MediumGun'):Extends('MediumHE'):Attrs{ -- name append
  areaOfEffect       = 76,
  name               = [[Ansaldo 76mm/40 Naval Gun]],
  range              = 1320,
  reloadTime         = 3.8,
  soundStart         = [[GER_75mm]],
  weaponVelocity     = 1300,
  damage = {
    default            = 2150,
  },  
}

-- Type 3 75mm/38 (JPN) 12RPM
Weapon('Type375mmL38'):Extends('MediumGun'):Attrs{
  name               = [[Type 3 75mm/38]],
  range              = 1480,
  reloadTime         = 4.85,
  soundStart         = [[JPN_75mm]],
  customparams = {
    weaponcost    = 16,
  },  
}

Weapon('Type375mmL38HE'):Extends('MediumHE'):Extends('Type375mmL38'):Attrs{ -- name append
  areaOfEffect       = 84,
  weaponVelocity     = 926,
  damage = {
    default            = 2260,
  },  
}
Weapon('Type375mmL38AP'):Extends('MediumAP'):Extends('Type375mmL38'):Attrs{ -- name append
  weaponVelocity     = 1358,
  customparams = {
    armor_penetration_1000m = 70,
    armor_penetration_100m  = 91,
  },
  damage = {
    default            = 2490,
  },
}

-- Type 90 75mm (JPN) 7 RPM
Weapon('Type9075mm'):Extends('MediumGun'):Attrs{
  name               = [[Type 90 75mm]],
  range              = 1270,
  reloadTime         = 6.5,
  soundStart         = [[JPN_75mm]],
  customparams = {
    weaponcost    = 16,
  },  
}

Weapon('Type9075mmHE'):Extends('MediumHE'):Extends('Type9075mm'):Attrs{ -- name append
  areaOfEffect       = 84,
  weaponVelocity     = 926,
  damage = {
    default            = 2260,
  },  
}

Weapon('Type9075mmAP'):Extends('MediumAP'):Extends('Type9075mm'):Attrs{ -- name append
  weaponVelocity     = 1358,
  customparams = {
    armor_penetration_1000m = 70,
    armor_penetration_100m  = 91,
  },
  damage = {
    default            = 2490,
  },
}

-- Type 3 76mm/40 Naval gun (JPN)
Weapon('Type376mmL40HE'):Extends('MediumGun'):Extends('MediumHE'):Attrs{ -- name append
  areaOfEffect       = 80,
  name               = [[Type 3 76mm/40 Naval gun]],
  range              = 1300,
  reloadTime         = 4,
  soundStart         = [[GER_75mm]],
  weaponVelocity     = 1300,
  damage = {
    default            = 2250,
  },  
}

