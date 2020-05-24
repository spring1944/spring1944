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
		armor_front			= 25,
		armor_rear			= 20,
		armor_side			= 25,
		armor_top			= 0,
		slope_front			= 23,
		slope_rear			= 25,
		
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
