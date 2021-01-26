local SWEStrvM37 = Tankette:New{
	name				= "Stridsvagn m/37",
	buildCostMetal		= 700,
	maxDamage			= 450,
	trackOffset			= 5,
	trackWidth			= 18,

	weapons = {
		[1] = {
			name				= "ksp_m1936",
			mainDir				= [[0 16 1]],
			maxAngleDif			= 210,
		},
		[2] = {
			name				= "ksp_m1936",
			mainDir				= [[0 16 1]],
			maxAngleDif			= 210,
			slaveTo				= 1,
		},
		[3] = {
			name				= ".30calproof",
		},
	},
	customParams = {
		armour = {
			base = {
				front = {
					thickness		= 15,
					slope			= 15,
				},
				rear = {
					thickness		= 10,
					slope			= 16,
				},
				side = {
					thickness 		= 10,
					slope			= 17,
				},
				top = {
					thickness		= 6,
				},
			},
			turret = {
				front = {
					thickness		= 12,
					slope			= 8,
				},
				rear = {
					thickness		= 12,
					slope			= 8,
				},
				side = {
					thickness 		= 12,
					slope			= 8,
				},
				top = {
					thickness		= 6,
				},
			},
		},
		maxvelocitykmh		= 60,
		normaltex			= "unittextures/SWEStrvM37_normals.png",
	},
}

return lowerkeys({
	["SWEStrvM37"] = SWEStrvM37,
})
