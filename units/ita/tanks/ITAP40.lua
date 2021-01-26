local ITAP40 = MediumTank:New{
	name				= "Carro Pesante P26/40",
	buildCostMetal		= 2470,
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
		armour = {
			base = {
				front = {
					thickness		= 50,
					slope			= 45,
				},
				rear = {
					thickness		= 40,
					slope			= -40,
				},
				side = {
					thickness 		= 45,
					slope			= 35,
				},
				top = {
					thickness		= 15, -- engine deck
				},
			},
			turret = {
				front = {
					thickness		= 50,
					slope			= 20,
				},
				rear = {
					thickness		= 45,
					slope			= 20,
				},
				side = {
					thickness 		= 45,
					slope			= 25,
				},
				top = {
					thickness		= 20,
				},
			},
		},
		maxammo				= 19,
		maxvelocitykmh		= 40,
		turretturnspeed		= 22,
		weapontoggle		= "priorityAPHEATHE",
		normaltex			= "unittextures/ITAP40_normals.png",
	},
}

return lowerkeys({
	["ITAP40"] = ITAP40,
})
