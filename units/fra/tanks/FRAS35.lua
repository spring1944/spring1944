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
		armor_front			= 39,
		armor_rear			= 30,
		armor_side			= 35,
		armor_top			= 15,
		maxammo				= 24,

		barrelrecoildist		= 1,
		barrelrecoilspeed		= 10,
		turretturnspeed			= 15,
		elevationspeed			= 20,

		maxvelocitykmh		= 37,
		customanims			= "somua_s35",
	},
}

return lowerkeys({
	["FRAS35"] = FRAS35,
})
