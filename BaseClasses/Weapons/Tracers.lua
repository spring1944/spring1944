-- Misc - Tracers

-- Tracer Base Class
local TracerClass = Weapon:New{
	areaOfEffect       = 1,
	burnblow           = true,
	canAttackGround	 = false,
	explosionGenerator = [[custom:nothing]],
	id                 = 666, -- needed?
	noSelfDamage       = true,
	range              = 1000,
	reloadtime         = 0.1,
	rgbColor           = [[1.0 0.75 0.0]],
	tolerance          = 600,
	turret             = true,
	customparams = {
		damagetype         = [[none]],
	},
	damage = {
		default            = 0,
	},
}

local MGTracerClass = TracerClass:New{
	avoidFriendly      = false,
	collideFriendly    = false,
	coreThickness      = 0.15,
	duration           = 0.01,
	intensity          = 0.7,
	laserFlareSize     = 0.0001,
	thickness          = 0.45,
	weaponType         = [[LaserCannon]],
	weaponVelocity     = 1500,
}

local GreenTracerClass = Weapon:New{ -- todo: not perfect to have to have this here if we want to add other nation specific colours
	rgbColor           = [[0.0 0.7 0.0]],  
}

return {
	TracerClass = TracerClass,
	MGTracerClass = MGTracerClass,
	GreenTracerClass = GreenTracerClass,
}
