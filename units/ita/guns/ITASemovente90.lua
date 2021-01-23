local ITASemovente90 = MediumTank:New(TankDestroyer):New(OpenTopped):New{
	name				= "Semovente da 90/53",
	description			= "Heavily Armed Tank Destroyer",
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
		armour = {
			base = {
				front = {
					thickness		= 25,
					slope			= 80,
				},
				rear = {
					thickness		= 25,
					slope			= -16,
				},
				side = {
					thickness 		= 25,
				},
				top = {
					thickness		= 15,
				},
			},
			turret = {
				front = {
					thickness		= 30,
					slope			= 29,
				},
				rear = {
					thickness		= 0,
				},
				side = {
					thickness 		= 15,
				},
				top = {
					thickness		= 8,
				},
			},
		},
		maxammo				= 6,
		maxvelocitykmh		= 25,
		exhaust_fx_name			= "diesel_exhaust",
		piecehitvols		= {
			base = {
				scale = {1, 0.8, 1},
				offset = {0, 0, 0},
			},
			turret = {
				scale = {1, 0.35, 1},
				offset = {0, -4, 0},
			},
		},
		normaltex			= "unittextures/ITASemovente90_normals.png",
	},
}

return lowerkeys({
	["ITASemovente90"] = ITASemovente90,
})
