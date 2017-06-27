local JPNHaGo = LightTank:New{
	name				= "Type 95 Ha-Go",
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
		maxvelocitykmh		= 45,
		exhaust_fx_name			= "diesel_exhaust",

	},
}

return lowerkeys({
	["JPNHaGo"] = JPNHaGo,
})
