local ITACannone65 = FGInfGun:New{
	name					= "Cannone da 65/17",
	corpse					= "itacannone65_destroyed",
	buildCostMetal			= 950,

	collisionVolumeType		= "box",
	collisionVolumeScales	= {8.0, 10.0, 6.0},
	collisionVolumeOffsets	= {0.0, 4.0, 3.0},

	weapons = {
		[1] = { -- HE
			name				= "Cannone65L17HE",
		},
		[2] = { -- HEAT
			name				= "Cannone65L17HEAT",
		},
	},
	customParams = {
        weapontoggle           = "priorityHEATHE",
	},
}


return lowerkeys({
	["ITACannone65"] = ITACannone65,
})
