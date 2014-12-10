local jpnDefs = {
	["jpn_platoon_rifle"] =
	{
		members = {
			"jpnrifle",
			"jpnrifle",
			"jpnrifle",
			"jpnrifle",
			"jpnrifle",
			"jpnrifle",
			"jpnrifle",
			"jpnrifle",
			"jpntype100smg",
			"jpnkneemortar",
		},
		name = "Arisaka Rifle Platoon",
		description = "8 x Arisaka Type 99 Rifle, 1 x Type 100 SMG, 1 x Knee Mortar: Long-Range Combat Platoon",
		buildCostMetal = 1500,
		buildPic = "JPNRifle.png",
		buildTime = 1500,
		side = "JPN",
	},
	["jpn_platoon_hq"] =
	{
		members = {
			"jpnrifle",
			"jpnrifle",
			"jpnrifle",
			"jpnrifle",
			"jpnrifle",
			"jpntype100smg",
		},
		name = "Rifle Squad",
		description = "5 x Arisaka Type 99, 1 x Type 100 SMG: Small Combat Squad",
		buildCostMetal = 600,
		buildPic = "JPNRifle.png",
		buildTime = 600,
		side = "JPN",
	},
	["jpn_platoon_assault"] =
	{
		members = {
			"jpntype100smg",
			"jpntype100smg",
			"jpntype100smg",
			"jpntype100smg",
			"jpntype100smg",
			"jpntype100smg",
			"jpntype100smg",
			"jpntype100smg",
			"jpntype100smg",
			"jpntype99lmg",
		},
		name = "Assault Platoon",
		description = "9 x Type 99 SMG, 1 x Type 99 LMG: Close-Quarters Assault Infantry",
		buildCostMetal = 1400,
		buildPic = "JPNType100SMG.png",
		buildTime = 1400,
		side = "JPN",
	},
	["jpn_platoon_mg"] =
	{
		members = {
			"jpntype99lmg",
			"jpntype99lmg",
			"jpntype92hmg",
			"jpnobserv",
		},
		name = "Machinegun Squad",
		description = "2 x Type 99 Machinegun, 1 x Type 98 Heavy Machinegun, 1 x Scout: Infantry Fire Support Squad",
		buildCostMetal = 1200,
		buildPic = "JPNType99LMG.png",
		buildTime = 1200,
		side = "JPN",
	},
	["jpn_platoon_sniper"] =
	{
		members = {
			"jpnsniper",
			"jpnobserv",
		},
		name = "Sniper Team",
		description = "1 x Arisaka Type 99 Sniper, 1 x Spotter: Long-Range Fire Support",
		buildCostMetal = 1140,
		buildPic = "JPNSniper.png",
		buildTime = 1140,
		side = "JPN",
	},
	["jpn_platoon_mortar"] =
	{
		members = {
			"jpnmortar",
			"jpnmortar",
			"jpnmortar",
			"jpnobserv",
		},
		name = "Mortar Team",
		description = "3 x Type 97 81mm Mortar, 1 x Spotter: Heavy Infantry Fire Support",
		buildCostMetal = 1580,
		buildPic = "JPNMortar.png",
		buildTime = 1580,
		side = "JPN",
	},
	["jpn_platoon_at"] =
	{
		members = {
			"jpntype4at",
			"jpntype3at",
			"jpntype3at",
		},
		name = "Anti-Tank Squad",
		description = "2 x Type 3 AT Grenade, 1 x Type 4 Rocket Launcher: Anti-Tank Infantry",
		buildCostMetal = 400,
		buildPic = "JPNType3AT.png",
		buildTime = 400,
		side = "JPN",
	},
	
	["jpn_platoon_landing"] =
	{
		members = {
			"jpntype99lmg",
			"jpntype99lmg",
			"jpnkneemortar",
			"jpntype100smg",
			"jpntype100smg",
			"jpntype100smg",
			"jpntype100smg",
			"jpntype100smg",
			"jpnrifle",
			"jpnrifle",
			"jpnrifle",
			"jpnrifle",
			"jpnrifle",
			"jpnrifle",
			"jpnrifle",
			"jpnrifle",
			"jpnrifle",
			"jpnrifle",
			"jpnobserv",
			"jpntype99lmg",
			"jpntype99lmg",
			"jpnkneemortar",
			"jpntype100smg",
			"jpntype100smg",
			"jpntype100smg",
			"jpntype100smg",
			"jpntype100smg",
			"jpnrifle",
			"jpnrifle",
			"jpnrifle",
			"jpnrifle",
			"jpnrifle",
			"jpnrifle",
			"jpnrifle",
			"jpnrifle",
			"jpnrifle",
			"jpnrifle",
			"jpntype3at",
			"jpntype3at",
			"jpnobserv",
		},
		-- other fields not needed for transport squads
	},
	["jpn_platoon_amph"] =
	{
		members = {
			"jpnobserv",
			"jpntype99lmg",
			"jpntype100smg",
			"jpntype100smg",
			"jpntype3at",
			"jpnrifle",
			"jpnrifle",
            		"jpnhqengineer",
			"jpnrifle",
			"jpnrifle",
			"jpnrifle",
			"jpnrifle",
		},
	},
	["jpn_platoon_hoha"] =
	{
		members = {

			"jpntype99lmg",
			"jpntype100smg",
			"jpntype100smg",
			"jpntype3at",
			"jpnrifle",
			"jpnrifle",
			"jpnrifle",
			"jpnrifle",
			"jpnrifle",
		},
	},
	["jpn_tankette_platoon_teke"] =
	{
		members = {
			"jpnteke",
			"jpnteke_hmg",
		},
		name = "tankette_platoon_teke",
		description = "1 x tnakette teke 37mm, 1 x tankette teke 7.7mm",
		buildCostMetal = 1300,
		buildPic = "JPNteke.png",
		model = "JPNteke.s3o",
		buildTime = 1300,
		side = "JPN",
	},
	["jpn_platoon_lct"] =
	{
		members = {
			"jpnshinhotochiha",
		},
	},
}

return jpnDefs
