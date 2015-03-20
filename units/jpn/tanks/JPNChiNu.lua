local JPNChiNu = MediumTank:New{
	name				= "Type 3 Chi-Nu",
	description			= "75mm Medium Tank",
	acceleration		= 0.034,
	brakeRate			= 0.15,
	buildCostMetal		= 2650,
	maxDamage			= 1880,
	trackOffset			= 5,
	trackWidth			= 14,

	weapons = {
		[1] = {
			name				= "Type375mmL38AP",
			mainDir				= [[0 16 1]],
			maxAngleDif			= 210,
		},
		[2] = {
			name				= "Type375mmL38HE",
			mainDir				= [[0 16 1]],
			maxAngleDif			= 210,
		},
		[3] = { -- bow MG
			name				= "Type97MG",
		},
		[4] = {
			name				= ".50calproof",
		},
	},
	customParams = {
		armor_front			= 60,
		armor_rear			= 25,
		armor_side			= 25,
		armor_top			= 11,
		maxammo				= 12,
		weaponcost			= 10,
		maxvelocitykmh		= 39,
		
		cegpiece = {
			[3] = "bow_mg_flare",
		},
	},
}

return lowerkeys({
	["JPNChiNu"] = JPNChiNu,
})
