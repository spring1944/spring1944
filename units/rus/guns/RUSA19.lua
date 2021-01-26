local RUS_A19 = FGInfGun:New{
	name					= "Canon de 75 modèle 1897",
	corpse					= "RUSM30_Destroyed",
	buildCostMetal			= 3500,

	transportCapacity		= 3,
	transportMass			= 150,

	collisionVolumeType		= "box",
	collisionVolumeScales	= {12.0, 8.0, 3.0},
	collisionVolumeOffsets	= {0.0, 8.0, 2.0},

	weapons = {
		[1] = { -- HE
			name				= "A19HE",
		},
		[2] = { -- Smoke
			name				= "A19Smoke",
		},
	},
	customParams = {
		normaltex			= "unittextures/RUSA19_normals.png",
	},
}

local RUS_A19_Stationary = HGun:New{
	name					= "Deployed 122mm A-19",
	corpse					= "RUSM30_Destroyed",
	weapons = {
		[1] = { -- HE
			name				= "A19HE",
		},
		[2] = { -- Smoke
			name				= "A19Smoke",
		},
	},
	customParams = {
		normaltex			= "unittextures/RUSA19_normals.png",
	},
}

return lowerkeys({
	["RUSA19"] = RUS_A19,
	["RUSA19_Stationary"] = RUS_A19_Stationary,
})
