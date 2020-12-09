local HUN_31M_105mm = HInfGun:New{
	name					= "105mm 31M Tábori Ágyú",
	corpse					= "hun31m_105mm_destroyed",
	buildCostMetal			= 3200,

	transportCapacity		= 4,
	transportMass			= 200,

	collisionVolumeType		= "box",
	collisionVolumeScales	= {10.0, 7.0, 4.0},
	collisionVolumeOffsets	= {0.0, 4.0, 3.0},

	weapons = {
		[1] = { -- HE
			name				= "m31_105mmHE",
		},
		[2] = { -- Smoke
			name				= "m31_105mmSmoke",
		},
	},
	customParams = {
	},
}

local HUN_31M_105mm_Stationary = HGun:New{
	name					= "Deployed 105mm 31M Tábori Ágyú",
	corpse					= "hun31m_105mm_destroyed",

	weapons = {
		[1] = { -- HE
			name				= "m31_105mmHE",
		},
		[2] = { -- Smoke
			name				= "m31_105mmSmoke",
		},
	},
	customParams = {

	},
}

return lowerkeys({
	["HUN31M_105mm"] = HUN_31M_105mm,
	["HUN31M_105mm_Stationary"] = HUN_31M_105mm_Stationary,
})
