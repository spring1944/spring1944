local HUN43MZrynyiII = MediumTank:New(AssaultGun):New{
	name				= "43.M Zrynyi II",
	buildCostMetal		= 3150,
	corpse				= "HUN43MZrynyiII_Abandoned",
	maxDamage			= 2160,
	trackOffset			= 5,
	trackWidth			= 18,

	weapons = {
		[1] = {
			name				= "Mavag_105_4043MHEAT",
			mainDir				= [[0 0 1]],
			maxAngleDif			= 25,
		},
		[2] = {
			name				= "Mavag_105_4043MHE",
			mainDir				= [[0 0 1]],
			maxAngleDif			= 25,
		},
		[3] = {
			name				= ".50calproof",
		},
	},

	customParams = {
		armour = {
			base = {
				front = {
					thickness		= 50, -- LFP
					slope			= -30,
				},
				rear = {
					thickness		= 25,
				},
				side = {
					thickness 		= 30, --+5mm skirt
				},
				top = {
					thickness		= 13,
				},
			},
			super = {
				front = {
					thickness		= 75,
					slope			= 18,
				},
				rear = {
					thickness		= 13,
					slope			= 50,
				},
				side = {
					thickness 		= 30, -- +5mm skirt
					slope			= 10,
				},
				top = {
					thickness		= 13,
				},
			},
		},
		maxammo				= 18,
		maxvelocitykmh		= 43,
		weapontoggle		= "priorityHEATHE",
		normaltex			= "unittextures/HUN43MZrynyiII_normals.png",
	},
}

return lowerkeys({
	["HUN43MZrynyiII"] = HUN43MZrynyiII,
})
