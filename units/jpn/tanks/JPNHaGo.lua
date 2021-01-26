local JPNHaGo = LightTank:New{
	name				= "Type 95 Ha-Go",
	buildCostMetal		= 977,
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
		armour = {
			base = {
				front = {
					thickness		= 12,
					slope			= 16,
				},
				rear = {
					thickness		= 10,
					slope			= -1,
				},
				side = {
					thickness 		= 12,
					slope			= 34,
				},
				top = {
					thickness		= 6,
				},
			},
			turret = {
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
		maxammo				= 20,
		maxvelocitykmh		= 45,
		exhaust_fx_name			= "diesel_exhaust",
		normaltex			= "unittextures/JPNHaGo_normals.png",
	},
}

return lowerkeys({
	["JPNHaGo"] = JPNHaGo,
})
