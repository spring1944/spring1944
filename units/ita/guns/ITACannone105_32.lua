local ITA_Cannone_105_32_Truck = HGunTractor:New{
	name					= "Towed Cannone da 105/32",
	buildCostMetal			= 3200,
	corpse					= "itapavesi_dead",
	trackOffset				= 10,
	trackWidth				= 15,
}

local ITA_Cannone_105_32_Stationary = HGun:New{
	name					= "Deployed Cannone da 105/32",
	corpse					= "ITACannone105_32_Destroyed",
	weapons = {
		[1] = { -- HE
			name				= "Cannone105_32HE",
		},
		[2] = { -- Smoke
			name				= "Cannone105_32Smoke",
		},
	},
}

return lowerkeys({
	["ITACannone105_32_Truck"] = ITA_Cannone_105_32_Truck,
	["ITACannone105_32_Stationary"] = ITA_Cannone_105_32_Stationary,
})
