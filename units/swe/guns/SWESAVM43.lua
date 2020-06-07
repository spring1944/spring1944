local SWESAVM43 = LightTank:New(AssaultGun):New{
	name				= "SAV m/43",
	buildCostMetal		= 1570,
	corpse			= "SWESAVM43_Abandoned",
	maxDamage			= 1200,
	turnRate			= 160,
	trackOffset			= 3,
	trackWidth			= 19,

	weapons = {
		[1] = {
			name				= "SWE75mmL30AP",
			maxAngleDif			= 15,
		},
		[2] = {
			name				= "SWE75mmL30HE",
			maxAngleDif			= 15,
		},
		[3] = {
			name				= ".50calproof",
		},
	},
	customParams = {
		armour = {
			base = {
				front = {
					thickness		= 30,
					slope			= 64,
				},
				rear = {
					thickness		= 15,
					slope			= 13,
				},
				side = {
					thickness 		= 15,
				},
				top = {
					thickness		= 10,
				},
			},
			super = {
				front = {
					thickness		= 50,
					slope			= 24,
				},
				rear = {
					thickness		= 13,
					slope			= 13,
				},
				side = {
					thickness 		= 13,
					slope			= 14,
				},
				top = {
					thickness		= 13,
				},
			},
		},
		maxammo				= 11,
		maxvelocitykmh		= 43,

	},
}

return lowerkeys({
	["SWESAVM43"] = SWESAVM43,
})
