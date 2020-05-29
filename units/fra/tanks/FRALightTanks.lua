local FRAR35 = LightTank:New{
	corpse				= "FRAR35_Burning",
	name				= "Char léger d'accompagnement 1935 R",
	buildCostMetal		= 1600,
	maxDamage			= 1060,
	trackOffset			= 5,
	trackWidth			= 15,

	objectName			= "FRA/FRAR35.s3o",
	
	weapons = {
		[1] = {
			name				= "FRA37mmSA18AP",
			mainDir				= [[0 16 1]],
			maxAngleDif			= 210,
		},
		[2] = {
			name				= "FRA37mmSA18HE",
			mainDir				= [[0 16 1]],
			maxAngleDif			= 210,
		},
		[3] = {
			name				= "MACmle1931",
		},
		[4] = {
			name				= ".50calproof",
		},
	},
	customParams = {
		armour = {
			base = {
				front = {
					thickness		= 32,
					slope			= 23,
				},
				rear = {
					thickness		= 40,
					slope			= 24,
				},
				side = {
					thickness 		= 40,
				},
				top = {
					thickness		= 25,
				},
			},
			turret = {
				front = {
					thickness		= 45,
					slope			= 28,
				},
				rear = {
					thickness		= 40,
					slope			= 29,
				},
				side = {
					thickness 		= 40,
					slope			= 26,
				},
				top = {
					thickness		= 25,
				},
			},
		},
		
		
		maxammo				= 24,
		barrelrecoildist		= 1,
		barrelrecoilspeed		= 10,
		turretturnspeed			= 15,
		elevationspeed			= 20,

		maxvelocitykmh		= 20,
		customanims			= "renault_r",

	},
}

local FRAR39 = FRAR35:New{
	corpse				= "FRAR39_Burning",
	name				= "Char léger d'accompagnement 1939 R",
	buildCostMetal		= 1800,
	objectName			= "FRA/FRAR39.s3o",
	weapons	= {
		[1] = {
			name		= "FRA37mmSA38AP",
		},
		[2] = {
			name		= "FRA37mmSA38HE",
		},		
	},
}

local FRAH35 = FRAR35:New{
	corpse				= "FRAH35_Burning",
	name				= "Char léger d'accompagnement 1935 H",
	buildCostMetal		= 1700,
	objectName			= "FRA/FRAH35.s3o",
	customParams = {
		armour = {
			base = {
				front = {
					thickness		= 34,
					slope			= 31,
				},
				rear = {
					thickness		= 34,
					slope			= 31,
				},
				side = {
					thickness 		= 34,
					slope			= 22,
				},
				top = {
					thickness		= 22,
				},
			},
			turret = {
				front = {
					thickness		= 45,
					slope			= 28,
				},
				rear = {
					thickness		= 40,
					slope			= 30,
				},
				side = {
					thickness 		= 40,
					slope			= 25,
				},
				top = {
					thickness		= 25,
				},
			},
		},

		maxvelocitykmh	= 25,
		customanims	= "hotchkiss_h",
	},
}

local FRAH39 = FRAH35:New{
	corpse				= "FRAH39_Burning",
	name				= "Char léger d'accompagnement 1939 H",
	buildCostMetal		= 1900,
	objectName			= "FRA/FRAH39.s3o",
	weapons	= {
		[1] = {
			name		= "FRA37mmSA38AP",
		},
		[2] = {
			name		= "FRA37mmSA38HE",
		},		
	},
	-- armor upgraded to 40mm
	customParams = {
		armour = {
			base = {
				front = {
					thickness		= 40,
				},
				rear = {
					thickness		= 40,
				},
				side = {
					thickness 		= 40,
				},
			},
		},
	},
}

return lowerkeys({
	["FRAR35"] = FRAR35,
	["FRAR39"] = FRAR39,
	["FRAH35"] = FRAH35,
	["FRAH39"] = FRAH39,
})
