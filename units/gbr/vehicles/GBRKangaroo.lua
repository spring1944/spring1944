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
		armor_front			= 89,
		armor_rear			= 38,
		armor_side			= 64,
		armor_top			= 25,--engine deck
		slope_front			= 54,
		slope_rear			= -9,
		maxvelocitykmh		= 40,
		normaltex			= "unittextures/GBRKangaroo_normals.dds",
	},
}

return lowerkeys({
	["GBRKangaroo"] = GBRKangaroo,
})
