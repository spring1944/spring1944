Unit('ITA_Cannone47_Truck'):Extends('ATGunTractor'):Attrs{
	name					= "Towed Cannone da 47/32",
	buildCostMetal			= 400,
	corpse					= "ITAFiat626_Abandoned", -- TODO: grumble
	trackOffset				= 5,
	trackWidth				= 12,
}

Unit('ITA_Cannone47_Stationary'):Extends('LightATGun'):Attrs{
	name					= "Deployed Cannone da 47/32",
	corpse					= "ITACannone47_destroyed",
	weapons = {
		[1] = { -- AP
			name				= "CannoneDa47mml32AP",
		},
	},
}

