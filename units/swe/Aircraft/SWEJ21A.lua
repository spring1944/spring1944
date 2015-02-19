local SWEJ21A = Fighter:New{
	name				= "Fw 190A-8",
	buildCostMetal		= 1125,
	maxDamage			= 320,
		
	maxAcc				= 0.693,
	maxAileron			= 0.0054,
	maxBank				= 1,
	maxElevator			= 0.0042,
	maxPitch			= 1,
	maxRudder			= 0.003,
	maxVelocity			= 18.9,

	script				= "gerfw190.cob", -- TODO: LUS!
	
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
			name				= "mg15115mm",
			maxAngleDif			= 10,
			slaveTo				= 1,
		},	
		[3] = {
			name				= "mg15115mm",
			maxAngleDif			= 10,
			slaveTo				= 1,
		},
		[4] = {
			name				= "mg15115mm",
			maxAngleDif			= 10,
			slaveTo				= 1,
		},
		[5] = {
			name				= "mg15115mm",
			maxAngleDif			= 10,
			slaveTo				= 1,
		},
	},
}


return lowerkeys({
	["SWEJ21A"] = SWEJ21A,
})
