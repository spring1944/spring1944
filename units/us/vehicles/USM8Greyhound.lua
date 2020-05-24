local USM8Greyhound = ArmouredCar:New{
	name				= "M8 Greyhound",
	buildCostMetal		= 1260,
	acceleration		= 0.06,
	maxDamage			= 780,
	trackOffset			= 10,
	trackWidth			= 13,
	brakeRate			= 0.54,
	turnrate			= 600,
	movementClass		= "TANK_6pluswheels",

	weapons = {
		[1] = {
			name				= "M637mmap",
			mainDir				= [[0 16 1]],
			maxAngleDif			= 210,
		},
		[2] = {
			name				= "M637mmhe",
			mainDir				= [[0 16 1]],
			maxAngleDif			= 210,
		},
		[3] = {
			name				= "M1919A4Browning",
			mainDir				= [[0 16 1]],
			maxAngleDif			= 210,
		},
		[4] = {
			name				= "M2BrowningAA",
		},
		[5] = {
			name				= ".30calproof",
		},
	},
	customParams = {
		armor_front			= 13,
		armor_rear			= 5,
		armor_side			= 10,
		armor_top			= 6,
		slope_front			= 59,
		slope_side			= 19,
		maxammo				= 15,
		turretturnspeed		= 12, -- manual
		maxvelocitykmh		= 89,
		normaltex			= "unittextures/USM8Greyhound_normals.dds",
	}
}

return lowerkeys({
	["USM8Greyhound"] = USM8Greyhound,
})
