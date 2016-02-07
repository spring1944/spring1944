-- Armour - Heavy Gun (120 to 152mm)

-- Implementations

-- D-25T 122mm (RUS)
Weapon('D25122mm'):Extends('HeavyGun'):Attrs{
  name               = [[D-25T 122mm]],
  range              = 2530,
  reloadTime         = 15,
  soundStart         = [[RUS_122mm]],
}

Weapon('D25122mmHE'):Extends('HeavyHE'):Extends('D25122mm'):Attrs{ -- name append
  areaOfEffect       = 154,
  weaponVelocity     = 900,
  damage = {
    default            = 7200,
  },  
}
Weapon('D25122mmAP'):Extends('HeavyAP'):Extends('D25122mm'):Attrs{ -- name append
  weaponVelocity     = 1584,
  customparams = {
    armor_penetration_1000m = 131,
    armor_penetration_100m  = 162,
  },
  damage = {
    default            = 4990,
  },
}

-- ML-20S 152mm (RUS)
Weapon('ML20S152mm'):Extends('HeavyGun'):Attrs{
  name               = [[ML-20S 152mm Howitzer]],
  range              = 1750,
  reloadTime         = 17.5,
  soundStart         = [[RUS_152mm]],
  customparams = {
    cegflare           = "XLARGE_MUZZLEFLASH",
	weaponcost         = 63,
  },
}

Weapon('ML20S152mmHE'):Extends('HeavyHE'):Extends('ML20S152mm'):Attrs{ -- name append
  areaOfEffect       = 183,
  soundHitDry        = [[GEN_Explo_6]],
  weaponVelocity     = 1200, --?
  damage = {
    default            = 12000,
  },  
  customparams = {
    fearaoe            = 150,
  },
}
Weapon('ML20S152mmAP'):Extends('HeavyAP'):Extends('ML20S152mm'):Attrs{ -- name append
  soundHitDry        = [[GEN_Explo_4]],
  weaponVelocity     = 1200,
  customparams = {
    armor_penetration_1000m = 99,
    armor_penetration_100m  = 109,
  },
  damage = {
    default            = 6325,
  },
}

-- 120mm Short Gun (JPN)
Weapon('Short120mmHE'):Extends('HeavyGun'):Extends('HeavyHE'):Attrs{ -- name append
  areaOfEffect       = 129,
  name               = [[Short Naval 120mm]],
  range              = 1720,
  reloadtime         = 11.25,
  soundStart         = [[GEN_105mm]],
  weaponVelocity     = 700,
  damage = {
    default            = 5800,
  },
}

-- Type 38 150mm Howitzer L/11 (JPN)
Weapon('Type38150mmL11'):Extends('HeavyGun'):Attrs{
  name               = [[Type 38 150mm/11]],
  soundStart         = [[150mmtype38]],
  
  range              = 1700,
  reloadtime         = 15,
  weaponVelocity     = 700,
  customparams = {
  	weaponcost         = 63,
  },
}

Weapon('Type38150mmL11HE'):Extends('HeavyHE'):Extends('Type38150mmL11'):Attrs{ -- name append
  areaOfEffect       = 165,
  soundHitDry        = [[GEN_Explo_6]],
  damage = {
    default            = 8500,
  },
}
Weapon('Type38150mmL11Smoke'):Extends('HeavySmoke'):Extends('Type38150mmL11') -- name append


-- Return only the full weapons
