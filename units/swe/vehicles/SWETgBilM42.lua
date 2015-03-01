local SWETgBilM42 = HalfTrack:New{
	name					= "Terrängbil m/42 KP",
	description				= "Transport/Supply Armoured Truck",
	buildCostMetal			= 1100,
	acceleration			= 0.039,
	brakeRate				= 0.195,
	maxDamage				= 646,
	maxReverseVelocity		= 2.59,
	maxVelocity				= 5.18,
	trackOffset				= 10,
	trackWidth				= 15,
	turnRate				= 400,
	
	customParams = {
		armor_front				= 20,
		armor_rear				= 8,
		armor_side				= 8,
		armor_top				= 0,
	},
}

return lowerkeys({
	["SWETgBilM42"] = SWETgBilM42,
})
