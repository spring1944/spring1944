local GER_Fw190 = Fighter:New{
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

	customParams = {
		enginesound			= "fw190b-",
		enginesoundnr		= 12,
	},

	weapons = {
		[1] = {
			name				= "mg15115mm",
			maxAngleDif			= 10,
			onlyTargetCategory	= "BUILDING INFANTRY SOFTVEH AIR OPENVEH HARDVEH SHIP LARGESHIP DEPLOYED",
		},
		[2] = {
			name				= "mg15115mm",
			maxAngleDif			= 10,
			slaveTo				= 1,
		},	
		[3] = {
			name				= "MG15120mm",
			maxAngleDif			= 10,
			slaveTo				= 1,
		},
		[4] = {
			name				= "MG15120mm",
			maxAngleDif			= 10,
			slaveTo				= 1,
		},
		[5] = {
			name				= "MG15120mm",
			maxAngleDif			= 10,
			slaveTo				= 1,
		},
		[6] = {
			name				= "MG15120mm",
			maxAngleDif			= 10,
			slaveTo				= 1,
		},
		[7] = {
			name 				= "Medium_Tracer",
		},
		[8] = {
			name				= "Large_Tracer",
		},
	},
}


return lowerkeys({
	["GERFw190"] = GER_Fw190,
})
