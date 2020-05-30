local HUN44MTas = HeavyTank:New{
	name				= "44.M Tas",
	corpse				= "HUN44MTas_Abandoned",
	buildCostMetal			= 5000,
	maxDamage			= 3800,
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
			name				= "gebauer_1934_37m",
		},
		[4] = {
			name				= ".50calproof",
		},
	},
	customParams = {
		armour = {
			base = {
				front = {
					thickness		= 75,
					slope			= 60,
				},
				rear = {
					thickness		= 100,
					slope			= -15,
				},
				side = {
					thickness 		= 50,
					slope			= 25,
				},
				top = {
					thickness		= 20,
				},
			},
			turret = {
				front = {
					thickness		= 100, -- guess at bit less than Panther
					slope			= 12,
				},
				rear = {
					thickness		= 50,
					slope			= 20,
				},
				side = {
					thickness 		= 50,
					slope			= 20,
				},
				top = {
					thickness		= 20,
				},
			},
		},

		maxammo				= 15,
		turretturnspeed		= 20, -- 18s for 360
		maxvelocitykmh		= 45,

	},
}

return lowerkeys({
	["HUN44MTas"] = HUN44MTas,
})
