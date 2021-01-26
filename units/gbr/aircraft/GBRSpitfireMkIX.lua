local GBR_SpitfireMkIX = FighterBomber:New{
	name				= "Spitfire Mk IXe LF",
	buildCostMetal		= 3375,
	maxDamage			= 254.5,
		
	maxAcc				= 0.622,
	maxAileron			= 0.006,
	maxBank				= 0.9,
	maxRudder			= 0.004,
	maxVelocity			= 22.6,

	customParams = {
		enginesound			= "spitfireb-",
		enginesoundnr		= 18,

		normaltex			= "unittextures/GBRSpitfireMkXIV_normals.png",
	},

	weapons = {
		[2] = {
			name				= "m2browningamg",
			maxAngleDif			= 10,
		},
		[3] = {
			name				= "m2browningamg",
			maxAngleDif			= 10,
			slaveTo				= 2,
		},	
		[4] = {
			name				= "HS40420mm",
			maxAngleDif			= 10,
			slaveTo				= 2,
		},
		[5] = {
			name				= "HS40420mm",
			maxAngleDif			= 10,
			slaveTo				= 2,
		},
	},
}


return lowerkeys({
	["GBRSpitfireMkIX"] = GBR_SpitfireMkIX,
})
