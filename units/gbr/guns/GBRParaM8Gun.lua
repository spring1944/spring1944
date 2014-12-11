local GBR_ParaM8Gun = InfantryGun:New{
	name					= "75mm M8",
	corpse					= "usm8gun_destroyed",
	customParams = {
		weaponcost	= 12,
		infgun		= true, -- TODO: what uses this?
	},
	weapons = {
		[1] = { -- HE
			name				= "M875mmHE",
		},
	},
}


return lowerkeys({
	["GBRParaM8Gun"] = GBR_ParaM8Gun,
})
