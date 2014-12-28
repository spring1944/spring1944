local GBR_Horsa = Glider:New{
	name			= "AS 51 Horsa",
	description		= "Troop-Carrying Glider",
	maxDamage		= 215,
	
	customParams = {
		spawn_on_death			= "gbr_platoon_glider_horsa", -- TODO: generalise
	},
}


return lowerkeys({
	["GBRHorsa"] = GBR_Horsa,
})
