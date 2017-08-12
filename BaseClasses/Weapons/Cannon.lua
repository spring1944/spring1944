-- Base AP Class
local AP = Weapon:New{
	canattackground    = false,
	colormap           = "ap_colormap.png",
	impactonly         = true,
	name               = "AP Shell",
	soundHitDry        = "GEN_Explo_1",
	customparams = {
		damagetype         = "kinetic",
		onlytargetcategory = "SOFTVEH OPENVEH HARDVEH SHIP LARGESHIP TURRET",
		badtargetcategory  = "SOFTVEH",
	},  
}

local AutoCannonAP = AP:New{
	intensity          = 0.1,
	separation         = 2,
	size               = 1,  
	stages             = 50,
	explosionGenerator = "custom:AP_XSmall",
	customparams		= {
		immobilizationchance = 0.25,	-- rather low
	},
} 
	
local LightAP = AP:New{
	explosionGenerator = "custom:AP_Small",
}

local MediumAP = AP:New{ -- LightMedium & Medium
	explosionGenerator = "custom:AP_Medium",
}

local HeavyAP = AP:New{ -- MediumHeavy & Heavy
	explosionGenerator = "custom:AP_Medium",
}

-- Base HEAT Class
local HEAT = Weapon:New{ -- Medium
	collisionSize      = 3,
	edgeEffectiveness  = 0.2,
	explosionGenerator = "custom:EP_medium",
	explosionSpeed     = 30, -- needed?
	impactonly         = true,
	name               = "HEAT Shell",
	soundHitDry        = "GEN_Explo_2",
	customparams = {
		damagetype         = "shapedcharge",
		onlytargetcategory = AP.customparams.onlytargetcategory,
		badtargetcategory  = AP.customparams.badtargetcategory,
	},
}

local HeavyHEAT = HEAT:New{ -- MediumHeavy
	explosionGenerator = "custom:EP_Large",
	soundHitDry        = "GEN_Explo_3",
}

-- Base HE Class

local HE = Weapon:New{
	accuracy           = 300,
	targetBorder	   = 0.6,
	edgeEffectiveness  = 0.2,
	explosionGenerator = "custom:HE_Medium",
	explosionSpeed     = 30, -- needed?
	name               = "HE Shell",
	soundHitDry        = "GEN_Explo_2",
	customparams = {
		onlytargetcategory     = "BUILDING INFANTRY SOFTVEH OPENVEH HARDVEH SHIP LARGESHIP DEPLOYED TURRET",
		damagetype         = "explosive",
		fearid             = 301,
	},
}

local AutoCannonHE = HE:New{ -- + AAGunHE
	areaOfEffect       = 24,
	edgeEffectiveness  = 0.5,
	explosionGenerator = "custom:HE_XSmall",
	customparams = {
		fearaoe            = 40,
		immobilizationchance = 0.25,	-- rather low
	},
}

local LightHE = HE:New{
	explosionGenerator = "custom:HE_Small",
	customparams = {
		fearaoe            = 40,
	},
}

local LightMediumHE = HE:New{
	customparams = {
		fearaoe            = 50,
	},
}

local MediumHE = HE:New{ -- Medium & MediumHeavy & InfGun
	soundHitDry        = "GEN_Explo_3",
	customparams = {
		fearaoe            = 75,
		fearid             = 401,
	},
}

local HeavyHE = HE:New{
	edgeEffectiveness  = 0.1,
	explosionGenerator = "custom:HE_XLarge",
	soundHitDry        = "GEN_Explo_4",
	customparams = {
		fearaoe            = 75,
		fearid             = 501,
	},
}
local HowitzerHE = HE:New{ -- + CS Howitzer
	explosionGenerator = "custom:HE_Large",
	soundStart         = [[GEN_105mm]],
	soundHitDry        = [[GEN_Explo_4]],
	customparams = {
		fearaoe            = 125,
		fearid             = 501,
	},
}

local MortarHE = HE:New{
	soundHitDry        = "GEN_Explo_3",
	customparams = {
		fearaoe            = 105,
		fearid             = 301,
	},
}

-- Base Smoke Class

local Smoke = Weapon:New{
	areaOfEffect       = 30,
	name               = "Smoke Shell",
	damage = {
		default = 10,
	},
	customparams = {
		onlytargetcategory     = "BUILDING INFANTRY SOFTVEH OPENVEH HARDVEH SHIP LARGESHIP DEPLOYED",
	}
}

local MortarSmoke = Smoke:New{
	customparams = {
		smokeradius        = 160,
		smokeduration      = 25,
		smokeceg           = "SMOKESHELL_Small",
	},
}

local HowitzerSmoke = Smoke:New{ -- + CS Howitzer
	customparams = {
		smokeradius        = 250,
		smokeduration      = 40,
		smokeceg           = "SMOKESHELL_Medium",
	},
}

local HeavySmoke = Smoke:New{ -- e.g. Ho-Ro
	customparams = {
		smokeradius        = 350,
		smokeduration      = 50,
		smokeceg           = "SMOKESHELL_Medium",
	},
}

-- AA Round Class

local AA = Weapon:New{
	accuracy           = 100,
	burnblow           = true,
	canattackground    = false,
	collisionSize      = 3,
	cylinderTargeting  = 2.5,
	leadlimit	= 190,
	edgeEffectiveness  = 0.001,
	name               = "AA Shell",
	soundHitDry        = "GEN_Explo_Flak1",
	tolerance          = 1400,
	customparams = {
		damagetype         = "explosive",
		no_range_adjust    = true,
		fearaoe            = 450,
		fearid             = 701,
		onlytargetcategory = "AIR",
	},
}

local AutoCannonAA = AA:New{
	areaOfEffect       = 30,
	explosionGenerator = [[custom:HE_Small]],
	movingAccuracy     = 300,
	targetMoveError    = 0,
}

local AntiAirGunAA = AA:New{
	areaOfEffect       = 60,
	explosionGenerator = [[custom:HE_Medium]],
}

-- Cannon Base

local Cannon = Weapon:New{
	avoidFeature       = false,
	collisionSize      = 4,
	impulseFactor      = 0,
	rgbColor           = [[0.5 0.5 0.0]], -- TODO: check that this is overriden by ap colormap
	separation         = 2,
	size               = 1,
	stages             = 50,
	turret             = true,
	weaponType         = "Cannon",
	customparams = {
		projectilelups     = {"cannontracer"},
		tracerfreq         = 1,
	},
}

-- Armour - Tank Guns

local TankGun = Cannon:New{
	accuracy           = 100,
	intensity          = 0.25,
	leadBonus          = 0.25,
	leadLimit          = 3,
	movingAccuracy     = 600,
	tolerance          = 300,
}

local AirATGun = TankGun:New(LightAP):New{ -- assumes we won't give them HE
	heightBoostFactor  = 0,
	targetMoveError    = 0.1,
	tolerance          = 600,
	customparams = {
		no_range_adjust    = true,
		armor_hit_side     = "top",
		cegflare           = "SMALL_MUZZLEFLASH",
		weaponcost         = -1, -- to automagic weaponswithammo
	},
}

-- Special case: light deployed AT guns have immobilization chance
local LightMediumATGun = {
	customparams = {
		immobilizationchance = 0.75,	-- rather high
	},
}

-- Armour - Light Gun (37 to 45mm)
local LightGun = TankGun:New{
	movingAccuracy     = 500, --590 for 2pdr?
	soundStart         = "US_37mm", -- move later?
	customparams = {
		cegflare           = "SMALL_MUZZLEFLASH",
		weaponcost         = 8,
	}
}

-- Armour - Light-Medium Gun (50 to 57mm)
local LightMediumGun = TankGun:New{
	soundStart         = "GER_50mm", -- move later?
	customparams = {
		cegflare           = "MEDIUMSMALL_MUZZLEFLASH",
		weaponcost         = 10,
	}
}

-- Armour - Medium Gun (75 to 76mm)
local MediumGun = TankGun:New{
	customparams = {
		cegflare           = "MEDIUM_MUZZLEFLASH",
		weaponcost         = 12,
	}
}

-- Armour - Medium Heavy Gun (85 to 100mm)
local MediumHeavyGun = TankGun:New{
	customparams = {
		cegflare           = "MEDIUMLARGE_MUZZLEFLASH",
		weaponcost         = 20,
	}
}

-- Armour - Heavy Gun (120 to 152mm)
local HeavyGun = TankGun:New{
	customParams = {
		cegflare           = "LARGE_MUZZLEFLASH",
		weaponcost         = 28,
	},
}

-- Armour - CS Howitzer
local CSHowitzer = HeavyGun:New{ -- for cegflare only atm (+TankGun base)
	accuracy           = 300,
	soundHitDry        = "GEN_Explo_4",
	soundStart         = "GEN_105mm", -- move later?
	targetMoveError    = 0.75,
	weaponVelocity     = 1000,
  	tolerance          = 900,
	customParams = {
		weaponcost         = 22,
	},
}

-- Artillery - Light Anti-Air (20 - 25mm)
local AutoCannon = Cannon:New{
	edgeEffectiveness  = 0.5,
	explosionSpeed     = 100, -- needed?
	movingAccuracy     = 500,
	predictBoost       = 0,
	leadlimit	 = 120,
	size               = 1e-13, -- visuals done with tracers, except AP rounds
	targetMoveError    = 0.1,
	tolerance          = 850,
	customparams = {
		cegflare           = "XSMALL_MUZZLEFLASH",
		flareonshot        = true,
		projectilelups     = {"cannon20tracer"},
		weaponcost         = 4,
	},
}

local AirAutoCannon = AutoCannon:New{ -- TODO: not sure how inheriting movingAccuracy and targetMoveError will pan out
	heightBoostFactor  = 0,
	range		= 860,
  	canAttackGround    = false,
	accuracy           = 500,
	sprayangle	   = 1200,
	weaponVelocity     = 1700,
	size               = 1e-13,
	soundTrigger       = false,
	avoidFriendly      = true,
	sprayAngle         = 250,
	customparams = {
		no_range_adjust    = true,
		weaponcost         = -2, --Air auto cannons don't cost ammo
		badtargetcategory  = "INFANTRY HARDVEH SHIP LARGESHIP DEPLOYED",
		onlytargetcategory = "INFANTRY SOFTVEH AIR OPENVEH SHIP LARGESHIP HARDVEH DEPLOYED TURRET",
	},
}

-- Artillery - Medium Anti-Air (37 - 40mm)
local AntiAirGun = Cannon:New{
	accuracy           = 150,
	intensity          = 0.9,
	predictBoost       = 0, -- this seems very strange for an AA weapon!
	size               = 1e-5,
	soundStart         = "GEN_37mmAA",
	soundTrigger       = false,
	sprayAngle         = 400,
	customparams = {
		badtargetcategory  = "INFANTRY HARDVEH SHIP LARGESHIP DEPLOYED",
		cegflare           = "SMALL_MUZZLEFLASH", -- this class used mainly for ~40mm weapons
		flareonshot        = true,
		weaponcost         = 8,
	},
}

-- Artillery - Inf Guns
local InfGun = Cannon:New(MediumHE):New{
	accuracy           = 510,
	intensity          = 0.1,
	noSelfDamage       = true,
	range              = 1310, -- move to implementations?
	reloadtime         = 6.75, -- ditto?
	targetMoveError    = 0.5, -- why different?
	tolerance          = 5000, -- seems high!
	weaponVelocity     = 825,
	customparams = {
		cegflare           = "MEDIUM_MUZZLEFLASH",
		weaponcost         = 12,
	},
}

-- Artillery - Light Howitzers
local Howitzer = Cannon:New{
	intensity          = 0.1,
	leadLimit          = 0.05,
	noSelfDamage       = true,
	soundStart         = "GEN_105mm",
	targetMoveError    = 0.75,
	tolerance          = 3000,
	weaponVelocity     = 1200,
	customparams = {
		howitzer           = 1,
		cegflare           = "LARGE_MUZZLEFLASH",
		seismicping        = 15,
		weaponcost         = 30,
	},
}

-- Artillery - long-range cannon
local LongRangeCannon = Cannon:New{
	intensity          = 0.1,
	leadLimit          = 0.05,
	noSelfDamage       = true,
	soundStart         = "GEN_100mm",
	targetMoveError    = 0.75,
	tolerance          = 3000,
	weaponVelocity     = 1600,
	customparams = {
		howitzer           = 1,
		cegflare           = "LARGE_MUZZLEFLASH",
		seismicping        = 15,
		weaponcost         = 40,
	},
}

-- Artillery - Mortars

local Mortar = Cannon:New{
	accuracy           = 485,
	collideFriendly    = false,
	leadLimit          = 500,
	model              = "MortarShell.S3O",
	reloadtime         = 12, -- to implementations?
	soundStart         = "GEN_Mortar",
	weaponVelocity     = 550,
	customparams = {
		armor_hit_side     = "top",
		cegflare           = "MEDIUM_MUZZLEFLASH",
		scriptanimation    = "mortar",
		weaponcost         = 15,
	},
}

return {
	-- AMMO TYPES
	-- AP bases
	AP = AP,
	AutoCannonAP = AutoCannonAP,
	LightAP = LightAP,
	MediumAP = MediumAP,
	HeavyAP = HeavyAP,
	LightMediumATGun = LightMediumATGun,
	-- HEAT bases
	HEAT = HEAT,
	HeavyHEAT = HeavyHEAT,
	-- HE bases
	HE = HE,
	AutoCannonHE = AutoCannonHE,
	LightHE = LightHE,
	LightMediumHE = LightMediumHE,
	MediumHE = MediumHE,
	HeavyHE = HeavyHE,
	HowitzerHE = HowitzerHE,
	MortarHE = MortarHE,
	-- Smoke bases
	Smoke = Smoke,
	MortarSmoke = MortarSmoke,
	HowitzerSmoke = HowitzerSmoke,
	HeavySmoke = HeavySmoke,
	-- AA bases
	AA = AA,
	AutoCannonAA = AutoCannonAA,
	AntiAirGunAA = AntiAirGunAA,
	-- WEAPON TYPES
	Cannon = Cannon,
	-- (Anti) Tank Guns
	TankGun = TankGun,
	AirATGun = AirATGun,
	LightGun = LightGun,
	LightMediumGun = LightMediumGun,
	MediumGun = MediumGun,
	MediumHeavyGun = MediumHeavyGun,
	HeavyGun = HeavyGun,
	CSHowitzer = CSHowitzer,
	-- Artillery
	AutoCannon = AutoCannon,
	AirAutoCannon = AirAutoCannon,
	AntiAirGun = AntiAirGun,
	InfGun = InfGun,
	Howitzer = Howitzer,
	LongRangeCannon = LongRangeCannon,
	Mortar = Mortar,
}
