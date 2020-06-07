local SWEPBilM31f = ArmouredCar:New{
	name				= "PBil m/31f Command Car",
	buildCostMetal		= 1085, -- from ITA AB41
	maxDamage			= 780,
	trackOffset			= 10,
	trackWidth			= 13,

	weapons = {
		[1] = {
			name				= "ksp_m1936",
			mainDir				= [[0 0 1]],
			maxAngleDif			= 90,
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
					slope			= 30,
				},
				rear = {
					thickness		= 10,
					slope			= 18,
				},
				side = {
					thickness 		= 8,
					slope			= 8,
				},
				top = {
					thickness		= 6,
				},
			},
			turret = {
				front = {
					thickness		= 15,
					slope			= 14,
				},
				rear = {
					thickness		= 13, -- BA-11
					slope			= 9,
				},
				side = {
					thickness 		= 13, -- BA-11
					slope			= 10,
				},
				top = {
					thickness		= 6,
				},
			},
		},
		reversemult			= 0.75,
		maxvelocitykmh		= 60,

	}
}

return lowerkeys({
	["SWEPBilM31f"] = SWEPBilM31f,
})
