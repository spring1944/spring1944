local GBRWasp = ArmouredCar:New{
	name				= "Wasp Mk.II",
	description			= "Universal Carrier Flamethrower",
	acceleration		= 0.066,
	brakeRate			= 0.09,
	buildCostMetal		= 1100,
	iconType			= "flametank",
	maxDamage			= 431,
	maxReverseVelocity	= 1.78,
	maxVelocity			= 3.56,
	trackOffset			= 10,
	trackWidth			= 13,
	turnRate			= 405,

	weapons = {
		[1] = {
			name				= "waspflamethrower",
			maxAngleDif			= 15,
		},
		[2] = {
			name				= ".30calproof",
		},
	},
	customParams = {
		armor_front			= 10,
		armor_rear			= 8,
		armor_side			= 8,
		armor_top			= 0,
		maxammo				= 7,
		weaponcost			= 4,
		weaponswithammo		= 1,
		hasturnbutton		= true,
		
		cegpiece = {
			[1] = "gun",
		},
	}
}

return lowerkeys({
	["GBRWasp"] = GBRWasp,
})
