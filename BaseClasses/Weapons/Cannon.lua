-- Base AP Class
AbstractWeapon('AP'):Extends('Weapon'):Attrs{
	canattackground    = false,
	colormap           = "ap_colormap.png",
	impactonly         = true,
	name               = "AP Shell",
	soundHitDry        = "GEN_Explo_1",
	customparams = {
		damagetype         = "kinetic",
		onlytargetcategory = "SOFTVEH OPENVEH HARDVEH SHIP LARGESHIP",
		badtargetcategory  = "SOFTVEH",
	},  
}

AbstractWeapon('AutoCannonAP'):Extends('AP'):Attrs{
	intensity          = 0.1,
	separation         = 2,
	size               = 1,  
	stages             = 50,
	explosionGenerator = "custom:AP_XSmall",
} 
	
AbstractWeapon('LightAP'):Extends('AP'):Attrs{
	explosionGenerator = "custom:AP_Small",
}

AbstractWeapon('MediumAP'):Extends('AP'):Attrs{ -- LightMedium & Medium
	explosionGenerator = "custom:AP_Medium",
}

AbstractWeapon('HeavyAP'):Extends('AP'):Attrs{ -- MediumHeavy & Heavy
	explosionGenerator = "custom:AP_Medium",
}

-- Base HEAT Class
AbstractWeapon('HEAT'):Extends('Weapon'):Attrs{ -- Medium
	collisionSize      = 3,
	edgeEffectiveness  = 0.2,
	explosionGenerator = "custom:EP_medium",
	explosionSpeed     = 30, -- needed?
	impactonly         = true,
	name               = "HEAT Shell",
	soundHitDry        = "GEN_Explo_2",
	customparams = {
		damagetype         = "shapedcharge",
		-- same as AP. potentially do something fancy to reference here?
		onlytargetcategory = "SOFTVEH OPENVEH HARDVEH SHIP LARGESHIP",
		badtargetcategory  = "SOFTVEH",
	},
}

AbstractWeapon('HeavyHEAT'):Extends('HEAT'):Attrs{ -- MediumHeavy
	explosionGenerator = "custom:EP_Large",
	soundHitDry        = "GEN_Explo_3",
}

-- Base HE Class

AbstractWeapon('HE'):Extends('Weapon'):Attrs{
	accuracy           = 300,
	edgeEffectiveness  = 0.2,
	explosionGenerator = "custom:HE_Medium",
	explosionSpeed     = 30, -- needed?
	name               = "HE Shell",
	soundHitDry        = "GEN_Explo_2",
	customparams = {
		damagetype         = "explosive",
		fearid             = 301,
	},
}

AbstractWeapon('AutoCannonHE'):Extends('HE'):Attrs{ -- + AAGunHE
	areaOfEffect       = 24,
	edgeEffectiveness  = 0.5,
	explosionGenerator = "custom:HE_XSmall",
	customparams = {
		fearaoe            = 40,
	},
}

AbstractWeapon('LightHE'):Extends('HE'):Attrs{
	explosionGenerator = "custom:HE_Small",
	customparams = {
		fearaoe            = 40,
	},
}

AbstractWeapon('LightMediumHE'):Extends('HE'):Attrs{
	customparams = {
		fearaoe            = 50,
	},
}

AbstractWeapon('MediumHE'):Extends('HE'):Attrs{ -- Medium & MediumHeavy & InfGun
	soundHitDry        = "GEN_Explo_3",
	customparams = {
		fearaoe            = 75,
		fearid             = 401,
	},
}

AbstractWeapon('HeavyHE'):Extends('HE'):Attrs{
	edgeEffectiveness  = 0.1,
	explosionGenerator = "custom:HE_XLarge",
	soundHitDry        = "GEN_Explo_4",
	customparams = {
		fearaoe            = 75,
		fearid             = 501,
	},
}
AbstractWeapon('HowitzerHE'):Extends('HE'):Attrs{ -- + CS Howitzer
	explosionGenerator = "custom:HE_Large",
	customparams = {
		fearaoe            = 125,
		fearid             = 501,
	},
}

AbstractWeapon('MortarHE'):Extends('HE'):Attrs{
	soundHitDry        = "GEN_Explo_3",
	customparams = {
		fearaoe            = 105,
		fearid             = 301,
	},
}

-- Base Smoke Class

AbstractWeapon('Smoke'):Extends('Weapon'):Attrs{
	areaOfEffect       = 30,
	name               = "Smoke Shell",
	damage = {
		default = 100,
	} ,
}

AbstractWeapon('MortarSmoke'):Extends('Smoke'):Attrs{
	customparams = {
		smokeradius        = 160,
		smokeduration      = 25,
		smokeceg           = "SMOKESHELL_Small",
	},
}

AbstractWeapon('HowitzerSmoke'):Extends('Smoke'):Attrs{ -- + CS Howitzer
	customparams = {
		smokeradius        = 250,
		smokeduration      = 40,
		smokeceg           = "SMOKESHELL_Medium",
	},
}

AbstractWeapon('HeavySmoke'):Extends('Smoke'):Attrs{ -- e.g. Ho-Ro
	customparams = {
		smokeradius        = 350,
		smokeduration      = 50,
		smokeceg           = "SMOKESHELL_Medium",
	},
}

-- AA Round Class

AbstractWeapon('AA'):Extends('Weapon'):Attrs{
	accuracy           = 200,
	burnblow           = true,
	canattackground    = false,
	collisionSize      = 5,
	cylinderTargeting  = 2.5,
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

AbstractWeapon('AutoCannonAA'):Extends('AA'):Attrs{
	areaOfEffect       = 30,
	explosionGenerator = [[custom:HE_Small]],
	movingAccuracy     = 0,
	targetMoveError    = 0,
}

AbstractWeapon('AntiAirGunAA'):Extends('AA'):Attrs{
	areaOfEffect       = 60,
	explosionGenerator = [[custom:HE_Medium]],
}

-- Cannon Base

AbstractWeapon('Cannon'):Extends('Weapon'):Attrs{
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

AbstractWeapon('TankGun'):Extends('Cannon'):Attrs{
	accuracy           = 100,
	intensity          = 0.25,
	leadBonus          = 0.5,
	leadLimit          = 0,
	movingAccuracy     = 600,
	tolerance          = 300,
}

AbstractWeapon('AirATGun'):Extends('TankGun'):Extends('LightAP'):Attrs{ -- assumes we won't give them HE
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

-- Armour - Light Gun (37 to 45mm)
AbstractWeapon('LightGun'):Extends('TankGun'):Attrs{
	movingAccuracy     = 500, --590 for 2pdr?
	soundStart         = "US_37mm", -- move later?
	customparams = {
		cegflare           = "SMALL_MUZZLEFLASH",
		weaponcost         = 8,
	}
}

-- Armour - Light-Medium Gun (50 to 57mm)
AbstractWeapon('LightMediumGun'):Extends('TankGun'):Attrs{
	soundStart         = "GER_50mm", -- move later?
	customparams = {
		cegflare           = "MEDIUMSMALL_MUZZLEFLASH",
		weaponcost         = 10,
	}
}

-- Armour - Medium Gun (75 to 76mm)
AbstractWeapon('MediumGun'):Extends('TankGun'):Attrs{
	customparams = {
		cegflare           = "MEDIUM_MUZZLEFLASH",
		weaponcost         = 12,
	}
}

-- Armour - Medium Heavy Gun (85 to 100mm)
AbstractWeapon('MediumHeavyGun'):Extends('TankGun'):Attrs{
	customparams = {
		cegflare           = "MEDIUMLARGE_MUZZLEFLASH",
		weaponcost         = 20,
	}
}

-- Armour - Heavy Gun (120 to 152mm)
AbstractWeapon('HeavyGun'):Extends('TankGun'):Attrs{
	customParams = {
		cegflare           = "LARGE_MUZZLEFLASH",
		weaponcost         = 28,
	},
}

-- Armour - CS Howitzer
AbstractWeapon('CSHowitzer'):Extends('HeavyGun'):Attrs{ -- for cegflare only atm (+TankGun base)
	accuracy           = 300,
	soundHitDry        = "GEN_Explo_4",
	soundStart         = "GEN_105mm", -- move later?
	targetMoveError    = 0.75,
	weaponVelocity     = 1000,
	customParams = {
		weaponcost         = 22,
	},
}

-- Artillery - Light Anti-Air (20 - 25mm)
AbstractWeapon('AutoCannon'):Extends('Cannon'):Attrs{
	edgeEffectiveness  = 0.5,
	explosionSpeed     = 100, -- needed?
	movingAccuracy     = 500,
	predictBoost       = 0,
	size               = 1e-13, -- visuals done with tracers, except AP rounds
	targetMoveError    = 0.1,
	tolerance          = 650,
	customparams = {
		cegflare           = "XSMALL_MUZZLEFLASH",
		flareonshot        = true,
		projectilelups     = {"cannon20tracer"},
		weaponcost         = 4,
	},
}

AbstractWeapon('AirAutoCannon'):Extends('AutoCannon'):Attrs{ -- TODO: not sure how inheriting movingAccuracy and targetMoveError will pan out
	heightBoostFactor  = 0,
	predictBoost       = 0.5,
	soundTrigger       = false,
	sprayAngle         = 250,
	customparams = {
		armor_hit_side     = "top",
		no_range_adjust    = true,
		weaponcost         = -2, --Air auto cannons don't cost ammo
		badtargetcategory  = "INFANTRY SOFTVEH OPENVEH HARDVEH SHIP LARGESHIP DEPLOYED",
		onlytargetcategory = "INFANTRY SOFTVEH AIR OPENVEH HARDVEH SHIP LARGESHIP DEPLOYED",
	},
}

-- Artillery - Medium Anti-Air (37 - 40mm)
AbstractWeapon('AntiAirGun'):Extends('Cannon'):Attrs{
	intensity          = 0.9,
	predictBoost       = 0, -- this seems very strange for an AA weapon!
	size               = 1e-5,
	soundStart         = "GEN_37mmAA",
	soundTrigger       = false,
	sprayAngle         = 400,
	customparams = {
		cegflare           = "SMALL_MUZZLEFLASH", -- this class used mainly for ~40mm weapons
		flareonshot        = true,
		weaponcost         = 8,
	},
}

-- Artillery - Inf Guns
AbstractWeapon('InfGun'):Extends('Cannon'):Extends('MediumHE'):Attrs{
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
AbstractWeapon('Howitzer'):Extends('Cannon'):Attrs{
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

-- Artillery - Mortars

AbstractWeapon('Mortar'):Extends('Cannon'):Attrs{
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

