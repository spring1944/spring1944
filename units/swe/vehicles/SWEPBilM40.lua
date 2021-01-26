local SWEPBilM40 = ArmouredCar:New{
	name				= "PBil m/40 Lynx",
	buildCostMetal		= 1280, 
	maxDamage			= 780,
	trackOffset			= 10,
	trackWidth			= 13,

	weapons = {
		[1] = {
			name				= "boforsm40_20mmap",
			mainDir				= [[0 16 1]],
			maxAngleDif			= 210,
		},
		[2] = {
			name				= "boforsm40_20mmhe",
			mainDir				= [[0 16 1]],
			maxAngleDif			= 210,
		},
		[3] = {
			name				= "ksp_m1939",
			mainDir				= [[0 16 1]],
			maxAngleDif			= 210,
		},
		[4] = {
			name				= "ksp_m1939",
			mainDir				= [[0 0 1]],
			maxAngleDif			= 45,
		},
		[5] = {
			name				= "ksp_m1939",
			mainDir				= [[0 0 -1]],
			maxAngleDif			= 45,
		},		
		[6] = {
			name				= ".30calproof",
		},
	},
	customParams = {
		armour = { -- mostly guesses
			base = {
				front = {
					thickness		= 13,
					slope			= 30,
				},
				rear = {
					thickness		= 8,
					slope			= 30,
				},
				side = {
					thickness 		= 10,
					slope			= 30,
				},
				top = {
					thickness		= 6,
				},
			},
			turret = {
				front = {
					thickness		= 13,
					slope			= 12,
				},
				rear = {
					thickness		= 8,
					slope			= -30,
				},
				side = {
					thickness 		= 10,
					slope			= 15,
				},
				top = {
					thickness		= 6,
				},
			},
		},
		maxammo				= 19,
		reversemult			= 0.75,
		maxvelocitykmh		= 73,
		normaltex			= "unittextures/SWEPBilM40_normals.png",
	}
}

return lowerkeys({
	["SWEPBilM40"] = SWEPBilM40,
})
