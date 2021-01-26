local US_P47Thunderbolt = FighterBomber:New{
	name				= "P47D Thunderbolt",
	buildCostMetal		= 3375,
	maxDamage			= 453.6,

	maxAcc				= 0.723,
	maxAileron			= 0.0044,
	maxBank				= 0.9,
	maxRudder			= 0.0023,
	maxVelocity			= 20.5,

	customParams = {
		enginesound			= "p51b-",
		enginesoundnr		= 16,
		proptexture			= "prop5.tga",
		maxFuel				= 180,
		normaltex			= "unittextures/USP47a_normals.png",
	},

	weapons = {
		[2] = {
			name				= "m2browningamg",
			maxAngleDif			= 10,
		},
		[3] = {
			name				= "m2browningamg",
			maxAngleDif			= 10,
			slaveTo				= 2,
		},
		[4] = {
			name				= "m2browningamg",
			maxAngleDif			= 10,
			slaveTo				= 2,
		},
		[5] = {
			name				= "m2browningamg",
			maxAngleDif			= 10,
			slaveTo				= 2,
		},
		[6] = {
			name				= "m2browningamg",
			maxAngleDif			= 10,
			slaveTo				= 2,
		},
		[7] = {
			name				= "m2browningamg",
			maxAngleDif			= 10,
			slaveTo				= 2,
		},
		[8] = {
			name				= "m2browningamg",
			maxAngleDif			= 10,
			slaveTo				= 2,
		},
		[9] = {
			name				= "m2browningamg",
			maxAngleDif			= 10,
			slaveTo				= 2,
		},
	},
}


return lowerkeys({
	["USP47Thunderbolt"] = US_P47Thunderbolt,
})
