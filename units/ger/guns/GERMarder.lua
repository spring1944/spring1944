local GERMarder = LightTank:New(TankDestroyer):New(OpenTopped):New{
	name				= "SdKfz 138 Panzerjäger Marder III Ausf. M",
	description			= "Cheap Turretless Tank Destroyer",
	buildCostMetal		= 1400,
	maxDamage			= 1050,
	trackOffset			= 3,
	trackWidth			= 12,

	weapons = {
		[1] = {
			name				= "kwk75mml48AP",
			maxAngleDif			= 15,
		},
		[2] = {
			name				= ".30calproof",
		},
	},
	customParams = {
		armor_front			= 10,
		armor_rear			= 10,
		armor_side			= 13,
		armor_top			= 10,
		maxammo				= 6,
		soundcategory		= "GER/Tank/JgPz",
		maxvelocitykmh		= 42,
		normaltex			= "",
	},
}

return lowerkeys({
	["GERMarder"] = GERMarder,
})
