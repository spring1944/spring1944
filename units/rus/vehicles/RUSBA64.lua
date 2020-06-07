local RUSBA64 = ArmouredCar:New{
	name				= "BA-64",
	description			= "Light Scout Car",
	buildCostMetal		= 525,
	maxDamage			= 245,
	trackOffset			= 4,
	trackWidth			= 11,
	turnRate			= 425,

	weapons = {
		[1] = {
			name				= "DT",
			mainDir				= [[0 16 1]],
			maxAngleDif			= 220,
		},
	},
	customParams = {
		armour = {
			base = {
				front = {
					thickness		= 15,
					slope			= 40,
				},
				rear = {
					thickness		= 9,
					slope			= 30,
				},
				side = {
					thickness 		= 9,
					slope			= 30,
				},
				top = {
					thickness		= 6,
				},
			},
			turret = {
				front = {
					thickness		= 10,
					slope			= 30,
				},
				rear = {
					thickness		= 10,
					slope			= 30,
				},
				side = {
					thickness 		= 10,
					slope			= 30,
				},
				top = {
					thickness		= 0,
				},
			},
		},
		maxvelocitykmh		= 80,
		normaltex			= "unittextures/RUSBA64_normals.dds",
	}
}

return lowerkeys({
	["RUSBA64"] = RUSBA64,
})
