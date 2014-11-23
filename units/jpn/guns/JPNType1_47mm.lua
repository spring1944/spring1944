local JPN_Type1_47mm_Truck = ATGunTractor:New{
	name					= "Towed Type 1 47mm Gun",
	buildCostMetal			= 400,
	corpse					= "JPNIsuzuTX40_Abandoned", -- TODO: grumble
	script					= "gerflak38_truck.cob",
	trackOffset				= 10,
	trackWidth				= 12,
}

return lowerkeys({
	["JPNType1_47mm_Truck"] = JPN_Type1_47mm_Truck,
})
