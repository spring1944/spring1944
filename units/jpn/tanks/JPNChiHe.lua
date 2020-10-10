local JPNChiHe = MediumTank:New{
	name				= "Type 1 Chi-He",
	buildCostMetal		= 1955,
	maxDamage			= 1700,
	maxVelocity			= 2.9,
	trackOffset			= 5,
	trackWidth			= 14,

	weapons = {
		[1] = {
			name				= "Type147mmAP",
			mainDir				= [[0 16 1]],
			maxAngleDif			= 210,
		},
		[2] = {
			name				= "Type147mmHE",
			mainDir				= [[0 16 1]],
			maxAngleDif			= 210,
		},
		[3] = { -- bow MG
			name				= "Type97MG",
            maxAngleDif			= 50,
		},
		[4] = { -- Rear turret MG
                        name                            = "Type97MG",
                        mainDir                         = [[0 16 -1]],
                        maxAngleDif                     = 210,

		},
		[5] = {
			name				= ".50calproof",
		},
	},
	customParams = {
		armour = {
			base = {
				front = {
					thickness		= 50,
					slope			= 16,
				},
				rear = {
					thickness		= 20,
					slope			= -1,
				},
				side = {
					thickness 		= 20,
					slope			= 30,
				},
				top = {
					thickness		= 12,
				},
			},
			turret = {
				front = {
					thickness		= 50,
					slope			= 1,
				},
				rear = {
					thickness		= 25,
					slope			= 1,
				},
				side = {
					thickness 		= 25,
					slope			= 10,
				},
				top = {
					thickness		= 12,
				},
			},
		},
		maxammo				= 20,
		maxvelocitykmh		= 44,
		exhaust_fx_name			= "diesel_exhaust",

	},
}

return lowerkeys({
	["JPNChiHe"] = JPNChiHe,
})
