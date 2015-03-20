local JPNHoHa = HalfTrack:New{
	name					= "Type 1 Ho-Ha",
	buildCostMetal			= 1100,
	acceleration			= 0.051,
	brakeRate				= 0.195,
	maxDamage				= 900,
	trackOffset				= 10,
	trackWidth				= 15,
	turnRate				= 400,
	
	customParams = {
		armor_front				= 12,
		armor_rear				= 8,
		armor_side				= 10,
		armor_top				= 0,
		maxvelocitykmh			= 50,
	},
}

return lowerkeys({
	["JPNHoHa"] = JPNHoHa,
})
