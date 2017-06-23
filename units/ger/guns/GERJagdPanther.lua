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
		armor_front			= 113,
		armor_rear			= 44,
		armor_side			= 46,
		armor_top			= 25,
		maxammo				= 15,
		soundcategory		= "GER/Tank/JgPz",
		maxvelocitykmh		= 46,
		normaltex			= "",
	},
}

return lowerkeys({
	["GERJagdPanther"] = GERJagdPanther,
})
