local GBRM10Achilles = OpenTankDestroyer:New{
	name				= "17pdr SP. Achilles Ic",
	description			= "Upgunned Tank Destroyer",
	acceleration		= 0.046,
	brakeRate			= 0.15,
	buildCostMetal		= 2400,
	maxDamage			= 2960,
	maxReverseVelocity	= 1.48,
	maxVelocity			= 2.96,
	trackOffset			= 5,
	trackWidth			= 18,
	turnRate			= 280,

	weapons = {
		[1] = {
			name				= "QF17pdrAP",
			mainDir				= [[0 16 1]],
			maxAngleDif			= 210,
		},
		[2] = {
			name				= "M2BrowningAA",
		},
		[3] = {
			name				= ".50calproof",
		},
	},
	customParams = {
		armor_front			= 60,
		armor_rear			= 25,
		armor_side			= 25,
		armor_top			= 19,
		maxammo				= 10,
		weaponcost			= 19,
	},
}

return lowerkeys({
	["GBRM10Achilles"] = GBRM10Achilles,
})
