local SWEStrvM41 = LightTank:New{
	name				= "Stridsvagn m/41 SII",
	buildCostMetal		= 1440,
	maxDamage			= 1100,
	trackOffset			= 5,
	trackWidth			= 18,

	weapons = {
		[1] = {
			name				= "Bofors_m38AP",
			mainDir				= [[0 16 1]],
			maxAngleDif			= 210,
		},
		[2] = {
			name				= "Bofors_m38HE",
			mainDir				= [[0 16 1]],
			maxAngleDif			= 210,
		},
		[3] = { -- coax
			name				= "ksp_m1939",
		},
		[4] = { -- hull
			name				= "ksp_m1939",
			maxAngleDif			= 50,
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
					slope			= 19,
				},
				rear = {
					thickness		= 15,
					slope			= 15,
				},
				side = {
					thickness 		= 20,
				},
				top = {
					thickness		= 8,
				},
			},
			turret = {
				front = {
					thickness		= 50,
					slope			= 9,
				},
				rear = {
					thickness		= 35,
					slope			= 8,
				},
				side = {
					thickness 		= 20,
					slope			= 9,
				},
				top = {
					thickness		= 8,
				},
			},
		},
		maxammo				= 15,
		maxvelocitykmh		= 42,

	},
}

return lowerkeys({
	["SWEStrvM41"] = SWEStrvM41,
})
