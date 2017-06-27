local FRA_105mm_Truck = HGunTractor:New{
	name					= "Towed Canon de 105 court modèle 1935 B",
	corpse					= "fracitroenp17_destroyed",
	trackOffset				= 5,
	trackWidth				= 12,
	objectName              = "FRA/FRA105mmMle1935B_truck.s3o",
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
	["FRA105mmMle1935B_Truck"] = FRA_105mm_Truck,
	["FRA105mmMle1935B_Stationary"] = FRA_105mm_Stationary,
})
