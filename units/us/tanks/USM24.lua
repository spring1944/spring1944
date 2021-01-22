local USM24 = LightTank:New{
	name				= "M24 Chaffee",
	buildCostMetal		= 2400,
	maxDamage			= 1200,
	acceleration		= 0.054,
	trackOffset			= 5,
	trackWidth			= 18,
	trackType			= "USStuart",

	weapons = {
		[1] = {
			name				= "M375mmAP",
			mainDir				= [[0 16 1]],
			maxAngleDif			= 210,
		},
		[2] = {
			name				= "M375mmHE",
			mainDir				= [[0 16 1]],
			maxAngleDif			= 210,
		},
		[3] = {
			name				= "M2Browning",
		},
		[4] = {
			name				= "M1919A4Browning",
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
					thickness		= 25,
					slope			= 59,
				},
				rear = {
					thickness		= 19,
					slope			= -40,
				},
				side = {
					thickness 		= 19,
				},
				top = {
					thickness		= 13,
				},
			},
			turret = {
				front = {
					thickness		= 25, -- not mantlet
					slope			= 13,
				},
				rear = {
					thickness		= 25,
					slope			= 2,
				},
				side = {
					thickness 		= 25,
					slope			= 10,
				},
				top = {
					thickness		= 13,
				},
			},
		},

		maxvelocitykmh		= 56,
		maxammo				= 20,
		turretturnspeed		= 30.0, -- 12s for 360

		normaltex			= "unittextures/usm24_normals.png",
	},
}

return lowerkeys({
	["USM24"] = USM24,
})
