local ITAM1542 = LightTank:New{
	name				= "Carro Mediuo M15/42",
	buildCostMetal		= 1942,
	maxDamage			= 1550,
	trackOffset			= 5,
	trackWidth			= 18,

	weapons = {
		[1] = {
			name				= "CannoneDa47mml40HEAT",
			mainDir				= [[0 16 1]],
			maxAngleDif			= 210,
		},
		[2] = {
			name				= "CannoneDa47mml40AP",
			mainDir				= [[0 16 1]],
			maxAngleDif			= 210,
		},
		[3] = {
			name				= "CannoneDa47mml40HE",
			mainDir				= [[0 16 1]],
			maxAngleDif			= 210,
		},
		[4] = { -- coax MG
			name				= "BredaM38",
			maxAngleDif			= 210,
		},
		[5] = { -- hull MG 1
			name				= "BredaM38",
		},
		[6] = { -- hull MG 2
			name				= "BredaM38",
			slaveTo				= 4,
		},
		[7] = {
			name				= ".50calproof",
		},
	},
	customParams = {
		armour = {
			base = {
				front = {
					thickness		= 50,
					slope			= 12,
				},
				rear = {
					thickness		= 25,
					slope			= -15,
				},
				side = {
					thickness 		= 25,
					slope			= 7,
				},
				top = {
					thickness		= 25, -- all but engine deck
				},
			},
			turret = {
				front = {
					thickness		= 45,
					slope			= 13,
				},
				rear = {
					thickness		= 25,
					slope			= 21,
				},
				side = {
					thickness 		= 25,
					slope			= 20,
				},
				top = {
					thickness		= 15,
				},
			},
		},
		maxammo				= 25,
		maxvelocitykmh		= 40,
		turretturnspeed		= 18,
		weapontoggle		= "priorityAPHEATHE",
		piecehitvols		= {
			base = {
				scale = {1, 0.27, 1},
				offset = {0, -12, 0},
			},
		},
		normaltex			= "unittextures/ITAM1542_normals.png",
	},
}

return lowerkeys({
	["ITAM1542"] = ITAM1542,
})
