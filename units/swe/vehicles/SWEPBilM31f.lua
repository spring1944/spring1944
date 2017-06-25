local SWEPBilM31f = ArmouredCar:New{
	name				= "PBil m/31f Command Car",
	buildCostMetal		= 1085, -- from ITA AB41
	maxDamage			= 780,
	trackOffset			= 10,
	trackWidth			= 13,

	weapons = {
		[1] = {
			name				= "ksp_m1936",
			mainDir				= [[0 0 1]],
			maxAngleDif			= 90,
		},
		[2] = {
			name				= ".30calproof",
		},
	},
	customParams = {
		armor_front			= 10,
		armor_rear			= 10,
		armor_side			= 8,
		armor_top			= 3,
		reversemult			= 0.75,
		maxvelocitykmh		= 60,
		normaltex			= "",
	}
}

return lowerkeys({
	["SWEPBilM31f"] = SWEPBilM31f,
})
