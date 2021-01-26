local ITASemovente105 = MediumTank:New(AssaultGun):New{
	name				= "Semovente da 105/25",
	description			= "Heavy Assault Gun",
	buildCostMetal		= 3450,
	maxDamage			= 1600,
	trackOffset			= 5,
	trackWidth			= 19,

	weapons = {
		[1] = {
			name				= "Ansaldo105mmL25HEAT",
			maxAngleDif			= 15,
		},
		[2] = {
			name				= "Ansaldo105mmL25HE",
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
					thickness		= 75,
					slope			= 5,
				},
				rear = {
					thickness		= 45,
				},
				side = {
					thickness 		= 45,
					slope 			= 7,
				},
				top = {
					thickness		= 15,
				},
			},
		},
		maxammo				= 11,
		maxvelocitykmh		= 35,
		weapontoggle		= "priorityHEATHE",
		normaltex			= "unittextures/ITASemovente105_normals.png",
	},
}

return lowerkeys({
	["ITASemovente105"] = ITASemovente105,
})
