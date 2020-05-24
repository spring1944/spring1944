local SWEStrvM37 = Tankette:New{
	name				= "Stridsvagn m/37",
	buildCostMetal		= 700,
	maxDamage			= 450,
	trackOffset			= 5,
	trackWidth			= 18,

	weapons = {
		[1] = {
			name				= "ksp_m1936",
			mainDir				= [[0 16 1]],
			maxAngleDif			= 210,
		},
		[2] = {
			name				= "ksp_m1936",
			mainDir				= [[0 16 1]],
			maxAngleDif			= 210,
			slaveTo				= 1,
		},
		[3] = {
			name				= ".30calproof",
		},
	},
	customParams = {
		armor_front			= 16,
		armor_rear			= 10,
		armor_side			= 10,
		armor_top			= 4,
		slope_front			= 68,
		slope_rear			= 15,
		slope_side			= 14,
		maxvelocitykmh		= 60,

	},
}

return lowerkeys({
	["SWEStrvM37"] = SWEStrvM37,
})
