local GERJagdPanzerIV = MediumTank:New(TankDestroyer):New{
	name				= "SdKfz 162 JagdPanzer IV/70(V)",
	description			= "Turretless Tank Destroyer",
	buildCostMetal		= 4500,
	maxDamage			= 2580,
	trackOffset			= 5,
	trackWidth			= 20,

	weapons = {
		[1] = {
			name				= "kwk75mml71AP",
			maxAngleDif			= 25,
		},
		[2] = {
			name				= ".50calproof",
		},
	},
	customParams = {
		armour = {
			base = {
				front = {
					thickness		= 80,
					slope			= 47,
				},
				rear = {
					thickness		= 22,
					slope			= 5,
				},
				side = {
					thickness 		= 30,
				},
				top = {
					thickness		= 20,
				},
			},
			super = {
				front = {
					thickness		= 80,
					slope			= 50,
				},
				rear = {
					thickness		= 30,
					slope			= 31,
				},
				side = {
					thickness 		= 40,
					slope			= 29,
				},
				top = {
					thickness		= 20,
				},
			},
		},
		maxammo				= 15,
		soundcategory		= "GER/Tank/JgPz",
		maxvelocitykmh		= 35,

	},
}

return lowerkeys({
	["GERJagdPanzerIV"] = GERJagdPanzerIV,
})
