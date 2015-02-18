local SWEStrvM42 = MediumTank:New{
	name				= "Stridsvagn m/42",
	acceleration		= 0.054,
	brakeRate			= 0.15,
	buildCostMetal		= 2400,
	maxDamage			= 2250,
	maxReverseVelocity	= 1.555,
	maxVelocity			= 3.11,
	trackOffset			= 5,
	trackWidth			= 20,

	weapons = {
		[1] = {
			name				= "M375mmAP",
			mainDir				= [[0 16 1]],
			maxAngleDif			= 210,
		},
		[2] = {
			name				= "M375mmHE",
			mainDir				= [[0 16 1]],
			maxAngleDif			= 210,
		},
		[3] = { -- coax 1
			name				= "M1919A4Browning",
		},
		[4] = { -- coax 2
			name				= "M1919A4Browning",
		},
		[5] = {
			name				= ".50calproof",
		},
	},
	customParams = {
		armor_front			= 64,
		armor_rear			= 23,
		armor_side			= 30,
		armor_top			= 9,
		maxammo				= 15,
		weaponcost			= 12,
	},
}

return lowerkeys({
	["SWEStrvM42"] = SWEStrvM42,
})
