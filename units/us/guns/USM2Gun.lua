Unit('US_M2Gun_Truck'):Extends('HGunTractor'):Attrs{
	name					= "Towed 105mm M2",
	corpse					= "USM5Tractor_Destroyed",
	trackOffset				= 10,
	trackWidth				= 15,
}

Unit('US_M2Gun_Stationary'):Extends('HGun'):Attrs{
	name					= "Deployed 105mm M2",
	corpse					= "USM2Gun_Destroyed",

	weapons = {
		[1] = { -- HE
			name				= "M2HE",
			maxAngleDif			= 45,
		},
		[2] = { -- Smoke
			name				= "M2smoke",
			maxAngleDif			= 45,
		},
	},
}

