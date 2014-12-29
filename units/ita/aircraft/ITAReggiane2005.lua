local ITA_Reggiane2005 = Fighter:New{
	name				= "Reggiane Re.2005",
	buildCostMetal		= 3125,
	maxDamage			= 260,
	maxFuel				= 150,
	
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
	},

	weapons = {
		[1] = {
			name				= "BredaSafat05",
			maxAngleDif			= 10,
			onlyTargetCategory	= "BUILDING INFANTRY SOFTVEH AIR OPENVEH HARDVEH SHIP LARGESHIP DEPLOYED",
		},
		[2] = {
			name				= "BredaSafat05",
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
			name 				= "Medium_Tracer",
		},
		[7] = {
			name				= "Large_Tracer",
		},
	},
}


return lowerkeys({
	["ITAReggiane2005"] = ITA_Reggiane2005,
})
