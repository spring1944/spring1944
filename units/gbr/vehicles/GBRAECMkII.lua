local GBRAECMkII = HeavyArmouredCar:New{
	name				= "AEC Armoured Car Mk.II",
	buildCostMetal		= 1550,
	maxDamage			= 1270,
	trackOffset			= 10,
	trackWidth			= 13,
	turnRate			= 405,

	weapons = {
		[1] = {
			name				= "qf6pdr57mmap",
			mainDir				= [[0 16 1]],
			maxAngleDif			= 210,
		},
		[2] = {
			name				= "qf6pdr57mmhe",
			mainDir				= [[0 16 1]],
			maxAngleDif			= 210,
		},
		[3] = {
			name				= "BESA",
		},
		[4] = {
			name				= ".30calproof",
		},
	},
	customParams = {
		armor_front			= 17,
		armor_rear			= 14,
		armor_side			= 25,
		armor_top			= 8,
		slope_front			= 58,
		slope_rear			= -10,
		maxammo				= 10,
		turretturnspeed		= 32, -- 11s for 360
		maxvelocitykmh		= 66,
		normaltex			= "unittextures/GBRAECMkII_normals.dds",
	}
}

return lowerkeys({
	["GBRAECMkII"] = GBRAECMkII,
})
