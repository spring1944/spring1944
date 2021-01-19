local GBR_Typhoon = AttackFighter:New{
	name				= "Hawker Typhoon Mk.IB",
	buildCostMetal		= 3000,
	maxDamage			= 444.5,
		
	maxAcc				= 0.648,
	maxAileron			= 0.0044,
	maxBank				= 0.9,
	maxRudder			= 0.0023,
	maxVelocity			= 16,

	customParams = {
		enginesound			= "spitfireb-",
		enginesoundnr		= 18,
		maxammo				= 8,

		normaltex			= "unittextures/GBRTyphoon1_normals.png",
	},

	weapons = {
		[1] = {
			name				= "RP3Rocket",
			maxAngleDif			= 30,
		},
		[2] = {
			name				= "RP3Rocket",
			maxAngleDif			= 30,
			slaveTo				= 1,
		},
		[3] = {
			name				= "HS40420mm",
			maxAngleDif			= 10,
		},
		[4] = {
			name				= "HS40420mm",
			maxAngleDif			= 10,
			slaveTo				= 3,
		},	
		[5] = {
			name				= "HS40420mm",
			maxAngleDif			= 10,
			slaveTo				= 3,
		},
		[6] = {
			name				= "HS40420mm",
			maxAngleDif			= 10,
			slaveTo				= 3,
		},
	},
}


return lowerkeys({
	["GBRTyphoon"] = GBR_Typhoon,
})
