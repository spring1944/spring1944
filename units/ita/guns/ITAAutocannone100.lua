local ITAAutocannone100 = Truck:New(SPArty):New{
	name				= "Autocannone da 100/17",
	buildCostMetal		= 3750,
	maxDamage			= 650,
	maxReverseVelocity	= 1.6,
	maxVelocity			= 3.2,
	trackOffset			= 5,
	trackWidth			= 19,

	weapons = {
		[1] = {
			name				= "Obice100mmL17HE",
		},
	},
	customParams = {
		maxammo				= 8,
		weaponcost			= 25,
	},
}

return lowerkeys({
	["ITAAutocannone100"] = ITAAutocannone100,
})
