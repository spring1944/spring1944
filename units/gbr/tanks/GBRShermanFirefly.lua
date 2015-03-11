local GBRShermanFirefly = MediumTank:New{
	name				= "Sherman Mk. Vc Firefly",
	description			= "Upgunned Medium Tank",
	acceleration		= 0.043,
	brakeRate			= 0.15,
	buildCostMetal		= 4000,
	maxDamage			= 3270,
	maxReverseVelocity	= 1.48,
	maxVelocity			= 2.96,
	trackOffset			= 5,
	trackWidth			= 18,

	weapons = {
		[1] = {
			name				= "QF17pdrAP",
			mainDir				= [[0 16 1]],
			maxAngleDif			= 210,
		},
		[2] = {
			name				= "QF17pdrHE",
			mainDir				= [[0 16 1]],
			maxAngleDif			= 210,
		},
		[3] = {
			name				= "M1919A4Browning",
		},
		[4] = {
			name				= ".50calproof",
		},
	},
	customParams = {
		armor_front			= 70,
		armor_rear			= 43,
		armor_side			= 41,
		armor_top			= 21,
		maxammo				= 14,
		weaponcost			= 19,
		turretturnspeed		= 24, -- 15s for 360
	},
}

return lowerkeys({
	["GBRShermanFirefly"] = GBRShermanFirefly,
})
