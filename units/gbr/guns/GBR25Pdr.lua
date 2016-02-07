Unit('GBR_25Pdr_Truck'):Extends('HGunTractor'):Attrs{
	name					= "Towed Q.F. 25 Pounder",
	corpse					= "gbrmorrisquad_destroyed",
	trackOffset				= 10,
	trackWidth				= 18,
}

Unit('GBR_25Pdr_Stationary'):Extends('HGun'):Attrs{
	name					= "Deployed Q.F. 25 Pounder",
	corpse					= "gbr25pdr_destroyed",

	weapons = {
		[1] = { -- HE
			name				= "qf25pdrhe",
			maxAngleDif			= 50,
		},
		[2] = { -- Smoke
			name				= "qf25pdrsmoke",
			maxAngleDif			= 50,
		},
	},
}

