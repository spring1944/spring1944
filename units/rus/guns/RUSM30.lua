local RUS_M30_Truck = HGunTractor:New{
	name					= "Towed 122mm M-30",
	buildCostMetal			= 2000,
	corpse					= "RUSYa12_abandoned", -- TODO: grumble
	trackOffset				= 10,
	trackWidth				= 13,
	customParams = {
		normaltex			= "unittextures/RUSM30_Truck_normals.png",
	},
}


local RUS_M30 = HInfGun:New{
	name					= "Canon de 105 court modèle 1935 B",
	corpse					= "RUSM30_Destroyed",
	buildCostMetal			= 2000,

	collisionVolumeType		= "box",
	collisionVolumeScales	= {9.0, 9.0, 5.0},
	collisionVolumeOffsets	= {-4.0, 9.0, 0.0},

	weapons = {
		[1] = { -- HE
			name				= "m30122mmHE",
		},
		[2] = { -- Smoke
			name				= "m30122mmSmoke",
		},
	},
	customParams = {
		normaltex			= "unittextures/RUSM30_normals.png",
	},
}

local RUS_M30_Stationary = HGun:New{
	name					= "Deployed 122mm M-30",
	corpse					= "RUSM30_Destroyed",
	weapons = {
		[1] = { -- HE
			name				= "m30122mmHE",
		},
		[2] = { -- Smoke
			name				= "m30122mmSmoke",
		},
	},
	customParams = {
		normaltex			= "unittextures/RUSM30_normals.png",
	},
}

return lowerkeys({
	["RUSM30_Truck"] = RUS_M30_Truck,
	["RUSM30"] = RUS_M30,
	["RUSM30_Stationary"] = RUS_M30_Stationary,
})
