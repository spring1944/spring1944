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
		armour = {
			base = {
				front = {
					thickness		= 70,
					slope			= 12,
				},
				rear = {
					thickness		= 53,
					slope			= 16,
				},
				side = {
					thickness 		= 30,
				},
				top = {
					thickness		= 17,
				},
			},
			turret = {
				front = {
					thickness		= 50,
					slope			= 15,
				},
				rear = {
					thickness		= 30,
					slope			= 12,
				},
				side = {
					thickness 		= 30,
					slope			= 25,
				},
				top = {
					thickness		= 10,
				},
			},
		},
		maxammo				= 12,
		maxvelocitykmh		= 40,
		normaltex			= "unittextures/GERPanzerIII_normals.dds",
	},
}

return lowerkeys({
	["GERPanzerIII"] = GERPanzerIII,
})
