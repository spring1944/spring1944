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
	maxVelocity			= 24,

	customParams = {
		enginesound			= "yakb-",
		enginesoundnr		= 20,
		planevoice			= {
			enter_map		= 'sounds/rus/air/fighter/rus_air_fighter_select.wav',
			return_to_base  = 'sounds/rus/air/rus_air_return.wav',
		},
		normaltex			= "unittextures/RUSLa5FN1_normalspng",
	},

	weapons = {
		[1] = {
			name				= "ShVAK20mm",
			maxAngleDif			= 10,
		},
		[2] = {
			name				= "ShVAK20mm",
			maxAngleDif			= 10,
			slaveTo				= 1,
		},	
	},
}


return lowerkeys({
	["RUSLa5FN"] = RUS_La5FN,
})
