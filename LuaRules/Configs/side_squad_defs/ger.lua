local gerDefs = {
	 -----------------------------
	 -- GER Platoons and Squads --
	 -----------------------------
	["ger_all"] = 
	{
	},

	["ger_platoon_hq"] =
	{
		members = {
			"gerrifle",
			"germp40",
			"gerrifle",
			"gerrifle",
			"germp40",
			"gerrifle",
		},
		name = "Rifle Squad",
		description = "4 x Kar 98K Rifle, 2 x MP40 SMG: Small Combat Squad",
		buildCostMetal = 610,
		buildPic = "GERRifle.png",
	},

	["ger_platoon_rifle"] =
	{
		members = {
			"germp40",
			"germp40",
			"gerrifle",
			"gerrifle",
			"gerrifle",
			"gerrifle",
			"gerrifle",
			"gerrifle",
			"gerrifle",
			"germg42",
		},
		name = "Kar 98K Rifle Platoon",
		description = "7 x Kar 98K Rifle, 2 x MP40 SMG, 1 x MG42 Machinegun: Long-Range Combat Platoon",
		buildCostMetal = 1830,
		buildPic = "GERRifle.png",
	},

	["ger_platoon_assault"] =
	{
		members = {
			"germp40",
			"germp40",
			"germp40",
			"germp40",
			"germp40",
			"germp40",
			"germp40",
			"germp40",
			"germp40",
			"germp40",
			"gerpanzerfaust",
			"gerpanzerfaust",
		},
		name = "Assault Platoon",
		description = "10 x MP40 SMG, 2 x Panzerfaust Anti-Tank: Close-Quarters Assault Infantry",
		buildCostMetal = 1800,
		buildPic = "GERMP40.png",
	},

	["ger_platoon_mg"] =
	{
		members = {
			"germg42",
			"germg42",
			"germg42",
			"gerobserv",
		},
		name = "Machinegun Squad",
		description = "3 x MG42 Machinegun, 1 x Scout: Infantry Fire Support Squad",
		buildCostMetal = 1220,
		buildPic = "GERMG42.png",
	},

	["ger_platoon_sniper"] =
	{
		members = {
			"gersniper",
			"gerobserv",
		},
		name = "Sniper Team",
		description = "1 x Kar 98K Sniper, 1 x Scout: Long-Range Fire Support",
		buildCostMetal = 1110,
		buildPic = "GERSniper.png",
	},

	["ger_platoon_mortar"] =
	{
		members = {
			"gergrw34",
			"gerobserv",
			"gergrw34",
			"gergrw34",
		},
		name = "GrW 34 Mortar Team",
		description = "3 x GrW 34 Mortar, 1 x Scout: Heavy Infantry Fire Support",
		buildCostMetal = 2110,
		buildPic = "GERGrW34.png",
	},

	["ger_platoon_at"] =
	{
		members = {
			"gerpanzerfaust",
			"gerpanzerfaust",
			"gerpanzerschrek",
		},
		name = "Anti-Tank Squad",
		description = "2 x Panzerfaust, 1 x Panzerschrek: Anti-Tank Infantry",
		buildCostMetal = 350,
		buildPic = "GERPanzerfaust.png",
	},

	["ger_platoon_scout"] =
	{
		members = {
			"gerobserv",
			"gerobserv",
			"gerobserv",
		},
		name = "Scout Team",
		description = "3 x Scout: Reconaissance",
		buildCostMetal = 470,
		buildPic = "GERObserv.png",
	},

	["ger_platoon_infgun"] =
	{
		members = {
			"gerobserv",
			"gerleig18",
		},
		name = "Infantry Gun Team",
		description = "1 x 7.5cm leIG 18, 1 x Scout: Long-Range Fire Support",
		buildCostMetal = 1320,
		buildPic = "GERLeIG18.png",
	},

	["ger_platoon_landing"] =
	{
		members = {
			"gerobserv",
			"gerobserv",
			"germg42",
			"germp40",
			"germp40",
			"germp40",
			"germp40",
			"germp40",
			"gerrifle",
			"gerrifle",
			"gerrifle",
			"gerrifle",
			"gerrifle",
			"gerrifle",
			"gerrifle",
			"gerrifle",
			"gerrifle",
			"gerrifle",
			"gerrifle",
			"gerrifle",
		},
        buildCostMetal = 3500,
		-- other fields not needed for transport squads
	},

	["ger_platoon_lct"] =
	{
		members = {
			"gerpanzeriv",
			"gerpanzeriv",
			"gerpanzeriv",
		},
		-- other fields not needed for transport squads
	},
}

return gerDefs
