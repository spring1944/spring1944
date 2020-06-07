local GBRSexton = MediumTank:New(SPArty):New(OpenTopped):New{
	name				= "25pdr SP Sexton Mk. II",
	buildCostMetal		= 4725,
	maxDamage			= 2586,
	trackOffset			= 5,
	trackWidth			= 18,

	weapons = {
		[1] = {
			name				= "QF25pdrHE",
			maxAngleDif			= 15,
		},
		[2] = {
			name				= ".50calproof",
		},
	},
	customParams = {
		armour = {
			base = {
				front = {
					thickness		= 51,
					slope			= 51,
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
					thickness		= 19,
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
		maxammo				= 21,
		maxvelocitykmh		= 40,
		normaltex			= "unittextures/GBRSexton_normals.dds",
	},
}

return lowerkeys({
	["GBRSexton"] = GBRSexton,
})
