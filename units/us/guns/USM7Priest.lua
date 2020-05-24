local USM7Priest = MediumTank:New(SPArty):New(OpenTopped):New{
	name				= "M7 HMC Priest",
	buildCostMetal		= 4500,
	maxDamage			= 2300,
	trackOffset			= 5,
	trackWidth			= 18,

	weapons = {
		[1] = {
			name				= "M2HE",
			maxAngleDif			= 15,
		},
		[2] = {
			name				= "M2BrowningAA",
		},
		[3] = {
			name				= ".50calproof",
		},
	},
	customParams = {
		armor_front			= 38,
		armor_rear			= 38,
		armor_side			= 19,
		armor_top			= 13,
		slope_front			= 55,
		slope_rear			= -15,
		maxammo				= 13,
		maxvelocitykmh		= 39,

	},
}

return lowerkeys({
	["USM7Priest"] = USM7Priest,
})
