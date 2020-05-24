local GERPanzerIV = MediumTank:New{
	name				= "PzKpfw IV Ausf H",
	buildCostMetal		= 2875,
	maxDamage			= 2600,
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
			name				= "MG34",
			mainDir				= [[0 0 1]],
			maxAngleDif			= 30,
		},		
		[5] = {
			name				= ".50calproof",
		},
	},
	customParams = {
		armor_front			= 80,
		armor_rear			= 20,
		armor_side			= 35, -- 30mm + 5mm skirt
		armor_top			= 15,
		slope_front			= 11,
		slope_rear			= -10,
		maxammo				= 17,
		turretturnspeed		= 16, -- 22.5s for 360
		maxvelocitykmh		= 25,

	},
}

return lowerkeys({
	["GERPanzerIV"] = GERPanzerIV,
})
