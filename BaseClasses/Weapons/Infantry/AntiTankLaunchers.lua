-- Infantry Anti-Tank Launchers

-- AT Launcher Base Class
AbstractWeapon('ATLClass'):Extends('Weapon'):Attrs{
	explosionGenerator = [[custom:HE_Medium]],
	explosionSpeed     = 30,
	impulseFactor      = 0,
	model              = [[Bomb_Tiny.S3O]],
	noSelfDamage       = true,
	soundHitDry        = [[GEN_Explo_3]],
	tolerance          = 6000,
	turret             = true,
	customparams = {
		damagetype         = [[shapedcharge]],
		cegflare           = "XSMALL_MUZZLEFLASH",
		scriptanimation    = "atlauncher",
		badTargetCategory  = "BUILDING FLAG INFANTRY SOFTVEH OPENVEH DEPLOYED",
	},
}

-- Recoilless Rifle (& Spigot Mortar) Class
AbstractWeapon('RCL_ATLClass'):Extends('ATLClass'):Attrs{
	accuracy           = 500,
	collisionSize      = 3,
	reloadtime         = 15,
	weaponType         = [[Cannon]],
	weaponVelocity     = 400,
}

-- Rocket Launcher Class
AbstractWeapon('Rocket_ATLClass'):Extends('ATLClass'):Attrs{
	areaOfEffect       = 32,
	cegTag             = [[BazookaTrail]],
	flightTime         = 1,
	gravityaffected    = true,
	reloadtime         = 10,
	startVelocity      = 10,
	weaponAcceleration = 2000,
	weaponTimer        = 1,
	weaponType         = [[MissileLauncher]],
	weaponVelocity     = 1000,
}

