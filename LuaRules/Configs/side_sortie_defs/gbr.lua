local gbrSorties = {
	gbr_sortie_recon = {
		members = {
			"gbrauster",
		},
		delay = 15,
		name = "Recon Sortie",
		description = "1 x TC Auster AOP Mk V",
		buildCostMetal = 1000,
		buildPic = "GBRAuster.png",
	},

	gbr_sortie_interceptor = {
		members = {
			"gbrspitfiremkxiv",
			"gbrspitfiremkxiv",
			"gbrspitfiremkxiv",
			"gbrspitfiremkxiv",
		},
		delay = 15,
		weight = 1,
		name = "Interceptor Sortie",
		description = "4 x Spitfire Mk XIVe",
		buildCostMetal = 5000,
		buildPic = "GBRSPitfireMkXIV.png",
	},

	gbr_sortie_fighter_bomber = {
		members = {
			"gbrspitfiremkix",
			"gbrspitfiremkix",
		},
		delay = 45,
		weight = 1,
		name = "Fighter-Bomber Sortie",
		description = "2 x Spitfire Mk IXe LF",
		buildCostMetal = 6750,
		buildPic = "GBRSpitfireMkIX.png",
	},

	gbr_sortie_attack = {
		members = {
			"gbrtyphoon",
			"gbrtyphoon",
		},
		delay = 45,
		weight = 1,
		name = "Attack Sortie",
		description = "2 x Hawker Typhoon Mk.IB",
		buildCostMetal = 5100,
		buildPic = "GBRTyphoon.png",
	},

	gbr_sortie_glider_horsa = {
		members = {
			"gbrhorsa",
		},
		groundOnly = 1,
		alwaysAttack = 1,
		delay = 45,
		weight = 1,
		silent = 1,
		name = "Glider-Borne Infantry Sortie",
		description = "3 x Commando, 8 x Rifle, 2 x Sten SMG, 3 x Bren LMG, 2 x PIAT, 1 x Scout, 1 x 3\" Mortar, 1 x 75mm Pack Howitzer",
		buildCostMetal = 5625,
		buildPic = "GBRHorsa.png",
	},
}

return gbrSorties
