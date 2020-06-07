local GBRShermanFirefly = MediumTank:New{
	name				= "Sherman Mk. Vc Firefly",
	description			= "Upgunned Medium Tank",
	buildCostMetal		= 4000,
	maxDamage			= 3270,
	trackOffset			= 5,
	trackWidth			= 18,

	weapons = {
		[1] = {
			name				= "QF17pdrMkVIAP",
			mainDir				= [[0 16 1]],
			maxAngleDif			= 210,
		},
		[2] = {
			name				= "QF17pdrMkVIHE",
			mainDir				= [[0 16 1]],
			maxAngleDif			= 210,
		},
		[3] = {
			name				= "M1919A4Browning",
		},
		[4] = {
			name				= "BESA",
			mainDir				= [[0 0 1]],
			maxAngleDif			= 30,
		},
		[5] = {
			name				= ".50calproof",
		},
	},
	customParams = {
		armour = {
			base = {
				front = {
					thickness		= 51,
					slope			= 56,
				},
				rear = {
					thickness		= 38,
					slope			= 21,
				},
				side = {
					thickness 		= 38,
				},
				top = {
					thickness		= 20,
				},
			},
			turret = {
				front = {
					thickness		= 76,
					slope			= 30,
				},
				rear = {
					thickness		= 64,
				},
				side = {
					thickness 		= 51,
					slope			= 3,
				},
				top = {
					thickness		= 25,
				},
			},
		},
		maxammo				= 14,
		turretturnspeed		= 19, 
		maxvelocitykmh		= 40,
		normaltex			= "unittextures/GBRShermans_normals.dds",
	},
}

return lowerkeys({
	["GBRShermanFirefly"] = GBRShermanFirefly,
})
