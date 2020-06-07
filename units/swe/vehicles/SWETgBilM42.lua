local SWETgBilM42 = HalfTrack:New{
	name					= "Terrängbil m/42 KP",
	description				= "Transport/Supply Armoured Truck",
	buildCostMetal			= 800,
	maxDamage				= 646,
	trackOffset				= 10,
	trackWidth				= 15,
	
	customParams = {
		armour = {
			base = {
				front = {
					thickness		= 20,
					slope			= 25,
				},
				rear = {
					thickness		= 8,
					slope			= 37,
				},
				side = {
					thickness 		= 8,
					slope			= 25,
				},
				top = {
					thickness		= 0,
				},
			},
		},
		maxvelocitykmh			= 70,

	},
}

return lowerkeys({
	["SWETgBilM42"] = SWETgBilM42,
})
