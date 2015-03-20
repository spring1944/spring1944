local RUST3485 = MediumTank:New{
	name				= "T-34-85",
	acceleration		= 0.052,
	brakeRate			= 0.15,
	buildCostMetal		= 4110,
	maxDamage			= 3200,
	trackOffset			= 5,
	trackWidth			= 20,

	weapons = {
		[1] = {
			name				= "S5385mmAP",
			mainDir				= [[0 16 1]],
			maxAngleDif			= 210,
		},
		[2] = {
			name				= "S5385mmHE",
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
		armor_front			= 90,
		armor_rear			= 59,
		armor_side			= 56,
		armor_top			= 20,
		maxammo				= 11,
		weaponcost			= 17,
		turretturnspeed		= 17, -- 21.1s for 360
		maxvelocitykmh		= 48,
	},
}

return lowerkeys({
	["RUST3485"] = RUST3485,
})
