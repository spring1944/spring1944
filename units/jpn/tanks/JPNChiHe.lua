local JPNChiHe = MediumTank:New{
	name				= "Type 1 Chi-He",
	buildCostMetal		= 2300,
	maxVelocity			= 2.9,
	trackOffset			= 5,
	trackWidth			= 14,

	weapons = {
		[1] = {
			name				= "Type147mmAP",
			mainDir				= [[0 16 1]],
			maxAngleDif			= 210,
		},
		[2] = {
			name				= "Type147mmHE",
			mainDir				= [[0 16 1]],
			maxAngleDif			= 210,
		},
		[3] = { -- bow MG
			name				= "Type97MG",
		},
		[4] = { -- Rear turret MG
			name				= "Type97MG",
		},
		[5] = {
			name				= ".50calproof",
		},
	},
	customParams = {
		armor_front			= 50,
		armor_rear			= 25,
		armor_side			= 25,
		armor_top			= 11,
		maxammo				= 20,
		weaponcost			= 8,
		maxvelocitykmh		= 44,
		
		cegpiece = {
			[3] = "bow_mg_flare",
			[4] = "turret_mg_flare",
		},
	},
}

return lowerkeys({
	["JPNChiHe"] = JPNChiHe,
})
