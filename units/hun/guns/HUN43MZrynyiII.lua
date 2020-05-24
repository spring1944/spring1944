local HUN43MZrynyiII = MediumTank:New(AssaultGun):New{
	name				= "43.M Zrynyi II",
	buildCostMetal		= 3150,
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
		armor_front			= 75,
		armor_rear			= 25,
		armor_side			= 30, -- Schuertzen
		armor_top			= 13,
		slope_front			= 19,
		slope_side			= 10,
		maxammo				= 18,
		maxvelocitykmh		= 43,
		weapontoggle		= "priorityHEATHE",
	},
}

return lowerkeys({
	["HUN43MZrynyiII"] = HUN43MZrynyiII,
})
