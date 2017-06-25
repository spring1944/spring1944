local JPN_Type1_47mm_Truck = ATGunTractor:New{
	name					= "Towed Type 1 47mm Gun",
	buildCostMetal			= 400,
	corpse					= "JPNIsuzuTX40_Abandoned", -- TODO: grumble
	trackOffset				= 10,
	trackWidth				= 12,
	customParams = {
		normaltex			= "",
	},
}

local JPN_Type1_47mm_Stationary = LightATGun:New{
	name					= "Deployed Type 1 47mm Gun",
	corpse					= "JPNType1_47mm_destroyed",
	minCloakDistance = 160,
	weapons = {
		[1] = { -- AP
			name				= "Type147mmAP_towed",
		},
	},
	customParams = {
		normaltex			= "",
	},
}

return lowerkeys({
	["JPNType1_47mm_Truck"] = JPN_Type1_47mm_Truck,
	["JPNType1_47mm_Stationary"] = JPN_Type1_47mm_Stationary,
})
