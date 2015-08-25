-- Aircraft - Bombs

-- Bomb Base Class
local BombClass = Weapon:New{
	collideFriendly    = true,
	explosionSpeed     = 30,
	explosionGenerator = [[custom:HE_XXLarge]],
	gravityaffected    = true,
	heightBoostFactor  = 0,
	impulseFactor      = 0.01,
	manualBombSettings = true,
	noSelfDamage       = true,
	reloadtime         = 600,
	tolerance          = 4000,
	trajectoryHeight   = 0.15,
	turret             = true,
	weaponType         = [[MissileLauncher]],
	startVelocity      = 280,
	weaponVelocity     = 280,
	customparams = {
		bomb               = true,
		no_range_adjust    = true,
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
