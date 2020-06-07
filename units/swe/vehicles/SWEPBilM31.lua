local SWEPBilM31 = ArmouredCarAA:New{
	name				= "PBil m/31 w/ 20mm Bofors m/40",
	buildCostMetal		= 990,
	maxDamage			= 420,
	trackOffset			= 10,
	trackWidth			= 16,

	weapons = {
		[1] = {
			name				= "boforsm40_20mmaa",
		},
		[2] = {
			name				= "boforsm40_20mmhe",
		},

		[3] = {
			name				= "ksp_m1936",
			maxAngleDif			= 30,
		},
		[4] = {
			name				= ".30calproof",
		},
	},
	customParams = {
		armour = {
			base = {
				front = {
					thickness		= 6,
				},
				rear = {
					thickness		= 6,
				},
				side = {
					thickness 		= 6,
				},
				top = {
					thickness		= 0,
				},
			},
			--[[turret = {
				front = {
					thickness		= 6,
					slope			= 30, -- guess
				},
				rear = {
					thickness		= 0,
				},
				side = {
					thickness 		= 0,
				},
				top = {
					thickness		= 0,
				},
			},]]
		},
		maxammo				= 19,
		maxvelocitykmh		= 60,

	}
}

return lowerkeys({
	["SWEPBilM31"] = SWEPBilM31,
})
