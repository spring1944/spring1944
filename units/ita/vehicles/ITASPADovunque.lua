local ITASPADovunque = TruckAA:New{
	name				= "Autocannone Breda da 20 mm A/A su Fiat-SPA Dovunque 35",
	acceleration		= 0.058,
	brakeRate			= 0.195,
	buildCostMetal		= 1200,
	maxDamage			= 453,
	trackOffset			= 10,
	trackWidth			= 13,
	turnRate			= 405,

	weapons = {
		[1] = {
			name				= "bredam3520mmaa",
		},
	},
	customParams = {
		maxammo				= 19,
		weaponcost			= 2,
		weaponswithammo		= 1,
		maxvelocitykmh		= 60,
	}
}

return lowerkeys({
	["ITASPADovunque"] = ITASPADovunque,
})
