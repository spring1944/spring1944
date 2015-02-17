local RUSIS2 = HeavyTank:New{
	name				= "IS-2 M1944",
	acceleration		= 0.043,
	brakeRate			= 0.105,
	buildCostMetal		= 11400,
	maxDamage			= 4600,
	maxReverseVelocity	= 1.37,
	maxVelocity			= 2.74,
	trackOffset			= 5,
	trackWidth			= 22,

	weapons = {
		[1] = {
			name				= "D25122mmAP",
			mainDir				= [[0 16 1]],
			maxAngleDif			= 210,
		},
		[2] = {
			name				= "D25122mmHE",
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
		armor_front			= 117,
		armor_rear			= 85,
		armor_side			= 93,
		armor_top			= 30,
		maxammo				= 5,
		weaponcost			= 27,
	},
}

return lowerkeys({
	["RUSIS2"] = RUSIS2,
})
