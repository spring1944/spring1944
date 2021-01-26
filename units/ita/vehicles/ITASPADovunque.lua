local ITASPADovunque = TruckAA:New{
	name				= "Autocannone Breda da 20 mm A/A su Fiat-SPA Dovunque 35",
	buildCostMetal		= 1200,
	maxDamage			= 453,
	trackOffset			= 10,
	trackWidth			= 13,

	weapons = {
		[1] = {
			name				= "bredam3520mmaa",
		},
	},
	customParams = {
		maxammo				= 19,
		maxvelocitykmh		= 60,
		normaltex			= "unittextures/ITASPADovunque_normals.png",
	}
}

return lowerkeys({
	["ITASPADovunque"] = ITASPADovunque,
})
