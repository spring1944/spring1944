local GERTigerII = HeavyTank:New{
	name				= "PzKpfw VII Koenigstiger Ausf B",
	buildCostMetal		= 15750,
	maxDamage			= 7000,
	trackOffset			= 5,
	trackWidth			= 26,

	weapons = {
		[1] = {
			name				= "KwK88mmL71AP",
			mainDir				= [[0 16 1]],
			maxAngleDif			= 210,
		},
		[2] = {
			name				= "KwK88mmL71HE",
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
					thickness		= 150,
					slope			= 50,
				},
				rear = {
					thickness		= 80,
					slope			= -28,
				},
				side = {
					thickness 		= 80,
					slope			= 27,
				},
				top = {
					thickness		= 40,
				},
			},
			turret = {
				front = {
					thickness		= 185,
					slope			= 9,
				},
				rear = {
					thickness		= 80,
					slope			= 19,
				},
				side = {
					thickness 		= 80,
					slope			= 19,
				},
				top = {
					thickness		= 44,
				},
			},
		},
	

		maxammo				= 16,
		turretturnspeed		= 20, -- 18s for 360
		maxvelocitykmh		= 38,
		normaltex			= "unittextures/GERTigerII_normals.dds",
	},
}

return lowerkeys({
	["GERTigerII"] = GERTigerII,
})
