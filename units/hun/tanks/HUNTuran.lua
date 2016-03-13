local HUN40MTuran = MediumTank:New{
	name				= "40.M Turan",
	buildCostMetal		= 2000,
	corpse				= "HUN40MTuran_Abandoned",
	maxDamage			= 1820,
	trackOffset			= 5,
	trackWidth			= 18,

	weapons = {
		[1] = {
			name				= "Mavag_37_42MAP",
			mainDir				= [[0 16 1]],
			maxAngleDif			= 210,
		},
		[2] = {
			name				= "Mavag_37_42MHE",
			mainDir				= [[0 16 1]],
			maxAngleDif			= 210,
		},
		[3] = { -- coax 1
			name				= "gebauer_1934_37m",
		},
		[4] = { -- bow mg
			name				= "gebauer_1934_37m",
			maxAngleDif			= 30,
		},
		[5] = {
			name				= ".50calproof",
		},
	},

	customParams = {
		armor_front			= 55,
		armor_rear			= 25,
		armor_side			= 25,
		armor_top			= 15,
		maxammo				= 18,
		maxvelocitykmh		= 47,
	},
}

return lowerkeys({
	["HUN40MTuran"] = HUN40MTuran,
})
