local SWE_B17A = Fighter:New{ -- based on JPN Ki 51
	name				= "SAAB B 17A",
	description			= "Light Bomber",
	buildCostMetal		= 2175, -- shared with CR.42
	maxDamage			= 240, -- shared with CR.42
	maxFuel				= 105,
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
	},

	weapons = {
		[1] = {
			name				= "bomb", -- 250kg
			maxAngleDif			= 10,
		},
		[2] = {
			name				= "bomb50kg",
			maxAngleDif			= 10,
		},
		[3] = {
			name				= "bomb50Kg",
			maxAngleDif			= 10,
			slaveTo				= 2,
		},	
		[4] = {
			name				= "bomb50kg",
			maxAngleDif			= 10,
		},
		[5] = {
			name				= "bomb50Kg",
			maxAngleDif			= 10,
			slaveTo				= 4,
		},	
		[6] = {
			name				= "mg42aa",
			maxAngleDif			= 10,
		},
		[7] = {
			name				= "mg42aa",
			maxAngleDif			= 10,
			slaveTo				= 6,
		},
		[8] = {
			name				= "mg42aa",
			maxAngleDif			= 50,
			mainDir				= [[0 1 -1]],
		},
	},
}


return lowerkeys({
	["SWEB17A"] = SWE_B17A,
})
