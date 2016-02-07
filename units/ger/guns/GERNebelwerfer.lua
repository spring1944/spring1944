Unit('GER_Nebelwerfer_Truck'):Extends('RGunTractor'):Attrs{
	name					= "Towed 15cm Nebelwerfer 41",
	corpse					= "GEROpelBlitz_Destroyed",
	trackOffset				= 10,
	trackWidth				= 13,
}

Unit('GER_Nebelwerfer_Stationary'):Extends('RGun'):Attrs{
	name					= "Deployed 15cm Nebelwerfer 41",
	corpse					= "gernebelwerfer_destroyed",
	customParams = {
		maxammo		= 1,
	},
	weapons = {
		[1] = {
			name				= "Nebelwerfer41",
		},
	},
}

