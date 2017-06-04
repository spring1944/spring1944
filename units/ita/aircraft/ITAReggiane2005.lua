local ITA_Reggiane2005 = Fighter:New{
	name				= "Reggiane Re.2005",
	buildCostMetal		= 3125,
	maxDamage			= 260,

	maxAcc				= 0.792,
	maxAileron			= 0.007,
	maxBank				= 1,
	maxElevator			= 0.006,
	maxPitch			= 1,
	maxRudder			= 0.004,
	maxVelocity			= 19.6,

	customParams = {
		enginesound			= "fw190b-",
		enginesoundnr		= 12,
		maxFuel				= 150,
	},

	weapons = {
		[1] = {
			name				= "BredaSafat05",
			maxAngleDif			= 10,
		},
		[2] = {
			name				= "BredaSafat05",
			maxAngleDif			= 10,
		},
		[3] = {
			name				= "MG15120mm",
			maxAngleDif			= 10,
		},
		[4] = {
			name				= "MG15120mm",
			maxAngleDif			= 10,
			slaveTo				= 3,
		},
		[5] = {
			name				= "MG15120mm",
			maxAngleDif			= 10,
			slaveTo				= 3,
		},
	},
}


return lowerkeys({
	["ITAReggiane2005"] = ITA_Reggiane2005,
})
