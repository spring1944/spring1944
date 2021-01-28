local GBR_4_5in_Truck = LongRangeGunTractor:New{
	name					= "Towed BL 4.5 inch Medium Gun",
	corpse					= "gbrmatador_destroyed",
	trackOffset				= 10,
	trackWidth				= 18,
	customParams = {
		normaltex			= "unittextures/GBR45inGun_normals.png",
	},
}

local GBR_4_5in = HInfGun:New{
	name					= "BL 4.5 inch Medium Gun",
	corpse					= "gbr45ingun_destroyed",
	buildCostMetal			= 3200,

	transportCapacity		= 4,
	transportMass			= 200,

	collisionVolumeType		= "box",
	collisionVolumeScales	= {8.0, 12.0, 3.0},
	collisionVolumeOffsets	= {0.0, 5.0, 3.0},

	weapons = {
		[1] = { -- HE
			name				= "BL45inGunHE",
		},
		[2] = { -- Smoke
			name				= "BL45inGunSmoke",
		},
	},
	customParams = {
		normaltex			= "unittextures/GBR45inGun_normals.png",
	},
}

local GBR_4_5in_Stationary = HGun:New{
	name					= "Deployed BL 4.5 inch Medium Gun",
	corpse					= "gbr45ingun_destroyed",

	weapons = {
		[1] = { -- HE
			name				= "BL45inGunHE",
		},
		[2] = { -- Smoke
			name				= "BL45inGunSmoke",
		},
	},
	customParams = {
		normaltex			= "unittextures/GBR45inGun_normals.png",
	},
}

return lowerkeys({
	["GBR45inGun_Truck"] = GBR_4_5in_Truck,
	["GBR45inGun"] = GBR_4_5in,
	["GBR45inGun_Stationary"] = GBR_4_5in_Stationary,
})
