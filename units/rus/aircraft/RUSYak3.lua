local RUS_Yak3 = Interceptor:New{
	name				= "Yak-9U",
	buildCostMetal		= 985,
	maxDamage			= 235,
		
	maxAcc				= 0.824,
	maxAileron			= 0.0044,
	maxBank				= 1,
	maxElevator			= 0.0031,
	maxPitch			= 1,
	maxRudder			= 0.0023,
	maxVelocity			= 24,

	customParams = {
		enginesound			= "yakb-",
		enginesoundnr		= 20,
		planevoice			= {
			enter_map		= 'sounds/rus/air/fighter/rus_air_fighter_select.wav',
			return_to_base  = 'sounds/rus/air/rus_air_return.wav',
		},
		normaltex			= "unittextures/RUSYak3_normals.png",
	},

	weapons = {
		[1] = {
			name				= "BeresinUBS",
			maxAngleDif			= 10,
		},
		[2] = {
			name				= "BeresinUBS",
			maxAngleDif			= 10,
			slaveTo				= 1,
		},	
		[3] = {
			name				= "ShVAK20mm",
			maxAngleDif			= 10,
			slaveTo				= 1,
		},
	},
}


return lowerkeys({
	["RUSYak3"] = RUS_Yak3,
})
