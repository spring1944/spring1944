local SWEKanon105_42 = HInfGun:New{
	name					= "10.5 cm kanon m/34",
	corpse					= "swekanon105_42_destroyed",
	buildCostMetal			= 3200,

	transportCapacity		= 4,
	transportMass			= 200,

	collisionVolumeType		= "box",
	collisionVolumeScales	= {19.0, 14.0, 3.0},
	collisionVolumeOffsets	= {0.0, 8.0, 0.0},

	weapons = {
		[1] = { -- HE
			name				= "Bofors105mmM_34HE",
		},
		[2] = {
			name				= "Bofors105mmM_34Smoke",
		},
	},
	customParams = {
	},
}

local SWEKanon105_42_Stationary = HGun:New{
	name					= "Deployed 10.5 cm kanon m/34",
	corpse					= "swekanon105_42_destroyed",

	weapons = {
		[1] = { -- HE
			name				= "Bofors105mmM_34HE",
		},
		[2] = {
			name				= "Bofors105mmM_34Smoke",
		},
	},
	customParams = {

	},
}

return lowerkeys({
	["SWEKanon105_42"] = SWEKanon105_42,
	["SWEKanon105_42_Stationary"] = SWEKanon105_42_Stationary,
})
