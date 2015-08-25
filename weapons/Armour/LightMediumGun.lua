-- Armour - Light-Medium Gun (50 to 57mm)
-- Implementations

-- QF 6Pdr 57mm (GBR)
local QF6Pdr57mm = LightMediumGun:New{
  name               = [[QF 6 Pdr Mk.?]],
  range              = 1200,
  reloadTime         = 4.95,
}

local QF6Pdr57mmHE = QF6Pdr57mm:New(LightMediumHE, true):New{
  areaOfEffect       = 55,
  weaponVelocity     = 1100,
  damage = {
    default            = 760,
  },  
}
local QF6Pdr57mmAP = QF6Pdr57mm:New(MediumAP, true):New{
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
local QF6Pdr57MkIIAHE = QF6Pdr57mm:New(LightMediumHE, false):New{
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
local KwK50mmL60 = LightMediumGun:New{
  name               = [[5cm KwK39 L/60]],
  range              = 1125,
  reloadTime         = 4.95,
}

local KwK50mmL60HE = KwK50mmL60:New(LightMediumHE, true):New{
  areaOfEffect       = 55,
  weaponVelocity     = 1100,
  damage = {
    default            = 330, -- much lower than 6pdr?
  },  
}
local KwK50mmL60AP = KwK50mmL60:New(MediumAP, true):New{
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
local ZiS257mm = LightMediumGun:New{
  name               = [[ZiS-2 57mm]],
  range              = 1180,
  reloadTime         = 4.95,
}

-- Currently only AP used
local ZiS257mmAP = ZiS257mm:New(MediumAP, true):New{
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
local Type9757mm = LightMediumGun:New{
  name               = [[Type 97 57mm]],
  range              = 980,
  reloadTime         = 4.0,
}

local Type9757mmHE = Type9757mm:New(LightMediumHE, true):New{
  areaOfEffect       = 57,
  weaponVelocity     = 800,
  damage = {
    default            = 1400,
  },  
}
local Type9757mmAP = Type9757mm:New(MediumAP, true):New{
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
return lowerkeys({
  -- QF 6Pdr
  QF6Pdr57mmHE = QF6Pdr57mmHE,
  QF6Pdr57mmAP = QF6Pdr57mmAP,
  QF6Pdr57MkIIAHE = QF6Pdr57MkIIAHE,
  -- KwK39 L60
  KwK50mmL60HE = KwK50mmL60HE,
  KwK50mmL60AP = KwK50mmL60AP,
  -- ZiS-2
  ZiS257mmAP = ZiS257mmAP,
  -- Type 97 57mm
  Type9757mmHE = Type9757mmHE,
  Type9757mmAP = Type9757mmAP,
  
})
