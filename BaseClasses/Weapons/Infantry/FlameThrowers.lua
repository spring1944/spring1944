-- Flamethrowers

-- Flamethrower Class
local FlamerClass = Weapon:New{
	avoidFeature       = false,
	burstrate          = 0.05,
	cegTag             = [[Flametrail]],
	edgeEffectiveness  = 0.25,
	explosionGenerator = [[custom:Flamethrower]],
	explosionSpeed     = 0.01,
	fireStarter        = 100,
	groundbounce       = false,
	id                 = 76, -- needed?
	impulseFactor      = 1e-06,
	reloadtime         = 2,
	size               = 0.01,
	soundStart         = [[GEN_Flamethrower]],
	soundTrigger       = true,
	sprayAngle         = 500,
	tolerance          = 200,
	turret             = true,
	weaponType         = [[Cannon]], -- apparantly so?!
	weaponVelocity     = 240,
	customparams = {
		ceg                = [[Flamethrower]],
		damagetime         = 15,
		damagetype         = [[fire]],
		fearid             = 501,
		scriptanimation    = "flame",
		weaponcost         = 4,
		onlytargetcategory     = "BUILDING INFANTRY SOFTVEH OPENVEH HARDVEH SHIP LARGESHIP DEPLOYED",
	},
	damage = {
		default            = 15,
	},
}

-- Return only the full weapons
return {
	FlamerClass = FlamerClass,
}
