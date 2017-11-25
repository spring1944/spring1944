local GBRSexton = MediumTank:New(SPArty):New(OpenTopped):New{
	name				= "25pdr SP Sexton Mk. II",
	buildCostMetal		= 4725,
	maxDamage			= 2586,
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
		maxvelocitykmh		= 40,
		normaltex			= "unittextures/GBRSexton_normals.dds",
	},
}

return lowerkeys({
	["GBRSexton"] = GBRSexton,
})
