local ITA_Cannone75_Truck = FGGunTractor:New{
	name					= "Towed Cannone da 75/32",
	buildCostMetal			= 1250,
	corpse					= "ITATL37_Abandoned", -- TODO: grumble
	trackOffset				= 10,
	trackWidth				= 13,
	customParams = {

	},
}

local ITA_Cannone75_Stationary = FGGun:New{
	name					= "Towed Cannone da 75/32",
	corpse					= "ITACannone75_Destroyed",
	weapons = {
		[1] = { -- HE
			name	= "Ansaldo75mmL34HE",
		},
		[2] = { -- AP
			name	= "Ansaldo75mmL34AP",
		},
	},	
	customParams = {

	},
}

return lowerkeys({
	["ITACannone75_Truck"] = ITA_Cannone75_Truck,
	["ITACannone75_Stationary"] = ITA_Cannone75_Stationary,
})
