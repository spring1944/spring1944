local RUSSU100 = MediumTank:New(TankDestroyer):New{
	name				= "SU-100",
	description			= "Heavy Tank Destroyer",
	buildCostMetal		= 6000,
	maxDamage			= 3160,
	trackOffset			= 5,
	trackWidth			= 20,

	weapons = {
		[1] = {
			name				= "D10S100mmAP",
			maxAngleDif			= 25,
		},
		[2] = {
			name				= ".50calproof",
		},
	},
	customParams = {
		armour = {
			base = {
				front = {
					thickness		= 75,
					slope			= 52,
				},
				rear = {
					thickness		= 45,
					slope			= 48,
				},
				side = {
					thickness 		= 45,
				},
				top = {
					thickness		= 20,
				},
			},
			super = {
				front = {
					thickness		= 45,
					slope			= 52,
				},
				rear = {
					thickness		= 45,
					slope			= 12,
				},
				side = {
					thickness 		= 45,
					slope			= 18,
				},
				top = {
					thickness		= 20,
				},
			},
		},
		maxammo				= 7,
		maxvelocitykmh		= 48,
		killvoicecategory_hardveh	= "RUS/Tank/RUS_TANK_TANKKILL",
		killvoicephasecount	= 3,
		exhaust_fx_name			= "diesel_exhaust",
		normaltex			= "unittextures/RUSSU100_normals.dds",
	},
}

return lowerkeys({
	["RUSSU100"] = RUSSU100,
})
