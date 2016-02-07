-- Artillery - Infantry Guns

-- Implementations

-- LeIG 18 (GER)
Weapon('LeIG18HE'):Extends('InfGun'):Attrs{
  areaOfEffect       = 88,
  name               = [[75mm LeIG 18 HE Shell]],
  soundStart         = [[GER_75mm]],
  damage = {
    default            = 1340,
  },
}

-- M8 Pack Howitzer (USA)
Weapon('M875mmHE'):Extends('InfGun'):Attrs{
  areaOfEffect       = 94,
  name               = [[M8 75mm Pack Howitzer HE Shell]],
  soundStart         = [[US_75mm]],
  damage = {
    default            = 1620,
  },
}

-- Cannone da 65/17 (ITA)
Weapon('Cannone65L17HE'):Extends('InfGun'):Attrs{
  areaOfEffect       = 68,
  name               = [[Cannone da 65/17 HE Shell]],
  range              = 1010,
  reloadtime         = 6.25,
  soundStart         = [[RUS_45mm]],
  weaponVelocity     = 420,
  damage = {
    default            = 900,
	cegflare           = "MEDIUMSMALL_MUZZLEFLASH", -- 65mm
  },
}

Weapon('Cannone65L17HEAT'):Extends('InfGun'):Attrs{ -- TODO: make a HEAT base class and inherit from Cannone65
  areaOfEffect       = 8,
  accuracy           = 250,
  predictBoost	     = 0.2,
  explosionGenerator = [[custom:EP_medium]],
  name               = [[Cannone da 65/17 HEAT Shell]],
  range              = 715,
  reloadtime         = 6.25,
  soundHitDry        = [[GEN_Explo_2]],
  soundStart         = [[RUS_45mm]],
  weaponVelocity     = 320,
  customparams = {
    armor_penetration  = 85,
    damagetype         = [[shapedcharge]],
    fearaoe            = nil,
    fearid             = nil,
	cegflare           = "MEDIUMSMALL_MUZZLEFLASH",
  },
  damage = {
    default            = 2056,
  },
}

-- Return only the full weapons
