local TeKeBase = Tankette:New{
	name				= "Type 97 Te-Ke",
	buildCostMetal		= 600,
	maxDamage			= 475,
	trackOffset			= 5,
	trackWidth			= 12,
	
	customParams = {
		armour = {
			base = {
				front = {
					thickness		= 14,
					slope			= 74,
				},
				rear = {
					thickness		= 12,
					slope			= 20,
				},
				side = {
					thickness 		= 16,
					slope			= 30,
				},
				top = {
					thickness		= 6,
				},
			},
			turret = { -- copied from Ha-Go, estimate
				front = {
					thickness		= 12, -- not mantlet
					slope			= 13,
				},
				rear = {
					thickness		= 12,
					slope			= 12,
				},
				side = {
					thickness 		= 12,
					slope			= 12,
				},
				top = {
					thickness		= 9,
				},
			},
		},
		maxvelocitykmh		= 42,
		exhaust_fx_name			= "diesel_exhaust",
		normaltex			= "unittextures/JPNTeKe_normals.png",
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
