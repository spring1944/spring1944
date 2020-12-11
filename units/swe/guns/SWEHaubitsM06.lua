local SWEHaubitsM06 = HInfGun:New{
	name					= "Haubits m/06",
	corpse					= "swehaubitsm06_destroyed",
	buildCostMetal			= 2650,

	collisionVolumeType		= "box",
	collisionVolumeScales	= {5.0, 5.0, 8.0},
	collisionVolumeOffsets	= {0.0, 8.5, 2.0},

	weapons = {
		[1] = { -- HE
			name				= "haubm06150mmL11HE",
		},
		[2] = { -- Smoke
			name				= "haubm06150mmL11Smoke",
		},
	},
	customParams = {
	},
}

local SWEHaubitsM06_Stationary = HGun:New{
	name					= "Deployed Haubits m/06",
	corpse					= "swehaubitsm06_destroyed",

	weapons = {
		[1] = { -- HE
			name				= "haubm06150mmL11HE",
		},
		[2] = { -- Smoke
			name				= "haubm06150mmL11Smoke",
		},
	},
	customParams = {
	},
}

return lowerkeys({
	["SWEHaubitsM06"] = SWEHaubitsM06,
	["SWEHaubitsM06_Stationary"] = SWEHaubitsM06_Stationary,
})
