Unit('SWEHaubitsM39_Truck'):Extends('HGunTractor'):Attrs{
	name					= "Towed 10.5cm Haubits m/39",
	--corpse					= "GERSdKfz11_Destroyed",
	trackOffset				= 10,
	trackWidth				= 13,
}

Unit('SWEHaubitsM39_Stationary'):Extends('HGun'):Attrs{
	name					= "Deployed 10.5cm Haubits m/39",
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

