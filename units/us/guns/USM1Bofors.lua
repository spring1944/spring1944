Unit('US_M1Bofors_Truck'):Extends('AAGunTractor'):Attrs{
	name					= "Towed 40mm M1 Bofors",
	corpse					= "USGMCTruck_Destroyed",
	trackOffset				= 5,
	trackWidth				= 12,
}

Unit('US_M1Bofors_Stationary'):Extends('AAGun'):Attrs{
	name					= "Deployed 40mm M1 Bofors",
	corpse					= "USM1Bofors_Destroyed",

	weapons = {
		[1] = { -- AA
			name				= "bofors40mmaa",
		},
		[2] = { -- HE
			name				= "bofors40mmhe",
		},
	},
}

