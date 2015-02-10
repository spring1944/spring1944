local RUS_Yak3 = Interceptor:New{
	name				= "Yak-9U",
	buildCostMetal		= 985,
	maxDamage			= 235,
		
	maxAcc				= 0.824,
	maxAileron			= 0.0044,
	maxBank				= 1,
	maxElevator			= 0.0031,
	maxPitch			= 1,
	maxRudder			= 0.0023,
	maxVelocity			= 21,

	customParams = {
		enginesound			= "yakb-",
		enginesoundnr		= 20,
		planevoice			= 1,
	},

	weapons = {
		[1] = {
			name				= "m2browningamg",
			maxAngleDif			= 10,
		},
		[2] = {
			name				= "m2browningamg",
			maxAngleDif			= 10,
			slaveTo				= 1,
		},	
		[3] = {
			name				= "ShVAK20mm",
			maxAngleDif			= 10,
			slaveTo				= 1,
		},
	},
}


return lowerkeys({
	["RUSYak3"] = RUS_Yak3,
})
