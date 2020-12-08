local FRA_75mmMle1897 = FGInfGun:New{
	name					= "Canon de 75 modèle 1897",
	corpse					= "FRA75mmMle1897_destroyed",
	objectName				= "FRA/FRA75mmMle1897.dae",
	buildCostMetal			= 1300,

	collisionVolumeType		= "box",
	collisionVolumeScales	= {11.0, 11.0, 2.0},
	collisionVolumeOffsets	= {0.0, 1.0, 2.0},

	weapons = {
		[1] = { -- HE
			name	= "FRA75mmMle1897HE",
		},
		[2] = { -- AP
			name	= "FRA75mmMle1897AP",
		},
	},
	customParams = {
	},
}

local FRA_75mmMle1897_Stationary = FGGun:New{
	name					= "Deployed Canon de 75 modèle 1897",
	corpse					= "FRA75mmMle1897_destroyed",
	objectName				= "FRA/FRA75mmMle1897_Stationary.dae",

	weapons = {
		[1] = { -- HE
			name	= "FRA75mmMle1897HE",
		},
		[2] = { -- AP
			name	= "FRA75mmMle1897AP",
		},
	},
	customParams = {

	},
}

return lowerkeys({
	["FRA75mmMle1897"] = FRA_75mmMle1897,
	["FRA75mmMle1897_stationary"] = FRA_75mmMle1897_Stationary,
})
