local ITA_FiatCR42 = Fighter:New{
	name				= "Fiat CR.42 Falco",
	description			= "Light Attack Aircraft",
	buildCostMetal		= 2175,
	maxDamage			= 240,
	maxFuel				= 95,
	cruiseAlt			= 1200,
		
	maxAcc				= 0.625,
	maxAileron			= 0.0055,
	maxBank				= 1.1,
	maxElevator			= 0.0064,
	maxPitch			= 1,
	maxRudder			= 0.005,
	maxVelocity			= 13.3,

	customParams = {
		enginesound			= "po2-",
		enginesoundnr		= 11,
	},

	weapons = {
		[1] = {
			name				= "bomb50kg",
			maxAngleDif			= 10,
		},
		[2] = {
			name				= "bomb50Kg",
			maxAngleDif			= 10,
		},	
		[3] = {
			name				= "BredaSafat05",
			maxAngleDif			= 10,
		},
		[4] = {
			name				= "BredaSafat05",
			maxAngleDif			= 10,
			slaveTo				= 3,
		},
		[5] = {
			name				= "BredaSafat03",
			maxAngleDif			= 10,
			slaveTo				= 3,
		},
		[6] = {
			name				= "BredaSafat03",
			maxAngleDif			= 10,
			slaveTo				= 3,
		},
	},
}


return lowerkeys({
	["ITAFiatCR42"] = ITA_FiatCR42,
})
