local GER_PaK40_Truck = ATGunTractor:New{
	name					= "Towed 7.5cm PaK 40",
	corpse					= "GERSdKfz11_Destroyed",
	trackOffset				= 10,
	trackWidth				= 13,
	customParams = {

	},
}

local GER_PaK40_Stationary = ATGun:New{
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
	["GERPaK40_Truck"] = GER_PaK40_Truck,
	["GERPaK40_Stationary"] = GER_PaK40_Stationary,
})
