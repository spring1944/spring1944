local USM36Jackson = MediumTank:New(TankDestroyer):New(OpenTopped):New{
	name				= "M36 GMC Jackson",
	description			= "Heavy Tank Destroyer",
	buildCostMetal		= 5410,
	maxDamage			= 3100,
	trackOffset			= 5,
	trackWidth			= 18,

	weapons = {
		[1] = {
			name				= "m390mmap",
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
		armor_rear			= 19,
		armor_side			= 19,
		armor_top			= 10,
		slope_front			= 55,
		slope_rear			= 28,
		slope_side			= 38,
		maxammo				= 13,
		turretturnspeed		= 10, -- Manual traverse 45s
		maxvelocitykmh		= 44,
		normaltex			= "unittextures/usm4shermana_normals.dds",
	},
}

return lowerkeys({
	["USM36Jackson"] = USM36Jackson,
})
