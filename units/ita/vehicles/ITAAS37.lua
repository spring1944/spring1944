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
		armour = {
			base = {
				front = {
					thickness		= 9,
					slope			= 30,
				},
				rear = {
					thickness		= 7,
					slope			= 10,
				},
				side = {
					thickness 		= 6,
					slope			= 19,
				},
				top = {
					thickness		= 0,
				},
			},
			turret = {
				front = {
					thickness		= 0,
				},
				rear = {
					thickness		= 0,
				},
				side = {
					thickness		= 0,
				},
				top = {
					thickness		= 0,
				},
			},
		},
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
