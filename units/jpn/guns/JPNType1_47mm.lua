local JPN_Type1_47mm = ATInfGun:New{
	name					= "Type 1 47mm Gun",
	corpse					= "JPNType1_47mm_destroyed",
	buildCostMetal			= 360,

	transportCapacity		= 1,
	transportMass			= 50,

	collisionVolumeType		= "box",
	collisionVolumeScales	= {9.0, 7.0, 5.0},
	collisionVolumeOffsets	= {0.0, 6.0, 4.0},

	weapons = {
		[1] = { -- AP
			name				= "CannoneDa47mml32AP_towed",
		},
	},
	customParams = {
		normaltex			= "unittextures/JPNType1_47mm_normals.png",
	},
}

local JPN_Type1_47mm_Stationary = LightATGun:New{
	name					= "Deployed Type 1 47mm Gun",
	buildCostMetal			= 360,
	corpse					= "JPNType1_47mm_destroyed",
	minCloakDistance = 160,
	weapons = {
		[1] = { -- AP
			name				= "Type147mmAP_towed",
		},
	},
	customParams = {
		normaltex			= "unittextures/JPNType1_47mm_normals.png",
	},
}

return lowerkeys({
	["JPNType1_47mm"] = JPN_Type1_47mm,
	["JPNType1_47mm_Stationary"] = JPN_Type1_47mm_Stationary,
})
