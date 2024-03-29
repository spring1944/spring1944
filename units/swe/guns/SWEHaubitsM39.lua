local SWEHaubitsM39_Truck = HGunTractor:New{
	name					= "Towed 10.5cm Haubits m/39",
	corpse					= "SWEVolvoHBT_Destroyed",
	trackOffset				= 10,
	trackWidth				= 13,
	customParams = {
		normaltex			= "unittextures/SWEVolvoHBT_normals.png",
	},
}

local SWEHaubitsM39 = HInfGun:New{
	name					= "10.5cm Haubits m/39",
	corpse					= "gerlefh18_destroyed",

	collisionVolumeType		= "box",
	collisionVolumeScales	= {9.0, 9.0, 4.0},
	collisionVolumeOffsets	= {0.0, 0.0, 0.0},

	weapons = {
		[1] = { -- HE
			name				= "leFH18HE",
		},
		[2] = { -- Smoke
			name				= "leFH18smoke",
		},
	},
	customParams = {
		normaltex			= "unittextures/SWEHaubitsM39_normals.png",
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
		normaltex			= "unittextures/SWEHaubitsM39_normals.png",
	},
}

return lowerkeys({
	["SWEHaubitsM39_Truck"] = SWEHaubitsM39_Truck,
	["SWEHaubitsM39"] = SWEHaubitsM39,
	["SWEHaubitsM39_Stationary"] = SWEHaubitsM39_Stationary,
})
