local SWEKanonM02_33 = FGInfGun:New{
	name					= "7,5cm Kanon m/02-33",
	corpse					= "ITACannone75_Destroyed",
	buildCostMetal			= 1125,

	collisionVolumeType		= "box",
	collisionVolumeScales	= {11.0, 11.0, 4.0},
	collisionVolumeOffsets	= {0.0, 8.0, 2.0},

	weapons = {
		[1] = { -- HE
			name	= "SWE75mmL30HE",
		},
		[2] = { -- AP
			name	= "SWE75mmL30AP",
		},
	},	
	customParams = {

	},
}

local SWEKanonM02_33_Stationary = FGGun:New{
	name					= "Deployed 7,5cm Kanon m/02-33",
	corpse					= "ITACannone75_Destroyed",

	weapons = {
		[1] = { -- HE
			name	= "SWE75mmL30HE",
		},
		[2] = { -- AP
			name	= "SWE75mmL30AP",
		},
	},	
	customParams = {

	},
}

return lowerkeys({
	["SWEKanonM02_33"] = SWEKanonM02_33,
	["SWEKanonM02_33_Stationary"] = SWEKanonM02_33_Stationary,
})
