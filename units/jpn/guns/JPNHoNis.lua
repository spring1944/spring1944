local HoNiBase = LightTank:New(AssaultGun):New{
	trackOffset			= 5,
	trackWidth			= 14,
	
	customParams = {
		armour = {
			base = {
				front = {
					thickness		= 25,
					slope			= -37,
				},
				rear = {
					thickness		= 20,
					slope			= 25,
				},
				side = {
					thickness 		= 25,
					slope			= 40,
				},
				top = {
					thickness		= 12,
				},
			},
			super = {
				front = {
					thickness		= 25,
					slope			= 15,
				},
				rear = {
					thickness		= 0,
				},
				side = {
					thickness 		= 25,
				},
				top = {
					thickness		= 0,
				},
			},
		},
		maxammo				= 14,
		maxvelocitykmh		= 38,
		exhaust_fx_name			= "diesel_exhaust",
	},
	
}

local JPNHoNiI = HoNiBase:New(OpenTopped):New{
	name				= "Type 1 Ho-Ni I",
	buildCostMetal		= 2050,
	maxDamage			= 1542,

	weapons = {
		[1] = {
			name				= "Type9075mmAP",
			maxAngleDif			= 20,
		},
		[2] = {
			name				= "Type9075mmHE",
			maxAngleDif			= 20,
		},
		[3] = {
			name				= ".50calproof",
		},
	},
}

local JPNHoNiII = HoNiBase:New(SPArty):New(OpenTopped):New{
	name				= "Type 2 Ho-Ni II",
	buildCostMetal		= 3150,
	maxDamage			= 1630,

	weapons = {
		[1] = {
			name				= "Type91105mmL24HE",
			maxAngleDif			= 20,
		},
		[2] = {
			name				= ".50calproof",
		},
	},
	
	customParams = {
		maxammo				= 4,
	},
}

local JPNHoNiIII = HoNiBase:New(TankDestroyer):New{
	name				= "Type 3 Ho-Ni III",
	buildCostMetal		= 2050,
	maxDamage			= 1700,

	weapons = {
		[1] = {
			name				= "Type375mmL38AP",
			maxAngleDif			= 20,
		},
		[2] = {
			name				= ".50calproof",
		},
	},

	customParams = {
		armour = {
			super = {
				front = {
					slope			= 16,
				},
				rear = {
					thickness		= 25,
					slope			= 11,
				},
				side = {
					slope 		= 24,
				},
				top = {
					thickness		= 10,
				},
			},
		},
	},
}
	
return lowerkeys({
	["JPNHoNiI"] = JPNHoNiI,
	["JPNHoNiII"] = JPNHoNiII,
	["JPNHoNiIII"] = JPNHoNiIII,
})
