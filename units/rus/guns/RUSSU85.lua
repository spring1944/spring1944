local RUSSU85 = MediumTank:New(TankDestroyer):New{
	name				= "SU-85",
	buildCostMetal		= 3200,
	maxDamage			= 2960,
	trackOffset			= 5,
	trackWidth			= 20,

	weapons = {
		[1] = {
			name				= "S5385mmAP",
			maxAngleDif			= 25,
		},
		[2] = {
			name				= ".50calproof",
		},
	},
	customParams = {
		armor_front			= 77,
		armor_rear			= 48,
		armor_side			= 46,
		armor_top			= 20,
		maxammo				= 9,
		weaponcost			= 17,
		maxvelocitykmh		= 55,
	},
}

return lowerkeys({
	["RUSSU85"] = RUSSU85,
})
