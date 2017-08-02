local USM36Jackson = MediumTank:New(TankDestroyer):New(OpenTopped):New{
	name				= "M36 GMC Jackson",
	description			= "Heavy Tank Destroyer",
	buildCostMetal		= 4250,
	maxDamage			= 3100,
	trackOffset			= 5,
	trackWidth			= 18,
	turnRate			= 240,

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
		armor_front			= 93,
		armor_rear			= 25,
		armor_side			= 25,
		armor_top			= 19,
		maxammo				= 13,
		turretturnspeed		= 8, -- Manual traverse 45s
		maxvelocitykmh		= 44,
		normaltex			= "unittextures/usm4shermana_normals.dds",
	},
}

return lowerkeys({
	["USM36Jackson"] = USM36Jackson,
})
