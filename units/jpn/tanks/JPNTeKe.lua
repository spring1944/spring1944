local TeKeBase = Tankette:New{
	name				= "Type 97 Te-Ke",
	buildCostMetal		= 600,
	maxDamage			= 475,
	trackOffset			= 5,
	trackWidth			= 12,
	
	customParams = {
		armor_front			= 14,
		armor_rear			= 12,
		armor_side			= 16,
		armor_top			= 6,
		maxvelocitykmh		= 42,
		exhaust_fx_name			= "diesel_exhaust",

	},
}

local JPNTeKe = TeKeBase:New{
	weapons = {
		[1] = {
			name				= "Type9437mmAP",
			mainDir				= [[0 16 1]],
			maxAngleDif			= 210,
		},
		[2] = {
			name				= "Type9437mmHE",
			mainDir				= [[0 16 1]],
			maxAngleDif			= 210,
		},
		[3] = {
			name				= ".50calproof",
		},
	},
	customParams = {
		maxammo				= 15,
	},
}

local JPNTeKe_HMG = TeKeBase:New{
	buildCostMetal		= 400,
	description			= "Tankettte with 7.7mm MG",
	weapons = {
		[1] = {
			name				= "Type97MG",
		},
		[2] = {
			name				= ".50calproof",
		},
	},
}

return lowerkeys({
	["JPNTeKe"] = JPNTeKe,
	["JPNTeKe_HMG"] = JPNTeKe_HMG,
})
