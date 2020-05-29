local GERSdKfz10 = ArmouredCarAA:New{
	name				= "SdKfz 10/5",
	buildCostMetal		= 1275,
	maxDamage			= 499,
	trackOffset			= 10,
	trackWidth			= 19,

	weapons = {
		[1] = {
			name				= "flak3820mmaa",
		},
	},
	customParams = {
		armour = {
			base = {
				front = {
					thickness		= 11,
					slope			= 17,
				},
				rear = {
					thickness		= 0,
				},
				side = {
					thickness 		= 0,
				},
				top = {
					thickness		= 0,
				},
			},
			turret = {
				front = {
					thickness		= 7,
					slope			= 28,
				},
				rear = {
					thickness		= 0,
				},
				side = {
					thickness 		= 0,
				},
				top = {
					thickness		= 0,
				},
			},
		},
		armor_front			= 11,
		armor_rear			= 0,
		armor_side			= 0,
		armor_top			= 0,
		maxammo				= 25,
		maxvelocitykmh		= 75,

	}
}

return lowerkeys({
	["GERSdKfz10"] = GERSdKfz10,
})
