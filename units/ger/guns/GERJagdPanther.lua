local GERJagdPanther = HeavyTank:New(TankDestroyer):New{
	name				= "SdKfz 173 JagdPanther",
	description			= "Heavy Turretless Tank Destroyer",
	buildCostMetal		= 9100,
	maxDamage			= 4550,
	trackOffset			= 5,
	trackWidth			= 26,

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
		armor_front			= 80,
		armor_rear			= 40,
		armor_side			= 50,
		armor_top			= 25,
		slope_front			= 55,
		slope_rear			= 26,
		slope_side			= 29,
		maxammo				= 15,
		soundcategory		= "GER/Tank/JgPz",
		maxvelocitykmh		= 46,

	},
}

return lowerkeys({
	["GERJagdPanther"] = GERJagdPanther,
})
