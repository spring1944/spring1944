local ITA_Cannone_105_32_Truck = LongRangeGunTractor:New{
	name					= "Towed Cannone da 105/32",
	corpse					= "itapavesi_dead",
	buildCostMetal			= 3000,	-- this is the weakest long-ranged gun
	trackOffset				= 10,
	trackWidth				= 15,
	customParams = {
		normaltex			= "",
	},
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
	customParams = {
		normaltex			= "",
	},
}

return lowerkeys({
	["ITACannone105_32_Truck"] = ITA_Cannone_105_32_Truck,
	["ITACannone105_32_Stationary"] = ITA_Cannone_105_32_Stationary,
})
