local SWEStrvM40SII = LightTank:New{
	name				= "Stridsvagn m/40K",
	buildCostMetal		= 1500,
	maxDamage			= 1090,
	trackOffset			= 5,
	trackWidth			= 18,

	weapons = {
		[1] = {
			name				= "Bofors_m38AP",
			mainDir				= [[0 16 1]],
			maxAngleDif			= 210,
		},
		[2] = {
			name				= "Bofors_m38HE",
			mainDir				= [[0 16 1]],
			maxAngleDif			= 210,
		},
		[3] = { -- coax 1
			name				= "ksp_m1939",
		},
		[4] = { -- coax 2
			name				= "ksp_m1939",
		},
		[5] = {
			name				= ".50calproof",
		},
	},
	customParams = {
		armor_front			= 43,
		armor_rear			= 13,
		armor_side			= 13,
		armor_top			= 5,
		slope_front			= 58,
		slope_rear			= -35,
		slope_side			= 16,
		maxammo				= 18,
		maxvelocitykmh		= 46,

	},
}

return lowerkeys({
	["SWEStrvM40SII"] = SWEStrvM40SII,
})
