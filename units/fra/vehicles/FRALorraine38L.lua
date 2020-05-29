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
					thickness		= 16,
					slope			= 66,
				},
				rear = {
					thickness		= 16,
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
	},
}

return lowerkeys({
	["FRALorraine38L"] = Lorraine38L,
})
