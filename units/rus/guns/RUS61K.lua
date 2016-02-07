Unit('RUS_61K_Truck'):Extends('AAGunTractor'):Attrs{
	name					= "Towed 37mm 61-K",
	corpse					= "RUSZiS5_Destroyed",
	trackOffset				= 5,
	trackWidth				= 12,
}

Unit('RUS_61K_Stationary'):Extends('AAGun'):Attrs{
	name					= "Deployed 37mm 61-K",
	corpse					= "RUS61K_Destroyed",

	weapons = {
		[1] = { -- AA
			name				= "M1939_61k37mmaa",
		},
		[2] = { -- HE
			name				= "M1939_61k37mmhe",
		},
	},
}

