-- Aircraft - Aircraft Anti-Tank Cannon

-- Implementations

-- Bordkanone BK 37 (GER)
Weapon('BK37mmAP'):Extends('AirATGun'):Attrs{
  --burst              = 1,
  --burstrate          = 0.375,
  name               = [[BK-37 37mm Semi-Automatic Cannon]],
  range              = 950,
  reloadtime         = 1,
  soundStart         = [[US_37mm]],
  weaponVelocity     = 1768,
  customparams = {
    --constant penetration since aircraft engagement range can't be realistically controlled
    armor_penetration = 45,
  },
  damage = {
    default            = 825,
  },
}

-- Ho-401 57mm HEAT (JPN)
Weapon('Ho40157mm'):Extends('AirATGun'):Attrs{
  areaOfEffect       = 12,
  name               = [[Ho-401 57 mm HEAT]],
  range              = 760,
  reloadTime         = 0.95,
  soundStart         = [[RUS_45mm]],
  weaponVelocity     = 918,
  customparams = {
    armor_penetration  = 55,
    damagetype         = [[shapedcharge]],
  },
  damage = {
    default            = 1341,
	cegflare           = "MEDIUM_MUZZLEFLASH",
  },
}

-- Return only the full weapons
