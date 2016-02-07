Unit('JPN_Type91_105mm_Truck'):Extends('HGunTractor'):Attrs{
	name					= "Towed Type 91 105mm Howitzer",
	buildCostMetal			= 1850, -- TODO: why?
	corpse					= "JPNShiKe_Abandoned", -- TODO: grumble
	trackOffset				= 10,
	trackWidth				= 13,
}

Unit('JPN_Type91_105mm_Stationary'):Extends('HGun'):Attrs{
	name					= "Deployed Type 91 105mm Howitzer",
	corpse					= "JPNType91_105mm_Destroyed",
	weapons = {
		[1] = { -- HE
			name				= "Type91105mmL24HE",
		},
		[2] = { -- Smoke
			name				= "Type91105mmL24smoke",
		},
	},
}

