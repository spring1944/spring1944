local ITAAS37 = HalfTrack:New{
	name					= "Carro Protetto A.S. 37",
	description				= "Transport/Supply Armoured Truck",
	buildCostMetal			= 1100,
	acceleration			= 0.039,
	brakeRate				= 0.195,
	maxDamage				= 560,
	trackOffset				= 10,
	trackWidth				= 15,
	turnRate				= 400,
	
	customParams = {
		armor_front				= 10,
		armor_rear				= 7,
		armor_side				= 6,
		armor_top				= 0,
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
