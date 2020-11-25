local GBR_ParaM8Gun = InfantryGun:New{
	name					= "75mm M8",
	corpse					= "usm8gun_destroyed",

	collisionVolumeType		= "box",
	collisionVolumeScales	= {2.5, 2.5, 6.0},
	collisionVolumeOffsets	= {0.0, 4.0, 2.0},

	weapons = {
		[1] = { -- HE
			name				= "M875mmHE",
		},
	},
	customParams = {

	},
}


return lowerkeys({
	["GBRParaM8Gun"] = GBR_ParaM8Gun,
})
