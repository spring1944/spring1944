local FRA_105mm = HInfGun:New{
	name					= "Canon de 105 court modèle 1935 B",
	corpse					= "FRA105mm_destroyed",
	objectName				= "FRA/FRA105mmMle1935B.dae",
	buildCostMetal			= 3200,

	transportCapacity		= 3,
	transportMass			= 150,

	collisionVolumeType		= "box",
	collisionVolumeScales	= {13.0, 9.0, 3.0},
	collisionVolumeOffsets	= {0.0, 7.0, 4.0},

	weapons = {
		[1] = { -- HE
			name				= "FRA105mmHE",
		},
		[2] = { -- Smoke
			name				= "FRA105mmsmoke",
		},
	},
	customParams = {
	},
}

local FRA_105mm_Stationary = HGun:New{
	name					= "Deployed Canon de 105 court modèle 1935 B",
	corpse					= "FRA105mm_destroyed",
	objectName              = "FRA/FRA105mmMle1935B_stationary.s3o",
    
	weapons = {
		[1] = { -- HE
			name				= "FRA105mmHE",
		},
		[2] = { -- Smoke
			name				= "FRA105mmsmoke",
		},
	},
	customParams = {
	},
}

return lowerkeys({
	["FRA105mmMle1935B"] = FRA_105mm,
	["FRA105mmMle1935B_Stationary"] = FRA_105mm_Stationary,
})
