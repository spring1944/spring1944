local GERPanzerIV = MediumTank:New{
	name				= "PzKpfw IV Ausf J",
	acceleration		= 0.038,
	brakeRate			= 0.15,
	buildCostMetal		= 2875,
	maxDamage			= 2600,
	maxReverseVelocity	= 1.405,
	maxVelocity			= 2.81,
	trackOffset			= 5,
	trackWidth			= 19,

	weapons = {
		[1] = {
			name				= "KwK75mmL48AP",
			mainDir				= [[0 16 1]],
			maxAngleDif			= 210,
		},
		[2] = {
			name				= "KwK75mmL48HE",
			mainDir				= [[0 16 1]],
			maxAngleDif			= 210,
		},
		[3] = {
			name				= "MG34",
		},
		[4] = {
			name				= ".50calproof",
		},
	},
	customParams = {
		armor_front			= 62,
		armor_rear			= 23,
		armor_side			= 35,
		armor_top			= 15,
		maxammo				= 17,
		weaponcost			= 16,
	},
}

return lowerkeys({
	["GERPanzerIV"] = GERPanzerIV,
})
