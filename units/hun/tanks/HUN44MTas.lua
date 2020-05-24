local HUN44MTas = HeavyTank:New{
	name				= "44.M Tas",
	corpse				= "HUN44MTas_Abandoned",
	buildCostMetal			= 5000,
	maxDamage			= 3800,
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
			name				= "gebauer_1934_37m",
		},
		[4] = {
			name				= ".50calproof",
		},
	},
	customParams = {
		armor_front			= 75,
		armor_rear			= 100,
		armor_side			= 50,
		armor_top			= 20,
		slope_front			= 60,
		slope_rear			= -15,
		slope_side			= 25,
		maxammo				= 15,
		turretturnspeed		= 20, -- 18s for 360
		maxvelocitykmh		= 45,

	},
}

return lowerkeys({
	["HUN44MTas"] = HUN44MTas,
})
