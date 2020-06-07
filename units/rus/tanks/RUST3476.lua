local RUST3476 = MediumTank:New{
	name				= "T-34 Model 1943",
	buildCostMetal		= 2400,
	maxDamage			= 3090,
	trackOffset			= 5,
	trackWidth			= 20,

	weapons = {
		[1] = {
			name				= "F3476mmAP",
			mainDir				= [[0 16 1]],
			maxAngleDif			= 210,
		},
		[2] = {
			name				= "F3476mmHE",
			mainDir				= [[0 16 1]],
			maxAngleDif			= 210,
		},
		[3] = {
			name				= "DT",
		},
		[4] = {
			name				= "DT",
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
					thickness		= 45,
					slope			= 60,
				},
				rear = {
					thickness		= 40,
					slope			= 47,
				},
				side = {
					thickness 		= 40,
					slope			= 40,
				},
				top = {
					thickness		= 16,
				},
			},
			turret = {
				front = {
					thickness		= 53,
					slope			= 30,
				},
				rear = {
					thickness		= 53,
					slope			= 18,
				},
				side = {
					thickness 		= 53,
					slope			= 21,
				},
				top = {
					thickness		= 15,
				},
			},
		},

		maxammo				= 19,
		turretturnspeed		= 26.5, -- 13.6s for 360
		maxvelocitykmh		= 53,
		killvoicecategory_hardveh	= "RUS/Tank/RUS_TANK_TANKKILL",
		killvoicephasecount		= 3,
		exhaust_fx_name			= "diesel_exhaust",
		normaltex			= "unittextures/RUST3476_normals.dds",
	},
}

return lowerkeys({
	["RUST3476"] = RUST3476,
})
