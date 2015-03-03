local ITASemovente75_18 = Tank:New(AssaultGun):New{
	name				= "Semovente da 75/18",
	acceleration		= 0.041,
	brakeRate			= 0.15,
	buildCostMetal		= 2050,
	maxDamage			= 1470,
	maxReverseVelocity	= 1.43,
	maxVelocity			= 2.86,
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
		weaponcost			= 12,
	},
}

return lowerkeys({
	["ITASemovente75_18"] = ITASemovente75_18,
})
