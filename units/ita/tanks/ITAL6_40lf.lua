local ITAL6_40lf = LightTank:New{
	name				= "L6/40 Lancia Flamme",
	description			= "Light Flamethrower Tank",
	buildCostMetal		= 1350,
	maxDamage			= 640,
	trackOffset			= 5,
	trackWidth			= 18,

	weapons = {
		[1] = {
			name				= "L6Lanciafiamme",
			mainDir				= [[0 16 1]],
			maxAngleDif			= 210,
		},
		[2] = {
			name				= ".30calproof",
		},
	},
	customParams = {
		armor_front			= 30,
		armor_rear			= 15,
		armor_side			= 15,
		armor_top			= 10,
		slope_front			= 11,
		slope_rear			= 1,
		slope_side			= 11,
		maxammo				= 8,
		weapontoggle		= "false",
		maxvelocitykmh		= 42,

	},
}

return lowerkeys({
	["ITAL6_40lf"] = ITAL6_40lf,
})
