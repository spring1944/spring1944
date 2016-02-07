Unit('RUSSU76'):Extends('LightTank'):Extends('AssaultGun'):Extends('OpenTopped'):Attrs{
	name				= "SU-76",
	buildCostMetal		= 1740,
	maxDamage			= 1120,
	trackOffset			= 3,
	trackWidth			= 19,

	weapons = {
		[1] = {
			name				= "ZiS376mmAP",
			maxAngleDif			= 12,
		},
		[2] = {
			name				= "ZiS376mmHE",
			maxAngleDif			= 12,
		},
		[3] = {
			name				= ".50calproof",
		},
	},
	customParams = {
		armor_front			= 29,
		armor_rear			= 17,
		armor_side			= 12,
		armor_top			= 7,
		maxammo				= 11,
		maxvelocitykmh		= 45,
		killvoicecategory_hardveh	= "RUS/Tank/RUS_TANK_TANKKILL",
		killvoicephasecount	= 3,
	},
}

