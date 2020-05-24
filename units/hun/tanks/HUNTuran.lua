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
		armor_front			= 50,
		armor_rear			= 25,
		armor_side			= 25,
		armor_top			= 13,
		slope_front			= 18,
		slope_side			= 10,
		maxammo				= 18,
		maxvelocitykmh		= 47,

	},
}

local HUN41MTuranII = HUN40MTuran:New{
	name				= "41.M Turan II",
	corpse				= "HUN41MTuranII_Abandoned",
	buildCostMetal		= 2422,
	maxDamage			= 1920,

	weapons = {
		[1] = {
			name				= "Mavag_75_41MHEAT",
			mainDir				= [[0 16 1]],
			maxAngleDif			= 210,
		},
		[2] = {
			name				= "Mavag_75_41MAP",
			mainDir				= [[0 16 1]],
			maxAngleDif			= 210,
		},
		[3] = {
			name				= "Mavag_75_41MHE",
			mainDir				= [[0 16 1]],
			maxAngleDif			= 210,
		},
		-- in theory the MG was changed to 1934/40.M, in practice I don't know if it was any different
		[4] = { -- coax 1
			name				= "gebauer_1934_37m",
		},
		[5] = { -- bow mg
			name				= "gebauer_1934_37m",
			maxAngleDif			= 30,
		},
		[6] = {
			name				= ".50calproof",
		},	
	},
	
	customParams = {
		armor_side			= 33, --+ 8mm skirts
		maxammo				= 18,
		maxvelocitykmh		= 47,
		weapontoggle		= "priorityAPHEATHE",
	},
}

local HUN43MTuranIII = HUN41MTuranII:New{
	name				= "43.M Turan III",
	corpse				= "HUN43MTuranIII_Abandoned",
	buildCostMetal		= 3330,
	maxDamage			= 1900,

	weapons = {
		[1] = {
			name				= "Mavag_75_43MAP",
			mainDir				= [[0 16 1]],
			maxAngleDif			= 210,
		},
		[2] = {
			name				= "Mavag_75_43MHE",
			mainDir				= [[0 16 1]],
			maxAngleDif			= 210,
		},
		-- in theory the MG was changed to 1934/40.M, in practice I don't know if it was any different
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
		armor_front			= 75,
		armor_rear			= 35,
		armor_side			= 35,
		maxammo				= 18,
		maxvelocitykmh		= 47,
		weapontoggle		= "priorityAPHE",
	},
}

return lowerkeys({
	["HUN40MTuran"] = HUN40MTuran,
	["HUN41MTuranII"] = HUN41MTuranII,
	["HUN43MTuranIII"] = HUN43MTuranIII,
})
