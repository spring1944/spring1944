local ITAL6_40lf = LightTank:New{
	name				= "L6/40 Lancia Flamme",
	description			= "Light Flamethrower Tank",
	buildCostMetal		= 1350,
	maxDamage			= 640,
	trackOffset			= 5,
	trackWidth			= 18,

	weapons = {
		[1] = {
			name				= "L6Lanciafiamme",
			mainDir				= [[0 16 1]],
			maxAngleDif			= 210,
		},
		[2] = {
			name				= ".30calproof",
		},
	},
	customParams = {
		armour = {
			base = {
				front = {
					thickness		= 30,
					slope			= 11,
				},
				rear = {
					thickness		= 15,
					slope			= 1,
				},
				side = {
					thickness 		= 15,
					slope			= 11,
				},
				top = {
					thickness		= 10,
				},
			},
			turret = {
				front = {
					thickness		= 40,
					slope			= 12,
				},
				rear = {
					thickness		= 15,
					slope			= 16,
				},
				side = {
					thickness 		= 15,
					slope			= 20,
				},
				top = {
					thickness		= 10,
				},
			},
		},
		maxammo				= 8,
		weapontoggle		= "false",
		maxvelocitykmh		= 42,

	},
}

return lowerkeys({
	["ITAL6_40lf"] = ITAL6_40lf,
})
