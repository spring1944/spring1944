-- Smallarms - Anti-Tank Rifles

-- Anti-Tank Rifle Base Class
local ATRifleClass = Weapon:New{
	areaOfEffect       = 1,
	avoidFeature       = true,
	avoidFriendly      = false,
	burnblow           = false,
	collideFeature     = true,
	collideFriendly    = false,
	collisionSize      = 2.5,
	coreThickness      = 0.15,
	duration           = 0.01,
	explosionGenerator = [[custom:AP_XSmall]],
	fireStarter        = 0,
	impactonly         = 1,
	impulseFactor      = 0.1,
	intensity          = 0.9,
	interceptedByShieldType = 32,
	laserFlareSize     = 0.0001,
	movingAccuracy     = 888,
	rgbColor           = [[1.0 0.75 0.0]],
	soundTrigger       = false,
	sprayAngle         = 100,
	thickness          = 0.8,
	fireTolerance	   = 5500,
	tolerance          = 6000,
	allowNonBlockingAim = true,
	turret             = true,
	weaponType         = [[LaserCannon]],
	customparams = {
		damagetype         = [[kinetic]],
		cegflare           = [[ptrd_muzzleflash]],
		scriptanimation    = [[atrifle]],
		-- this prevents shooting observer null units
		onlytargetcategory     = "BUILDING INFANTRY SOFTVEH OPENVEH HARDVEH SHIP LARGESHIP DEPLOYED",
		badtargetcategory  = "INFANTRY",
	},
}

return {
	ATRifleClass = ATRifleClass,
}
