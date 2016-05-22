local GBRJeep = ArmouredCar:New{
	name				= "Jeep",
	description			= "Light Scout Car",
	buildCostMetal		= 1100,
	maxDamage			= 100,
	trackOffset			= 4,
	trackWidth			= 11,
	turnRate			= 425,
	iconType			= "jeep",


	weapons = {
		[1] = {
			name				= "binocs2",
			mainDir				= [[0 0 1]],
			maxAngleDif			= 20,
		},
	},
	customParams = {
		maxvelocitykmh		= 85,
	}
}

return lowerkeys({
	["GBRJeep"] = GBRJeep,
})
