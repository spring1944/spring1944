local ITASemovente90 = Tank:New(TankDestroyer):New(OpenTopped):New{
	name				= "Semovente da 90/53",
	description			= "Heavily Armed Tank Destroyer",
	acceleration		= 0.032,
	brakeRate			= 0.15,
	buildCostMetal		= 3550,
	maxDamage			= 1700,
	trackOffset			= 5,
	trackWidth			= 15,

	weapons = {
		[1] = {
			name				= "Ansaldo90mmL53AP",
			maxAngleDif			= 80,
		},
		[2] = {
			name				= ".30calproof",
		},
	},
	customParams = {
		armor_front			= 40,
		armor_rear			= 0,
		armor_side			= 25,
		armor_top			= 10,
		maxammo				= 6,
		weaponcost			= 20,
		maxvelocitykmh		= 25,
	},
}

return lowerkeys({
	["ITASemovente90"] = ITASemovente90,
})
