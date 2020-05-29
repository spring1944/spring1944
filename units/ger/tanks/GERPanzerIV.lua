local GERPanzerIV = MediumTank:New{
	name				= "PzKpfw IV Ausf H",
	buildCostMetal		= 2875,
	maxDamage			= 2600,
	trackOffset			= 5,
	trackWidth			= 19,

	weapons = {
		[1] = {
			name				= "KwK75mmL48AP",
			mainDir				= [[0 16 1]],
			maxAngleDif			= 210,
		},
		[2] = {
			name				= "KwK75mmL48HE",
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
		armour = {
			base = {
				front = {
					thickness		= 80,
					slope			= 10,
				},
				rear = {
					thickness		= 20,
					slope			= -8,
				},
				side = {
					thickness 		= 35,
				},
				top = {
					thickness		= 10,
				},
			},
			turret = {
				front = {
					thickness		= 50,
					slope			= 11,
				},
				rear = {
					thickness		= 38,
					slope			= 17,
				},
				side = {
					thickness 		= 38, -- 30mm + 8mm skirt
					slope			= 26,
				},
				top = {
					thickness		= 16,
				},
			},
		},
		
		maxammo				= 17,
		turretturnspeed		= 16, -- 22.5s for 360
		maxvelocitykmh		= 25,

	},
}

return lowerkeys({
	["GERPanzerIV"] = GERPanzerIV,
})
