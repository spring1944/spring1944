local JPN_Type92_10cm = HInfGun:New{
	name					= "Type 92 10cm Cannon",
	corpse					= "JPNType92_10cm_Destroyed",
	buildCostMetal			= 3200,

	transportCapacity		= 4,
	transportMass			= 200,

	collisionVolumeType		= "box",
	collisionVolumeScales	= {13.0, 10.0, 7.0},
	collisionVolumeOffsets	= {0.0, 5.0, 1.0},

	weapons = {
		[1] = { -- HE
			name				= "Type92_10cmHE",
		},
		[2] = { -- Smoke
			name				= "Type92_10cmSmoke",
		},
	},
	customParams = {
	},
}


local JPN_Type92_10cm_Stationary = HGun:New{
	name					= "Deployed Type 92 10cm Cannon",
	corpse					= "JPNType92_10cm_Destroyed",
	weapons = {
		[1] = { -- HE
			name				= "Type92_10cmHE",
		},
		[2] = { -- Smoke
			name				= "Type92_10cmSmoke",
		},
	},
	customParams = {

	},
}

return lowerkeys({
	["JPNType92_10cm"] = JPN_Type92_10cm,
	["JPNType92_10cm_Stationary"] = JPN_Type92_10cm_Stationary,
})
