local GER_Fw190G = FighterBomber:New{
	name				= "Fw 190F-8",
	buildCostMetal		= 3375,
	maxDamage			= 320,
		
	maxAcc				= 0.685,
	maxAileron			= 0.0054,
	maxBank				= 0.9,
	maxRudder			= 0.003,
	maxVelocity			= 17.5,

	customParams = {
		enginesound			= "fw190b-",
		enginesoundnr		= 12,
		normaltex			= "",
	},

	weapons = {
		[2] = {
			name				= "mg15115mm",
			maxAngleDif			= 10,
		},
		[3] = {
			name				= "mg15115mm",
			maxAngleDif			= 10,
			slaveTo				= 2,
		},	
		[4] = {
			name				= "MG15120mm",
			maxAngleDif			= 10,
			slaveTo				= 2,
		},
		[5] = {
			name				= "MG15120mm",
			maxAngleDif			= 10,
			slaveTo				= 2,
		},
	},
}


return lowerkeys({
	["GERFw190G"] = GER_Fw190G,
})
