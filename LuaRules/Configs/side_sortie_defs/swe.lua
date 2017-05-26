local sweSorties = {
	swe_sortie_recon = {
		members = {
			"swes14b",
		},
		delay = 15,
		name = "Recon Sortie",
		description = "1 x S 14B Storch Reconnaissance Plane",
		buildCostMetal = 1000,
		buildPic = "SWES14B.png",
	},

	swe_sortie_interceptor = {
		members = {
			"swej22",
			"swej22",
			"swej22",
			"swej22",
		},
		delay = 15,
		weight = 1,
		name = "Interceptor Sortie",
		description = "4 x FFVS J 22",
		buildCostMetal = 3200,
		buildPic = "SWEJ22.png",
	},

	swe_sortie_fighter = {
		members = {
			"swej21a",
			"swej21a",
			"swej21a",
		},
		delay = 30,
		weight = 1,
		name = "Air Superiority Fighter Sortie",
		description = "3 x SAAB J 21A",
		buildCostMetal = 4050,
		buildPic = "SWEJ21A.png",
	},

	swe_sortie_divebomber = {
		members = {
			"sweb17a",
			"sweb17a",
		},
		delay = 45,
		weight = 1,
		name = "Dive Bomber Sortie",
		description = "2 x SAAB B 17A",
		buildCostMetal = 6750,
		buildPic = "SWEB17A.png",
	},
	
	swe_sortie_at = {
		members = {
			"sweb18",
			"sweb18",
		},
		delay = 45,
		weight = 1,
		name = "Anti-tank sortie",
		description = "2 x SAAB T 18",
		buildCostMetal = 4500,
		buildPic = "SWEB18.png",
	},
}

return sweSorties
