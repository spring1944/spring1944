local USM7Priest = MediumTank:New(SPArty):New(OpenTopped):New{
	name				= "M7 HMC Priest",
	buildCostMetal		= 4500,
	maxDamage			= 2300,
	trackOffset			= 5,
	trackWidth			= 18,

	weapons = {
		[1] = {
			name				= "M2HE",
			maxAngleDif			= 15,
		},
		[2] = {
			name				= "M2BrowningAA",
		},
		[3] = {
			name				= ".50calproof",
		},
	},
	customParams = {
		armour = {
			base = {
				front = {
					thickness		= 51,
					slope			= 55,
				},
				rear = {
					thickness		= 38,
				},
				side = {
					thickness 		= 38,
				},
				top = {
					thickness		= 20,
				},
			},
			super = {
				front = {
					thickness		= 13,
					slope			= 25,
				},
				rear = {
					thickness		= 13,
				},
				side = {
					thickness 		= 13,
				},
				top = {
					thickness		= 0,
				},
			},
		},
		maxammo				= 13,
		maxvelocitykmh		= 39,
		normaltex			= "unittextures/USM7Priest_normals.png",
	},
}

return lowerkeys({
	["USM7Priest"] = USM7Priest,
})
