local USM10Wolverine = MediumTank:New(TankDestroyer):New(OpenTopped):New{
	name				= "M10 GMC Wolverine",
	description			= "Turreted Tank Destroyer",
	buildCostMetal		= 1900,
	maxDamage			= 2903,
	trackOffset			= 5,
	trackWidth			= 18,

	weapons = {
		[1] = {
			name				= "M7AP",
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
					slope			= 68,
				},
				rear = {
					thickness		= 25,
					slope			= 44,
				},
				side = {
					thickness 		= 25,
					slope			= 23,
				},
				top = {
					thickness		= 0,
				},
			},
		},
		maxammo				= 13,
		turretturnspeed		= 10, -- Manual traverse 45s
		maxvelocitykmh		= 48,
		normaltex			= "unittextures/USM4ShermanA_normals.dds",
	},
}

return lowerkeys({
	["USM10Wolverine"] = USM10Wolverine,
})
