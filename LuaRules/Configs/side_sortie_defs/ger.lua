local gerSorties = {
	ger_sortie_recon = {
		"gerfi156",
		delay = 15,
	},
  
	ger_sortie_interceptor = {
		"gerbf109",
		"gerbf109",
		"gerbf109",
		"gerbf109",
		delay = 15,
		weight = 1,
	},
  
	ger_sortie_fighter = {
		"gerfw190",
		"gerfw190",
		"gerfw190",
		"gerfw190",
		delay = 30,
		weight = 1,
	},
  
	ger_sortie_fighter_bomber = {
		"gerfw190g",
		"gerfw190g",
		delay = 45,
		weight = 1,
	},
  
	ger_sortie_attack = {
		"gerju87g",
		"gerju87g",
		"gerju87g",
		delay = 45,
		weight = 1,
	},
  
	ger_sortie_flying_bomb = {
		"gerv1",
		groundOnly = 1,
		alwaysAttack = 1,
		delay = 45,
		weight = 1,
		silent = 1,
	},
}

return gerSorties
