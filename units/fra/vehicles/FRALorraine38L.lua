local Lorraine38L = HalfTrack:New{
	name					= "Voiture blindée de chasseurs portés 38L",
	buildCostMetal			= 1100,
	corpse					= "FRALorraine38L_Burning",
	maxDamage				= 605,
	trackOffset				= 10,
	trackWidth				= 14,
	
	objectName				= "FRA/FRALorraine38L.s3o",
	
	customParams = {
		armour = {
			base = {
				front = {
					thickness		= 9,
					slope			= 34,
				},
				rear = {
					thickness		= 9,
				},
				side = {
					thickness 		= 9,
				},
				top = {
					thickness		= 6,
				},
			},
			super = {
				front = {
					thickness		= 9,
				},
				rear = {
					thickness		= 9,
				},
				side = {
					thickness 		= 9,
				},
				top = {
					thickness		= 0,
				},
			},
			trailer = {
				front = {
					thickness		= 9,
				},
				rear = {
					thickness		= 9,
				},
				side = {
					thickness 		= 9,
				},
				top = {
					thickness		= 0,
				},
			},
		},
		maxvelocitykmh		= 37,
		customanims			= "lorraine38l",
		piecehitvols		= {
			super = {
				scale = {1, 0.6, 0.7},
				offset = {0, 1.5, -2.5},
			},
			trailer = {
				scale = {0.92, 1, 0.68},
				offset = {0, 0, -3.1},
			},
		},

		normaltex = "unittextures/FRALorraine38L_normals.png",
	},
}

return lowerkeys({
	["FRALorraine38L"] = Lorraine38L,
})
