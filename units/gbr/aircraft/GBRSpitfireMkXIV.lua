local GBR_SpitfireMkXIV = Interceptor:New{
	name				= "Spitfire Mk XIVe",
	buildCostMetal		= 1250,
	maxDamage			= 299.3,
		
	maxAcc				= 0.900,
	maxAileron			= 0.006,
	maxBank				= 1,
	maxElevator			= 0.005,
	maxPitch			= 1,
	maxRudder			= 0.004,
	maxVelocity			= 21,

	turnRate			= 24,

	customParams = {
		enginesound			= "spitfireb-",
		enginesoundnr		= 18,
		proptexture			= "prop5.tga",

	},

	weapons = {
		[1] = {
			name				= "m2browningamg",
			maxAngleDif			= 10,
		},
		[2] = {
			name				= "m2browningamg",
			maxAngleDif			= 10,
			slaveTo				= 2,
		},	
		[3] = {
			name				= "HS40420mm",
			maxAngleDif			= 10,
			slaveTo				= 2,
		},
		[4] = {
			name				= "HS40420mm",
			maxAngleDif			= 10,
			slaveTo				= 2,
		},
	},
}


return lowerkeys({
	["GBRSpitfireMkXIV"] = GBR_SpitfireMkXIV,
})
