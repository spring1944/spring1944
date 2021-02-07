local RUS_ZiS2_Truck = ATGunTractor:New{
	name					= "Towed 57mm ZiS-2",
	buildCostMetal			= 450,
	corpse					= "RUSZiS5_Destroyed",
	trackOffset				= 5,
	trackWidth				= 12,
	customParams = {
		normaltex			= "unittextures/RUSZiS2_Truck_normals.png",
	},
}

local RUS_ZiS2 = ATInfGun:New{
	name					= "57mm ZiS-2",
	corpse					= "ruszis2_destroyed",
	buildCostMetal			= 450,

	collisionVolumeType		= "box",
	collisionVolumeScales	= {12.0, 6.0, 4.0},
	collisionVolumeOffsets	= {0.0, 0.0, 0.0},

	weapons = {
		[1] = { -- AP
			name				= "zis257mmap",
		},
	},
	customParams = {
		normaltex			= "unittextures/RUSZiS2_normals.png",
	},
}

local RUS_ZiS2_Stationary = LightATGun:New{
	name					= "Deployed 57mm ZiS-2",
	corpse					= "ruszis2_destroyed",

	weapons = {
		[1] = { -- AP
			name				= "zis257mmap",
		},
	},
	customParams = {
		normaltex			= "unittextures/RUSZiS2_normals.png",
	},
}

return lowerkeys({
	["RUSZiS2_Truck"] = RUS_ZiS2_Truck,
	["RUSZiS2"] = RUS_ZiS2,
	["RUSZiS2_Stationary"] = RUS_ZiS2_Stationary,
})
