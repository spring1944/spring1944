local RUS_La5FN = Fighter:New{
	name				= "La-5FN",
	buildCostMetal		= 1125,
	maxDamage			= 260.5,
		
	maxAcc				= 0.990,
	maxAileron			= 0.0055,
	maxBank				= 1,
	maxElevator			= 0.0043,
	maxPitch			= 1,
	maxRudder			= 0.0035,
	maxVelocity			= 21,

	customParams = {
		enginesound			= "yakb-",
		enginesoundnr		= 20,
		planevoice			= 1,
	},

	weapons = {
		[1] = {
			name				= "ShVAK20mm",
			maxAngleDif			= 10,
			onlyTargetCategory	= "BUILDING INFANTRY SOFTVEH AIR OPENVEH HARDVEH SHIP LARGESHIP DEPLOYED",
		},
		[2] = {
			name				= "ShVAK20mm",
			maxAngleDif			= 10,
			slaveTo				= 1,
		},	
		[3] = {
			name				= "Large_Tracer_Green",
		},
	},
}


return lowerkeys({
	["RUSLa5FN"] = RUS_La5FN,
})
