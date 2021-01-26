local US_M1_45inGun = HInfGun:New{
	name					= "4.5 inch Gun M1",
	corpse					= "USM1_45inGun_Destroyed",
	buildCostMetal			= 3200,

	transportCapacity		= 3,
	transportMass			= 150,

	collisionVolumeType		= "box",
	collisionVolumeScales	= {18.0, 12.0, 3.0},
	collisionVolumeOffsets	= {0.0, 9.0, 1.0},

	weapons = {
		[1] = { -- HE
			name				= "M1_45in_GunHE",
		},
		[2] = { -- Smoke
			name				= "M1_45in_GunSmoke",
		},
	},
	customParams = {
		normaltex			= "unittextures/USM1_45inGun_normals.png",
	},
}

local US_M1_45inGun_Stationary = HGun:New{
	name					= "Deployed 4.5 inch Gun M1",
	corpse					= "USM1_45inGun_Destroyed",

	weapons = {
		[1] = { -- HE
			name				= "M1_45in_GunHE",
		},
		[2] = { -- Smoke
			name				= "M1_45in_GunSmoke",
		},
	},
	customParams = {
		normaltex			= "unittextures/USM1_45inGun_normals.png",
	},
}

return lowerkeys({
	["USM1_45inGun"] = US_M1_45inGun,
	["USM1_45inGun_Stationary"] = US_M1_45inGun_Stationary,
})
