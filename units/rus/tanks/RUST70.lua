local RUST70 = LightTank:New{
	name				= "T-70/M42",	
	buildCostMetal		= 1500,
	maxDamage			= 920,
	trackOffset			= 5,
	trackWidth			= 18,

	weapons = {
		[1] = {
			name				= "M1938_20k45mmAP",
			mainDir				= [[0 16 1]],
			maxAngleDif			= 210,
		},
		[2] = {
			name				= "M1938_20k45mmHE",
			mainDir				= [[0 16 1]],
			maxAngleDif			= 210,
		},
		[3] = {
			name				= "DT",
		},
		[4] = {
			name				= ".50calproof",
		},
	},
	customParams = {
		armor_front			= 60,
		armor_rear			= 35,
		armor_side			= 18,
		armor_top			= 10,
		maxammo				= 18,
		maxvelocitykmh		= 45,
		killvoicecategory_hardveh	= "RUS/Tank/RUS_TANK_TANKKILL",
		killvoicephasecount		= 3,
		normaltex			= "unittextures/RUST70_normals.dds",
	},
}

return lowerkeys({
	["RUST70"] = RUST70,
})
