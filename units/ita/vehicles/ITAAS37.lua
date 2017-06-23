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
		armor_front				= 10,
		armor_rear				= 7,
		armor_side				= 6,
		armor_top				= 0,
		maxvelocitykmh			= 52,
		normaltex			= "",
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
