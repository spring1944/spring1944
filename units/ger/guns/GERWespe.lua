local GERWespe = LightTank:New(SPArty):New(OpenTopped):New{
	name				= "SdKfz 124 Wespe",
	buildCostMetal		= 4200,
	maxDamage			= 1100,
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
		[3] = {
			name				= ".30calproof",
		},
	},
	customParams = {
		armor_front			= 18,
		armor_rear			= 14,
		armor_side			= 13,
		armor_top			= 4,
		maxammo				= 6,
		maxvelocitykmh		= 40,
		normaltex			= "",
	},
}

return lowerkeys({
	["GERWespe"] = GERWespe,
})
