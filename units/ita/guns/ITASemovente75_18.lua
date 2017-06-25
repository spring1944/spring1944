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
		armor_front			= 50,
		armor_rear			= 25,
		armor_side			= 25,
		armor_top			= 15,
		maxammo				= 14,
		maxvelocitykmh		= 40,
		exhaust_fx_name			= "diesel_exhaust",
		normaltex			= "",
	},
}

return lowerkeys({
	["ITASemovente75_18"] = ITASemovente75_18,
})
