local ITA_Obice100 = HInfGun:New{
	name					= "Obice da 100/22",
	corpse					= "ITAObice100_Destroyed",
	buildCostMetal			= 1800,

	collisionVolumeType		= "box",
	collisionVolumeScales	= {10.0, 8.0, 4.0},
	collisionVolumeOffsets	= {0.0, 3.0, 3.0},

	weapons = {
		[1] = { -- HE
			name				= "Obice100mml22he",
		},
		[2] = { -- Smoke
			name				= "Obice100mml22smoke",
		},
	},
	customParams = {
	},
}

local ITA_Obice100_Stationary = HGun:New{
	name					= "Deployed Obice da 100/22",
	corpse					= "ITAObice100_Destroyed",
	weapons = {
		[1] = { -- HE
			name				= "Obice100mml22he",
		},
		[2] = { -- Smoke
			name				= "Obice100mml22smoke",
		},
	},
	customParams = {

	},
}

return lowerkeys({
	["ITAObice100"] = ITA_Obice100,
	["ITAObice100_Stationary"] = ITA_Obice100_Stationary,
})
