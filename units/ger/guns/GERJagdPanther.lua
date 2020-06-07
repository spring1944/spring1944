local GERJagdPanther = HeavyTank:New(TankDestroyer):New{
	name				= "SdKfz 173 JagdPanther",
	description			= "Heavy Turretless Tank Destroyer",
	buildCostMetal		= 9100,
	maxDamage			= 4550,
	trackOffset			= 5,
	trackWidth			= 26,

	weapons = {
		[1] = {
			name				= "kwk88mml71AP",
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
					slope			= 55,
				},
				rear = {
					thickness		= 40,
					slope			= -26,
				},
				side = {
					thickness 		= 50,
					slope			= 29,
				},
				top = {
					thickness		= 25,
				},
			},
			super = {
				front = {
					thickness		= 80,
					slope			= 55,
				},
				rear = {
					thickness		= 40,
					slope			= 35,
				},
				side = {
					thickness 		= 50,
					slope			= 29,
				},
				top = {
					thickness		= 25,
				},
			},
		},
		maxammo				= 15,
		soundcategory		= "GER/Tank/JgPz",
		maxvelocitykmh		= 46,

	},
}

return lowerkeys({
	["GERJagdPanther"] = GERJagdPanther,
})
