local JPN_Type90_75mm = InfantryGun:New{
	name					= "Type 90 75mm Gun",
	corpse					= "JPNType90_75mm_Destroyed",
	buildCostMetal			= 1250,

	collisionVolumeType		= "box",
	collisionVolumeScales	= {10.0, 10.0, 5.0},
	collisionVolumeOffsets	= {0.0, 6.0, 3.0},

	weapons = {
		[1] = { -- HE
			name	= "Type9075mmHE",
		},
		[2] = { -- AP
			name	= "Type9075mmAP",
		},
	},	
	customParams = {

	},
}

local JPN_Type90_75mm_Stationary = FGGun:New{
	name					= "Towed Type 90 75mm Gun",
	corpse					= "JPNType90_75mm_Destroyed",

	weapons = {
		[1] = { -- HE
			name	= "Type9075mmHE",
		},
		[2] = { -- AP
			name	= "Type9075mmAP",
		},
	},	
	customParams = {

	},
}


return lowerkeys({
	["JPNType90_75mm"] = JPN_Type90_75mm,
	["JPNType90_75mm_Stationary"] = JPN_Type90_75mm_Stationary,
})
