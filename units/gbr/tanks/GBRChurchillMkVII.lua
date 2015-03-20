local GBRChurchillMkVII = HeavyTank:New{
	name				= "A22F Churchill Mk. VII",
	description			= "Heavily Armoured Support Tank",
	acceleration		= 0.029,
	brakeRate			= 0.105,
	buildCostMetal		= 5800,
	maxDamage			= 4060,
	movementClass		= "TANK_Goat",
	trackOffset			= 5,
	trackWidth			= 18,

	weapons = {
		[1] = {
			name				= "QF75mmAP",
			mainDir				= [[0 16 1]],
			maxAngleDif			= 210,
		},
		[2] = {
			name				= "QF75mmHE",
			mainDir				= [[0 16 1]],
			maxAngleDif			= 210,
		},
		[3] = {
			name				= "BESA",
		},
		[4] = {
			name				= ".50calproof",
		},
	},
	customParams = {
		armor_front			= 148,
		armor_rear			= 57,
		armor_side			= 75,
		armor_top			= 19,
		maxammo				= 14,
		weaponcost			= 12,
		turretturnspeed		= 24, -- 15s for 360
		maxvelocitykmh		= 24,
	},
}

return lowerkeys({
	["GBRChurchillMkVII"] = GBRChurchillMkVII,
})
