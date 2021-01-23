local ITA_FiatCR42 = Fighter:New{
	name				= "Fiat CR.42 Falco",
	description			= "Lowaltitude Light Attack Aircraft",
	buildCostMetal		= 1175,
	noChaseCategory		= "FLAG MINE OPENVEH HARDVEH BUILDING",
	maxDamage			= 240,
	cruiseAlt			= 750,
	sightDistance			= 600,

	maxAcc				= 0.625,
	maxAileron			= 0.0055,
	maxBank				= 1.1,
	maxElevator			= 0.0064,
	maxPitch			= 1,
	maxRudder			= 0.005,
	maxVelocity			= 16.3,

	customParams = {
		enginesound			= "po2-",
		enginesoundnr		= 11,
		maxFuel				= 95,

		normaltex			= "unittextures/ITAFiatCR42_normals.png",
	},

	weapons = {
		[1] = {
			name				= "TypeF12kg",
			maxAngleDif			= 10,
		},
		[2] = {
			name				= "TypeF12kg",
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
