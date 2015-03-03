local RUSSU85 = Tank:New(TankDestroyer):New{
	name				= "SU-85",
	acceleration		= 0.056,
	brakeRate			= 0.15,
	buildCostMetal		= 3200,
	maxDamage			= 2960,
	maxReverseVelocity	= 2.035,
	maxVelocity			= 4.07,
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
	},
}

return lowerkeys({
	["RUSSU85"] = RUSSU85,
})
