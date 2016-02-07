-- Armour - Light-Medium Gun (50 to 57mm)
-- Implementations

-- QF 6Pdr 57mm (GBR)
Weapon('QF6Pdr57mm'):Extends('LightMediumGun'):Attrs{
  name               = [[QF 6 Pdr Mk.?]],
  range              = 1200,
  reloadTime         = 4.95,
}

Weapon('QF6Pdr57mmHE'):Extends('LightMediumHE'):Extends('QF6Pdr57mm'):Attrs{ -- name append
  areaOfEffect       = 55,
  weaponVelocity     = 1100,
  damage = {
    default            = 760,
  },  
}
Weapon('QF6Pdr57mmAP'):Extends('MediumAP'):Extends('QF6Pdr57mm'):Attrs{ -- name append
  weaponVelocity     = 1670,
  customparams = {
    armor_penetration_1000m = 66,
    armor_penetration_100m  = 86,
  },
  damage = {
    default            = 1795,
  },
}

-- Naval QF 6-Pounder Mk IIA - uses only HE
Weapon('QF6Pdr57MkIIAHE'):Extends('LightMediumHE'):Extends('QF6Pdr57mm'):Attrs{ -- NOname append
	name		= [[QF 6-Pounder Mk IIA]],
	-- autoloader, 40 shots per minute
	reloadTime	= 1.5,
	areaOfEffect       = 55,
	weaponVelocity     = 1100,
	damage = {
		default		= 760,
	},
}

-- KwK39 L60 50mm (GER)
Weapon('KwK50mmL60'):Extends('LightMediumGun'):Attrs{
  name               = [[5cm KwK39 L/60]],
  range              = 1125,
  reloadTime         = 4.95,
}

Weapon('KwK50mmL60HE'):Extends('LightMediumHE'):Extends('KwK50mmL60'):Attrs{ -- name append
  areaOfEffect       = 55,
  weaponVelocity     = 1100,
  damage = {
    default            = 330, -- much lower than 6pdr?
  },  
}
Weapon('KwK50mmL60AP'):Extends('MediumAP'):Extends('KwK50mmL60'):Attrs{ -- name append
  weaponVelocity     = 1670,
  customparams = {
    armor_penetration_1000m = 44,
    armor_penetration_100m  = 67,
  },
  damage = {
    default            = 1435,
  },
}

-- ZiS-2 57mm (RUS)
Weapon('ZiS257mm'):Extends('LightMediumGun'):Attrs{
  name               = [[ZiS-2 57mm]],
  range              = 1180,
  reloadTime         = 4.95,
}

-- Currently only AP used
Weapon('ZiS257mmAP'):Extends('MediumAP'):Extends('ZiS257mm'):Attrs{ -- name append
  weaponVelocity     = 1980,
  customparams = {
    armor_penetration_1000m = 64,
    armor_penetration_100m  = 95,
  },
  damage = {
    default            = 2571,
  },
}

-- Type 97 57mm (JPN)
Weapon('Type9757mm'):Extends('LightMediumGun'):Attrs{
  name               = [[Type 97 57mm]],
  range              = 980,
  reloadTime         = 4.0,
}

Weapon('Type9757mmHE'):Extends('LightMediumHE'):Extends('Type9757mm'):Attrs{ -- name append
  areaOfEffect       = 57,
  weaponVelocity     = 800,
  damage = {
    default            = 1400,
  },  
}
Weapon('Type9757mmAP'):Extends('MediumAP'):Extends('Type9757mm'):Attrs{ -- name append
  weaponVelocity     = 1518,
  customparams = {
    armor_penetration_1000m = 25,
    armor_penetration_100m  = 45,
  },
  damage = {
    default            = 1606,
  },
}


-- Return only the full weapons
