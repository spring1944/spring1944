-- Aircraft - Bombs

-- Bomb Base Class
local BombClass = Weapon:New{
	collideFriendly    = true,
	explosionSpeed     = 30,
	explosionGenerator = [[custom:HE_XXLarge]],
	heightBoostFactor  = 0,
	highTrajectory     = 0,
	targetBorder	   = 0.6,
	impulseFactor      = 0.01,
	--manualBombSettings = true,
	noSelfDamage       = true,
	reloadtime         = 600,
	leadlimit	= 50,
	tolerance          = 5000,
	turret             = true,
	weaponType         = [[Cannon]],
	weaponVelocity     = 200,
	customparams = {
		bomb               = true,
		no_range_adjust    = true,
		onlyTargetCategory = "HARDVEH OPENVEH SHIP LARGESHIP TURRET",
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
