local HUN_PaK40 = ATInfGun:New{
	name					= "7.5cm PaK 40",
	corpse					= "gerpak40_destroyed",
	buildCostMetal			= 840,

	collisionVolumeType		= "box",
	collisionVolumeScales	= {13.0, 6.0, 6.0},
	collisionVolumeOffsets	= {0.0, 4.0, 3.0},

	weapons = {
		[1] = { -- AP
			name				= "KwK75mmL48AP",
		},
	},
	customParams = {
	},
}

local HUN_PaK40_Stationary = ATGun:New{
	name					= "Deployed 7.5cm PaK 40",
	corpse					= "gerpak40_destroyed",

	weapons = {
		[1] = { -- AP
			name				= "KwK75mmL48AP",
		},
	},
	customParams = {

	},
}
	
return lowerkeys({
	["HUNPaK40"] = HUN_PaK40,
	["HUNPaK40_Stationary"] = HUN_PaK40_Stationary,
})
