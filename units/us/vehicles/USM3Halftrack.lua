Unit('USM3Base'):Extends('Vehicle'):Attrs{
	maxDamage				= 930,
	trackOffset				= 10,
	trackWidth				= 15,
	
	customParams = {
		armor_front				= 9,
		armor_rear				= 8,
		armor_side				= 8,
		armor_top				= 8,
		normaltex				= "unittextures/gbrm5halftrack_normals.dds",
		maxvelocitykmh			= 72,
	},
}

Unit('USM3Halftrack'):Extends('USM3Base'):Extends('HalfTrack'):Attrs{
	name					= "M3A1 Halftrack",
	buildCostMetal			= 1200,
	
	weapons = {
		[1] = {
			name					= "M2Browning",
		},
		[2] = {
			name					= "M2BrowningAA",
		},
	},
}


Unit('USM16MGMC'):Extends('USM3Base'):Extends('ArmouredCarAA'):Attrs{
	name					= "M16 MGMC",
	buildCostMetal			= 990,
	corpse					= "usm3halftrack_destroyed", -- TODO: M16 corpse

	weapons = {
		[1] = {
			name					= "M2BrowningAA",
		},
		[2] = { -- Need to be interlaced with AA to use same flares
			name					= "M2Browning",
		},
		[3] = {
			name					= "M2BrowningAA",
		},
		[4] = {
			name					= "M2Browning",
		},
		[5] = {
			name					= "M2BrowningAA",
		},
		[6] = {
			name					= "M2BrowningAA",
		},
	},
}



-- Lend Lease
Unit('GBRM5Halftrack'):Extends('USM3Halftrack'):Attrs{name = "M5A1 Halftrack"}
Unit('RUSM5Halftrack'):Extends('USM3Halftrack'):Attrs{name = "M5A1 Halftrack"}

