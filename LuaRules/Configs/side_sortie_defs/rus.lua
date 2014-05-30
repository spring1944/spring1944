local rusSorties = {
	rus_sortie_recon = {
		"ruspo2",
		delay = 15,
		name = "Recon Sortie",
		description = "1 x Po-2 Kukuruznik",
		buildCostMetal = 1000,
		buildPic = "RUSPo2.png",
		buildTime = 1000,
	},
  
	rus_sortie_interceptor = {
		"rusyak3",
		"rusyak3",
		"rusyak3",
		"rusyak3",
		delay = 15,
		weight = 1,
		name = "Interceptor Sortie",
		description = "4 x Yak-9U",
		buildCostMetal = 3940,
		buildPic = "RUSYak3.png",
		buildTime = 3940,
	},
  
	rus_sortie_fighter = {
		"rusla5fn",
		"rusla5fn",
		"rusla5fn",
		"rusla5fn",
		delay = 30,
		weight = 1,
		name = "Air Superiority Fighter Sortie",
		description = "4 x La-5FN",
		buildCostMetal = 4500,
		buildPic = "RUSLa5FN.png",
		buildTime = 4500,
	},
  
	rus_sortie_attack = {
		"rusil2",
		"rusil2",
		delay = 45,
		weight = 1,
		name = "Attack Sortie",
		description = "2 x IL-2M Shturmovik",
		buildCostMetal = 6750,
		buildPic = "RUSIL2.png",
		buildTime = 6750,
	},
  
	rus_sortie_tankbuster = {
		"rusil2ptab",
		"rusil2ptab",
		delay = 45,
		weight = 1,
		name = "Attack Sortie",
		description = "2 x IL-2M Shturmovik PTAB",
		buildCostMetal = 6750,
		buildPic = "RUSIL2PTAB.png",
		buildTime = 6750,
	},

	rus_sortie_partisan = {
		"ruspo2partisan",
		silent = 1,
		delay = 45,
		weight = 1,
		alwaysAttack = 1,
		name = "Partisan Supply Drop Sortie",
		description = "1 x Po-2 Kukuruznik (Partisan)",
		buildCostMetal = 2000,
		buildPic = "RUSPo2Partisan.png",
		buildTime = 2000,
	},
}

return rusSorties
