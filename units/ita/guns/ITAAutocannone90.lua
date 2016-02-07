Unit('ITAAutocannone90'):Extends('Truck'):Extends('TankDestroyer'):Attrs{
	name				= "Autocannone 90/53 su Lancia 3Ro",
	description			= "Self-Propelled AT Gun",
	buildCostMetal		= 2950,
	maxDamage			= 800,
	trackOffset			= 5,
	trackWidth			= 19,

	weapons = {
		[1] = {
			name				= "Ansaldo90mmL53AP",
			maxAngleDif			= 175,
		},
	},
	customParams = {
		maxammo				= 5,
		maxvelocitykmh		= 45,
	},
}

