local GER_Bf109 = Interceptor:New{
	name				= "BF 109K-4",
	buildCostMetal		= 985,
	maxDamage			= 224.7,
		
	maxAcc				= 0.803,
	maxAileron			= 0.00465,
	maxBank				= 1,
	maxElevator			= 0.0036,
	maxPitch			= 1,
	maxRudder			= 0.002765,
	maxVelocity			= 19.85,

	customParams = {
		enginesound			= "me109b-",
		enginesoundnr		= 18,

	},

	weapons = {
		[1] = {
			name				= "mg15115mm",
			maxAngleDif			= 10,
		},
		[2] = {
			name				= "mg15115mm",
			maxAngleDif			= 10,
			slaveTo				= 1,
		},	
		[3] = {
			name				= "mk10830mm",
			maxAngleDif			= 10,
		},
	},
}


return lowerkeys({
	["GERBf109"] = GER_Bf109,
})
