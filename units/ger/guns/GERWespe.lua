local GERWespe = LightTank:New(SPArty):New(OpenTopped):New{
	name				= "SdKfz 124 Wespe",
	buildCostMetal		= 4200,
	maxDamage			= 1100,
	trackOffset			= 5,
	trackWidth			= 18,

	weapons = {
		[1] = {
			name				= "LeFH18HE",
			maxAngleDif			= 15,
		},
		[2] = {
			name				= "mg42aa",
		},
		[3] = {
			name				= ".30calproof",
		},
	},
	customParams = {
		armour = {
			base = {
				front = {
					thickness		= 15,
					slope			= 73,
				},
				rear = {
					thickness		= 15,
					slope			= -14,
				},
				side = {
					thickness 		= 15,
				},
				top = {
					thickness		= 20,
				},
			},
			super = {
				front = {
					thickness		= 10,
					slope			= 25,
				},
				rear = {
					thickness		= 0,
				},
				side = {
					thickness 		= 10,
					slope			= 29,
				},
				top = {
					thickness		= 0,
				},
			},
		},
		maxammo				= 6,
		maxvelocitykmh		= 40,
		normaltex			= "unittextures/GERWespe_normals.png",
	},
}

return lowerkeys({
	["GERWespe"] = GERWespe,
})
