local ShermanBase = MediumTank:New{
	brakeRate			= 0.15,
	trackOffset			= 5,
	trackWidth			= 18,
	trackType			= "USShermanA",
	turnRate			= 280, -- FIXME: worth it?
	
	weapons = {
		[1] = {
			mainDir				= [[0 16 1]],
			maxAngleDif			= 210,
		},
		[2] = {
			mainDir				= [[0 16 1]],
			maxAngleDif			= 210,
		},
		[3] = {
			name				= "M1919A4Browning",
		},
		[4] = {
			name				= "M2BrowningAA",
		},
		[5] = {
			name				= ".50calproof",
		},
	},
	
	customParams = {
		armor_front			= 70,
		armor_rear			= 41,
		armor_side			= 41,
		armor_top			= 21,
		
		cegpiece = {
			[4] = "aaflare",
		},
	},
}	

local USM4A4Sherman = ShermanBase:New{
	name				= "M4A3 Sherman",
	acceleration		= 0.043,
	maxReverseVelocity	= 1.48,
	maxVelocity			= 2.96,
	buildCostMetal		= 2550,
	maxDamage			= 3180,

	weapons = {
		[1] = {
			name				= "M375mmAP",
		},
		[2] = {
			name				= "M375mmHE",
		},
	},
	
	customParams = {
		maxammo				= 20,
		weaponcost			= 12,
	},
}


local USM4Jumbo = USM4A4Sherman:New{
	name				= "M4A3E2 Sherman Jumbo",
	description			= "Uparmoured Medium Tank",
	acceleration		= 0.035,
	maxReverseVelocity	= 1.295,
	maxVelocity			= 2.59,
	buildCostMetal		= 6200,
	maxDamage			= 4267,
}

local USM4A376Sherman = ShermanBase:New{
	name				= "M4A3(76) HVSS Sherman",
	description			= "Upgunned Medium Tank",
	acceleration		= 0.05,
	maxReverseVelocity	= 1.555,
	maxVelocity			= 3.11,
	buildCostMetal		= 2850,
	maxDamage			= 3365,

	weapons = {
		[1] = {
			name				= "M7AP",
		},
		[2] = {
			name				= "M7HE",
		},
	},
	
	customParams = {
		armor_rear			= 43,
		armor_side			= 43,
		maxammo				= 14,
		weaponcost			= 14,
	},
}

local USM4A3105Sherman = ShermanBase:New{
	name				= "M4A3(105) Sherman",
	description			= "Close Support Tank",
	acceleration		= 0.049,
	maxReverseVelocity	= 1.26,
	maxVelocity			= 2.52,
	buildCostMetal		= 3450,
	maxDamage			= 3150,

	weapons = {
		[1] = {
			name				= "m4105mmhe",
		},
		[2] = {
			name				= "m4105mmsmoke",
		},
	},
	
	customParams = {
		armor_rear			= 32,
		armor_side			= 50,
		maxammo				= 12,
		weaponcost			= 22,
		cabfiresmoke		= true,
	},
}

return lowerkeys({
	["USM4A4Sherman"] = USM4A4Sherman,
	["USM4Jumbo"] = USM4Jumbo,
	["USM4A376Sherman"] = USM4A376Sherman,
	["USM4A3105Sherman"] = USM4A3105Sherman,
})
