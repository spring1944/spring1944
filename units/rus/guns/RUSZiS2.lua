Unit('RUS_ZiS2_Truck'):Extends('ATGunTractor'):Attrs{
	name					= "Towed 57mm ZiS-2",
	buildCostMetal			= 450,
	corpse					= "RUSZiS5_Destroyed",
	trackOffset				= 5,
	trackWidth				= 12,
}

Unit('RUS_ZiS2_Stationary'):Extends('LightATGun'):Attrs{
	name					= "Deployed 57mm ZiS-2",
	corpse					= "ruszis2_destroyed",

	weapons = {
		[1] = { -- AP
			name				= "zis257mmap",
		},
	},
}

