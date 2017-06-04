local ITA_MC200 = Fighter:New{
	name				= "Macchi MC.200 CB",
	description			= "Attack Fighter",
	buildCostMetal		= 2375,
	maxDamage			= 210,

	maxAcc				= 0.782,
	maxAileron			= 0.0054,
	maxBank				= 0.9,
	maxRudder			= 0.003,
	maxVelocity			= 16.5,

	customParams = {
		enginesound			= "yakb-",
		enginesoundnr		= 20,
		maxammo				= 2,
		maxFuel				= 60,
	},

	weapons = {
		[1] = {
			name				= "A_tkbomb",
			maxAngleDif			= 10,
		},
		[2] = {
			name				= "lastA_tkbomb",
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
