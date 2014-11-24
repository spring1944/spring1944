local ITA_Obice100_Truck = HGunTractor:New{
	name					= "Towed Obice da 100/22",
	corpse					= "ITATL37_Abandoned", -- TODO: grumble
	script					= "ruszis3_truck.cob",
	trackOffset				= 10,
	trackWidth				= 13,
}

local ITA_Obice100_Stationary = HGun:New{
	name					= "Deployed Obice da 100/22",
	corpse					= "ITAObice100_Destroyed",
	customParams = {
		weaponcost	= 25,
	},
	weapons = {
		[1] = { -- HE
			name				= "Obice100mml22he",
		},
		[2] = { -- Smoke
			name				= "Obice100mml22smoke",
		},
	},
}

return lowerkeys({
	["ITAObice100_Truck"] = ITA_Obice100_Truck,
	["ITAObice100_Stationary"] = ITA_Obice100_Stationary,
})
