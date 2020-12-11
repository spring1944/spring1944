local SWE_PvKanM43 = ATInfGun:New{
	name					= "5.7cm PvKan m/43",
	corpse					= "ruszis2_destroyed",
	buildCostMetal			= 450,

	collisionVolumeType		= "box",
	collisionVolumeScales	= {12.0, 10.0, 6.0},
	collisionVolumeOffsets	= {0.0, 5.0, 1.5},

	weapons = {
		[1] = { -- AP
			name				= "PvKanM43AP",
		},
	},
	customParams = {

	},
}

local SWE_PvKanM43_Stationary = LightATGun:New{
	name					= "Deployed 5.7cm PvKan m/43",
	corpse					= "ruszis2_destroyed", -- TODO: change

	weapons = {
		[1] = { -- AP
			name				= "PvKanM43AP",
		},
	},
	customParams = {

	},
}

return lowerkeys({
	["SWEPvKanM43"] = SWE_PvKanM43,
	["SWEPvKanM43_Stationary"] = SWE_PvKanM43_Stationary,
})
