local GBRStaghound = ArmouredCarAA:New{
	name				= "T17E2 Staghound AA",
	buildCostMetal		= 990,
	maxDamage			= 1270,
	trackOffset			= 10,
	trackWidth			= 16,

	weapons = {
		[1] = {
			name				= "M2browningaa",
		},
		[2] = {
			name				= "M2browningaa",
		},
		[3] = {
			name				= "M2browning",
		},
		[4] = {
			name				= ".30calproof",
		},
	},
	customParams = {
		armour = {
			base = {
				front = {
					thickness		= 22,
					slope			= 47,
				},
				rear = {
					thickness		= 9,
					slope			= 28,
				},
				side = {
					thickness 		= 19,
					slope			= -12,
				},
				top = {
					thickness		= 13,
				},
			},
			turret = {
				front = {
					thickness		= 32,
					slope			= 42,
				},
				rear = {
					thickness		= 32,
					slope			= 2,
				},
				side = {
					thickness 		= 32,
				},
				top = {
					thickness		= 0,
				},
			},
		},
		turretturnspeed		= 43, -- may find this too slow in game
		maxvelocitykmh		= 89,

	}
}

return lowerkeys({
	["GBRStaghound"] = GBRStaghound,
})
