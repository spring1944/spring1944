local USM7Priest = SPArty:New{
	name				= "M7 HMC Priest",
	acceleration		= 0.065,
	brakeRate			= 0.15,
	buildCostMetal		= 4500,
	maxDamage			= 2300,
	maxReverseVelocity	= 1.445,
	maxVelocity			= 2.89,
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
		armor_front			= 23,
		armor_rear			= 13,
		armor_side			= 19,
		armor_top			= 25,
		maxammo				= 13,
		weaponcost			= 30,
	},
}

return lowerkeys({
	["USM7Priest"] = USM7Priest,
})
