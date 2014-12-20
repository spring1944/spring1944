local gerSorties = {
	ger_sortie_recon = {
		members = {
			"gerfi156",
		},
		delay = 15,
		name = "Recon Sortie",
		description = "1 x Fi 156 Storch",
		buildCostMetal = 1000,
		buildPic = "GERFi156.png",
		buildTime = 1000,
		objectName = "MortarShell.s3o",
	},
  
	ger_sortie_interceptor = {
		members = {
			"gerbf109",
			"gerbf109",
			"gerbf109",
			"gerbf109",
		},
		delay = 15,
		weight = 1,
		name = "Interceptor Sortie",
		description = "4 x Bf 109K-4",
		buildCostMetal = 3940,
		buildPic = "GERBf109.png",
		buildTime = 3940,
		objectName = "MortarShell.s3o",
	},
  
	ger_sortie_fighter = {
		members = {
			"gerfw190",
			"gerfw190",
			"gerfw190",
			"gerfw190",
		},
		delay = 30,
		weight = 1,
		name = "Air Superiority Fighter Sortie",
		description = "4 x Fw 190A-8",
		buildCostMetal = 4500,
		buildPic = "GERFw190.png",
		buildTime = 4500,
		objectName = "MortarShell.s3o",
	},
  
	ger_sortie_fighter_bomber = {
		members = {
			"gerfw190g",
			"gerfw190g",
		},
		delay = 45,
		weight = 1,
		name = "Fighter-Bomber Sortie",
		description = "2 x Fw 190F-8",
		buildCostMetal = 6750,
		buildPic = "GERFw190G.png",
		buildTime = 6750,
		objectName = "MortarShell.s3o",
	},
  
	ger_sortie_attack = {
		members = {
			"gerju87g",
			"gerju87g",
			"gerju87g",
		},
		delay = 45,
		weight = 1,
		name = "Tankbuster Sortie",
		description = "3 x Ju 87G-1 Stuka",
		buildCostMetal = 5400,
		buildPic = "GERJu87G.png",
		buildTime = 5400,
		objectName = "MortarShell.s3o",
	},
  
	ger_sortie_flying_bomb = {
		members = {
			"gerv1",
		},
		groundOnly = 1,
		alwaysAttack = 1,
		delay = 45,
		weight = 1,
		silent = 1,
		name = "Flying Bomb Strike",
		description = "1 x V-1 (Fi-103)",
		buildCostMetal = 1825,
		buildPic = "GERV1.png",
		buildTime = 1825,
		objectName = "MortarShell.s3o",
	},
}

return gerSorties
