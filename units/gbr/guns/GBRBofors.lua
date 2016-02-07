Unit('GBR_Bofors_Truck'):Extends('AAGunTractor'):Attrs{
	name					= "Towed Q.F. 40mm Bofors",
	corpse					= "GBRBedfordTruck_Destroyed",
	trackOffset				= 10,
	trackWidth				= 13,
}

Unit('GBR_Bofors_Stationary'):Extends('AAGun'):Attrs{
	name					= "Deployed Q.F. 40mm Bofors",
	corpse					= "GBRBofors_Destroyed",

	weapons = {
		[1] = { -- AA
			name				= "bofors40mmaa",
		},
		[2] = { -- HE
			name				= "bofors40mmhe",
		},
	},
}

