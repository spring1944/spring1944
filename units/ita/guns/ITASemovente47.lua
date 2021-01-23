local ITASemovente47 = LightTank:New(TankDestroyer):New(OpenTopped):New{
	name				= "Semovente da 47/32",
	description			= "Light Turretless Tank Destroyer",
	buildCostMetal		= 720,
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
		armour = {
			base = {
				front = {
					thickness		= 30,
					slope			= -7,
				},
				rear = {
					thickness		= 15,
				},
				side = {
					thickness 		= 15,
				},
				top = {
					thickness		= 10,
				},
			},
			super = {
				front = {
					thickness		= 50,
					slope			= 12,
				},
				rear = {
					thickness		= 15,
				},
				side = {
					thickness 		= 15,
					slope			= 11,
				},
				top = {
					thickness		= 10,
				},
			},
		},
		maxammo				= 18,
		weapontoggle		= "priorityHEATAP",
		maxvelocitykmh		= 42.3,
		normaltex			= "unittextures/ITASemovente47_normals.png",
	},
}

return lowerkeys({
	["ITASemovente47"] = ITASemovente47,
})
