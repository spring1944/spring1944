local JPNHaGo = LightTank:New{
	name				= "Type 95 Ha-Go",
	acceleration		= 0.034,
	brakeRate			= 0.15,
	buildCostMetal		= 1150,
	maxDamage			= 740,
	trackOffset			= 5,
	trackWidth			= 14,

	weapons = {
		[1] = {
			name				= "Type9837mmAP",
			mainDir				= [[0 16 1]],
			maxAngleDif			= 210,
		},
		[2] = {
			name				= "Type9837mmHE",
			mainDir				= [[0 16 1]],
			maxAngleDif			= 210,
		},
		[3] = { -- bow MG
			name				= "Type97MG",
		},
		[4] = { -- Rear Turret MG
			name				= "Type97MG",
		},
		[5] = {
			name				= ".50calproof",
		},
	},
	customParams = {
		armor_front			= 15,
		armor_rear			= 10,
		armor_side			= 14,
		armor_top			= 6,
		maxammo				= 20,
		weaponcost			= 7,
		maxvelocitykmh		= 45,
		
		cegpiece = {
			[3] = "bow_mg_flare",
			[4] = "turret_mg_flare",
		},
	},
}

return lowerkeys({
	["JPNHaGo"] = JPNHaGo,
})
