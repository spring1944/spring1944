local FRA_47mmAT = ATInfGun:New{
	name					= "Canon antichar de 47 mm modèle 1937",
	corpse					= "FRA47mmAT_destroyed",
	objectName				= "FRA/FRA47mmAT.dae",
	buildCostMetal			= 400,

	collisionVolumeType		= "box",
	collisionVolumeScales	= {11.0, 8.0, 3.0},
	collisionVolumeOffsets	= {0.0, 4.0, 1.0},

	weapons = {
		[1] = { -- AP
			name				= "FRA47mmSA37AP",
		},
	},
	customParams = {
		normaltex = "unittextures/FRACitroenP17_normals.png",
	},
}

local FRA_47mmAT_Stationary = ATGun:New{
	name					= "Deployed Canon antichar de 47 mm modèle 1937",
	corpse					= "FRA47mmAT_destroyed",
	objectName				= "FRA/FRA47mmAT_stationary.s3o",

	weapons = {
		[1] = { -- AP
			name				= "FRA47mmSA37AP",
		},
	},
	customParams = {
		normaltex = "unittextures/FRACitroenP17_normals.png",
	},
}

return lowerkeys({
	["FRA47mmAT"] = FRA_47mmAT,
	["FRA47mmAT_Stationary"] = FRA_47mmAT_Stationary,
})
