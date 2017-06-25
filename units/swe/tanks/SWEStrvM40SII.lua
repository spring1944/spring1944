local SWEStrvM40SII = LightTank:New{
	name				= "Stridsvagn m/40",
	buildCostMetal		= 1500,
	maxDamage			= 750,
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
		armor_front			= 54, -- 13+35~63d,  13 + 30mm @ 32d gives 81!
		armor_rear			= 18,
		armor_side			= 18,
		armor_top			= 5,
		maxammo				= 18,
		maxvelocitykmh		= 48,
		normaltex			= "",
	},
}

return lowerkeys({
	["SWEStrvM40SII"] = SWEStrvM40SII,
})
