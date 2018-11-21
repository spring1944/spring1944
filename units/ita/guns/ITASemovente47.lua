local ITASemovente47 = LightTank:New(TankDestroyer):New(OpenTopped):New{
	name				= "Semovente da 47/32",
	description			= "Light Turretless Tank Destroyer",
	buildCostMetal		= 900,
	maxDamage			= 640,
	trackOffset			= 5,
	trackWidth			= 11,
	turnRate = 150,

	weapons = {
		[1] = {
			name				= "CannoneDa47mml32AP",
			mainDir				= [[0 0 1]],
			maxAngleDif			= 30,
		},
		[2] = {
			name				= "CannoneDa47mml32HEAT",
			mainDir				= [[0 0 1]],
			maxAngleDif			= 30,
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
		weapontoggle		= "priorityHEATAP",
		maxvelocitykmh		= 42.3,

	},
}

return lowerkeys({
	["ITASemovente47"] = ITASemovente47,
})
