local HUN_LeFH18_Truck = HGunTractor:New{
	name					= "Towed 10.5cm LeFH 18M",
	corpse					= "HUNHansaLloyd_Burning",
	trackOffset				= 10,
	trackWidth				= 13,
	customParams = {
		normaltex			= "unittextures/HUNLefH18_truck_normals.png",
	},
}

local HUN_LeFH18 = HInfGun:New{
	name					= "10.5cm LeFH 18M",
	corpse					= "gerlefh18_destroyed",
	buildCostMetal			= 1800,

	collisionVolumeType		= "box",
	collisionVolumeScales	= {9.0, 7.0, 4.0},
	collisionVolumeOffsets	= {0.0, 0.0, 0.0},

	weapons = {
		[1] = { -- HE
			name				= "leFH18HE",
		},
		[2] = { -- Smoke
			name				= "leFH18smoke",
		},
	},
	customParams = {
		normaltex			= "unittextures/HUNLefh18_normals.png",
	},
}

local HUN_LeFH18_Stationary = HGun:New{
	name					= "Deployed 10.5cm LeFH 18M",
	corpse					= "gerlefh18_destroyed",

	weapons = {
		[1] = { -- HE
			name				= "leFH18HE",
		},
		[2] = { -- Smoke
			name				= "leFH18smoke",
		},
	},
	customParams = {
		normaltex			= "unittextures/HUNLefh18_normals.png",
	},
}

return lowerkeys({
	["HUNLeFH18_Truck"] = HUN_LeFH18_Truck,
	["HUNLeFH18"] = HUN_LeFH18,
	["HUNLeFH18_Stationary"] = HUN_LeFH18_Stationary,
})
