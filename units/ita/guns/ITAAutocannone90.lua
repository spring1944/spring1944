local ITAAutocannone90 = Truck:New(TankDestroyer):New{
	name				= "Autocannone da 90/56",
	description			= "Self-Propelled AT Gun",
	buildCostMetal		= 2950,
	maxDamage			= 800,
	maxReverseVelocity	= 1.05,
	maxVelocity			= 2.1,
	trackOffset			= 5,
	trackWidth			= 19,

	weapons = {
		[1] = {
			name				= "Ansaldo90mmL53AP",
			maxAngleDif			= 175,
		},
	},
	customParams = {
		maxammo				= 5,
		weaponcost			= 20,
	},
}

return lowerkeys({
	["ITAAutocannone90"] = ITAAutocannone90,
})
