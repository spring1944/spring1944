Unit('GER_FlaK38_Truck'):Extends('AAGunTractor'):Attrs{
	name					= "Towed 2cm FlaK 38",
	buildCostMetal			= 1250,
	corpse					= "GEROpelBlitz_Destroyed",
	trackOffset				= 10,
	trackWidth				= 13,
}

Unit('GER_FlaK38_Stationary'):Extends('AAGun'):Attrs{
	name					= "Deployed 2cm FlaK 38",
	corpse					= "GERFlaK38_Destroyed",

	weapons = {
		[1] = { -- AA
			name				= "flak3820mmaa",
		},
		[2] = { -- HE
			name				= "flak3820mmhe",
		},
	},
}

