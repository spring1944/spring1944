local TeKeBase = Tankette:New{
	name				= "Type 97 Te-Ke",
	acceleration		= 0.034,
	brakeRate			= 0.15,
	buildCostMetal		= 700,
	maxDamage			= 475,
	maxReverseVelocity	= 1.45,
	maxVelocity			= 2.9,
	trackOffset			= 5,
	trackWidth			= 12,
	
	customParams = {
		armor_front			= 14,
		armor_rear			= 12,
		armor_side			= 16,
		armor_top			= 6,
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
		weaponcost			= 8,
	},
}

local JPNTeKe_HMG = TeKeBase:New{
	description			= "Tankettte with 7.7mm MG",
	weapons = {
		[1] = {
			name				= "Type97MG",
		},
		[2] = {
			name				= ".50calproof",
		},
	},
	customParams = {
		weaponswithammo		= 0,
	},
}

return lowerkeys({
	["JPNTeKe"] = JPNTeKe,
	["JPNTeKe_HMG"] = JPNTeKe_HMG,
})
