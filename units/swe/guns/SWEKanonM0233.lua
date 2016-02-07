Unit('SWEKanonM02_33_Truck'):Extends('FGGunTractor'):Attrs{
	name					= "Towed 7,5cm Kanon m/02-33",
	buildCostMetal			= 1250,
	corpse					= "ITATL37_Abandoned", -- TODO: grumble
	trackOffset				= 10,
	trackWidth				= 13,
}

Unit('SWEKanonM02_33_Stationary'):Extends('FGGun'):Attrs{
	name					= "Deployed 7,5cm Kanon m/02-33",
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

