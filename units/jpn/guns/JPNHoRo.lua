local JPNHoRo = LightTank:New(AssaultGun):New(OpenTopped):New{
	name				= "Type 4 Ho-Ro",
	description			= "Heavy Howitzer Assault Gun",
	buildCostMetal		= 3450,
	maxDamage			= 1630,
	trackOffset			= 5,
	trackWidth			= 14,

	weapons = {
		[1] = {
			name				= "Type38150mmL11HE",
			maxAngleDif			= 20,
		},
		[2] = {
			name				= "Type38150mmL11Smoke",
			maxAngleDif			= 20,
		},
		[3] = {
			name				= ".50calproof",
		},
	},
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
					slope			= 0,
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
					thickness 		= 20,
				},
				top = {
					thickness		= 12,
				},
			},
		},
		
		maxammo				= 4,
		weapontoggle		= "smoke",
		canfiresmoke		= true,
		maxvelocitykmh		= 38,
		exhaust_fx_name			= "diesel_exhaust",

	},
}

return lowerkeys({
	["JPNHoRo"] = JPNHoRo,
})
