local gbrSorties = {
	gbr_sortie_recon = {
		"gbrauster",
		delay = 15,
	},
  
	gbr_sortie_interceptor = {
		"gbrspitfiremkxiv",
		"gbrspitfiremkxiv",
		"gbrspitfiremkxiv",
		"gbrspitfiremkxiv",
		delay = 15,
		weight = 1,
	},
  
	gbr_sortie_fighter_bomber = {
		"gbrspitfiremkix",
		"gbrspitfiremkix",
		delay = 45,
		weight = 1,
	},
  
	gbr_sortie_attack = {
		"gbrtyphoon",
		"gbrtyphoon",
		delay = 45,
		weight = 1,
	},
  
	gbr_sortie_glider_horsa = {
		"gbrhorsa",
		groundOnly = 1,
		alwaysAttack = 1,
		delay = 45,
		weight = 1,
		silent = 1,
	},
}

return gbrSorties
