local GBRSexton = Tank:New(SPArty):New(OpenTopped):New{
	name				= "25pdr SP. Sexton Mk. II",
	acceleration		= 0.052,
	brakeRate			= 0.15,
	buildCostMetal		= 4725,
	maxDamage			= 2586,
	maxReverseVelocity	= 1.52,
	maxVelocity			= 3.04,
	trackOffset			= 5,
	trackWidth			= 18,

	weapons = {
		[1] = {
			name				= "QF25pdrHE",
			maxAngleDif			= 15,
		},
		[2] = {
			name				= ".50calproof",
		},
	},
	customParams = {
		armor_front			= 63,
		armor_rear			= 38,
		armor_side			= 38,
		armor_top			= 6,
		maxammo				= 21,
		weaponcost			= 18,
	},
}

return lowerkeys({
	["GBRSexton"] = GBRSexton,
})
