local FRA_47mmAT = InfantryGun:New{
	name					= "Canon de 105 court modèle 1935 B",
	corpse					= "FRA105mm_destroyed",
	objectName				= "FRA/FRA105mmMle1935B.dae",
	buildCostMetal			= 2000,

	collisionVolumeType		= "box",
	collisionVolumeScales	= {9.0, 13.0, 3.0},
	collisionVolumeOffsets	= {0.0, 2.0, 1.0},

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
