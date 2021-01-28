local GER_PaK40_Truck = ATGunTractor:New{
	name					= "Towed 7.5cm PaK 40",
	corpse					= "GERSdKfz11_Destroyed",
	trackOffset				= 10,
	trackWidth				= 13,
	customParams = {
		normaltex			= "unittextures/GERPaK40_Truck_normals.png",
	},
}

local GER_PaK40 = ATInfGun:New{
	name					= "7.5cm PaK 40",
	corpse					= "gerpak40_destroyed",
	buildCostMetal			= 840,

	collisionVolumeType		= "box",
	collisionVolumeScales	= {13.0, 6.0, 6.0},
	collisionVolumeOffsets	= {0.0, 6.0, 3.0},

	weapons = {
		[1] = { -- AP
			name				= "KwK75mmL48AP",
		},
	},
	customParams = {
		normaltex			= "unittextures/GERPaK40_normals.png",
	},
}

local GER_PaK40_Stationary = ATGun:New{
	name					= "Deployed 7.5cm PaK 40",
	corpse					= "gerpak40_destroyed",

	weapons = {
		[1] = { -- AP
			name				= "KwK75mmL48AP",
		},
	},
	customParams = {
		normaltex			= "unittextures/GERPaK40_normals.png",
	},
}
	
return lowerkeys({
	["GERPaK40_Truck"] = GER_PaK40_Truck,
	["GERPaK40"] = GER_PaK40,
	["GERPaK40_Stationary"] = GER_PaK40_Stationary,
})
