local RUSISU152 = HeavyTank:New(AssaultGun):New{
	name				= "ISU-152",
	description			= "Heavy Assault Gun",
	buildCostMetal		= 5800,
	maxDamage			= 4180,
	trackOffset			= 5,
	trackWidth			= 22,

	weapons = {
		[1] = {
			name				= "ML20S152mmHE",
			maxAngleDif			= 25,
		},
		--[2] = {
			--name				= "ML20S152mmAP",
			--maxAngleDif			= 25,
		--},
		[2] = {
			name				= ".50calproof",
		},
	},
	customParams = {
		armour = {
			base = {
				front = {
					thickness		= 90,
					slope			= -31,
				},
				rear = {
					thickness		= 60,
					slope			= 50,
				},
				side = {
					thickness 		= 90,
				},
				top = {
					thickness		= 30,
				},
			},
			super = {
				front = {
					thickness		= 90,
					slope			= 29,
				},
				rear = {
					thickness		= 60,
					slope			= 1,
				},
				side = {
					thickness 		= 75,
					slope			= 15,
				},
				top = {
					thickness		= 30,
				},
			},
		},

		maxammo				= 4,
		soundcategory		= "RUS/Tank/Zveroboy",
		weapontoggle		= false,
		maxvelocitykmh		= 40,
		killvoicecategory	= "RUS/Tank/Zveroboy/RUS_ISU_KILL",
		killvoicephasecount	= 3,
		exhaust_fx_name			= "diesel_exhaust",
		normaltex			= "unittextures/RUSISU152_normals.dds",
		piecehitvols		= {
			base				= {
									scale = {1, 0.6, 1},
									offset = {0, -0.2, 0},
								},
		},
	},
}

return lowerkeys({
	["RUSISU152"] = RUSISU152,
})
