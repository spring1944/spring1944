local SWEStrvM41 = LightTank:New{
	name				= "Stridsvagn m/41 SII",
	buildCostMetal		= 1440,
	maxDamage			= 1100,
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
		[3] = { -- coax
			name				= "ksp_m1939",
		},
		[4] = { -- hull
			name				= "ksp_m1939",
			maxAngleDif			= 50,
		},
		[5] = {
			name				= ".50calproof",
		},
	},
	customParams = {
		armor_front			= 50,
		armor_rear			= 15,
		armor_side			= 20,
		armor_top			= 8,
		slope_front			= 19,
		slope_rear			= 15,
		maxammo				= 15,
		maxvelocitykmh		= 42,

	},
}

return lowerkeys({
	["SWEStrvM41"] = SWEStrvM41,
})
