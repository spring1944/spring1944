local RUST60 = Tankette:New{
	name				= "T-60/M41",
	buildCostMetal		= 1250,
	maxDamage			= 640,
	trackOffset			= 5,
	trackWidth			= 18,

	weapons = {
		[1] = {
			name				= "TNSh20mmAP",
			mainDir				= [[0 16 1]],
			maxAngleDif			= 210,
		},
		[2] = {
			name				= "TNSh20mmHE",
			mainDir				= [[0 16 1]],
			maxAngleDif			= 210,
		},
		[3] = {
			name				= "DT",
		},
		[4] = {
			name				= ".50calproof",
		},
	},
	customParams = {
		armour = {
			base = {
				front = {
					thickness		= 15,
					slope			= 72,
				},
				rear = {
					thickness		= 25,
					slope			= -27,
				},
				side = {
					thickness 		= 15,
				},
				top = {
					thickness		= 13,
				},
			},
			turret = {
				front = {
					thickness		= 25,
					slope			= 25,
				},
				rear = {
					thickness		= 25,
					slope			= 24,
				},
				side = {
					thickness 		= 25,
					slope			= 25,
				},
				top = {
					thickness		= 10,
				},
			},
		},
		maxammo				= 28,
		maxvelocitykmh		= 44,
		killvoicecategory_hardveh	= "RUS/Tank/RUS_TANK_TANKKILL",
		killvoicephasecount		= 3,
		normaltex			= "unittextures/RUST60_normals.dds",
	},
}

return lowerkeys({
	["RUST60"] = RUST60,
})
