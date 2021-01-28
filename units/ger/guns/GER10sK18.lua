local GER_10sK18_Truck = LongRangeGunTractor:New{
	name					= "Towed 10cm sK 18",
	corpse					= "GERSdKfz7_Destroyed",
	trackOffset				= 10,
	trackWidth				= 19,
	customParams = {
		normaltex			= "unittextures/GER10sK18_normals.png",
	},
}

local GER_10sK18 = HInfGun:New{
	name					= "10cm sK 18",
	corpse					= "gerlefh18_destroyed",
	buildCostMetal			= 3200,

	transportCapacity		= 4,
	transportMass			= 200,

	collisionVolumeType		= "box",
	collisionVolumeScales	= {7.0, 11.0, 9.0},
	collisionVolumeOffsets	= {0.0, 8.0, 2.0},

	weapons = {
		[1] = { -- HE
			name			= "GER10sK18HE",
		},
		[2] = { -- Smoke
			name			= "GER10sK18Smoke",
		},
	},
	customParams = {
		normaltex			= "unittextures/GER10sK18_normals.png",
	},
}

local GER_10sK18_Stationary = HGun:New{
	name					= "Deployed 10cm sK 18",
	corpse					= "ger10sk18_destroyed",

	weapons = {
		[1] = { -- HE
			name			= "GER10sK18HE",
		},
		[2] = { -- Smoke
			name			= "GER10sK18Smoke",
		},
	},
	customParams = {
		normaltex			= "unittextures/GER10sK18_normals.png",
	},
}

return lowerkeys({
	["GER10sK18_Truck"] = GER_10sK18_Truck,
	["GER10sK18"] = GER_10sK18,
	["GER10sK18_Stationary"] = GER_10sK18_Stationary,
})
