local RUST28 = MediumTank:New{
	name				= "T-28",
	buildCostMetal		= 2200,
	maxDamage			= 2540,
	trackOffset			= 5,
	trackWidth			= 24,

	weapons = {
		[1] = {
			name				= "KT28_76mmAP",
			mainDir				= [[0 16 1]],
			maxAngleDif			= 210,
		},
		[2] = {
			name				= "KT28_76mmHE",
			mainDir				= [[0 16 1]],
			maxAngleDif			= 210,
		},
		[3] = {
			name				= "DT",
		},
		[4] = {
			name				= "DT",
            mainDir				= [[0 0 -1]],
            maxAngleDif			= 210,
		},
		[5] = {
			name				= "DT",
			mainDir				= [[1 0 1]],
			maxAngleDif			= 170, -- 165 according to tech docs
		},
		[6] = {
			name				= "DT",
			mainDir				= [[-1 0 1]],
			maxAngleDif			= 170, -- 165 according to tech docs
		},
		[7] = {
			name				= ".50calproof",
		},
	},
	customParams = {
		armour = {
			base = {
				front = {
					thickness		= 30,
					slope			= 23,
				},
				rear = {
					thickness		= 20,
					slope			= 6,
				},
				side = {
					thickness 		= 20,
				},
				top = {
					thickness		= 15,
				},
			},
			turret = {
				front = {
					thickness		= 20,
				},
				rear = {
					thickness		= 20,
				},
				side = {
					thickness 		= 20,
				},
				top = {
					thickness		= 15,
				},
			},
		},
		maxammo				= 19,
		turretturnspeed		= 26.5, -- 13.6s for 360
		maxvelocitykmh		= 42,
		killvoicecategory_hardveh	= "RUS/Tank/RUS_TANK_TANKKILL",
		killvoicephasecount		= 3,
		customanims			= "t_28",
	},
}

local RUST28E = RUST28:New{
	name				= "T-28e",
	buildCostMetal		= 2400,
	maxDamage			= 3200,
	weapons = {
		[1] = {
			name				= "L10_76mmAP",
		},
		[2] = {
			name				= "L10_76mmHE",
		},
	},
	customParams = {
		armour = {
			base = {
				front = {
					thickness		= 50,
					slope			= 20,
				},
				rear = {
					thickness		= 50,
				},
				side = {
					thickness 		= 50,
				},
			},
			turret = {
				front = {
					thickness		= 50,
				},
				rear = {
					thickness		= 50,
				},
				side = {
					thickness 		= 50,
				},
			},
		},
		maxvelocitykmh = 36,
	},
}

return lowerkeys({
	["RUST28"] = RUST28,
	["RUST28E"] = RUST28E,
})
