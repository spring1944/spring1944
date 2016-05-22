local HUNFiat508CM = ArmouredCar:New{
	name				= "Fiat508CM",
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
	["HUNFiat508CM"] = HUNFiat508CM,
})
