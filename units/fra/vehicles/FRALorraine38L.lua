local Lorraine38L = HalfTrack:New{
	name					= "Voiture blindée de chasseurs portés 38L",
	buildCostMetal			= 1100,
	corpse					= "FRALorraine38L_Burning",
	maxDamage				= 605,
	trackOffset				= 10,
	trackWidth				= 14,
	
	objectName				= "FRA/FRALorraine38L.s3o",
	
	customParams = {
		armor_front			= 16,
		armor_rear			= 16,
		armor_side			= 9,
		armor_top			= 0,
		maxvelocitykmh		= 37,
		customanims			= "lorraine38l",
		normaltex			= "",
	},
}

return lowerkeys({
	["FRALorraine38L"] = Lorraine38L,
})
