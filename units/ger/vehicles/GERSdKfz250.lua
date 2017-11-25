local GERSdKfz250 = ArmouredCar:New{
	name				= "Sd.Kfz. 250/9",
	description			= "Light Support Halftrack",
	acceleration		= 0.039,
	brakeRate			= 0.195,
	buildCostMetal		= 925,
	maxDamage			= 570,
	trackOffset			= 10,
	trackWidth			= 13,
	iconType			= "halftrack",
	movementClass		= "TANK_Light",

	weapons = {
		[1] = {
			name				= "flak3820mmap",
			mainDir				= [[0 16 1]],
			maxAngleDif			= 210,
		},
		[2] = {
			name				= "flak3820mmhe",
			mainDir				= [[0 16 1]],
			maxAngleDif			= 210,
		},
		[3] = {
			name				= "MG34",
			mainDir				= [[0 16 1]],
			maxAngleDif			= 210,
		},
		[4] = {
			name				= ".30calproof",
		},
	},
	customParams = {
		armor_front			= 12,
		armor_rear			= 8,
		armor_side			= 9,
		armor_top			= 0,
		maxammo				= 19,
		turretturnspeed		= 20, -- manual, light turret
		maxvelocitykmh		= 76,
		customanims			= "sdkfz250",

	}
}

return lowerkeys({
	["GERSdKfz250"] = GERSdKfz250,
})
