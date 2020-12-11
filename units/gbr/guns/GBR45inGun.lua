local GBR_4_5in = HInfGun:New{
	name					= "BL 4.5 inch Medium Gun",
	corpse					= "gbr45ingun_destroyed",
	buildCostMetal			= 3200,

	transportCapacity		= 4,
	transportMass			= 200,

	collisionVolumeType		= "box",
	collisionVolumeScales	= {8.0, 10.0, 3.0},
	collisionVolumeOffsets	= {0.0, 7.0, 3.0},

	weapons = {
		[1] = { -- HE
			name				= "BL45inGunHE",
		},
		[2] = { -- Smoke
			name				= "BL45inGunSmoke",
		},
	},
	customParams = {
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

	},
}

return lowerkeys({
	["GBR45inGun"] = GBR_4_5in,
	["GBR45inGun_Stationary"] = GBR_4_5in_Stationary,
})
