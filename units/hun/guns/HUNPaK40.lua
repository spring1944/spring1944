local HUN_PaK40_Truck = ATGunTractor:New{
	name					= "Towed 7.5cm PaK 40",
	corpse					= "HUNHansaLloyd_Burning",
	trackOffset				= 10,
	trackWidth				= 13,
	customParams = {
		normaltex			= "unittextures/HUNPaK40_truck_normals.png",
	},
}

local HUN_PaK40 = ATInfGun:New{
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
		normaltex			= "unittextures/HUNPaK40_normals.png",
	},
}

local HUN_PaK40_Stationary = ATGun:New{
	name					= "Deployed 7.5cm PaK 40",
	corpse					= "gerpak40_destroyed",

	weapons = {
		[1] = { -- AP
			name				= "KwK75mmL48AP",
		},
	},
	customParams = {
		normaltex			= "unittextures/HUNPaK40_normals.png",
	},
}
	
return lowerkeys({
	["HUNPaK40_Truck"] = HUN_PaK40_Truck,
	["HUNPaK40"] = HUN_PaK40,
	["HUNPaK40_Stationary"] = HUN_PaK40_Stationary,
})
