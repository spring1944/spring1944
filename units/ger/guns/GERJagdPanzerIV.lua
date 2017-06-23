local GERJagdPanzerIV = MediumTank:New(TankDestroyer):New{
	name				= "SdKfz 162 JagdPanzer IV/70(V)",
	description			= "Turretless Tank Destroyer",
	buildCostMetal		= 4500,
	maxDamage			= 2580,
	trackOffset			= 5,
	trackWidth			= 20,

	weapons = {
		[1] = {
			name				= "kwk75mml71AP",
			maxAngleDif			= 25,
		},
		[2] = {
			name				= ".50calproof",
		},
	},
	customParams = {
		armor_front			= 106,
		armor_rear			= 20,
		armor_side			= 36,
		armor_top			= 20,
		maxammo				= 15,
		soundcategory		= "GER/Tank/JgPz",
		maxvelocitykmh		= 35,
		normaltex			= "",
	},
}

return lowerkeys({
	["GERJagdPanzerIV"] = GERJagdPanzerIV,
})
