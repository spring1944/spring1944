local JPNHoNiIII = Tank:New(TankDestroyer):New{
	name				= "Type 3 Ho-Ni III",
	acceleration		= 0.041,
	brakeRate			= 0.15,
	buildCostMetal		= 2050,
	maxDamage			= 1700,
	maxReverseVelocity	= 1.5,
	maxVelocity			= 3,
	trackOffset			= 5,
	trackWidth			= 14,

	weapons = {
		[1] = {
			name				= "Type375mmL38AP",
			maxAngleDif			= 20,
		},
		[2] = {
			name				= ".50calproof",
		},
	},
	customParams = {
		armor_front			= 30,
		armor_rear			= 25,
		armor_side			= 25,
		armor_top			= 12,
		maxammo				= 14,
		weaponcost			= 12,
	},
}

return lowerkeys({
	["JPNHoNiIII"] = JPNHoNiIII,
})
