local ITA_Cannone_105_32 = HInfGun:New{
	name					= "Cannone da 105/32",
	corpse					= "ITACannone105_32_Destroyed",
	buildCostMetal			= 3000,

	transportCapacity		= 3,
	transportMass			= 150,

	collisionVolumeType		= "box",
	collisionVolumeScales	= {15.0, 10.0, 10.0},
	collisionVolumeOffsets	= {0.0, 6.0, 6.0},

	weapons = {
		[1] = { -- HE
			name				= "Cannone105_32HE",
		},
		[2] = { -- Smoke
			name				= "Cannone105_32Smoke",
		},
	},
	customParams = {
	},
}

local ITA_Cannone_105_32_Stationary = HGun:New{
	name					= "Deployed Cannone da 105/32",
	corpse					= "ITACannone105_32_Destroyed",
	weapons = {
		[1] = { -- HE
			name				= "Cannone105_32HE",
		},
		[2] = { -- Smoke
			name				= "Cannone105_32Smoke",
		},
	},
	customParams = {

	},
}

return lowerkeys({
	["ITACannone105_32"] = ITA_Cannone_105_32,
	["ITACannone105_32_Stationary"] = ITA_Cannone_105_32_Stationary,
})
