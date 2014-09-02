-- Armour - Light-Medium Gun (50 to 57mm)

-- LightMediumGun Base Class
local LightMediumGunClass = Weapon:New{
  accuracy           = 100,
  avoidFeature		 = false,
  collisionSize      = 4,
  impulseFactor      = 0,
  intensity          = 0.25,
  leadBonus          = 0.5,
  leadLimit          = 0,
  movingAccuracy     = 600,
  separation         = 2, 
  size               = 1,
  soundStart         = [[GER_50mm]], -- move later?
  stages             = 50,
  tolerance          = 300,
  turret             = true,
  weaponType         = [[Cannon]],
  customparams = {
    cegflare           = "MEDIUM_MUZZLEFLASH",
  }
}

-- HE Round Class
local LightMediumGunHEClass = Weapon:New{
  accuracy           = 300,
  edgeEffectiveness  = 0.25,
  explosionGenerator = [[custom:HE_Medium]],
  explosionSpeed     = 30, -- needed?
  name               = [[HE Shell]],
  rgbColor           = [[0.5 0.5 0.0]],
  soundHitDry        = [[GEN_Explo_2]],
  customparams = {
    damagetype         = [[explosive]],
    fearaoe            = 50,
    fearid             = 301,
  },
}

-- AP Round Class
local LightMediumGunAPClass = Weapon:New{
  areaOfEffect       = 10,
  canattackground    = false,
  colormap           = [[ap_colormap.png]],
  edgeEffectiveness  = 0.1,
  explosionGenerator = [[custom:AP_Medium]],
  explosionSpeed     = 100, -- needed?
  impactonly         = 1,
  name               = [[AP Shell]],
  soundHitDry        = [[GEN_Explo_1]],
  customparams = {
    damagetype         = [[kinetic]],
  },  
}

-- Implementations

-- QF 6Pdr 57mm (GBR)
local QF6Pdr57mm = LightMediumGunClass:New{
  name               = [[QF 6 Pdr Mk.?]],
  range              = 1200,
  reloadTime         = 4.95,
}

local QF6Pdr57mmHE = QF6Pdr57mm:New(LightMediumGunHEClass, true):New{
  areaOfEffect       = 55,
  weaponVelocity     = 1100,
  damage = {
    default            = 760,
  },  
}
local QF6Pdr57mmAP = QF6Pdr57mm:New(LightMediumGunAPClass, true):New{
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
local QF6Pdr57MkIIAHE = QF6Pdr57mm:New(LightMediumGunHEClass, false):New{
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
local KwK50mmL60 = LightMediumGunClass:New{
  name               = [[5cm KwK39 L/60]],
  range              = 1125,
  reloadTime         = 4.95,
}

local KwK50mmL60HE = KwK50mmL60:New(LightMediumGunHEClass, true):New{
  areaOfEffect       = 55,
  weaponVelocity     = 1100,
  damage = {
    default            = 330, -- much lower than 6pdr?
  },  
}
local KwK50mmL60AP = KwK50mmL60:New(LightMediumGunAPClass, true):New{
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
local ZiS257mm = LightMediumGunClass:New{
  name               = [[ZiS-2 57mm]],
  range              = 1180,
  reloadTime         = 4.95,
}

-- Currently only AP used
local ZiS257mmAP = ZiS257mm:New(LightMediumGunAPClass, true):New{
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
local Type9757mm = LightMediumGunClass:New{
  name               = [[Type 97 57mm]],
  range              = 980,
  reloadTime         = 4.0,
}

local Type9757mmHE = Type9757mm:New(LightMediumGunHEClass, true):New{
  areaOfEffect       = 57,
  weaponVelocity     = 800,
  damage = {
    default            = 1400,
  },  
}
local Type9757mmAP = Type9757mm:New(LightMediumGunAPClass, true):New{
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
