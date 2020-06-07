local GBRKangaroo = MediumTank:New(Transport):New{
	name				= "Ram Kangaroo",
	description			= "Heavily Armoured Transport",
	buildCostMetal		= 1200,
	maxDamage			= 2948,
	trackOffset			= 10,
	trackWidth			= 21,
	transportCapacity	= 12,
    transportMass       = 600,
	
	weapons = {
		[1] = {
			name				= ".50calproof",
		},
	},
	customParams = {
		weapontoggle		= 'explicitly-undefined-in-child',
				armour = {
			base = {
				front = {
					thickness		= 89,
					slope			= 54,
				},
				rear = {
					thickness		= 38,
					slope			= -9,
				},
				side = {
					thickness 		= 64,
				},
				top = {
					thickness		= 25,--engine deck
				},
			},
		},
		maxvelocitykmh		= 40,
		normaltex			= "unittextures/GBRKangaroo_normals.dds",
	},
}

return lowerkeys({
	["GBRKangaroo"] = GBRKangaroo,
})
