local FRA_75mmMle1897_Truck = FGGunTractor:New{
	name					= "Towed Canon de 75 modèle 1897",
	corpse					= "fracitroenp17_destroyed",
	trackOffset				= 5,
	trackWidth				= 12,
	objectName				= "FRA/FRA75mmMle1897_truck.s3o",
	customParams = {
		normaltex			= "",
	},
}

local FRA_75mmMle1897_Stationary = FGGun:New{
	name					= "Deployed Canon de 75 modèle 1897",
	corpse					= "FRA75mmMle1897_destroyed",
	objectName				= "FRA/FRA75mmMle1897_stationary.s3o",
	
	weapons = {
		[1] = { -- HE
			name	= "FRA75mmMle1897HE",
		},
		[2] = { -- AP
			name	= "FRA75mmMle1897AP",
		},
	},	
	customParams = {
		normaltex			= "",
	},
}

return lowerkeys({
	["FRA75mmMle1897_truck"] = FRA_75mmMle1897_Truck,
	["FRA75mmMle1897_stationary"] = FRA_75mmMle1897_Stationary,
})
