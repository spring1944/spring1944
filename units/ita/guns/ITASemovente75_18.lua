local ITASemovente75_18 = MediumTank:New(AssaultGun):New{
	name				= "Semovente da 75/18",
	buildCostMetal		= 2050,
	maxDamage			= 1470,
	trackOffset			= 5,
	trackWidth			= 15,

	weapons = {
		[1] = {
			name				= "ansaldo75mml18heat",
			maxAngleDif			= 40, -- Mwuhahaha
		},
		[2] = {
			name				= "ansaldo75mml18he",
			maxAngleDif			= 40,
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
					slope			= 12,
				},
				rear = {
					thickness		= 27,
					slope			= -20,
				},
				side = {
					thickness 		= 25,
				},
				top = {
					thickness		= 10, -- engine deck
				},
			},
			super = {
				front = {
					thickness		= 50,
					slope			= 5,
				},
				rear = {
					thickness		= 25,
				},
				side = {
					thickness 		= 25,
					slope			= 8,
				},
				top = {
					thickness		= 15,
				},
			},
		},
		maxammo				= 14,
		maxvelocitykmh		= 40,
		exhaust_fx_name			= "diesel_exhaust",
		weapontoggle		= "priorityHEATHE",
	},
}

return lowerkeys({
	["ITASemovente75_18"] = ITASemovente75_18,
})
