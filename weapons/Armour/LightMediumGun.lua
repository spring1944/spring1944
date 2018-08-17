-- Armour - Light-Medium Gun (50 to 57mm)
-- Implementations

-- QF 6Pdr 57mm (GBR)
local QF6Pdr57mm = LightMediumGun:New{
  name               = [[QF 6 Pdr Mk.?]],
  range              = 1200,
  reloadTime         = 4.95,
}

local QF6Pdr57mmHE = LightMediumHE:New(QF6Pdr57mm, true):New{
  areaOfEffect       = 55,
  weaponVelocity     = 1100,
  damage = {
    default            = 760,
  },  
}
local QF6Pdr57mmAP = MediumAP:New(QF6Pdr57mm, true):New{
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
local QF6Pdr57MkIIAHE = LightMediumHE:New(QF6Pdr57mm, false):New{
	name		= [[QF 6-Pounder Mk IIA]],
	-- autoloader, 40 shots per minute
	reloadTime	= 1.5,
	areaOfEffect       = 55,
	movingAccuracy     = 300,
	weaponVelocity     = 1100,
	damage = {
		default		= 760,
	},
}

-- Swedish naval 57mm gun 	57mm/26.9 Finspång QF M/1895
-- stats from http://www.navypedia.org/arms/sweden/sw_guns.htm
local SWE_57mmM95 = LightMediumHE:New(QF6Pdr57mm, false):New{
	name		= [[57mm/26.9 Finspång QF M/1895]],
	-- 20 rounds per minute
	reloadTime	= 3,
	areaOfEffect	= 50,
	movingAccuracy     = 300,
	weaponVelocity	= 850,
	damage = {
		default		= 835,
	},
}

-- KwK39 L60 50mm (GER)
local KwK50mmL60 = LightMediumGun:New{
  name               = [[5cm KwK39 L/60]],
  range              = 1125,
  reloadTime         = 4.95,
}

local KwK50mmL60HE = LightMediumHE:New(KwK50mmL60, true):New{
  areaOfEffect       = 55,
  weaponVelocity     = 1100,
  damage = {
    default            = 330, -- much lower than 6pdr?
  },  
}
local KwK50mmL60AP = MediumAP:New(KwK50mmL60, true):New{
  weaponVelocity     = 1670,
  customparams = {
    armor_penetration_1000m = 47,
    armor_penetration_100m  = 69,
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
local ZiS257mmAP = MediumAP:New(ZiS257mm, true):New{
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
  movingAccuracy     = 300,  -- mainly because of naval use
  reloadTime         = 4.0,
}

local Type9757mmHE = LightMediumHE:New(Type9757mm, true):New{
  areaOfEffect       = 57,
  weaponVelocity     = 620,
  damage = {
    default            = 1400,
  },  
}
local Type9757mmAP = MediumAP:New(Type9757mm, true):New{
  weaponVelocity     = 1518,
  customparams = {
    armor_penetration_1000m = 25,
    armor_penetration_100m  = 45,
  },
  damage = {
    default            = 1606,
  },
}

-- 57 mm pansarvärnskanon m/43 (SWE)
local PvKanM43 = LightMediumGun:New{
	name               = [[57 mm pansarvärnskanon m/43]],
	range              = 1200,
	reloadTime         = 4.95,
	soundStart			= [[PVKAN_M_43]],
}

local PvKanM43AP = MediumAP:New(PvKanM43, true):New{
	weaponVelocity     = 1670,
	customparams = {
		armor_penetration_1000m = 66,
		armor_penetration_100m  = 86,
	},
	damage = {
		default            = 1795,
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
  -- Sweden
  PvKanM43AP = PvKanM43AP,
  SWE_57mmM95 = SWE_57mmM95,
})
