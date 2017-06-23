local ITA_MC202 = Fighter:New{
	name				= "Macchi MC.202",
	description			= "Light Fighter",
	buildCostMetal		= 3125,
	maxDamage			= 224.7,

	maxAcc				= 0.777,
	maxAileron			= 0.00465,
	maxBank				= 1,
	maxElevator			= 0.004,
	maxPitch			= 1,
	maxRudder			= 0.00375,
	maxVelocity			= 18.9,

	customParams = {
		enginesound			= "fw190b-",
		enginesoundnr		= 12,
		maxFuel				= 90,
		normaltex			= "",
	},

	weapons = {
		[1] = {
			name				= "BredaSafat05",
			maxAngleDif			= 10,
		},
		[2] = {
			name				= "BredaSafat05",
			maxAngleDif			= 10,
			slaveTo				= 1,
		},
		[3] = {
			name				= "BredaSafat03",
			maxAngleDif			= 10,
			slaveTo				= 1,
		},
		[4] = {
			name				= "BredaSafat03",
			maxAngleDif			= 10,
			slaveTo				= 1,
		},
	},
}


return lowerkeys({
	["ITAMC202"] = ITA_MC202,
})
