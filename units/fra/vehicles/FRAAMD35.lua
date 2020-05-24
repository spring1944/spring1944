local FRAAMD35 = ArmouredCar:New{
	name				= "Panhard 178",
	buildCostMetal		= 1085,
	maxDamage			= 820,
	trackOffset			= 10,
	trackWidth			= 17,

	objectName			= "FRA/FRAAMD35.s3o",
	
	weapons = {
		[1] = {
			name				= "Canon_25_SA_35_AP",
			mainDir				= [[0 16 1]],
			maxAngleDif			= 210,
		},
		[2] = {
			name				= "Canon_25_SA_35_HE",
			mainDir				= [[0 16 1]],
			maxAngleDif			= 210,
		},
		[3] = {
			name				= "MACmle1931",
			mainDir				= [[0 16 1]],
			maxAngleDif			= 210,
		},
		[4] = {
			name				= ".30calproof",
		},
	},
	customParams = {
		armor_front			= 15,
		armor_rear			= 15,
		armor_side			= 15,
		armor_top			= 7,
		slope_front			= 66,
		slope_rear			= -2,

		barrelrecoildist	= 1,

		customanims			= "amd35",
		
		reversemult			= 0.75,
		maxammo				= 19,
		maxvelocitykmh		= 73,


	}
}

return lowerkeys({
	["FRAAMD35"] = FRAAMD35,
})
