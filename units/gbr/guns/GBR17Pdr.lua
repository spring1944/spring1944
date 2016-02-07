Unit('GBR_17Pdr_Truck'):Extends('ATGunTractor'):Attrs{
	name					= "Towed Q.F. 17 Pounder",
	corpse					= "gbrmorrisquad_destroyed",
	trackOffset				= 10,
	trackWidth				= 18,
}

Unit('GBR_17Pdr_Stationary'):Extends('ATGun'):Attrs{
	name					= "Deployed Q.F. 17 Pounder",
	corpse					= "gbr17pdr_destroyed",

	weapons = {
		[1] = { -- AP
			name				= "qf17pdrap",
		},
	},
}

