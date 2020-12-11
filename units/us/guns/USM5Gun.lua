local US_M5Gun = ATInfGun:New{
	name					= "3-Inch M5",
	corpse					= "usm5gun_destroyed",
	buildCostMetal			= 600,

	collisionVolumeType		= "box",
	collisionVolumeScales	= {15.0, 9.0, 2.0},
	collisionVolumeOffsets	= {0.0, 6.5, -1},

	weapons = {
		[1] = { -- AP
			name				= "M7ap",
		},
	},
	customParams = {

	},
}


local US_M5Gun_Stationary = ATGun:New{
	name					= "Deployed 3-Inch M5",
	corpse					= "usm5gun_destroyed",
	weapons = {
		[1] = { -- AP
			name				= "M7ap",
		},
	},
	customParams = {

	},
}

return lowerkeys({
	["USM5Gun"] = US_M5Gun,
	["USM5Gun_Stationary"] = US_M5Gun_Stationary,
})
