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
		armour = {
			base = {
				front = {
					thickness		= 19,
					slope			= 44,
				},
				rear = {
					thickness		= 5,
				},
				side = {
					thickness 		= 10,
					slope			= 19,
				},
				top = {
					thickness		= 6,
				},
			},
			turret = {
				front = {
					thickness		= 19,
					slope			= 12,
				},
				rear = {
					thickness		= 19,
					slope			= 19,
				},
				side = {
					thickness 		= 19,
					slope			= 19,
				},
				top = {
					thickness		= 0,
				},
			},
		},
		maxammo				= 15,
		turretturnspeed		= 12, -- manual
		maxvelocitykmh		= 89,
		normaltex			= "unittextures/USM8Greyhound_normals.dds",
	}
}

return lowerkeys({
	["USM8Greyhound"] = USM8Greyhound,
})
