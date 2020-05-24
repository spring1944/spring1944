local RUSSU100 = MediumTank:New(TankDestroyer):New{
	name				= "SU-100",
	description			= "Heavy Tank Destroyer",
	buildCostMetal		= 6000,
	maxDamage			= 3160,
	trackOffset			= 5,
	trackWidth			= 20,

	weapons = {
		[1] = {
			name				= "D10S100mmAP",
			maxAngleDif			= 25,
		},
		[2] = {
			name				= ".50calproof",
		},
	},
	customParams = {
		armor_front			= 75,
		armor_rear			= 45,
		armor_side			= 45,
		armor_top			= 20,
		slope_front			= 49,
		slope_rear			= 48,
		slope_side			= 18,
		maxammo				= 7,
		maxvelocitykmh		= 48,
		killvoicecategory_hardveh	= "RUS/Tank/RUS_TANK_TANKKILL",
		killvoicephasecount	= 3,
		exhaust_fx_name			= "diesel_exhaust",
		normaltex			= "unittextures/RUSSU100_normals.dds",
	},
}

return lowerkeys({
	["RUSSU100"] = RUSSU100,
})
