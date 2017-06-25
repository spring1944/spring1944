local GERSdKfz10 = TruckAA:New{
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
		armor_front			= 11,
		armor_rear			= 0,
		armor_side			= 0,
		armor_top			= 0,
		maxammo				= 25,
		maxvelocitykmh		= 75,
		normaltex			= "",
	}
}

return lowerkeys({
	["GERSdKfz10"] = GERSdKfz10,
})
