local ITAP40 = MediumTank:New{
	name				= "Carro Pesante P26/40",
	buildCostMetal		= 2500,
	maxDamage			= 2600,
	trackOffset			= 5,
	trackWidth			= 20,

	weapons = {
		[1] = {
			name				= "Ansaldo75mmL18HEAT",
			mainDir				= [[0 16 1]],
			maxAngleDif			= 210,
		},
		[2] = {
			name				= "Ansaldo75mmL34AP",
			mainDir				= [[0 16 1]],
			maxAngleDif			= 210,
		},
		[3] = {
			name				= "Ansaldo75mmL34HE",
			mainDir				= [[0 16 1]],
			maxAngleDif			= 210,
		},
		[4] = {
			name				= "BredaM38",
			maxAngleDif			= 10,
		},
		[5] = {
			name				= ".50calproof",
		},
	},
	customParams = {
		armor_front			= 66,
		armor_rear			= 42,
		armor_side			= 46,
		armor_top			= 20,
		maxammo				= 19,
		maxvelocitykmh		= 40,
		weapontoggle		= "priorityAPHEATHE",
		normaltex			= "",
	},
}

return lowerkeys({
	["ITAP40"] = ITAP40,
})
