local FRAS35 = MediumTank:New{
	corpse				= "FRAS35_Burning",
	name				= "Char 1935 S",
	buildCostMetal		= 2400,
	maxDamage			= 1950,
	trackOffset			= 5,
	trackWidth			= 19,

	collisionVolumeType	= "box",
	collisionVolumeOffsets	= [[0.0 0.75 0]],
	collisionVolumeScales	= [[2.5 1.5 5.0]],

	usePieceCollisionVolumes	= true,
	
	objectName			= "FRA/FRAS35.s3o",
	
	weapons = {
		[1] = {
			name				= "FRA47mmSA35AP",
			mainDir				= [[0 16 1]],
			maxAngleDif			= 210,
		},
		[2] = {
			name				= "FRA47mmSA35HE",
			mainDir				= [[0 16 1]],
			maxAngleDif			= 210,
		},
		[3] = {
			name				= "MACmle1931",
		},
		[4] = {
			name				= ".50calproof",
		},
	},
	customParams = {
		armour = {
			base = {
				front = {
					thickness		= 47,
					slope			= 24,
				},
				rear = {
					thickness		= 35,
					slope			= 31,
				},
				side = {
					thickness 		= 40,
					slope			= 21,
				},
				top = {
					thickness		= 25,
				},
			},
			turret = {
				front = {
					thickness		= 56,
				},
				rear = {
					thickness		= 45,
					slope			= 21,
				},
				side = {
					thickness 		= 45,
					slope			= 22,
				},
				top = {
					thickness		= 30,
				},
			},
		},
		
		maxammo				= 24,
		
		barrelrecoildist		= 1,
		barrelrecoilspeed		= 10,
		turretturnspeed			= 15,
		elevationspeed			= 20,

		maxvelocitykmh		= 37,
		customanims			= "somua_s35",

		normaltex = "unittextures/FRAS35_normals.png",
	},
}

return lowerkeys({
	["FRAS35"] = FRAS35,
})
