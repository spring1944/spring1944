local SWEJ21A = Fighter:New{
	name				= "SAAB J 21A",
	description			= "Heavy Fighter",
	buildCostMetal		= 1125,
	maxDamage			= 320,
		
	maxAcc				= 0.723,
	maxAileron			= 0.0052,
	maxBank				= 1,
	maxElevator			= 0.0044,
	maxPitch			= 1,
	maxRudder			= 0.003,
	maxVelocity			= 18.9,

	customParams = {
		enginesound			= "fw190b-",
		enginesoundnr		= 12,

	},

	weapons = {
		[1] = {
			name				= "HS40420mm",
			maxAngleDif			= 10,
		},
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
			name				= "m2browningamg",
			maxAngleDif			= 10,
			slaveTo				= 2,
		},
		[5] = {
			name				= "m2browningamg",
			maxAngleDif			= 10,
			slaveTo				= 2,
		},
	},
}


return lowerkeys({
	["SWEJ21A"] = SWEJ21A,
})
