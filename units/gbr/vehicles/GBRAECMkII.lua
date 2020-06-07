local GBRAECMkII = HeavyArmouredCar:New{
	name				= "AEC Armoured Car Mk.II",
	buildCostMetal		= 1550,
	maxDamage			= 1270,
	trackOffset			= 10,
	trackWidth			= 13,
	turnRate			= 405,

	weapons = {
		[1] = {
			name				= "qf6pdr57mmap",
			mainDir				= [[0 16 1]],
			maxAngleDif			= 210,
		},
		[2] = {
			name				= "qf6pdr57mmhe",
			mainDir				= [[0 16 1]],
			maxAngleDif			= 210,
		},
		[3] = {
			name				= "BESA",
		},
		[4] = {
			name				= ".30calproof",
		},
	},
	customParams = {
		armour = {
			base = {
				front = {
					thickness		= 17,
					slope			= 58,
				},
				rear = {
					thickness		= 14,
					slope			= -10,
				},
				side = {
					thickness 		= 25,
				},
				top = {
					thickness		= 10,
				},
			},
			turret = {
				front = {
					thickness		= 31,
				},
				rear = {
					thickness		= 20,
				},
				side = {
					thickness 		= 25,
				},
				top = {
					thickness		= 17,
				},
			},
		},

		maxammo				= 10,
		turretturnspeed		= 32, -- 11s for 360 (WT says 14.3)
		maxvelocitykmh		= 66,
		normaltex			= "unittextures/GBRAECMkII_normals.dds",
	}
}

return lowerkeys({
	["GBRAECMkII"] = GBRAECMkII,
})
