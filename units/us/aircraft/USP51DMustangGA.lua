local US_P51DMustangGA = AttackFighter:New{
	name				= "P-51D-25 Mustang",
	buildCostMetal		= 3000,
	maxDamage			= 346.5,
		
	maxAcc				= 0.622,
	maxAileron			= 0.0052,
	maxBank				= 0.9,
	maxRudder			= 0.003,
	maxVelocity			= 20.5,

	customParams = {
		enginesound			= "p51b-",
		enginesoundnr		= 16,
		maxammo				= 8,
		normaltex			= "unittextures/USP51MustangGA_normals.png",
	},

	weapons = {
		[1] = {
			name				= "HVARRocket",
			maxAngleDif			= 30,
		},
		[2] = {
			name				= "HVARRocket",
			maxAngleDif			= 30,
			slaveTo				= 1,
		},
		[3] = {
			name				= "m2browningamg",
			maxAngleDif			= 10,
		},
		[4] = {
			name				= "m2browningamg",
			maxAngleDif			= 10,
			slaveTo				= 3,
		},	
		[5] = {
			name				= "m2browningamg",
			maxAngleDif			= 10,
			slaveTo				= 3,
		},
		[6] = {
			name				= "m2browningamg",
			maxAngleDif			= 10,
			slaveTo				= 3,
		},
		[7] = {
			name				= "m2browningamg",
			maxAngleDif			= 10,
			slaveTo				= 3,
		},	
		[8] = {
			name				= "m2browningamg",
			maxAngleDif			= 10,
			slaveTo				= 3,
		},
	},
}


return lowerkeys({
	["USP51DMustangGA"] = US_P51DMustangGA,
})
