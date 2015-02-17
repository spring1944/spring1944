local GERTiger = HeavyTank:New{
	name				= "PzKpfw VI Tiger Ausf E",
	acceleration		= 0.04,
	brakeRate			= 0.105,
	buildCostMetal		= 9770,
	maxDamage			= 5700,
	maxReverseVelocity	= 1.405,
	maxVelocity			= 2.81,
	trackOffset			= 5,
	trackWidth			= 23,

	weapons = {
		[1] = {
			name				= "KwK88mmL56AP",
			mainDir				= [[0 16 1]],
			maxAngleDif			= 210,
		},
		[2] = {
			name				= "KwK88mmL56HE",
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
		armor_front			= 103,
		armor_rear			= 81,
		armor_side			= 71,
		armor_top			= 25,
		maxammo				= 17,
		weaponcost			= 20,
	},
}

return lowerkeys({
	["GERTiger"] = GERTiger,
})
