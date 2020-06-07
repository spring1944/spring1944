local RUSIS2 = HeavyTank:New{
	name				= "IS-2 M1944",
	buildCostMetal		= 10260,
	maxDamage			= 4600,
	trackOffset			= 5,
	trackWidth			= 22,

	weapons = {
		[1] = {
			name				= "D25122mmAP",
			mainDir				= [[0 16 1]],
			maxAngleDif			= 210,
		},
		[2] = {
			name				= "D25122mmHE",
			mainDir				= [[0 16 1]],
			maxAngleDif			= 210,
		},
		[3] = {
			name				= "DT",
		},
		[4] = {
			name				= "DT",
		},
		[5] = {
			name				= ".50calproof",
		},
	},
	customParams = {
		armour = {
			base = {
				front = {
					thickness		= 120,
					slope			= 61,
				},
				rear = {
					thickness		= 60,
					slope			= 49,
				},
				side = {
					thickness 		= 100,
					slope			= 14,
				},
				top = {
					thickness		= 30,
				},
			},
			turret = {
				front = {
					thickness		= 100,
					slope			= 10,
				},
				rear = {
					thickness		= 100,
					slope			= 31,
				},
				side = {
					thickness 		= 100,
					slope			= 20,
				},
				top = {
					thickness		= 30,
				},
			},
		},
		maxammo				= 5,
		turretturnspeed		= 12, -- 30s for 360
		maxvelocitykmh		= 37,
		killvoicecategory_hardveh	= "RUS/Tank/RUS_TANK_TANKKILL",
		killvoicephasecount		= 3,
		exhaust_fx_name			= "diesel_exhaust",
		normaltex			= "unittextures/RUSIS2_normals.dds",
	},
}

return lowerkeys({
	["RUSIS2"] = RUSIS2,
})
