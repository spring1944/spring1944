local ITAP40 = MediumTank:New{
	name				= "Carro Pesante P26/40",
	acceleration		= 0.054,
	brakeRate			= 0.15,
	buildCostMetal		= 2500,
	maxDamage			= 2600,
	trackOffset			= 5,
	trackWidth			= 20,

	weapons = {
		[1] = {
			name				= "Ansaldo75mmL34AP",
			mainDir				= [[0 16 1]],
			maxAngleDif			= 210,
		},
		[2] = {
			name				= "Ansaldo75mmL34HE",
			mainDir				= [[0 16 1]],
			maxAngleDif			= 210,
		},
		[3] = {
			name				= "BredaM38",
			maxAngleDif			= 10,
		},
		[4] = {
			name				= ".50calproof",
		},
	},
	customParams = {
		armor_front			= 66,
		armor_rear			= 42,
		armor_side			= 46,
		armor_top			= 20,
		maxammo				= 19,
		weaponcost			= 10,
		maxvelocitykmh		= 40,
	},
}

return lowerkeys({
	["ITAP40"] = ITAP40,
})
