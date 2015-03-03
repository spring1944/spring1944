local GERJagdPanther = Tank:New(TankDestroyer):New{
	name				= "SdKfz 173 JagdPanther",
	description			= "Heavy Turretless Tank Destroyer",
	acceleration		= 0.051,
	brakeRate			= 0.15,
	buildCostMetal		= 9100,
	maxDamage			= 4550,
	maxReverseVelocity	= 2.035,
	maxVelocity			= 4.07,
	trackOffset			= 5,
	trackWidth			= 20,

	weapons = {
		[1] = {
			name				= "kwk88mml71AP",
			maxAngleDif			= 25,
		},
		[2] = {
			name				= ".50calproof",
		},
	},
	customParams = {
		armor_front			= 113,
		armor_rear			= 44,
		armor_side			= 46,
		armor_top			= 25,
		maxammo				= 15,
		weaponcost			= 26,
		soundcategory		= "GER/Tank/JgPz",
	},
}

return lowerkeys({
	["GERJagdPanther"] = GERJagdPanther,
})
