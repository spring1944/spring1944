local GERSdKfz250 = ArmouredCar:New{
	name				= "Sd.Kfz. 250/9",
	description			= "Light Support Halftrack",
	acceleration		= 0.039,
	brakeRate			= 0.195,
	buildCostMetal		= 925,
	maxDamage			= 570,
	trackOffset			= 10,
	trackWidth			= 13,
	iconType			= "halftrack",
	movementClass		= "TANK_Light",

	weapons = {
		[1] = {
			name				= "flak3820mmap",
			mainDir				= [[0 16 1]],
			maxAngleDif			= 210,
		},
		[2] = {
			name				= "flak3820mmhe",
			mainDir				= [[0 16 1]],
			maxAngleDif			= 210,
		},
		[3] = {
			name				= "MG34",
			mainDir				= [[0 16 1]],
			maxAngleDif			= 210,
		},
		[4] = {
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
					slope			= 20,
				},
				side = {
					thickness 		= 8,
					slope			= 30,
				},
				top = {
					thickness		= 6,
				},
			},
			turret = {
				front = {
					thickness		= 30,
					slope			= 36,
				},
				rear = {
					thickness		= 8,
					slope			= 36,
				},
				side = {
					thickness 		= 8,
					slope			= 27,
				},
				top = {
					thickness		= 0,
				},
			},
		},
		
		slope_side			= 30,
		maxammo				= 19,
		turretturnspeed		= 20, -- manual, light turret
		maxvelocitykmh		= 76,
		customanims			= "sdkfz250",

		normaltex			= "unittextures/GERSdKfz250_9_normals.png",
	}
}

return lowerkeys({
	["GERSdKfz250"] = GERSdKfz250,
})
