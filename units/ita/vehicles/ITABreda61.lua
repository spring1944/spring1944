local ITA_Breda61 = EngineerVehicle:New{
	name					= "Breda tipo 61",
	description				= "Minelaying Vehicle",
	category				= "INFANTRY", -- a hack so it is still targeted by smallarms & HE but not mines
	buildCostMetal			= 1400,
	maxDamage				= 975,
	maxReverseVelocity		= 1.5,
	maxVelocity				= 3,
	trackOffset				= 10,
	trackWidth				= 15,
	customParams = {
		normaltex			= "unittextures/ITABreda61_normals.png",
	},
}

return lowerkeys({
	["ITABreda61"] = ITA_Breda61,
})
