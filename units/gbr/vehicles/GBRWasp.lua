local GBRWasp = ArmouredCar:New{
	name				= "Wasp Mk.II",
	description			= "Universal Carrier Flamethrower",
	buildCostMetal		= 935,
	iconType			= "flametank",
	maxDamage			= 431,
	trackOffset			= 10,
	trackWidth			= 13,
	movementClass		= "TANK_Light", -- tracked so should be better at slopes than wheeled light AFVs

	weapons = {
		[1] = {
			name				= "waspflamethrower",
			maxAngleDif			= 15,
			mainDir				= [[0 0.05 1]],
		},
		[2] = {
			name				= ".30calproof",
		},
	},
	customParams = {
		armor_front			= 10,
		armor_rear			= 8,
		armor_side			= 8,
		armor_top			= 0,
		maxammo				= 7,
		maxvelocitykmh		= 48,

	}
}

return lowerkeys({
	["GBRWasp"] = GBRWasp,
})
