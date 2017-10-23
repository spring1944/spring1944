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
		armor_front			= 60,
		armor_rear			= 25,
		armor_side			= 25,
		armor_top			= 19,
		maxammo				= 10,
		turretturnspeed		= 10, -- Manual traverse 45s
		maxvelocitykmh		= 51,
		normaltex			= "unittextures/GBRShermans_normals.dds",
	},
}

return lowerkeys({
	["GBRM10Achilles"] = GBRM10Achilles,
})
