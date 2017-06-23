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
		armor_front			= 50,
		armor_rear			= 25,
		armor_side			= 40,
		armor_top			= 0,
		maxammo				= 14,
		maxvelocitykmh		= 38,
		exhaust_fx_name			= "diesel_exhaust",
		normaltex			= "",
	},
}

return lowerkeys({
	["JPNHoNiI"] = JPNHoNiI,
})
