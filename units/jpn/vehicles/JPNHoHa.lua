local JPNHoHa = HalfTrack:New{
	name					= "Type 1 Ho-Ha",
	buildCostMetal			= 700,
	maxDamage				= 900,
	trackOffset				= 10,
	trackWidth				= 15,
	
	customParams = {
		armor_front				= 12,
		armor_rear				= 8,
		armor_side				= 10,
		armor_top				= 0,
		slope_front			= 39,
		slope_side			= 31,

		maxvelocitykmh			= 50,
		exhaust_fx_name			= "diesel_exhaust",

	},
}

return lowerkeys({
	["JPNHoHa"] = JPNHoHa,
})
