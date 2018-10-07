-- Aircraft - Bombs

-- Bomb Base Class
local BombClass = Weapon:New{
	collideFriendly    = true,
	explosionSpeed     = 30,
	explosionGenerator = [[custom:HE_XXLarge]],
	fireTolerance	= 5000,
	heightBoostFactor  = 0,
	highTrajectory     = 0,
	targetBorder	   = 1,
	impulseFactor      = 0.01,
	--manualBombSettings = true,
	noSelfDamage       = true,
	reloadtime         = 600,
	leadlimit	= 5,
	tolerance          = 500,
	turret             = false,
	weaponType         = [[Cannon]],
	weaponVelocity     = 200,
	customparams = {
		bomb               = true,
		no_range_adjust    = true,
		onlyTargetCategory = "BUILDING HARDVEH OPENVEH SHIP LARGESHIP TURRET",
		badtargetcategory  = "SHIP LARGESHIP",
		damagetype         = [[explosive]],
	},
	damage = {
		default            = 30000,
		planes             = 5,
	},
}

-- Return only the full weapons
return {
	BombClass = BombClass,
}
