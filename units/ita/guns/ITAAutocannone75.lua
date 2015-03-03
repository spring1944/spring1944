local ITAAutocannone75 = Truck:New(AssaultGun):New{
	name				= "Autocannone da 90/56",
	description			= "Gun Truck",
	buildCostMetal		= 1650,
	maxDamage			= 270,
	maxReverseVelocity	= 1.4,
	maxVelocity			= 2.8,
	trackOffset			= 5,
	trackWidth			= 19,

	weapons = {
		[1] = {
			name				= "ansaldo75mml27he",
			maxAngleDif			= 30,
		},
	},
	customParams = {
		maxammo				= 5,
		weaponcost			= 12,
		weaponswithammo		= 1,
	},
}

return lowerkeys({
	["ITAAutocannone75"] = ITAAutocannone75,
})
