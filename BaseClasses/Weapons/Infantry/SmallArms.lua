local SmallArm = Weapon:New{
	accuracy           = 100,
	areaOfEffect       = 1,
	avoidFeature       = true,
	avoidFriendly      = false,
	burnblow           = false,
	collideFeature     = true,
	collideFriendly    = false,
	explosionGenerator = "custom:Bullet",
	fireStarter        = 0,
	impactonly         = true,
	interceptedByShieldType = 8,
	fireTolerance	= 5000,
	tolerance          = 6000,
	turret             = true,
	weaponType         = "LaserCannon",
	weaponVelocity     = 1500,
	customparams = {
		damagetype         = "smallarm",
		onlytargetcategory = "INFANTRY SOFTVEH DEPLOYED",
		badtargetcategory  = "SOFTVEH DEPLOYED",
	},
}

-- Pistol Base Class
local PistolClass = SmallArm:New{
	collisionSize      = 2.5,
	coreThickness      = 0.15,
	duration           = 0.025,
	movingAccuracy     = 888,
	range              = 180,
	reloadtime         = 1.5,
	--rgbColor           = [[1.0 0.75 0.0]],
	soundTrigger       = false,
	thickness          = 0.2,
	customparams = {
		cegflare           = "PISTOL_MUZZLEFLASH",
		scriptanimation    = "pistol",
	},
	damage = {
		default            = 31,
	},
}

-- Rifle Base Class
local RifleClass = SmallArm:New{
	accuracy           = 210,
	collisionSize      = 2.5,
	coreThickness      = 0.15,
	duration           = 0.01,
	impulsefactor      = 0.1,
	intensity          = 0.9,
	movingAccuracy     = 888,
	rgbColor           = [[1.0 0.75 0.0]],
	sprayAngle         = 100,
	thickness          = 0.4,
	customparams = {
		cegflare           = "RIFLE_MUZZLEFLASH",
		scriptanimation    = "rifle",
	},
	damage = {
		default            = 33,
	},
}

-- Sniper Rifle Base Class
local SniperRifleClass = RifleClass:New{
	accuracy           = 0,
	movingAccuracy     = 1777,
	range              = 1040,
	reloadtime         = 10,
	tolerance          = 2000,
	customparams = {
		onlytargetcategory  = "INFANTRY DEPLOYED", -- don't waste sniper shots on light vehs
		fearaoe            = 90,
		fearid             = 401,
		scriptanimation    = "sniper",
	},
	damage = {
		default              = 625,
		infantry             = 1700,
		sandbags             = 325,
	},
}

-- Submachinegun Base Class
local SMGClass = SmallArm:New{
	accuracy           = 300,
	burst              = 5,
	collisionSize      = 2.5,
	coreThickness      = 0.15,
	duration           = 0.01,
	intensity          = 0.7,
	movingAccuracy     = 933,
	rgbColor           = [[1.0 0.75 0.0]],
	soundTrigger       = true,
	sprayAngle         = 350,
	thickness          = 0.4,
	customparams = {
		cegflare           = "SMG_MUZZLEFLASH",
		scriptanimation    = "smg",
	},
	damage = {
		default            = 17,
	},
}

-- MachineGun Base Class
local MGClass = SmallArm:New{
	accuracy           = 220,
	collisionSize      = 2.5,
	coreThickness      = 0.15,
	duration           = 0.01,
	size               = 1e-13, -- visuals done with tracers
	fireStarter        = 1,
	intensity          = 0.9,
	soundTrigger       = true,
	sprayAngle         = 350,
	movingAccuracy     = 999,
	thickness          = 0.8,
	tolerance          = 600,
	customparams = {
		fearaoe            = 45,
		fearid             = 301,
		cegflare           = "MG_MUZZLEFLASH",
		flareonshot        = true,
		scriptanimation    = "mg",
		projectilelups     = {"mgtracer"},
	},
	damage = {
		default            = 33,
	},
}

local HeavyMGClass = MGClass:New{
	burst              = 8,
	burstRate          = 0.1,
	size               = 1e-13, -- visuals done with tracers
	interceptedByShieldType = 16,
	movingAccuracy     = 500,
	rgbColor           = [[1.0 0.75 0.0]],
	targetMoveError    = 0.25,
	tolerance          = 3000, -- needed?
	weaponVelocity     = 3000,
	customparams = {
		fearid             = 401,
		onlytargetcategory = "INFANTRY SOFTVEH OPENVEH DEPLOYED SHIP LARGESHIP TURRET",
		badtargetcategory  = "OPENVEH LARGESHIP DEPLOYED SHIP",
    	armor_penetration_1000m = 4,
    	armor_penetration_100m  = 12,
	},
	damage = {
		default            = 50,
	},
}

local AMG = Weapon:New{ -- should be used like ammo bases
	avoidFriendly      = true,
	accuracy           = 600,
	sprayangle	   = 1200,
	size		   = 1e-13,
	rgbColor           = [[0.2 0.0 0.3]],
	customparams = {
		onlytargetcategory = "AIR INFANTRY SOFTVEH OPENVEH SHIP LARGESHIP DEPLOYED TURRET",
		badtargetcategory  = "INFANTRY SOFTVEH OPENVEH SHIP LARGESHIP DEPLOYED TURRET",
	}
}

local AAMG = Weapon:New{ -- should be used like ammo bases
	sprayAngle         = 1050,
	accuracy           = 900,
	movingAccuracy     = 1200,
	size		   = 1e-13,
	canAttackGround    = false,
	predictBoost       = 0.75,
	range              = 1050,
	customparams = {
		no_range_adjust    = true,
		fearid             = 701,
		onlytargetcategory = "AIR",
		badtargetcategory  = "",
	}
}

return {
	SmallArm = SmallArm,
	PistolClass = PistolClass,
	RifleClass = RifleClass,
	SniperRifleClass = SniperRifleClass,
	SMGClass = SMGClass,
	MGClass = MGClass,
	HeavyMGClass = HeavyMGClass,
	AMG = AMG,
	AAMG = AAMG,
}
