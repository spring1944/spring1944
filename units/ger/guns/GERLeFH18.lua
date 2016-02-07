Unit('GER_LeFH18_Truck'):Extends('HGunTractor'):Attrs{
	name					= "Towed 10.5cm LeFH 18M",
	corpse					= "GERSdKfz11_Destroyed",
	trackOffset				= 10,
	trackWidth				= 13,
}

Unit('GER_LeFH18_Stationary'):Extends('HGun'):Attrs{
	name					= "Deployed 10.5cm LeFH 18M",
	corpse					= "gerlefh18_destroyed",

	weapons = {
		[1] = { -- HE
			name				= "leFH18HE",
		},
		[2] = { -- Smoke
			name				= "leFH18smoke",
		},
	},
}

