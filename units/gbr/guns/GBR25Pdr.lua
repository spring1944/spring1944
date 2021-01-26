local GBR_25Pdr = HInfGun:New{
	name					= "Q.F. 25 Pounder",
	corpse					= "gbr25pdr_destroyed",
	buildCostMetal			= 1800,

	collisionVolumeType		= "box",
	collisionVolumeScales	= {12.0, 10.0, 4.0},
	collisionVolumeOffsets	= {0.0, 5.0, 4.0},

	weapons = {
		[1] = { -- HE
			name				= "qf25pdrhe",
		},
		[2] = { -- Smoke
			name				= "qf25pdrsmoke",
		},
	},
	customParams = {
		normaltex			= "unittextures/GBR25Pounder_normals.png",
	},
}

local GBR_25Pdr_Stationary = HGun:New{
	name					= "Deployed Q.F. 25 Pounder",
	corpse					= "gbr25pdr_destroyed",

	weapons = {
		[1] = { -- HE
			name				= "qf25pdrhe",
			maxAngleDif			= 50,
		},
		[2] = { -- Smoke
			name				= "qf25pdrsmoke",
			maxAngleDif			= 50,
		},
	},
	customParams = {
		normaltex			= "unittextures/GBR25Pounder_normals.png",
	},
}

return lowerkeys({
	["GBR25Pdr"] = GBR_25Pdr,
	["GBR25Pdr_Stationary"] = GBR_25Pdr_Stationary,
})
