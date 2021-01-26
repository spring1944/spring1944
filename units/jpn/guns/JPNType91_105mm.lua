local JPN_Type91_105mm = HInfGun:New{
	name					= "Type 91 105mm Howitzer",
	corpse					= "JPNType91_105mm_Destroyed",
	buildCostMetal			= 1850,

	collisionVolumeType		= "box",
	collisionVolumeScales	= {9.0, 7.0, 4.0},
	collisionVolumeOffsets	= {0.0, 7.0, 2.0},

	weapons = {
		[1] = { -- HE
			name				= "Type91105mmL24HE",
		},
		[2] = { -- Smoke
			name				= "Type91105mmL24smoke",
		},
	},
	customParams = {
		normaltex			= "unittextures/JPNType91_105mm_Stationary_normals.png",
	},
}

local JPN_Type91_105mm_Stationary = HGun:New{
	name					= "Deployed Type 91 105mm Howitzer",
	corpse					= "JPNType91_105mm_Destroyed",
	weapons = {
		[1] = { -- HE
			name				= "Type91105mmL24HE",
		},
		[2] = { -- Smoke
			name				= "Type91105mmL24smoke",
		},
	},
	customParams = {
		normaltex			= "unittextures/JPNType91_105mm_Stationary_normals.png",
	},
}

return lowerkeys({
	["JPNType91_105mm"] = JPN_Type91_105mm,
	["JPNType91_105mm_Stationary"] = JPN_Type91_105mm_Stationary,
})
