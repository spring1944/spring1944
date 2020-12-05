local FRA_25mmAT = InfantryGun:New{
	name					= "Canon léger de 25 antichar SA-L modèle 1934",
	corpse					= "FRA25mmMle1934_destroyed",
	objectName				= "FRA/FRA25mmMle1934.dae",
	buildCostMetal			= 400,

	transportCapacity		= 1,
	transportMass			= 50,

	collisionVolumeType		= "box",
	collisionVolumeScales	= {8.0, 8.0, 3.0},
	collisionVolumeOffsets	= {0.0, 0.0, 1.0},

	weapons = {
		[1] = { -- AP
			name				= "Canon_25_SA_34_AP",
		},
	},
	customParams = {

	},
}

local FRA_25mmAT_Stationary = LightATGun:New{
	name					= "Deployed Canon léger de 25 antichar SA-L modèle 1934",
	corpse					= "FRA25mmMle1934_destroyed",
	objectName				= "FRA/FRA25mmMle1934_Stationary.s3o",
	minCloakDistance		= 160,
	cloakTimeout			= 64,
	weapons = {
		[1] = { -- AP
			name				= "Canon_25_SA_34_AP",
		},
	},
	customParams = {

	},
}

local FRA_25mmAA_Truck = AAGunTractor:New{
	name					= "Towed Canon de 25 mm Hotchkiss",
	corpse					= "FRACitroenType45_Abandoned",
	buildCostMetal			= 1300,
	trackOffset				= 4,
	trackWidth				= 15,
	objectName				= "FRA/FRA25mmAA_Truck.s3o",
	customParams = {

	},
}

local FRA_25mmAA_Stationary = AAGun:New{
	name					= "Deployed Canon de 25 mm Hotchkiss",
	corpse					= "FRA25mmAA_destroyed",
	objectName				= "FRA/FRA25mmAA_Stationary.s3o",

	weapons = {
		[1] = { -- AA
			name				= "Hotchkiss25mmAA",
		},
		[2] = { -- HE
			name				= "Hotchkiss25mmHE",
		},
	},
	customParams = {

	},
}

return lowerkeys({
	["FRA25mmMle1934"] = FRA_25mmAT,
	["FRA25mmMle1934_Stationary"] = FRA_25mmAT_Stationary,
	["FRA25mmAA_Truck"] = FRA_25mmAA_Truck,
	["FRA25mmAA_Stationary"] = FRA_25mmAA_Stationary,
})
