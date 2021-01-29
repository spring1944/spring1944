local GER_Nebelwerfer_Truck = RGunTractor:New{
	name					= "Towed 15cm Nebelwerfer 41",
	corpse					= "GEROpelBlitz_Destroyed",
	trackOffset				= 10,
	trackWidth				= 13,
	customParams = {
		normaltex			= "unittextures/GERNebelwerfer_Truck_normals.png",
	},
}

local GER_Nebelwerfer = RInfGun:New{
	name					= "15cm Nebelwerfer 41",
	corpse					= "gernebelwerfer_destroyed",
	buildCostMetal			= 3600,

	collisionVolumeType		= "box",
	collisionVolumeScales	= {6.0, 6.0, 6.0},
	collisionVolumeOffsets	= {0.0, 0.0, 0.0},

	customParams = {
		maxammo				= 1,
		normaltex			= "unittextures/GERNebelwerfer_normals.png",
	},
	weapons = {
		[1] = {
			name			= "Nebelwerfer41",
		},
	},
}

local GER_Nebelwerfer_Stationary = RGun:New{
	name					= "Deployed 15cm Nebelwerfer 41",
	corpse					= "gernebelwerfer_destroyed",
	customParams = {
		maxammo				= 1,
		normaltex			= "unittextures/GERNebelwerfer_normals.png",
	},
	weapons = {
		[1] = {
			name			= "Nebelwerfer41",
		},
	},
}

return lowerkeys({
	["GERNebelwerfer_Truck"] = GER_Nebelwerfer_Truck,
	["GERNebelwerfer"] = GER_Nebelwerfer,
	["GERNebelwerfer_Stationary"] = GER_Nebelwerfer_Stationary,
})
