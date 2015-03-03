local GERStuGIII = Tank:New(AssaultGun):New{
	name				= "SdKfz 142/1 StuG III Ausf. G",
	acceleration		= 0.042,
	brakeRate			= 0.15,
	buildCostMetal		= 2750,
	maxDamage			= 2390,
	maxReverseVelocity	= 1.48,
	maxVelocity			= 2.96,
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
		armor_front			= 83,
		armor_rear			= 51,
		armor_side			= 30,
		armor_top			= 17,
		maxammo				= 11,
		weaponcost			= 16,
		soundcategory		= "GER/Tank/StuG",
	},
}

return lowerkeys({
	["GERStuGIII"] = GERStuGIII,
})
