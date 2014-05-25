local rusSorties = {
	rus_sortie_recon = {
		"ruspo2",
		delay = 15,
	},
  
	rus_sortie_interceptor = {
		"rusyak3",
		"rusyak3",
		"rusyak3",
		"rusyak3",
		delay = 15,
		weight = 1,
	},
  
	rus_sortie_fighter = {
		"rusla5fn",
		"rusla5fn",
		"rusla5fn",
		"rusla5fn",
		delay = 30,
		weight = 1,
	},
  
	rus_sortie_attack = {
		"rusil2",
		"rusil2",
		delay = 45,
		weight = 1,
	},
  
	rus_sortie_tankbuster = {
		"rusil2ptab",
		"rusil2ptab",
		delay = 45,
		weight = 1,
	},

	rus_sortie_partisan = {
		"ruspo2partisan",
		silent = 1,
		delay = 45,
		weight = 1,
		alwaysAttack = 1,
	},
}

return rusSorties
