local USM8Gun = InfantryGun:New{
	name					= "75mm M8",
	corpse					= "usm8gun_destroyed",
	buildCostMetal				= 1280,

	collisionVolumeType		= "box",
	collisionVolumeScales	= {2.5, 2.5, 6.0},
	collisionVolumeOffsets	= {0.0, 4.0, 2.0},

	weapons = {
		[1] = { -- HE
			maxAngleDif		= 5,
			name			= "M875mmHE",
		},
	},
	customParams = {
		normaltex			= "unittextures/USM8Gun_normals.png",
	},
}


return lowerkeys({
	["USM8Gun"] = USM8Gun,
})
