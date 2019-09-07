-- Infantry Anti-Tank Launchers

-- AT Launcher Base Class
local ATLClass = Weapon:New{
	explosionGenerator = [[custom:HE_Medium]],
	explosionSpeed     = 30,
	impulseFactor      = 0,
	model              = [[Bomb_Tiny.S3O]],
	noSelfDamage       = true,
	soundHitDry        = [[GEN_Explo_3]],
	tolerance          = 6000,
	fireTolerance	   = 5500,
	turret             = true,
	customparams = {
		damagetype         = [[shapedcharge]],
		cegflare           = "XSMALL_MUZZLEFLASH",
		scriptanimation    = "atlauncher",
		onlytargetcategory     = "BUILDING INFANTRY SOFTVEH OPENVEH HARDVEH SHIP LARGESHIP DEPLOYED",
		badTargetCategory  = "BUILDING FLAG INFANTRY SOFTVEH OPENVEH DEPLOYED",
	},
}

-- Recoilless Rifle (& Spigot Mortar) Class
local RCL_ATLClass = ATLClass:New{
	accuracy           = 300,
	predictBoost = 0.25,
	collisionSize      = 3,
	reloadtime         = 15,
	weaponType         = [[Cannon]],
	weaponVelocity     = 750,
}

-- Rocket Launcher Class
local Rocket_ATLClass = ATLClass:New{
	areaOfEffect       = 32,
	avoidGround	= false,
	avoidFeature	= false,
	leadLimit 	= 25,
	proximityPriority = -1,
	cegTag             = [[BazookaTrail]],
	reloadtime         = 10,
	tolerance          = 1200,
	fireTolerance	   = 1000,
	tracks		= true,
	turnRate	  = 4,
	startVelocity     = 200,
	weaponAcceleration = 725,
	flightTime        = 3,
	weaponType         = [[MissileLauncher]],
}

return {
	ATLClass = ATLClass,
	RCL_ATLClass = RCL_ATLClass,
	Rocket_ATLClass = Rocket_ATLClass,
}
