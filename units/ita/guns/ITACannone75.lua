Unit('ITA_Cannone75_Truck'):Extends('FGGunTractor'):Attrs{
	name					= "Towed Cannone da 75/32",
	buildCostMetal			= 1250,
	corpse					= "ITATL37_Abandoned", -- TODO: grumble
	trackOffset				= 10,
	trackWidth				= 13,
}

Unit('ITA_Cannone75_Stationary'):Extends('FGGun'):Attrs{
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
}

