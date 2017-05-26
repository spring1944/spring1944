local FRA_25mmAT_Truck = ATGunTractor:New{
	name					= "Towed Canon léger de 25 antichar SA-L modèle 1934",
	buildCostMetal			= 400,
	corpse					= "FRALafflyV15_Abandoned",
	trackOffset				= 4,
	trackWidth				= 15,
	objectName				= "FRA/FRA25mmMle1934_Truck.s3o",
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
}

return lowerkeys({
	["FRA25mmMle1934_Truck"] = FRA_25mmAT_Truck,
	["FRA25mmMle1934_Stationary"] = FRA_25mmAT_Stationary,
})
