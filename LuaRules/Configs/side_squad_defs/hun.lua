local hunDefs = {
	 -----------------------------
	 -- HUN Platoons and Squads --
	 -----------------------------

	["hun_platoon_hq"] =
	{
		members = {
			"hunrifle",
			"hunsmg",
			"hunrifle",
			"hunrifle",
			"hunsmg",
			"hunrifle",
		},
		name = "Rifle Squad",
		description = "4 x FEG 35M Rifle, 2 x 43M SMG: Small Combat Squad",
		buildCostMetal = 550,
		buildPic = "HUNRifle.png",
	},

	["hun_platoon_rifle"] =
	{
		members = {
			"hunsmg",
			"hunsmg",
			"hunrifle",
			"hunrifle",
			"hunrifle",
			"hunrifle",
			"hunrifle",
			"hunrifle",
			"hunrifle",
			"hunlmg",
		},
		name = "FEG 35M Rifle Platoon",
		description = "7 x FEG 35M Rifle, 2 x 43M SMG, 1 x 31M Machinegun: Long-Range Combat Platoon",
		buildCostMetal = 1830,
		buildPic = "HUNRifle.png",
	},

	["hun_platoon_assault"] =
	{
		members = {
			"hunsmg",
			"hunsmg",
			"hunsmg",
			"hunsmg",
			"hunsmg",
			"hunsmg",
			"hunsmg",
			"hunsmg",
			"hunsmg",
			"hunsmg",
			"hunlmg",
			"hunpanzerfaust",
		},
		name = "Assault Platoon",
		description = "10 x 43M SMG, 1 x 31M LMG, 1 x Panzerfaust Anti-Tank: Close-Quarters Assault Infantry",
		buildCostMetal = 1800,
		buildPic = "hunsmg.png",
	},

	["hun_platoon_mg"] =
	{
		members = {
			"hunlmg",
			"hunlmg",
			"hunhmg",
			"hunobserv",
		},
		name = "Machinegun Squad",
		description = "2 x 31M Light Machinegun, 1 x 7M/31 Heavy Machinegun, 1 x Scout: Infantry Fire Support Squad",
		buildCostMetal = 1350,
		buildPic = "HUNHMG.png",
	},

	["hun_platoon_sniper"] =
	{
		members = {
			"hunsniper",
			"hunobserv",
		},
		name = "Sniper Team",
		description = "1 x FEG 35M Sniper, 1 x Scout: Long-Range Fire Support",
		buildCostMetal = 1250,
		buildPic = "HUNSniper.png",
	},

	["hun_platoon_mortar"] =
	{
		members = {
			"hunmortar",
			"hunobserv",
			"hunmortar",
			"hunmortar",
		},
		name = "8 cm 36/39M aknavető Mortar team",
		description = "8 cm 36/39M aknavető (Mortar), 1 x Scout: Heavy Infantry Fire Support",
		buildCostMetal = 2110,
		buildPic = "hunmortar.png",
	},

	["hun_platoon_at"] =
	{
		members = {
			"hunpanzerfaust",
			"hunpanzerfaust",
			"hunpanzerschrek",
		},
		name = "Anti-Tank Squad",
		description = "2 x Panzerfaust, 1 x Panzerschrek: Anti-Tank Infantry",
		buildCostMetal = 450,
		buildPic = "HUNPanzerfaust.png",
	},

	["hun_platoon_scout"] =
	{
		members = {
			"hunobserv",
			"hunobserv",
			"hunobserv",
		},
		name = "Scout Team",
		description = "3 x Scout: Reconaissance",
		buildCostMetal = 470,
		buildPic = "HUNObserv.png",
	},

	["hun_platoon_landing"] =
	{
		members = {
			"hunobserv",
			"hunobserv",
			"hunlmg",
			"hunsmg",
			"hunsmg",
			"hunsmg",
			"hunsmg",
			"hunsmg",
			"hunrifle",
			"hunrifle",
			"hunrifle",
			"hunrifle",
			"hunrifle",
			"hunrifle",
			"hunrifle",
			"hunrifle",
			"hunrifle",
			"hunrifle",
			"hunrifle",
			"hunrifle",
		},
        buildCostMetal = 3500,
		-- other fields not needed for transport squads
	},

	["hun_platoon_lct"] =
	{
		members = {
			"hun40mturan",
			"hun41mturanii",
		},
		-- other fields not needed for transport squads
	},
}

return hunDefs
