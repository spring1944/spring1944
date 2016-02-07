Unit('RUS_ZiS3_Truck'):Extends('FGGunTractor'):Attrs{
	name					= "Towed 76mm ZiS-3",
	corpse					= "RUSZiS5_Destroyed",
	trackOffset				= 5,
	trackWidth				= 12,
}

Unit('RUS_ZiS3_Stationary'):Extends('FGGun'):Attrs{
	name					= "Deployed 76mm ZiS-3",
	corpse					= "RUSZiS-3_Destroyed",
	
	weapons = {
		[1] = { -- HE
			name	= "ZiS376mmHE",
		},
		[2] = { -- AP
			name	= "ZiS376mmAP",
		},
	},	
}

