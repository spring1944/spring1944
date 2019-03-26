local SWE_B17A = Fighter:New{ 
	name				= "SAAB B 17A",
	description			= "Light Bomber",
	buildCostMetal		= 2175, -- shared with CR.42
	maxDamage			= 397, 
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
		maxammo				= 5,
		maxFuel				= 105,

	},

	weapons = {
		[1] = {
			name				= "bomb250kg", 
			maxAngleDif			= 5,
		},
		[2] = {
			name				= "bomb50kg",
			maxAngleDif			= 15,
		},
		[3] = {
			name				= "bomb50Kg",
			maxAngleDif			= 15,
			slaveTo				= 2,
		},
		[4] = {
			name				= "bomb50kg",
			maxAngleDif			= 15,
			slaveTo				= 2,
		},
		[5] = {
			name				= "lastbomb50Kg",
			maxAngleDif			= 15,
			slaveTo				= 2,
		},
		[6] = {
			name				= "ksp_m1936AMG",
			maxAngleDif			= 10,
		},
		[7] = {
			name				= "ksp_m1936AMG",
			maxAngleDif			= 10,
			slaveTo				= 6,
		},
		[8] = {
			name				= "ksp_m1936AA",
			maxAngleDif			= 90,
			mainDir				= [[0 .25 -1]],
		},
	},
}


return lowerkeys({
	["SWEB17A"] = SWE_B17A,
})
