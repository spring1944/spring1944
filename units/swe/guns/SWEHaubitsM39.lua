local SWEHaubitsM39 = HInfGun:New{
	name					= "10.5cm Haubits m/39",
	corpse					= "gerlefh18_destroyed",

	collisionVolumeType		= "box",
	collisionVolumeScales	= {9.0, 9.0, 4.0},
	collisionVolumeOffsets	= {0.0, 8.5, 1.5},

	weapons = {
		[1] = { -- HE
			name				= "leFH18HE",
		},
		[2] = { -- Smoke
			name				= "leFH18smoke",
		},
	},
	customParams = {
	},
}

local SWEHaubitsM39_Stationary = HGun:New{
	name					= "Deployed 10.5cm Haubits m/39",
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

	},
}

return lowerkeys({
	["SWEHaubitsM39"] = SWEHaubitsM39,
	["SWEHaubitsM39_Stationary"] = SWEHaubitsM39_Stationary,
})
