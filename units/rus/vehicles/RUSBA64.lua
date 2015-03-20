local RUSBA64 = ArmouredCar:New{
	name				= "BA-64",
	description			= "Light Scout Car",
	acceleration		= 0.03,
	brakeRate			= 0.09,
	buildCostMetal		= 525,
	maxDamage			= 245,
	trackOffset			= 4,
	trackWidth			= 11,
	turnRate			= 425,

	weapons = {
		[1] = {
			name				= "DT",
			mainDir				= [[0 16 1]],
			maxAngleDif			= 220,
		},
	},
	customParams = {
		armor_front			= 15,
		armor_rear			= 4,
		armor_side			= 6,
		armor_top			= 4,
		maxvelocitykmh		= 80,
	}
}

return lowerkeys({
	["RUSBA64"] = RUSBA64,
})
