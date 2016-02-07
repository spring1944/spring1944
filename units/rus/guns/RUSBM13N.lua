Unit('RUSBM13N'):Extends('Truck'):Attrs{
	name				= "BM-13N Katyusha",
	description			= "Self-Propelled Rocket Artillery",
	buildCostMetal		= 6800,
	iconType			= "RocketTruck",
	maxDamage			= 573,
	trackOffset			= 4,
	trackWidth			= 11,
	script				= "<NAME>.lua", -- TODO: vehicle.lua

	weapons = {
		[1] = {
			name				= "M13132mm",
			maxAngleDif			= 20,
		},
	},
	customParams = {
		maxammo				= 1,
		maxvelocitykmh		= 69,
	},
}

