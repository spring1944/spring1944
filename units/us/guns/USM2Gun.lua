local US_M2Gun = HInfGun:New{
	name					= "105mm M2",
	corpse					= "USM2Gun_Destroyed",

	transportCapacity		= 3,
	transportMass			= 150,

	collisionVolumeType		= "box",
	collisionVolumeScales	= {15.0, 9.0, 2.0},
	collisionVolumeOffsets	= {0.0, 6.5, -1.0},

	weapons = {
		[1] = { -- HE
			name				= "M2HE",
		},
		[2] = { -- Smoke
			name				= "M2smoke",
		},
	},
	customParams = {
		normaltex			= "unittextures/USM2Gun_normals.png",
	},
}

local US_M2Gun_Stationary = HGun:New{
	name					= "Deployed 105mm M2",
	corpse					= "USM2Gun_Destroyed",

	weapons = {
		[1] = { -- HE
			name				= "M2HE",
			maxAngleDif			= 45,
		},
		[2] = { -- Smoke
			name				= "M2smoke",
			maxAngleDif			= 45,
		},
	},
	customParams = {
		normaltex			= "unittextures/USM2Gun_normals.png",
	},
}

return lowerkeys({
	["USM2Gun"] = US_M2Gun,
	["USM2Gun_Stationary"] = US_M2Gun_Stationary,
})
