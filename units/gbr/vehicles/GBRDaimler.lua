local GBRDaimler = ArmouredCar:New{
	name				= "Daimler Armoured Car Mk.II",
	buildCostMetal		= 1215,
	maxDamage			= 680,
	trackOffset			= 10,
	trackWidth			= 13,

	weapons = {
		[1] = {
			name				= "qf2pdr40mmap",
			mainDir				= [[0 16 1]],
			maxAngleDif			= 210,
		},
		[2] = {
			name				= "qf2pdr40mmhe",
			mainDir				= [[0 16 1]],
			maxAngleDif			= 210,
		},
		[3] = {
			name				= "BESA",
			mainDir				= [[0 16 1]],
			maxAngleDif			= 210,
		},
		[4] = {
			name				= ".30calproof",
		},
	},
	customParams = {
		armour = {
			base = {
				front = {
					thickness		= 14,
					slope			= 39,
				},
				rear = {
					thickness		= 14,
					slope			= -23,
				},
				side = {
					thickness 		= 10,
					slope			= 30,
				},
				top = {
					thickness		= 8,
				},
			},
			turret = {
				front = {
					thickness		= 16,
					slope			= 15,
				},
				rear = {
					thickness		= 10,
				},
				side = {
					thickness 		= 14,
					slope			= 17,
				},
				top = {
					thickness		= 4,
				},
			},
		},
		maxammo				= 13,
		reversemult			= 0.75,
		turretturnspeed		= 20, -- manual, light turret
		maxvelocitykmh		= 80,
		normaltex			= "unittextures/GBRDaimler_normals.dds",
	}
}

return lowerkeys({
	["GBRDaimler"] = GBRDaimler,
})
