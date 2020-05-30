local RUST3485 = MediumTank:New{
	name				= "T-34-85",
	buildCostMetal		= 4110,
	maxDamage			= 3200,
	trackOffset			= 5,
	trackWidth			= 20,

	weapons = {
		[1] = {
			name				= "S5385mmAP",
			mainDir				= [[0 16 1]],
			maxAngleDif			= 210,
		},
		[2] = {
			name				= "S5385mmHE",
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
					thickness		= 90,
					slope			= 19,
				},
				rear = {
					thickness		= 52,
					slope			= 10,
				},
				side = {
					thickness 		= 75,
					slope			= 20,
				},
				top = {
					thickness		= 20,
				},
			},
		},

		maxammo				= 11,
		turretturnspeed		= 17, -- 21.1s for 360
		maxvelocitykmh		= 48,
		killvoicecategory_hardveh	= "RUS/Tank/RUS_TANK_TANKKILL",
		killvoicephasecount		= 3,
		exhaust_fx_name			= "diesel_exhaust",
		normaltex			= "unittextures/RUST3485_normals.dds",
	},
}

return lowerkeys({
	["RUST3485"] = RUST3485,
})
