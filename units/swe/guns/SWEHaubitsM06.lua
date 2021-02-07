local SWEHaubitsM06_Truck = HGunTractor:New{
	name					= "Towed Haubits m/06",
	corpse					= "SWEVolvoHBT_Destroyed",
	buildCostMetal			= 2650,
	trackOffset				= 10,
	trackWidth				= 13,
	customParams = {
		normaltex			= "unittextures/SWEVolvoHBT_normals.png",
	},
}

local SWEHaubitsM06 = HInfGun:New{
	name					= "Haubits m/06",
	corpse					= "swehaubitsm06_destroyed",
	buildCostMetal			= 2650,

	collisionVolumeType		= "box",
	collisionVolumeScales	= {5.0, 5.0, 8.0},
	collisionVolumeOffsets	= {0.0, 0.0, 0.0},

	weapons = {
		[1] = { -- HE
			name				= "haubm06150mmL11HE",
		},
		[2] = { -- Smoke
			name				= "haubm06150mmL11Smoke",
		},
	},
	customParams = {
		normaltex			= "unittextures/SWEHaubitsM39_normals.png",
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
		normaltex			= "unittextures/SWEHaubitsM39_normals.png",
	},
}

return lowerkeys({
	["SWEHaubitsM06_Truck"] = SWEHaubitsM06_Truck,
	["SWEHaubitsM06"] = SWEHaubitsM06,
	["SWEHaubitsM06_Stationary"] = SWEHaubitsM06_Stationary,
})
