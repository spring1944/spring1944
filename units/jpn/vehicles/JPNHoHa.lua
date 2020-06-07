local JPNHoHa = HalfTrack:New{
	name					= "Type 1 Ho-Ha",
	buildCostMetal			= 700,
	maxDamage				= 900,
	trackOffset				= 10,
	trackWidth				= 15,
	
	customParams = {
		armour = {
			base = {
				front = {
					thickness		= 12,
					slope			= 39,
				},
				rear = {
					thickness		= 8,
				},
				side = {
					thickness 		= 10,
					slope			= 31,
				},
				top = {
					thickness		= 0,
				},
			},
		},
		maxvelocitykmh			= 50,
		exhaust_fx_name			= "diesel_exhaust",

	},
}

return lowerkeys({
	["JPNHoHa"] = JPNHoHa,
})
