local JPN_Type90_75mm_Truck = FGGunTractor:New{
	name					= "Towed Type 90 75mm Gun",
	buildCostMetal			= 1250,
	corpse					= "JPNShiKe_Abandoned", -- TODO: grumble
	trackOffset				= 10,
	trackWidth				= 13,
	customParams = {
		normaltex			= "",
	},
}

local JPN_Type90_75mm_Stationary = FGGun:New{
	name					= "Towed Type 90 75mm Gun",
	corpse					= "JPNType90_75mm_Destroyed",

	weapons = {
		[1] = { -- HE
			name	= "Type9075mmHE",
		},
		[2] = { -- AP
			name	= "Type9075mmAP",
		},
	},	
	customParams = {
		normaltex			= "",
	},
}


return lowerkeys({
	["JPNType90_75mm_Truck"] = JPN_Type90_75mm_Truck,
	["JPNType90_75mm_Stationary"] = JPN_Type90_75mm_Stationary,
})
