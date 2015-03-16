local ITA_Breda61 = EngineerVehicle:New{
	name					= "Breda tipo 61",
	description				= "Minelaying Vehicle",
	buildCostMetal			= 1400,
	maxDamage				= 975,
	maxReverseVelocity		= 1.5,
	maxVelocity				= 3,
	trackOffset				= 10,
	trackWidth				= 15,
}

return lowerkeys({
	["ITABreda61"] = ITA_Breda61,
})
