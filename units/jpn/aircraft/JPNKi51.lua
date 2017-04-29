local JPN_Ki51 = Fighter:New{
	name				= "Ki. 51 (Type 99) Assault Plane",
	description			= "Ground-Attack Aircraft",
	buildCostMetal		= 2175, -- shared with CR.42
	maxDamage			= 240, -- shared with CR.42
	cruiseAlt			= 1500,
	iconType			= "bomber",

	maxAcc				= 0.581,
	maxAileron			= 0.0055,
	maxBank				= 1.1,
	maxElevator			= 0.0044,
	maxPitch			= 1,
	maxRudder			= 0.005,
	maxVelocity			= 13.3,

	customParams = {
		enginesound			= "po2-",
		enginesoundnr		= 11,
		maxFuel				= 105,
	},

	weapons = {
		[1] = { -- first 2 are same as CR.42
			name				= "bomb50kg",
			maxAngleDif			= 10,
		},
		[2] = {
			name				= "bomb50Kg",
			maxAngleDif			= 10,
            slaveTo             = 1,
		},
		[3] = {
			name				= "bomb50kg",
			maxAngleDif			= 10,
            slaveTo             = 1,
		},
		[4] = {
			name				= "lastbomb50Kg",
			maxAngleDif			= 10,
            slaveTo             = 1,
		},
		[5] = {
			name				= "Type1Ho103",
			maxAngleDif			= 10,
		},
		[6] = {
			name				= "Type1Ho103",
			maxAngleDif			= 10,
			slaveTo				= 5,
		},
		[7] = {
			name				= "Te4",
			maxAngleDif			= 70,
			mainDir				= [[0 1 -9]],
		},
	},
}


return lowerkeys({
	["JPNKi51"] = JPN_Ki51,
})
