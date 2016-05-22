local JPNKurogane = ArmouredCar:New{
	name				= "Kurogane",
	description			= "Light Scout Car",
	buildCostMetal		= 1100,
	maxDamage			= 150,
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
		maxvelocitykmh		= 80,
		damageGroup		= "unarmouredVehicles",
	}
}

return lowerkeys({
	["JPNKurogane"] = JPNKurogane,
})
