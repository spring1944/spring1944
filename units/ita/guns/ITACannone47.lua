local ITA_Cannone47_Truck = ATGunTractor:New{
	name					= "Towed Cannone da 47/32",
	buildCostMetal			= 400,
	corpse					= "ITAFiat626_Abandoned", -- TODO: grumble
	trackOffset				= 5,
	trackWidth				= 12,
	customParams = {
		normaltex			= "",
	},
}

local ITA_Cannone47_Stationary = LightATGun:New{
	name					= "Deployed Cannone da 47/32",
	corpse					= "ITACannone47_destroyed",
	minCloakDistance = 160,
	cloakTimeout = 64,
	weapons = {
		[1] = { -- AP
			name				= "CannoneDa47mml32AP_towed",
		},
	},
	customParams = {
		normaltex			= "",
	},
}

return lowerkeys({
	["ITACannone47_Truck"] = ITA_Cannone47_Truck,
	["ITACannone47_Stationary"] = ITA_Cannone47_Stationary,
})
