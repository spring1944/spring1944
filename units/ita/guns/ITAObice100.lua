Unit('ITA_Obice100_Truck'):Extends('HGunTractor'):Attrs{
	name					= "Towed Obice da 100/22",
	corpse					= "ITATL37_Abandoned", -- TODO: grumble
	trackOffset				= 10,
	trackWidth				= 13,
}

Unit('ITA_Obice100_Stationary'):Extends('HGun'):Attrs{
	name					= "Deployed Obice da 100/22",
	corpse					= "ITAObice100_Destroyed",
	weapons = {
		[1] = { -- HE
			name				= "Obice100mml22he",
		},
		[2] = { -- Smoke
			name				= "Obice100mml22smoke",
		},
	},
}

