-- Armour - Light Gun (37 to 45mm)

-- Implementations

-- QF 2Pdr 40mm (GBR)
Weapon('QF2Pdr40mm'):Extends('LightGun'):Attrs{
  name               = [[QF 2 Pdr Mk.X]],
  range              = 1070,
  reloadTime         = 4.5,
}

Weapon('QF2Pdr40mmHE'):Extends('LightHE'):Extends('QF2Pdr40mm'):Attrs{ -- name append
  areaOfEffect       = 42,
  weaponVelocity     = 1584,
  damage = {
    default            = 350,
  },  
}
Weapon('QF2Pdr40mmAP'):Extends('LightAP'):Extends('QF2Pdr40mm'):Attrs{ -- name append
  weaponVelocity     = 1616,
  customparams = {
    armor_penetration_1000m = 45,
    armor_penetration_100m  = 59,
  },
  damage = {
    default            = 1105,
  },
}

-- M6 37mm (USA)
Weapon('M637mm'):Extends('LightGun'):Attrs{
  name               = [[37mm M6]],
  range              = 1010,
  reloadTime         = 4.5,
}

-- Canister is radically different!
Weapon('M637mmCanister'):Extends('M637mm'):Attrs{ -- name append
  areaOfEffect       = 10,
  coreThickness      = 0.15,
  duration           = 0.01,
  edgeEffectiveness  = 1,
  explosionGenerator = [[custom:Bullet]],
  explosionSpeed     = 100, -- needed?
  intensity          = 0.7,
  laserFlareSize     = 0.0001,
  name               = [[Canister Shot]],
  projectiles        = 122,
  range              = 550,
  rgbColor           = [[1.0 0.75 0.0]],
  soundTrigger       = true,
  sprayAngle         = 3000,
  targetMoveError    = 0.1,
  thickness          = 0.3,
  weaponType         = [[LaserCannon]], -- this is why it's so different
  weaponVelocity     = 1400,
  customparams = {
    damagetype         = [[smallarm]],
    fearaoe            = 20,
    fearid             = 301,
	onlytargetCategory = "INFANTRY SOFTVEH DEPLOYED",
  },
  damage = {
    default            = 150,
  },  
}

Weapon('M637mmHE'):Extends('LightHE'):Extends('M637mm'):Attrs{ -- name append
  areaOfEffect       = 44,
  weaponVelocity     = 1584,
  damage = {
    default            = 228,
  },  
}
Weapon('M637mmAP'):Extends('LightAP'):Extends('M637mm'):Attrs{ -- name append
  weaponVelocity     = 1768,
  customparams = {
    armor_penetration_1000m = 46,
    armor_penetration_100m  = 63,
  },
  damage = {
    default            = 933,
  },
}

-- M1938 20K 45mm (RUS)
Weapon('M1938_20K45mm'):Extends('LightGun'):Attrs{
  name               = [[20K M1938 45mm]],
  range              = 980,
  reloadTime         = 4.8,
  soundStart         = [[RUS_45mm]],
}

Weapon('M1938_20K45mmHE'):Extends('LightHE'):Extends('M1938_20K45mm'):Attrs{ -- name append
  areaOfEffect       = 52, -- Naval is 47?
  weaponVelocity     = 1584,
  damage = {
    default            = 270,
  },  
}
Weapon('M1938_20K45mmAP'):Extends('LightAP'):Extends('M1938_20K45mm'):Attrs{ -- name append
  weaponVelocity     = 1518, -- Naval (unused) is 1768?
  customparams = {
    armor_penetration_1000m = 20,
    armor_penetration_100m  = 43, -- These seem very low!
  },
  damage = {
    default            = 1565,
  },
}

-- Naval copy, only HE used currently. Should these values be so different?
Weapon('M1937_40K45mmHE'):Extends('M1938_20K45mmHE'):Attrs{
  name                 = [[40K 45mm Naval Gun HE Shell]],
}

-- Cannone da 47/32 M35 (ITA)
Weapon('CannoneDa47mml32'):Extends('LightGun'):Attrs{
  name                 = [[47 mm L/32 Gun]],
  range                = 980,
  reloadTime           = 4.8,
  soundStart           = [[ITA_M35_47mm]],
}

Weapon('CannoneDa47mml32AP'):Extends('LightAP'):Extends('CannoneDa47mml32'):Attrs{ -- name append
  weaponVelocity       = 1000,
  customparams = {
    armor_penetration_1000m = 32,
    armor_penetration_100m  = 57,
  },
  damage = {
    default            = 1200,
  },
}

Weapon('CannoneDa47mml32HEAT'):Extends('HEAT'):Extends('CannoneDa47mml32'):Attrs{ -- name append
  range                = 637,
  weaponVelocity       = 800,
  customparams = {
    armor_penetration       = 75,
  },
  damage = {
    default            = 1048,
  },
}

-- Cannone da 47/40 (ITA)
-- it had some links:
-- https://web.archive.org/web/20081021061843/http://ww2armor.jexiste.fr/Files/Axis/Axis/1-Vehicles/Italy/2-MediumTanks/M13-40/2-Design.htm
-- http://www.quarry.nildram.co.uk/ammotable6.htm
Weapon('CannoneDa47mml40'):Extends('LightGun'):Attrs{
  name                 = [[47 mm L/40 Gun]],
  range                = 1090,
  reloadTime           = 4.4,
  soundStart           = [[ITA_M39_47mm]],
}

Weapon('CannoneDa47mml40HE'):Extends('LightHE'):Extends('CannoneDa47mml40'):Attrs{ -- name append
  areaOfEffect       = 52,
  weaponVelocity     = 1084,
  damage = {
    default            = 270,
  },  
}

Weapon('CannoneDa47mml40AP'):Extends('LightAP'):Extends('CannoneDa47mml40'):Attrs{ -- name append
  weaponVelocity     = 1818,
  customparams = {
    armor_penetration_1000m = 43,
    armor_penetration_100m  = 71,
  },
  damage = {
    default            = 1225,
  },
}
Weapon('CannoneDa47mml40HEAT'):Extends('HEAT'):Extends('CannoneDa47mml40'):Attrs{ -- name append
  range                = 708,
  weaponVelocity       = 900,
  customparams = {
    armor_penetration       = 115,
  },
  damage = {
    default            = 1048,
  },
}


-- Type 1 37mm (JPN)
Weapon('Type137mm'):Extends('LightGun'):Attrs{
  name                 = [[Type 1 37 mm Gun]],
  range                = 950,
  reloadTime           = 4.4,
  soundStart           = [[US_37mm]],
}

Weapon('Type137mmHE'):Extends('LightHE'):Extends('Type137mm'):Attrs{ -- name append
  areaOfEffect       = 26,
  weaponVelocity     = 800,
  damage = {
    default            = 220,
  },
}

Weapon('Type137mmAP'):Extends('LightAP'):Extends('Type137mm'):Attrs{ -- name append
  weaponVelocity     = 1118,
  customparams = {
    armor_penetration_1000m = 25,
    armor_penetration_100m  = 50,
  },
  damage = {
    default            = 818,
  },
}


-- Type 98 37mm (JPN)
Weapon('Type9837mm'):Extends('LightGun'):Attrs{
  name                 = [[Type 98 37 mm Gun]],
  range                = 930,
  reloadTime           = 4.0,
  soundStart           = [[RUS_45mm]],
}

Weapon('Type9837mmHE'):Extends('LightHE'):Extends('Type9837mm'):Attrs{ -- name append
  areaOfEffect       = 28,
  weaponVelocity     = 800,
  damage = {
    default            = 220,
  },
}

Weapon('Type9837mmAP'):Extends('LightAP'):Extends('Type9837mm'):Attrs{ -- name append
  weaponVelocity     = 1518,
  customparams = {
    armor_penetration_1000m = 20,
    armor_penetration_100m  = 40,
  },
  damage = {
    default            = 818,
  },
}

-- Type 94 37mm (JPN)
Weapon('Type9437mm'):Extends('LightGun'):Attrs{
  name                 = [[Type 94 37 mm Gun]],
  range                = 900,
  reloadTime           = 4.8,
  soundStart           = [[RUS_45mm]],
}

Weapon('Type9437mmHE'):Extends('LightHE'):Extends('Type9437mm'):Attrs{ -- name append
  areaOfEffect       = 32,
  weaponVelocity     = 800,
  damage = {
    default            = 220,
  },
}

Weapon('Type9437mmAP'):Extends('LightAP'):Extends('Type9437mm'):Attrs{ -- name append
  weaponVelocity     = 1518,
  customparams = {
    armor_penetration_1000m = 25,
    armor_penetration_100m  = 40,
  },
  damage = {
    default            = 900,
  },
}

-- Type 1 47mm (JPN)
Weapon('Type147mm'):Extends('LightGun'):Attrs{
  name                 = [[Type 1 47 mm Gun]],
  range                = 1100,
  reloadTime           = 4.5,
  soundStart           = [[RUS_45mm]],
}

Weapon('Type147mmHE'):Extends('LightHE'):Extends('Type147mm'):Attrs{ -- name append
  areaOfEffect       = 38,
  weaponVelocity     = 800,
  damage = {
    default            = 350,
  },
}

Weapon('Type147mmAP'):Extends('LightAP'):Extends('Type147mm'):Attrs{ -- name append
  weaponVelocity     = 1118,
  customparams = {
    armor_penetration_1000m = 53,
    armor_penetration_100m  = 76,
  },
  damage = {
    default            = 1183,
  },
}


-- Return only the full weapons
