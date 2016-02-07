Unit('GER_PaK40_Truck'):Extends('ATGunTractor'):Attrs{
	name					= "Towed 7.5cm PaK 40",
	corpse					= "GERSdKfz11_Destroyed",
	trackOffset				= 10,
	trackWidth				= 13,
}

Unit('GER_PaK40_Stationary'):Extends('ATGun'):Attrs{
	name					= "Deployed 7.5cm PaK 40",
	corpse					= "gerpak40_destroyed",

	weapons = {
		[1] = { -- AP
			name				= "KwK75mmL48AP",
		},
	},
}
	
