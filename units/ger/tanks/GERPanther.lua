local GERPanther = HeavyTank:New{
	name				= "PzKpfw V Panther Ausf G",
	buildCostMetal		= 5400,
	acceleration		= 0.05,
	maxDamage			= 4547,
	trackOffset			= 5,
	trackWidth			= 19,

	weapons = {
		[1] = {
			name				= "KwK75mmL71AP",
			mainDir				= [[0 16 1]],
			maxAngleDif			= 210,
		},
		[2] = {
			name				= "KwK75mmL71HE",
			mainDir				= [[0 16 1]],
			maxAngleDif			= 210,
		},
		[3] = {
			name				= "MG34",
		},
		[4] = {
			name				= "MG34",
			mainDir				= [[0 0 1]],
			maxAngleDif			= 30,
		},
		[5] = {
			name				= ".50calproof",
		},
	},
	customParams = {
		armour = {
			base = {
				front = {
					thickness		= 80,
					slope			= 56,
				},
				rear = {
					thickness		= 40,
					slope			= -31,
				},
				side = {
					thickness 		= 50,
					slope			= 30,
				},
				top = {
					thickness		= 17,
				},
			},
			turret = {
				front = {
					thickness		= 110,
					slope			= 12,
				},
				rear = {
					thickness		= 45,
					slope			= 25,
				},
				side = {
					thickness 		= 45,
					slope			= 25,
				},
				top = {
					thickness		= 15,
				},
			},
		},
		maxammo				= 15,
		turretturnspeed		= 20, -- 18s for 360
		maxvelocitykmh		= 46,
		piecehitvols		= {
			base = {
				scale = {1, 0.8, 1},
				offset = {0, -0.1, 0},
			},
		},
		normaltex			= "unittextures/GERPanther_normals.png",
	},
}

return lowerkeys({
	["GERPanther"] = GERPanther,
})
