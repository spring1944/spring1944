Unit('SWE_BoforsM36_Truck'):Extends('AAGunTractor'):Attrs{
	name					= "Towed 4cm LvAkan m/36",
	corpse					= "USGMCTruck_Destroyed",
	trackOffset				= 5,
	trackWidth				= 12,
}

Unit('SWE_BoforsM36_Stationary'):Extends('AAGun'):Attrs{
	name					= "Deployed 4cm LvAkan m/36",
	corpse					= "SWEBoforsM36_Destroyed",

	weapons = {
		[1] = { -- AA
			name				= "bofors40mmaa",
		},
		[2] = { -- HE
			name				= "bofors40mmhe",
		},
	},
}

