local ITA_MC200 = Fighter:New{
	name				= "Macchi MC.200 CB",
	description			= "Attack Fighter",
	buildCostMetal		= 2375,
	maxDamage			= 210,
	maxFuel				= 60,
	
	maxAcc				= 0.782,
	maxAileron			= 0.0054,
	maxBank				= 0.9,
	maxElevator			= 0.0042,
	maxPitch			= 1,
	maxRudder			= 0.003,
	maxVelocity			= 16.5,

	customParams = {
		enginesound			= "yakb-",
		enginesoundnr		= 20,
		maxmmo				= 2,
	},

	weapons = {
		[1] = {
			name				= "A_tkbomb",
			maxAngleDif			= 10,
		},
		[2] = {
			name				= "A_tkbomb",
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
	},
}


return lowerkeys({
	["ITAMC200"] = ITA_MC200,
})
