local GBRKangaroo = MediumTank:New(Transport):New{
	name				= "Ram Kangaroo",
	description			= "Heavily Armoured Transport",
	acceleration		= 0.045,
	brakeRate			= 0.15,
	buildCostMetal		= 1200,
	maxDamage			= 2948,
	maxReverseVelocity	= 1.48,
	maxVelocity			= 2.96,
	trackOffset			= 10,
	trackWidth			= 15,
	transportCapacity	= 12,
    transportMass       = 600,
	
	weapons = {
		[1] = {
			name				= ".50calproof",
		},
	},
	customParams = {
		armor_front			= 63,
		armor_rear			= 43,
		armor_side			= 44,
		armor_top			= 15,
		weaponswithammo		= 0,
	},
}

return lowerkeys({
	["GBRKangaroo"] = GBRKangaroo,
})
