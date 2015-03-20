local GERSdKfz251 = HalfTrack:New{
	name					= "SdKfz 251/1 Halftrack",
	buildCostMetal			= 1100,
	acceleration			= 0.039,
	brakeRate				= 0.195,
	maxDamage				= 850,
	trackOffset				= 10,
	trackWidth				= 15,
	turnRate				= 405,
	
	weapons = {
		[1] = {
			name					= "MG34",
		},
		[2] = {
			name					= "MG42AA",
		},
	},
	
	customParams = {
		armor_front			= 9,
		armor_rear			= 9,
		armor_side			= 10,
		armor_top			= 0,
		maxvelocitykmh		= 52.5,
	},
	
}

return lowerkeys({
	["GERSdKfz251"] = GERSdKfz251,
})
