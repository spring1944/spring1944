local HUN_PaK40_Truck = ATGunTractor:New{
	name					= "Towed 7.5cm PaK 40",
	corpse					= "HUNHansaLloyd_Burning",
	trackOffset				= 10,
	trackWidth				= 13,
	customParams = {

	},
}

local HUN_PaK40_Stationary = ATGun:New{
	name					= "Deployed 7.5cm PaK 40",
	corpse					= "gerpak40_destroyed",

	weapons = {
		[1] = { -- AP
			name				= "KwK75mmL48AP",
		},
	},
	customParams = {

	},
}
	
return lowerkeys({
	["HUNPaK40_Truck"] = HUN_PaK40_Truck,
	["HUNPaK40_Stationary"] = HUN_PaK40_Stationary,
})
