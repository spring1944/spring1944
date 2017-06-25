local GERSdKfz251 = HalfTrack:New{
	name					= "SdKfz 251/1 Halftrack",
	buildCostMetal			= 1100,
	maxDamage				= 850,
	trackOffset				= 10,
	trackWidth				= 15,
	
	weapons = {
		[1] = {
			name					= "MG34",
			maxAngleDif				= 90,
		},
		[2] = {
			name					= "MG34",
			maxAngleDif			= 180,
			mainDir				= [[0 0 -1]],
		},
	},
	
	customParams = {
		armor_front			= 9,
		armor_rear			= 9,
		armor_side			= 10,
		armor_top			= 0,
		maxvelocitykmh		= 52.5,
		normaltex			= "",
	},
	
}

return lowerkeys({
	["GERSdKfz251"] = GERSdKfz251,
})
