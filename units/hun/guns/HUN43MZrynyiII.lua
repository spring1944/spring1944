local HUN43MZrynyiII = MediumTank:New(AssaultGun):New{
	name				= "43.M Zrynyi II",
	buildCostMetal		= 3500,
	corpse				= "HUN43MZrynyiII_Abandoned",
	maxDamage			= 2160,
	trackOffset			= 5,
	trackWidth			= 18,

	weapons = {
		[1] = {
			name				= "Mavag_105_4043MHEAT",
			mainDir				= [[0 0 1]],
			maxAngleDif			= 25,
		},
		[2] = {
			name				= "Mavag_105_4043MHE",
			mainDir				= [[0 0 1]],
			maxAngleDif			= 25,
		},
		[3] = {
			name				= ".50calproof",
		},
	},

	customParams = {
		armor_front			= 70,
		armor_rear			= 25,
		armor_side			= 30,
		armor_top			= 15,
		maxammo				= 18,
		maxvelocitykmh		= 40,
		normaltex			= "",
	},
}

return lowerkeys({
	["HUN43MZrynyiII"] = HUN43MZrynyiII,
})