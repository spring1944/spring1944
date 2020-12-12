local GERLeIG18 = InfantryGun:New{
	name					= "7.5cm LeIG 18",
	corpse					= "gerleig18_destroyed",
	buildCostMetal			= 1280,

	collisionVolumeType		= "box",
	collisionVolumeScales	= {10.0, 8.0, 3.0},
	collisionVolumeOffsets	= {0.0, 2.0, 4.0},

	weapons = {
		[1] = { -- HE
			maxAngleDif		= 5,
			name			= "leig18HE",
		},
	},
	customParams = {

	},
}


return lowerkeys({
	["GERLeIG18"] = GERLeIG18,
})
