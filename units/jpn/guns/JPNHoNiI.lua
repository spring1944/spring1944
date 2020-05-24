local JPNHoNiI = LightTank:New(AssaultGun):New(OpenTopped):New{
	name				= "Type 1 Ho-Ni I",
	buildCostMetal		= 2050,
	maxDamage			= 1542,
	trackOffset			= 5,
	trackWidth			= 14,

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
	customParams = {
		armor_front			= 25,
		armor_rear			= 20,
		armor_side			= 25,
		armor_top			= 0,
		slope_front			= 15,
		slope_rear			= 25,
		slope_side			= 27,
		maxammo				= 14,
		maxvelocitykmh		= 38,
		exhaust_fx_name			= "diesel_exhaust",

	},
}

return lowerkeys({
	["JPNHoNiI"] = JPNHoNiI,
})
