local GBRWasp = ArmouredCar:New{
	name				= "Wasp Mk.II",
	description			= "Universal Carrier Flamethrower",
	buildCostMetal		= 1100,
	iconType			= "flametank",
	maxDamage			= 431,
	trackOffset			= 10,
	trackWidth			= 13,

	weapons = {
		[1] = {
			name				= "waspflamethrower",
			maxAngleDif			= 15,
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
		normaltex			= "",
	}
}

return lowerkeys({
	["GBRWasp"] = GBRWasp,
})
