local GERWespe = Tank:New(SPArty):New(OpenTopped):New{
	name				= "SdKfz 124 Wespe",
	acceleration		= 0.042,
	brakeRate			= 0.15,
	buildCostMetal		= 4200,
	maxDamage			= 1100,
	maxReverseVelocity	= 1.48,
	maxVelocity			= 2.96,
	trackOffset			= 5,
	trackWidth			= 18,

	weapons = {
		[1] = {
			name				= "LeFH18HE",
			maxAngleDif			= 15,
		},
		[2] = {
			name				= "mg42aa",
		},
		[2] = {
			name				= ".30calproof",
		},
	},
	customParams = {
		armor_front			= 18,
		armor_rear			= 14,
		armor_side			= 13,
		armor_top			= 4,
		maxammo				= 6,
		weaponcost			= 30,
		
		cegpiece = {
			[2] = "aaflare",
		},
	},
}

return lowerkeys({
	["GERWespe"] = GERWespe,
})
