local GER_LeFH18 = HInfGun:New{
	name					= "10.5cm LeFH 18M",
	corpse					= "gerlefh18_destroyed",
	buildCostMetal			= 1800,

	collisionVolumeType		= "box",
	collisionVolumeScales	= {10.0, 7.0, 4.0},
	collisionVolumeOffsets	= {0.0, 7.0, 3.0},

	weapons = {
		[1] = { -- HE
			name				= "leFH18HE",
		},
		[2] = { -- Smoke
			name				= "leFH18smoke",
		},
	},
	customParams = {
		normaltex			= "unittextures/GERleFH18_normals.png",
	},
}

local GER_LeFH18_Stationary = HGun:New{
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
		normaltex			= "unittextures/GERleFH18_normals.png",
	},
}

return lowerkeys({
	["GERLeFH18"] = GER_LeFH18,
	["GERLeFH18_Stationary"] = GER_LeFH18_Stationary,
})
