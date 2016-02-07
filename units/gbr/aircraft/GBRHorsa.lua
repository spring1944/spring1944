Unit('GBR_Horsa'):Extends('Glider'):Attrs{
	name			= "AS 51 Horsa",
	description		= "Troop-Carrying Glider",
	maxDamage		= 215,
	script			= "<NAME>.lua",
	customParams = {
		spawn_on_death			= "gbr_platoon_glider_horsa", -- TODO: generalise
	},
}


