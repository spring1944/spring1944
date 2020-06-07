local ITASemovente75_46 = MediumTank:New(AssaultGun):New{
	name				= "Semovente da 75/46",
	buildCostMetal		= 4050,
	maxDamage			= 1770,
	trackOffset			= 5,
	trackWidth			= 19,

	weapons = {
		[1] = {
			name				= "Ansaldo75mmL46ap",
			maxAngleDif			= 10,
		},
		[2] = {
			name				= "Ansaldo75mmL46he",
			maxAngleDif			= 10,
		},
		[3] = {
			name				= ".50calproof",
		},
	},
	customParams = {
		armour = {
			base = {
				front = {
					thickness		= 50,
					slope			= 40,
				},
				rear = {
					thickness		= 25,
					slope			= -15,
				},
				side = {
					thickness 		= 40,
				},
				top = {
					thickness		= 15,
				},
			},
			super = {
				front = {
					thickness		= 100,
					slope			= 25,
				},
				rear = {
					thickness		= 45,
				},
				side = {
					thickness 		= 70,
				},
				top = {
					thickness		= 15,
				},
			},
		},
		maxammo				= 11,
		maxvelocitykmh		= 38,

	},
}

return lowerkeys({
	["ITASemovente75_46"] = ITASemovente75_46,
})
