Unit('JPN_Type1_47mm_Truck'):Extends('ATGunTractor'):Attrs{
	name					= "Towed Type 1 47mm Gun",
	buildCostMetal			= 400,
	corpse					= "JPNIsuzuTX40_Abandoned", -- TODO: grumble
	trackOffset				= 10,
	trackWidth				= 12,
}

Unit('JPN_Type1_47mm_Stationary'):Extends('LightATGun'):Attrs{
	name					= "Deployed Type 1 47mm Gun",
	corpse					= "JPNType1_47mm_destroyed",
	weapons = {
		[1] = { -- AP
			name				= "Type147mmAP",
		},
	},
}

