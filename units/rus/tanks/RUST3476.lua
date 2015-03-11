local RUST3476 = MediumTank:New{
	name				= "T-34-76",
	acceleration		= 0.054,
	brakeRate			= 0.15,
	buildCostMetal		= 2400,
	maxDamage			= 3090,
	maxReverseVelocity	= 2.035,
	maxVelocity			= 4.07,
	trackOffset			= 5,
	trackWidth			= 20,

	weapons = {
		[1] = {
			name				= "F3476mmAP",
			mainDir				= [[0 16 1]],
			maxAngleDif			= 210,
		},
		[2] = {
			name				= "F3476mmHE",
			mainDir				= [[0 16 1]],
			maxAngleDif			= 210,
		},
		[3] = {
			name				= "DT",
		},
		[4] = {
			name				= ".50calproof",
		},
	},
	customParams = {
		armor_front			= 67,
		armor_rear			= 60,
		armor_side			= 52,
		armor_top			= 20,
		maxammo				= 19,
		weaponcost			= 12,
		turretturnspeed		= 26.5, -- 13.6s for 360
	},
}

return lowerkeys({
	["RUST3476"] = RUST3476,
})
