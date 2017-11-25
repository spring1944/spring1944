local hunSorties = {
	hun_sortie_recon = {
		members = {
			"hunwm21",
		},
		delay = 15,
		name = "Recon Sortie",
		description = "1 x WM-21",
		buildCostMetal = 1000,
		buildPic = "hunwm21.png",
	},
	hun_sortie_interceptor = {
		members = {
			"hunbf109",
			"hunbf109",
			"hunbf109",
			"hunbf109",
		},
		delay = 15,
		weight = 1,
		name = "Interceptor Sortie",
		description = "4 x Bf 109K-4",
		buildCostMetal = 3940,
		buildPic = "HUNBf109.png",
	},
	hun_sortie_fighter = {
		members = {
			"hunme210",
			"hunme210",
			"hunme210",
		},
		delay = 30,
		weight = 1,
		name = "Air Superiority Fighter Sortie",
		description = "3 x Me 210Ca-1",
		buildCostMetal = 4500,
		buildPic = "HUNMe210.png",
	},
	hun_sortie_bomber = {
		members = {
			"hunme210_bomber",
			"hunme210_bomber",
		},
		delay = 45,
		weight = 1,
		name = "Bomber Sortie",
		description = "2 x Me 210 gyorsbombázó",
		buildCostMetal = 6750,
		buildPic = "HUNMe210_bomber.png",
	},
	hun_sortie_attack = {
		members = {
			"hunme210_attack",
			"hunme210_attack",
		},
		delay = 45,
		weight = 1,
		name = "Attack sortie",
		description = "2 x Me 210 with Nebelwerfer rockets",
		buildCostMetal = 6600,
		buildPic = "HUNMe210_bomber.png",
	},
}

return hunSorties
