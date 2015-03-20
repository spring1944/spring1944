local ITASemovente47 = Tank:New(TankDestroyer):New(OpenTopped):New{
	name				= "Semovente da 47/32",
	description			= "Light Turretless Tank Destroyer",
	acceleration		= 0.042,
	brakeRate			= 0.15,
	buildCostMetal		= 900,
	maxDamage			= 640,
	trackOffset			= 5,
	trackWidth			= 11,

	weapons = {
		[1] = {
			name				= "CannoneDa47mml32HEAT",
			maxAngleDif			= 15,
		},
		[2] = {
			name				= "CannoneDa47mml32AP",
			maxAngleDif			= 15,
		},
		[3] = {
			name				= ".50calproof",
		},
	},
	customParams = {
		armor_front			= 30,
		armor_rear			= 15,
		armor_side			= 15,
		armor_top			= 0,
		maxammo				= 18,
		weaponcost			= 10,
		weapontoggle		= false,
		maxvelocitykmh		= 42.3,
	},
}

return lowerkeys({
	["ITASemovente47"] = ITASemovente47,
})
