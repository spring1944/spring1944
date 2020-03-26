local JPN_Ki102 = AttackFighter:New(ArmouredPlane):New{
	name				= "Ki-102b (Type 4) Assault Plane",
	description			= "Anti-Tank Aircraft",
	buildCostMetal		= 985,
	maxDamage			= 495,
	cruiseAlt			= 1250,
	radarDistance		= 1200,
	iconType			= "bomber",

	maxAcc				= 0.702,
	maxAileron			= 0.00375,
	maxBank				= 0.9,
	maxRudder			= 0.0025,
	maxVelocity			= 16.8,

	customParams = {
		enginesound			= "yakb-",
		enginesoundnr		= 20,
		maxammo				= 18,
		maxFuel				= 160,

	},

	weapons = {
		[1] = {
			name				= "Ho40157mm",
			maxAngleDif			= 15,
			mainDir				= [[0 -1 16]],
		},
		[2] = {
			name				= "Ho520mmAP",
			maxAngleDif			= 10,
			mainDir				= [[0 -1 16]],
		},
		[3] = {
			name				= "Ho520mmAP",
			maxAngleDif			= 10,
			mainDir				= [[0 -1 16]],
			slaveTo				= 2, 
		},
		[4] = {
			name				= "Type93AA",
			maxAngleDif			= 90,
			mainDir				= [[0 .25 -1]],
		},
	},
}


return lowerkeys({
	["JPNKi102"] = JPN_Ki102,
})
