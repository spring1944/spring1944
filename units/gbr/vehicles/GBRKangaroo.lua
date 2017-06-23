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
		armor_front			= 63,
		armor_rear			= 43,
		armor_side			= 44,
		armor_top			= 15,
		maxvelocitykmh		= 40,
		normaltex			= "unittextures/GBRKangaroo_normals.dds",
	},
}

return lowerkeys({
	["GBRKangaroo"] = GBRKangaroo,
})
