local RUS_M30 = HInfGun:New{
	name					= "Canon de 105 court modèle 1935 B",
	corpse					= "RUSM30_Destroyed",
	buildCostMetal			= 2000,

	collisionVolumeType		= "box",
	collisionVolumeScales	= {9.0, 9.0, 5.0},
	collisionVolumeOffsets	= {-4.0, 9.0, 0.0},

	weapons = {
		[1] = { -- HE
			name				= "m30122mmHE",
		},
		[2] = { -- Smoke
			name				= "m30122mmSmoke",
		},
	},
	customParams = {
	},
}

local RUS_M30_Stationary = HGun:New{
	name					= "Deployed 122mm M-30",
	corpse					= "RUSM30_Destroyed",
	weapons = {
		[1] = { -- HE
			name				= "m30122mmHE",
		},
		[2] = { -- Smoke
			name				= "m30122mmSmoke",
		},
	},
	customParams = {

	},
}

return lowerkeys({
	["RUSM30"] = RUS_M30,
	["RUSM30_Stationary"] = RUS_M30_Stationary,
})
