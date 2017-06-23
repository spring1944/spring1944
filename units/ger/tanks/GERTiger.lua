local GERTiger = HeavyTank:New{
	name				= "PzKpfw VI Tiger Ausf E",
	buildCostMetal		= 8790,
	maxDamage			= 5700,
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
			name				= "MG34",
			mainDir				= [[0 0 1]],
			maxAngleDif			= 30,
		},		
		[5] = {
			name				= ".50calproof",
		},
	},
	customParams = {
		armor_front			= 103,
		armor_rear			= 81,
		armor_side			= 71,
		armor_top			= 25,
		maxammo				= 17,
		turretturnspeed		= 10, -- 60s for 360
		maxvelocitykmh		= 45.4,
		normaltex			= "",
	},
}

return lowerkeys({
	["GERTiger"] = GERTiger,
})
