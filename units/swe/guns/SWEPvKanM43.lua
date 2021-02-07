local SWE_PvKanM43_Truck = ATGunTractor:New{
	name					= "Towed 5.7cm PvKan m/43",
	buildCostMetal			= 450,
	corpse					= "SWEScaniaVabisF11_Destroyed",
	trackOffset				= 5,
	trackWidth				= 12,
	customParams = {
		normaltex			= "unittextures/SWEPvKanM43_truck_normals.png",
	},
}

local SWE_PvKanM43 = ATInfGun:New{
	name					= "5.7cm PvKan m/43",
	corpse					= "ruszis2_destroyed",
	buildCostMetal			= 450,

	collisionVolumeType		= "box",
	collisionVolumeScales	= {12.0, 10.0, 6.0},
	collisionVolumeOffsets	= {0.0, 0.0, 0.0},

	weapons = {
		[1] = { -- AP
			name				= "PvKanM43AP",
		},
	},
	customParams = {
		normaltex			= "unittextures/SWEPvKanM43_stationary_normals.png",
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
		normaltex			= "unittextures/SWEPvKanM43_stationary_normals.png",
	},
}

return lowerkeys({
	["SWEPvKanM43_Truck"] = SWE_PvKanM43_Truck,
	["SWEPvKanM43"] = SWE_PvKanM43,
	["SWEPvKanM43_Stationary"] = SWE_PvKanM43_Stationary,
})
