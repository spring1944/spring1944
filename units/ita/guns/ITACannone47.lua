local ITA_Cannone47_Truck = ATGunTractor:New{
	name					= "Towed Cannone da 47/32",
	corpse					= "ITAFiat626_Abandoned", -- TODO: grumble
	trackOffset				= 5,
	trackWidth				= 12,
	customParams = {
		normaltex			= "unittextures/ITACanone47_truck_normals.png",
	},
}

local ITA_Cannone47 = ATInfGun:New{
	name					= "Cannone da 47/32",
	corpse					= "gerpak40_destroyed",
	buildCostMetal			= 360,

	transportCapacity		= 1,
	transportMass			= 50,

	collisionVolumeType		= "box",
	collisionVolumeScales	= {3.0, 5.0, 7.0},
	collisionVolumeOffsets	= {0.0, 0.0, 0.0},

	weapons = {
		[1] = { -- AP
			name				= "CannoneDa47mml32AP_towed",
		},
	},
	customParams = {
		normaltex			= "unittextures/ITACanone47_stationary_normals.png",
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
		normaltex			= "unittextures/ITACanone47_stationary_normals.png",
	},
}

return lowerkeys({
	["ITACannone47_Truck"] = ITA_Cannone47_Truck,
	["ITACannone47"] = ITA_Cannone47,
	["ITACannone47_Stationary"] = ITA_Cannone47_Stationary,
})
