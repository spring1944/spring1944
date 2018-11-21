local JPN_Type98_20mm_Truck = AAGunTractor:New{
	name					= "Towed Type 98 20mm Gun",
	buildCostMetal			= 1125,
	corpse					= "JPNIsuzuTX40_Abandoned", -- TODO: grumble
	trackOffset				= 10,
	trackWidth				= 13,
	customParams = {

	},
}

local JPN_Type98_20mm_Stationary = AAGun:New{
	name					= "Deployed Type 98 20mm Gun",
	corpse					= "JPNType98_20mm_Destroyed",

	weapons = {
		[1] = { -- AA
			name				= "Type9820mmAA",
		},
		[2] = { -- HE
			name				= "Type9820mmHE",
		},
	},
	customParams = {

	},
}

return lowerkeys({
	["JPNType98_20mm_Truck"] = JPN_Type98_20mm_Truck,
	["JPNType98_20mm_Stationary"] = JPN_Type98_20mm_Stationary,
	["JPNType98_20mm_Stationary_base"] = JPN_Type98_20mm_Stationary:Clone("JPNType98_20mm_Stationary"),
})
