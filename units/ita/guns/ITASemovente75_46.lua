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
		armor_front			= 100,
		armor_rear			= 25,
		armor_side			= 70,
		armor_top			= 15,
		slope_front			= 25,
		slope_rear			= -15,
		maxammo				= 11,
		maxvelocitykmh		= 38,

	},
}

return lowerkeys({
	["ITASemovente75_46"] = ITASemovente75_46,
})
