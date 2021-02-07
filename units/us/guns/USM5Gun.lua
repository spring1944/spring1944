local US_M5Gun_Truck = ATGunTractor:New{
	name					= "Towed 3-Inch M5",
	buildCostMetal			= 600,
	corpse					= "USGMCTruck_Destroyed",
	trackOffset				= 10,
	trackWidth				= 15,
	customParams = {
		normaltex			= "unittextures/USM5Gun_Truck_normals.png",
	},
}

local US_M5Gun = ATInfGun:New{
	name					= "3-Inch M5",
	corpse					= "usm5gun_destroyed",
	buildCostMetal			= 600,

	collisionVolumeType		= "box",
	collisionVolumeScales	= {15.0, 9.0, 2.0},
	collisionVolumeOffsets	= {0.0, 0.0, 0.0},

	weapons = {
		[1] = { -- AP
			name				= "M7ap",
		},
	},
	customParams = {
		normaltex			= "unittextures/USM5Gun_normals.png",
	},
}

local US_M5Gun_Stationary = ATGun:New{
	name					= "Deployed 3-Inch M5",
	corpse					= "usm5gun_destroyed",
	weapons = {
		[1] = { -- AP
			name				= "M7ap",
		},
	},
	customParams = {
		normaltex			= "unittextures/USM5Gun_normals.png",
	},
}

return lowerkeys({
	["USM5Gun_Truck"] = US_M5Gun_Truck,
	["USM5Gun"] = US_M5Gun,
	["USM5Gun_Stationary"] = US_M5Gun_Stationary,
})
