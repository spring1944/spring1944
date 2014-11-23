local JPN_Type98_20mm_Truck = AAGunTractor:New{
	name					= "Towed Type 98 20mm Gun",
	buildCostMetal			= 1250,
	corpse					= "JPNIsuzuTX40_Abandoned", -- TODO: grumble
	script					= "gerflak38_truck.cob",
	trackOffset				= 10,
	trackWidth				= 13,
}

return lowerkeys({
	["JPNType98_20mm_Truck"] = JPN_Type98_20mm_Truck,
})
