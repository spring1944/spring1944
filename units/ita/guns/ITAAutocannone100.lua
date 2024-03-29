local ITAAutocannone100 = Truck:New(SPArty):New{
	name				= "Autocannone da 100/17",
	buildCostMetal		= 3750,
	maxDamage			= 650,
	trackOffset			= 5,
	trackWidth			= 19,

	weapons = {
		[1] = {
			name				= "Obice100mmL17HE",
		},
		[2] = {
			name				= "Obice100mmL17Smoke",
		},
	},
	customParams = {
		turretturnspeed		= 8,
		maxammo				= 8,
		maxvelocitykmh		= 45,
		weapontoggle		= "smoke",
		nomoveandfire		= true,
		normaltex			= "unittextures/ITAAutocannone100_normals.png",
	},
}

return lowerkeys({
	["ITAAutocannone100"] = ITAAutocannone100,
})
