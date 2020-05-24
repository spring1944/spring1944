local GERStuGIII = MediumTank:New(AssaultGun):New{
	name				= "SdKfz 142/1 StuG III Ausf. G",
	buildCostMetal		= 2750,
	maxDamage			= 2390,
	trackOffset			= 3,
	trackWidth			= 19,

	weapons = {
		[1] = {
			name				= "kwk75mml48AP",
			maxAngleDif			= 15,
		},
		[2] = {
			name				= "kwk75mml48HE",
			maxAngleDif			= 15,
		},
		[3] = {
			name				= ".50calproof",
		},
	},
	customParams = {
		armor_front			= 80,
		armor_rear			= 50,
		armor_side			= 30,
		armor_top			= 17,
		slope_front			= 9,
		slope_rear			= -10,
		slope_side			= 10,
		maxammo				= 11,
		soundcategory		= "GER/Tank/StuG",
		maxvelocitykmh		= 40,

	},
}

return lowerkeys({
	["GERStuGIII"] = GERStuGIII,
})
