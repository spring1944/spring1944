local USLVTA4 = LightTank:New(Amphibian):New{
	name				= "LVT(A)-4",
	description			= "Amphibious Support Tank",
	buildCostMetal		= 1800,
	maxDamage			= 1814,
	trackOffset			= 5,
	trackWidth			= 18,

	weapons = {
		[1] = {
			name				= "M875mmHE",
		},
		[2] = {
			name				= "M2BrowningAA",
		},
		[3] = {
			name				= ".30calproof",
		},
	},
	customParams = {
		armour = {
			base = {
				front = {
					thickness		= 13,
					slope			= 31,
				},
				rear = {
					thickness		= 6,
				},
				side = {
					thickness 		= 6,
				},
				top = {
					thickness		= 6,
				},
			},
			turret = {
				front = {
					thickness		= 38,
					slope			= 19,
				},
				rear = {
					thickness		= 25,
					slope			= 2,
				},
				side = {
					thickness 		= 25,
					slope			= 20,
				},
				top = {
					thickness		= 0,
				},
			},
		},

		maxammo				= 9,
		maxvelocitykmh		= 40,
		flagCapRate			= 0.5,
		flagCapType			= 'buoy',
		normaltex			= "unittextures/USLVTA4_normals.dds",
	},
}

return lowerkeys({
	["USLVTA4"] = USLVTA4,
})
