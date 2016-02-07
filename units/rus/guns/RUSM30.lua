Unit('RUS_M30_Truck'):Extends('HGunTractor'):Attrs{
	name					= "Towed 122mm M-30",
	buildCostMetal			= 2000,
	corpse					= "RUSYa12_abandoned", -- TODO: grumble
	trackOffset				= 10,
	trackWidth				= 13,
}

Unit('RUS_M30_Stationary'):Extends('HGun'):Attrs{
	name					= "Deployed 122mm M-30",
	corpse					= "RUSM30_Destroyed",
	weapons = {
		[1] = { -- HE
			name				= "m30122mmHE",
		},
		[2] = { -- Smoke
			name				= "m30122mmSmoke",
		},
	},
}

