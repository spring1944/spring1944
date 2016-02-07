Unit('USLVTA4'):Extends('LightTank'):Extends('Amphibian'):Attrs{
	name				= "LVT(A)-4",
	description			= "Amphibious Support Tank",
	buildCostMetal		= 2250,
	maxDamage			= 1814,
	trackOffset			= 5,
	trackWidth			= 18,

	weapons = {
		[1] = {
			name				= "M875mmHE",
		},
		[2] = {
			name				= "M2BrowningAA",
		},
		[3] = {
			name				= ".30calproof",
		},
	},
	customParams = {
		armor_front			= 15,
		armor_rear			= 6,
		armor_side			= 8,
		armor_top			= 6,
		maxammo				= 9,
		maxvelocitykmh		= 40,
	},
}

