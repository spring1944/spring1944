local JPN_Ki84 = Fighter:New{
	name				= "Ki.84 Hayate",
	buildCostMetal		= 3125,
	maxDamage			= 260,

	maxAcc				= 0.937,
	maxAileron			= 0.0051,
	maxBank				= 1,
	maxElevator			= 0.0039,
	maxPitch			= 1,
	maxRudder			= 0.0035,
	maxVelocity			= 23.6,

	customParams = {
		enginesound			= "fw190b-",
		enginesoundnr		= 12,
		maxFuel				= 150,
		normaltex			= "unittextures/JPNKi84_normals.png",
	},

	weapons = {
		[1] = {
			name				= "Type1Ho103",
			maxAngleDif			= 10,
		},
		[2] = {
			name				= "Type1Ho103",
			maxAngleDif			= 10,
			slaveTo				= 1,
		},
		[3] = {
			name				= "Ho520mmHE",
			maxAngleDif			= 10,
			slaveTo				= 1,
		},
		[4] = {
			name				= "Ho520mmHE",
			maxAngleDif			= 10,
			slaveTo				= 1,
		},
	},
}


return lowerkeys({
	["JPNKi84"] = JPN_Ki84,
})
