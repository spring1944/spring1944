local GERTigerII = HeavyTank:New{
	name				= "PzKpfw VII Koenigstiger Ausf B",
	acceleration		= 0.033,
	brakeRate			= 0.105,
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
			name				= ".50calproof",
		},
	},
	customParams = {
		armor_front			= 154,
		armor_rear			= 90,
		armor_side			= 84,
		armor_top			= 40,
		maxammo				= 16,
		weaponcost			= 26,
		turretturnspeed		= 20, -- 18s for 360
		maxvelocitykmh		= 38,
	},
}

return lowerkeys({
	["GERTigerII"] = GERTigerII,
})
