AbstractWeapon('SmallArm'):Extends('Weapon'):Attrs{
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
AbstractWeapon('PistolClass'):Extends('SmallArm'):Attrs{
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
AbstractWeapon('RifleClass'):Extends('SmallArm'):Attrs{
	accuracy           = 100,
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
Weapon('SniperRifleClass'):Extends('RifleClass'):Attrs{
  accuracy           = 0,
  explosionGenerator = [[custom:Bullet]],
  movingAccuracy     = 1777,
  range              = 1040,
  reloadtime         = 10,
  soundTrigger       = false,
  tolerance          = 2000,
  turret             = true,
  weaponType         = [[LaserCannon]],
  customparams = {
    damagetype         = [[smallarm]],
    fearaoe            = 90,
    fearid             = 401,
	scriptanimation    = [[sniper]],
  },
  damage = {
    default              = 625,
    infantry             = 1700,
    sandbags             = 325,
  },
}

-- Submachinegun Base Class
AbstractWeapon('SMGClass'):Extends('SmallArm'):Attrs{
	accuracy           = 100,
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
AbstractWeapon('MGClass'):Extends('SmallArm'):Attrs{
	collisionSize      = 2.5,
	coreThickness      = 0.15,
	duration           = 0.01,
	fireStarter        = 1,
	intensity          = 0.9,
	rgbColor           = [[1.0 0.75 0.0]],
	soundTrigger       = true,
	sprayAngle         = 350,
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

AbstractWeapon('HeavyMGClass'):Extends('MGClass'):Attrs{
	burst              = 8,
	burstRate          = 0.1,
	interceptedByShieldType = 16,
	movingAccuracy     = 500,
	targetMoveError    = 0.25,
	tolerance          = 3000, -- needed?
	weaponVelocity     = 3000,
	customparams = {
		fearid             = 401,
		onlytargetcategory = "INFANTRY SOFTVEH DEPLOYED OPENVEH",
	},
	damage = {
		default            = 50,
	},
}

AbstractWeapon('AMG'):Extends('Weapon'):Attrs{ -- should be used like ammo bases
	customparams = {
		onlytargetcategory = "AIR INFANTRY SOFTVEH OPENVEH HARDVEH SHIP LARGESHIP DEPLOYED",
		badtargetcategory  = "INFANTRY SOFTVEH OPENVEH HARDVEH SHIP LARGESHIP DEPLOYED",
	}
}

AbstractWeapon('AAMG'):Extends('Weapon'):Attrs{ -- should be used like ammo bases
	sprayAngle         = 1050,
	accuracy           = 400,
	movingAccuracy     = 800,
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

