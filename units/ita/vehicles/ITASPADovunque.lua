local ITASPADovunque = TruckAA:New{
	name				= "SPA Dovunque 35",
	acceleration		= 0.058,
	brakeRate			= 0.195,
	buildCostMetal		= 1200,
	maxDamage			= 453,
	maxReverseVelocity	= 1.5,
	maxVelocity			= 4,
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
	}
}

return lowerkeys({
	["ITASPADovunque"] = ITASPADovunque,
})
