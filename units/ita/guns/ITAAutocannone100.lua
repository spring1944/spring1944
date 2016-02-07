Unit('ITAAutocannone100'):Extends('Truck'):Extends('SPArty'):Attrs{
	name				= "Autocannone da 100/17",
	buildCostMetal		= 3750,
	maxDamage			= 650,
	trackOffset			= 5,
	trackWidth			= 19,

	weapons = {
		[1] = {
			name				= "Obice100mmL17HE",
		},
	},
	customParams = {
		maxammo				= 8,
		maxvelocitykmh		= 45,
	},
}

