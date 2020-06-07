local GBRM10Achilles = MediumTank:New(TankDestroyer):New(OpenTopped):New{
	name				= "17pdr SP Achilles Ic",
	description			= "Upgunned Tank Destroyer",
	buildCostMetal		= 2400,
	maxDamage			= 2960,
	trackOffset			= 5,
	trackWidth			= 18,

	weapons = {
		[1] = {
			name				= "QF17pdrAP",
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
		armour = {
			base = {
				front = {
					thickness		= 38,
					slope			= 55,
				},
				rear = {
					thickness		= 19,
					slope			= 28,
				},
				side = {
					thickness 		= 19,
					slope			= 38,
				},
				top = {
					thickness		= 10,
				},
			},
			turret = {
				front = {
					thickness		= 25, -- not mantlet
					slope			= 67,
				},
				rear = {
					thickness		= 25,
					slope			= -29,
				},
				side = {
					thickness 		= 25,
					slope			= 22,
				},
				top = {
					thickness		= 0,
				},
			},
		},
		maxammo				= 10,
		turretturnspeed		= 10, -- Manual traverse 45s
		maxvelocitykmh		= 51,
		normaltex			= "unittextures/GBRShermans_normals.dds",
	},
}

return lowerkeys({
	["GBRM10Achilles"] = GBRM10Achilles,
})
