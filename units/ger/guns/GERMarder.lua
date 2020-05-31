local GERMarder = LightTank:New(TankDestroyer):New(OpenTopped):New{
	name				= "SdKfz 138 Panzerjäger Marder III Ausf. M",
	description			= "Cheap Turretless Tank Destroyer",
	buildCostMetal		= 1400,
	maxDamage			= 1050,
	trackOffset			= 3,
	trackWidth			= 12,

	weapons = {
		[1] = {
			name				= "kwk75mml48AP",
			maxAngleDif			= 15,
		},
		[2] = {
			name				= ".30calproof",
		},
	},
	customParams = {
		armour = {
			base = {
				front = {
					thickness		= 15,
					slope			= 65,
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
					thickness		= 15,
					slope			= 24,
				},
				rear = {
					thickness		= 0,
				},
				side = {
					thickness 		= 15,
					slope			= 19,
				},
				top = {
					thickness		= 0,
				},
			},
		},
		maxammo				= 6,
		soundcategory		= "GER/Tank/JgPz",
		maxvelocitykmh		= 42,

	},
}

return lowerkeys({
	["GERMarder"] = GERMarder,
})
