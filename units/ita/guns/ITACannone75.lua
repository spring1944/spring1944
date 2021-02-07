local ITA_Cannone75 = FGInfGun:New{
	name					= "Cannone da 75/32",
	corpse					= "ITACannone75_Destroyed",
	buildCostMetal			= 1250,

	collisionVolumeType		= "box",
	collisionVolumeScales	= {10.0, 10.0, 5.0},
	collisionVolumeOffsets	= {0.0, 0.0, 0.0},

	weapons = {
		[1] = { -- HE
			name	= "Ansaldo75mmL34HE",
		},
		[2] = { -- AP
			name	= "Ansaldo75mmL34AP",
		},
	},	
	customParams = {
		normaltex			= "unittextures/ITACannone75_Stationary_normals.png",
	},
}

local ITA_Cannone75_Stationary = FGGun:New{
	name					= "Towed Cannone da 75/32",
	corpse					= "ITACannone75_Destroyed",
	weapons = {
		[1] = { -- HE
			name	= "Ansaldo75mmL34HE",
		},
		[2] = { -- AP
			name	= "Ansaldo75mmL34AP",
		},
	},	
	customParams = {
		normaltex			= "unittextures/ITACannone75_Stationary_normals.png",
	},
}

return lowerkeys({
	["ITACannone75"] = ITA_Cannone75,
	["ITACannone75_Stationary"] = ITA_Cannone75_Stationary,
})
