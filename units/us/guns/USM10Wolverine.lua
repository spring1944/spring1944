local USM10Wolverine = MediumTank:New(TankDestroyer):New(OpenTopped):New{
	name				= "M10 GMC Wolverine",
	description			= "Turreted Tank Destroyer",
	buildCostMetal		= 1900,
	maxDamage			= 2903,
	trackOffset			= 5,
	trackWidth			= 18,
	turnRate			= 280,

	weapons = {
		[1] = {
			name				= "M7AP",
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
		maxammo				= 13,
		turretturnspeed		= 8, -- Manual traverse 45s
		maxvelocitykmh		= 48,
		normaltex			= "unittextures/USM4ShermanA_normals.dds",
	},
}

return lowerkeys({
	["USM10Wolverine"] = USM10Wolverine,
})
