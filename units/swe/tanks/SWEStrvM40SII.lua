local SWEStrvM40SII = LightTank:New{
	name				= "Stridsvagn m/40K",
	buildCostMetal		= 1500,
	maxDamage			= 1090,
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
		[3] = { -- coax 1
			name				= "ksp_m1939",
		},
		[4] = { -- coax 2
			name				= "ksp_m1939",
		},
		[5] = {
			name				= ".50calproof",
		},
	},
	customParams = {		
		armour = {
			base = {
				front = {
					thickness		= 43,
					slope			= 58,
				},
				rear = {
					thickness		= 13,
					slope			= -35,
				},
				side = {
					thickness 		= 13,
					slope			= 16,
				},
				top = {
					thickness		= 5,
				},
			},
			turret = {
				front = {
					thickness		= 35,
					slope			= 15,
				},
				rear = {
					thickness		= 13,
					slope			= -21,
				},
				side = {
					thickness 		= 13,
					slope			= 15,
				},
				top = {
					thickness		= 5,
				},
			},
		},
		maxammo				= 18,
		maxvelocitykmh		= 46,
		normaltex			= "unittextures/SWEStrvM40SII_normals.png",
	},
}

return lowerkeys({
	["SWEStrvM40SII"] = SWEStrvM40SII,
})
