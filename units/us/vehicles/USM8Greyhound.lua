local USM8Greyhound = ArmouredCar:New{
	name				= "M8 Greyhound",
	description			= "Light Armoured Car",
	acceleration		= 0.047,
	brakeRate			= 0.09,
	buildCostMetal		= 1400,
	maxDamage			= 780,
	maxReverseVelocity	= 3.555,
	maxVelocity			= 7.11,
	trackOffset			= 10,
	trackWidth			= 13,
	turnRate			= 405,

	weapons = {
		[1] = {
			name				= "M637mmap",
			mainDir				= [[0 16 1]],
			maxAngleDif			= 210,
		},
		[2] = {
			name				= "M637mmhe",
			mainDir				= [[0 16 1]],
			maxAngleDif			= 210,
		},
		[3] = {
			name				= "M1919A4Browning",
			mainDir				= [[0 16 1]],
			maxAngleDif			= 210,
		},
		[4] = {
			name				= "M2BrowningAA",
		},
		[5] = {
			name				= ".30calproof",
		},
	},
	customParams = {
		armor_front			= 18,
		armor_rear			= 11,
		armor_side			= 11,
		armor_top			= 3,
		maxammo				= 15,
		weaponcost			= 8,
		weaponswithammo		= 2,
		
		cegpiece = {
			[4] = "aaflare",
		},
	}
}

return lowerkeys({
	["USM8Greyhound"] = USM8Greyhound,
})
