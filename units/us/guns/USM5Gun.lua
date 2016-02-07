Unit('US_M5Gun_Truck'):Extends('ATGunTractor'):Attrs{
	name					= "Towed 3-Inch M5",
	buildCostMetal			= 600,
	corpse					= "USGMCTruck_Destroyed",
	trackOffset				= 10,
	trackWidth				= 15,
}

Unit('US_M5Gun_Stationary'):Extends('ATGun'):Attrs{
	name					= "Deployed 3-Inch M5",
	corpse					= "usm5gun_destroyed",
	weapons = {
		[1] = { -- AP
			name				= "M7ap",
		},
	},
}

