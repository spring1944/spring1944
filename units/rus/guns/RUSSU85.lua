local RUSSU85 = MediumTank:New(TankDestroyer):New{
	name				= "SU-85",
	buildCostMetal		= 3200,
	maxDamage			= 2960,
	trackOffset			= 5,
	trackWidth			= 20,

	weapons = {
		[1] = {
			name				= "S5385mmAP",
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
					thickness		= 45,
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

		maxammo				= 9,
		maxvelocitykmh		= 55,
		killvoicecategory_hardveh	= "RUS/Tank/RUS_TANK_TANKKILL",
		killvoicephasecount		= 3,
		exhaust_fx_name			= "diesel_exhaust",
		normaltex			= "unittextures/RUSSU85_normals.dds",
	},
}

return lowerkeys({
	["RUSSU85"] = RUSSU85,
})
