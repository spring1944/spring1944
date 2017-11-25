local GERPanzerIII = MediumTank:New{
	name				= "PzKpfw III Ausf L",
	buildCostMetal		= 2150,
	maxDamage			= 2130,
	trackOffset			= 5,
	trackWidth			= 19,

	weapons = {
		[1] = {
			name				= "KwK50mmL60AP",
			mainDir				= [[0 16 1]],
			maxAngleDif			= 210,
		},
		[2] = {
			name				= "KwK50mmL60HE",
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
		armor_front			= 62,
		armor_rear			= 40,
		armor_side			= 31,
		armor_top			= 14,
		maxammo				= 12,
		maxvelocitykmh		= 40,
		normaltex			= "unittextures/GERPanzerIII_normals.dds",
	},
}

return lowerkeys({
	["GERPanzerIII"] = GERPanzerIII,
})
