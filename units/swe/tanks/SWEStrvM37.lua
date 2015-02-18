local SWEStrvM37 = Tankette:New{
	name				= "Stridsvagn m/37",
	acceleration		= 0.044,
	brakeRate			= 0.15,
	buildCostMetal		= 700,
	maxDamage			= 450,
	maxReverseVelocity	= 2.22,
	maxVelocity			= 4.44,
	trackOffset			= 5,
	trackWidth			= 18,

	weapons = {
		[1] = {
			name				= "Vickers", -- TODO: m/36
			mainDir				= [[0 16 1]],
			maxAngleDif			= 210,
		},
		[2] = {
			name				= "Vickers", -- TODO: m/36
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
		weaponswithammo		= 0,
	},
}

return lowerkeys({
	["SWEStrvM37"] = SWEStrvM37,
})
