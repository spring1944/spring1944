Unit('GBRM10Achilles'):Extends('MediumTank'):Extends('TankDestroyer'):Extends('OpenTopped'):Attrs{
	name				= "17pdr SP Achilles Ic",
	description			= "Upgunned Tank Destroyer",
	buildCostMetal		= 2400,
	maxDamage			= 2960,
	trackOffset			= 5,
	trackWidth			= 18,
	turnRate			= 280,

	weapons = {
		[1] = {
			name				= "QF17pdrAP",
			mainDir				= [[0 16 1]],
			maxAngleDif			= 210,
		},
		[2] = {
			name				= "M2BrowningAA",
		},
		[3] = {
			name				= ".50calproof",
		},
	},
	customParams = {
		armor_front			= 60,
		armor_rear			= 25,
		armor_side			= 25,
		armor_top			= 19,
		maxammo				= 10,
		turretturnspeed		= 8, -- Manual traverse 45s
		maxvelocitykmh		= 51,
	},
}

