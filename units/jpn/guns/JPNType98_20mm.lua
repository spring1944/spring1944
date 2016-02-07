Unit('JPN_Type98_20mm_Truck'):Extends('AAGunTractor'):Attrs{
	name					= "Towed Type 98 20mm Gun",
	buildCostMetal			= 1250,
	corpse					= "JPNIsuzuTX40_Abandoned", -- TODO: grumble
	trackOffset				= 10,
	trackWidth				= 13,
}

Unit('JPN_Type98_20mm_Stationary'):Extends('AAGun'):Attrs{
	name					= "Deployed Type 98 20mm Gun",
	corpse					= "JPNType98_20mm_Destroyed",

	weapons = {
		[1] = { -- AA
			name				= "Type9820mmAA",
		},
		[2] = { -- HE
			name				= "Type9820mmHE",
		},
	},
}

