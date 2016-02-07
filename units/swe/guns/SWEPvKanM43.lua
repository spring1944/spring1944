Unit('SWE_PvKanM43_Truck'):Extends('ATGunTractor'):Attrs{
	name					= "Towed 5.7cm PvKan m/43",
	buildCostMetal			= 450,
	corpse					= "SWEScaniaVabisF11_Destroyed",
	trackOffset				= 5,
	trackWidth				= 12,
}

Unit('SWE_PvKanM43_Stationary'):Extends('LightATGun'):Attrs{
	name					= "Deployed 5.7cm PvKan m/43",
	corpse					= "ruszis2_destroyed", -- TODO: change

	weapons = {
		[1] = { -- AP
			name				= "zis257mmap", -- TODO: change
		},
	},
}

