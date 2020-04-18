local GER_Ju87G = AttackFighter:New{
	name				= "Ju-87G-1 Stuka",
	description			= "Anti-Tank Aircraft",
	buildCostMetal		= 1800,
	maxDamage			= 360,
	cruiseAlt			= 1500,
		
	maxAcc				= 0.416,
	maxAileron			= 0.00375,
	maxBank				= 1,
	maxRudder			= 0.0015,
	maxVelocity			= 16.8,

	customParams = {
		enginesound			= "stukab-",
		enginesoundnr		= 12,
		maxammo				= 15,

	},

	weapons = {
		[1] = {
			name				= "bk37mmap",
			maxAngleDif			= 10,
			mainDir				= [[0 0 9]],
		},
		[2] = {
			name				= "bk37mmap",
			maxAngleDif			= 10,
			mainDir				= [[0 0 9]],
			slaveTo				= 1,
		},	
		[3] = {
			name				= "mg42aa",
			maxAngleDif			= 90,
			mainDir				= [[0 .25 -1]],
		},
		[4] = {
			name				= "mg42aa",
			maxAngleDif			= 90,
			mainDir				= [[0 .25 -1]],
			slaveTo				= 3,
		},
		[5] = {
			name				= "mg15115mm",
			mainDir				= [[0 0 9]],
			maxAngleDif			= 25,
		},
		[6] = {
			name				= "mg15115mm",
			maxAngleDif			= 25,
			mainDir				= [[0 0 9]],
			slaveTo				= 5,
		},
	},
}


return lowerkeys({
	["GERJu87G"] = GER_Ju87G,
})
