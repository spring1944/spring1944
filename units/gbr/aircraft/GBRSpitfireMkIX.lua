local GBR_SpitfireMkIX = FighterBomber:New{
	name				= "Spitfire Mk IXe LF",
	buildCostMetal		= 3375,
	cruiseAlt			= 750,
	maxDamage			= 254.5,
		
	maxAcc				= 0.622,
	maxAileron			= 0.006,
	maxBank				= 0.9,
	maxElevator			= 0.005,
	maxPitch			= 1,
	maxRudder			= 0.004,
	maxVelocity			= 12.6,

	turnRate			= 24,

	customParams = {
		enginesound			= "spitfireb-",
		enginesoundnr		= 18,
	},

	weapons = {
		[2] = {
			name				= "m2browningamg",
			maxAngleDif			= 10,
			onlyTargetCategory	= "BUILDING INFANTRY SOFTVEH AIR OPENVEH HARDVEH SHIP LARGESHIP DEPLOYED",
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
		[6] = {
			name 				= "Medium_Tracer",
		},
		[7] = {
			name				= "Large_Tracer",
		},
	},
}


return lowerkeys({
	["GBRSpitfireMkIX"] = GBR_SpitfireMkIX,
})
