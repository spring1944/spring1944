local GERTigerII = HeavyTank:New{
	name				= "PzKpfw VII Koenigstiger Ausf B",
	buildCostMetal		= 15750,
	maxDamage			= 7000,
	trackOffset			= 5,
	trackWidth			= 26,

	weapons = {
		[1] = {
			name				= "KwK88mmL71AP",
			mainDir				= [[0 16 1]],
			maxAngleDif			= 210,
		},
		[2] = {
			name				= "KwK88mmL71HE",
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
		armor_front			= 150,
		armor_rear			= 80,
		armor_side			= 80,
		armor_top			= 40,
		slope_front			= 50,
		slope_rear			= -28,
		slope_side			= 27,
		maxammo				= 16,
		turretturnspeed		= 20, -- 18s for 360
		maxvelocitykmh		= 38,
		normaltex			= "unittextures/GERTigerII_normals.dds",
	},
}

return lowerkeys({
	["GERTigerII"] = GERTigerII,
})
