local ITA_Breda20_Truck = AAGunTractor:New{
	name					= "Towed Breda 20/65",
	buildCostMetal			= 1250,
	corpse					= "ITAFiat626_Abandoned", -- TODO: grumble
	trackOffset				= 10,
	trackWidth				= 13,
}

local ITA_Breda20_Stationary = AAGun:New{
	name					= "Deployed Breda 20/65",
	corpse					= "ITABreda20_Destroyed",

	weapons = {
		[1] = { -- AA
			name				= "BredaM3520mmAA",
		},
		[2] = { -- HE
			name				= "BredaM3520mmHE",
		},
	},
}

return lowerkeys({
	["ITABreda20_Truck"] = ITA_Breda20_Truck,
	["ITABreda20_Stationary"] = ITA_Breda20_Stationary,
})
