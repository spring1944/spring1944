local JPNHoHa = HalfTrack:New{
	name					= "Type 1 Ho-Ha",
	buildCostMetal			= 1100,
	maxDamage				= 900,
	trackOffset				= 10,
	trackWidth				= 15,
	
	customParams = {
		armor_front				= 12,
		armor_rear				= 8,
		armor_side				= 10,
		armor_top				= 0,
		maxvelocitykmh			= 50,
		exhaust_fx_name			= "diesel_exhaust",
		normaltex			= "",
	},
}

return lowerkeys({
	["JPNHoHa"] = JPNHoHa,
})
