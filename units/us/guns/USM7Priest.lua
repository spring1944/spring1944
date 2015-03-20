local USM7Priest = Tank:New(SPArty):New(OpenTopped):New{
	name				= "M7 HMC Priest",
	acceleration		= 0.065,
	brakeRate			= 0.15,
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
		armor_front			= 23,
		armor_rear			= 13,
		armor_side			= 19,
		armor_top			= 25,
		maxammo				= 13,
		weaponcost			= 30,
		maxvelocitykmh		= 39,
		
		cegpiece = {
			[2] = "aaflare",
		},
	},
}

return lowerkeys({
	["USM7Priest"] = USM7Priest,
})
