local GERPanther = HeavyTank:New{
	name				= "PzKpfw V Panther Ausf G",
	buildCostMetal		= 5400,
	maxDamage			= 4547,
	trackOffset			= 5,
	trackWidth			= 19,

	weapons = {
		[1] = {
			name				= "KwK75mmL71AP",
			mainDir				= [[0 16 1]],
			maxAngleDif			= 210,
		},
		[2] = {
			name				= "KwK75mmL71HE",
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
		armor_front			= 113,
		armor_rear			= 47,
		armor_side			= 49,
		armor_top			= 16,
		maxammo				= 15,
		turretturnspeed		= 20, -- 18s for 360
		maxvelocitykmh		= 46,
	},
}

return lowerkeys({
	["GERPanther"] = GERPanther,
})
