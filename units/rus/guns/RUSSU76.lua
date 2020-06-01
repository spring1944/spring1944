local RUSSU76 = LightTank:New(AssaultGun):New(OpenTopped):New{
	name				= "SU-76",
	buildCostMetal		= 1570,
	maxDamage			= 1120,
	trackOffset			= 3,
	trackWidth			= 19,

	weapons = {
		[1] = {
			name				= "ZiS376mmAP",
			maxAngleDif			= 12,
		},
		[2] = {
			name				= "ZiS376mmHE",
			maxAngleDif			= 12,
		},
		[3] = {
			name				= ".50calproof",
		},
	},
	customParams = {
		armour = {
			base = {
				front = {
					thickness		= 25,
					slope			= 60,
				},
				rear = {
					thickness		= 15,
				},
				side = {
					thickness 		= 15,
				},
				top = {
					thickness		= 7,
				},
			},
			super = {
				front = {
					thickness		= 25,
					slope			= 27,
				},
				rear = {
					thickness		= 0,
				},
				side = {
					thickness 		= 10,
					slope			= 21,
				},
				top = {
					thickness		= 0,
				},
			},
		},

		maxammo				= 11,
		maxvelocitykmh		= 45,
		killvoicecategory_hardveh	= "RUS/Tank/RUS_TANK_TANKKILL",
		killvoicephasecount	= 3,
		normaltex			= "unittextures/RUSSU76_normals.dds",
	},
}

return lowerkeys({
	["RUSSU76"] = RUSSU76,
})
