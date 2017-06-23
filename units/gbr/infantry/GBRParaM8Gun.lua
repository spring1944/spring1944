local GBR_ParaM8Gun = InfantryGun:New{
	name					= "75mm M8",
	corpse					= "usm8gun_destroyed",

	weapons = {
		[1] = { -- HE
			name				= "M875mmHE",
		},
	},
	customParams = {
		normaltex			= "",
	},
}


return lowerkeys({
	["GBRParaM8Gun"] = GBR_ParaM8Gun,
})
