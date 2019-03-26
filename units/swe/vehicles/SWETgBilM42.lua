local SWETgBilM42 = HalfTrack:New{
	name					= "Terrängbil m/42 KP",
	description				= "Transport/Supply Armoured Truck",
	buildCostMetal			= 800,
	maxDamage				= 646,
	trackOffset				= 10,
	trackWidth				= 15,
	
	customParams = {
		armor_front				= 20,
		armor_rear				= 8,
		armor_side				= 8,
		armor_top				= 0,
		maxvelocitykmh			= 70,

	},
}

return lowerkeys({
	["SWETgBilM42"] = SWETgBilM42,
})
