local FRA_47mmAT_Truck = ATGunTractor:New{
	name					= "Towed Canon antichar de 47 mm modèle 1937",
	buildCostMetal			= 400,
	corpse					= "fracitroenp17_destroyed",
	trackOffset				= 4,
	trackWidth				= 15,
	objectName				= "FRA/FRA47mmAT_truck.s3o",
	customParams = {
		normaltex			= "",
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
		normaltex			= "",
	},
}

return lowerkeys({
	["FRA47mmAT_Truck"] = FRA_47mmAT_Truck,
	["FRA47mmAT_Stationary"] = FRA_47mmAT_Stationary,
})
