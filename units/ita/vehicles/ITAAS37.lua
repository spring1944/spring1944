local ITAAS37 = HalfTrack:New{
	name					= "Carro Protetto A.S. 37",
	description				= "Transport/Supply Armoured Truck",
	acceleration			= 0.047,
	brakeRate				= 0.09,
	buildCostMetal			= 1100,
	maxDamage				= 560,
	movementClass			= "TANK_Car",
	trackOffset				= 10,
	trackWidth				= 15,
	
	customParams = {
		armor_front				= 9,
		armor_rear				= 7,
		armor_side				= 6,
		armor_top				= 0,
		slope_front			= 30,
		slope_rear			= 10,
		slope_side			= 19,
		maxvelocitykmh			= 52,

	},
	
	weapons = {
		[1] = {
			name					= "BredaM38",
			maxAngleDif				= 210,
		},
	},
}

return lowerkeys({
	["ITAAS37"] = ITAAS37,
})
