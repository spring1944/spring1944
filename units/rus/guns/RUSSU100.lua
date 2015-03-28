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
		armor_front			= 87,
		armor_rear			= 44,
		armor_side			= 46,
		armor_top			= 20,
		maxammo				= 7,
		weaponcost			= 22,
		maxvelocitykmh		= 48,
	},
}

return lowerkeys({
	["RUSSU100"] = RUSSU100,
})
