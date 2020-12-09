local ITA_Cannone47 = ATInfGun:New{
	name					= "Cannone da 47/32",
	corpse					= "gerpak40_destroyed",
	buildCostMetal			= 360,

	collisionVolumeType		= "box",
	collisionVolumeScales	= {3.0, 5.0, 7.0},
	collisionVolumeOffsets	= {0.0, 3.0, 5.0},

	weapons = {
		[1] = { -- AP
			name				= "CannoneDa47mml32AP_towed",
		},
	},
	customParams = {
	},
}

local ITA_Cannone47_Stationary = LightATGun:New{
	name					= "Deployed Cannone da 47/32",
	buildCostMetal			= 360,
	corpse					= "ITACannone47_destroyed",
	minCloakDistance = 160,
	cloakTimeout = 64,
	weapons = {
		[1] = { -- AP
			name				= "CannoneDa47mml32AP_towed",
		},
	},
	customParams = {

	},
}

return lowerkeys({
	["ITACannone47"] = ITA_Cannone47,
	["ITACannone47_Stationary"] = ITA_Cannone47_Stationary,
})
