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
		armor_front			= 19, -- superstructure + gunshield
		armor_rear			= 15,
		armor_side			= 11,
		armor_top			= 12,
		slope_front			= 31,
		slope_side			= 8,
		maxammo				= 6,
		soundcategory		= "GER/Tank/JgPz",
		maxvelocitykmh		= 42,

	},
}

return lowerkeys({
	["GERMarder"] = GERMarder,
})
