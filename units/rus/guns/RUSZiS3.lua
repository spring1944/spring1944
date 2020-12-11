local RUS_ZiS3 = FGInfGun:New{
	name					= "76mm ZiS-3",
	corpse					= "RUSZiS-3_Destroyed",
	buildCostMetal			= 1300,

	collisionVolumeType		= "box",
	collisionVolumeScales	= {12.0, 11.0, 6.0},
	collisionVolumeOffsets	= {0.0, 8.0, 3.0},

	weapons = {
		[1] = { -- HE
			name	= "ZiS376mmHE",
		},
		[2] = { -- AP
			name	= "ZiS376mmAP",
		},
	},	
	customParams = {

	},
}

local RUS_ZiS3_Stationary = FGGun:New{
	name					= "Deployed 76mm ZiS-3",
	corpse					= "RUSZiS-3_Destroyed",
	
	weapons = {
		[1] = { -- HE
			name	= "ZiS376mmHE",
		},
		[2] = { -- AP
			name	= "ZiS376mmAP",
		},
	},	
	customParams = {

	},
}

return lowerkeys({
	["RUSZiS3"] = RUS_ZiS3,
	["RUSZiS3_Stationary"] = RUS_ZiS3_Stationary,
})
