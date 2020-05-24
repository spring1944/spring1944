local GBRM10Achilles = MediumTank:New(TankDestroyer):New(OpenTopped):New{
	name				= "17pdr SP Achilles Ic",
	description			= "Upgunned Tank Destroyer",
	buildCostMetal		= 2400,
	maxDamage			= 2960,
	trackOffset			= 5,
	trackWidth			= 18,

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
		armor_front			= 38,
		armor_rear			= 25,
		armor_side			= 19,
		armor_top			= 19,
		slope_front			= 55,
		slope_rear			= 28,
		slope_side			= 38,
		maxammo				= 10,
		turretturnspeed		= 10, -- Manual traverse 45s
		maxvelocitykmh		= 51,
		normaltex			= "unittextures/GBRShermans_normals.dds",
	},
}

return lowerkeys({
	["GBRM10Achilles"] = GBRM10Achilles,
})
