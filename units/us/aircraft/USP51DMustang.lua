local US_P51DMustang = Fighter:New{
	name				= "P-51D Mustang",
	buildCostMetal		= 1080,
	maxDamage			= 346.5,
		
	maxAcc				= 0.622,
	maxAileron			= 0.0055,
	maxBank				= 1,
	maxElevator			= 0.0043,
	maxPitch			= 1,
	maxRudder			= 0.0035,
	maxVelocity			= 24,

	customParams = {
		enginesound			= "p51b-",
		enginesoundnr		= 16,
		normaltex			= "unittextures/USP51DMustang_normals.png",
	},

	weapons = {
		[1] = {
			name				= "m2browningamg",
			maxAngleDif			= 10,
		},
		[2] = {
			name				= "m2browningamg",
			maxAngleDif			= 10,
			slaveTo				= 1,
		},	
		[3] = {
			name				= "m2browningamg",
			maxAngleDif			= 10,
			slaveTo				= 1,
		},
		[4] = {
			name				= "m2browningamg",
			maxAngleDif			= 10,
			slaveTo				= 1,
		},
		[5] = {
			name				= "m2browningamg",
			maxAngleDif			= 10,
			slaveTo				= 1,
		},
		[6] = {
			name				= "m2browningamg",
			maxAngleDif			= 10,
			slaveTo				= 1,
		},
	},
}


return lowerkeys({
	["USP51DMustang"] = US_P51DMustang,
})
