Unit('ITA_Breda20_Truck'):Extends('AAGunTractor'):Attrs{
	name					= "Towed Breda 20/65",
	buildCostMetal			= 1250,
	corpse					= "ITAFiat626_Abandoned", -- TODO: grumble
	trackOffset				= 10,
	trackWidth				= 13,
}

Unit('ITA_Breda20_Stationary'):Extends('AAGun'):Attrs{
	name					= "Deployed Breda 20/65",
	corpse					= "ITABreda20_Destroyed",

	weapons = {
		[1] = { -- AA
			name				= "BredaM3520mmAA",
		},
		[2] = { -- HE
			name				= "BredaM3520mmHE",
		},
	},
}

