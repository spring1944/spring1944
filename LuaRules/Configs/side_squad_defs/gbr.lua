local gbrDefs = {
	 -----------------------------
	 -- GBR Platoons and Squads --
	 -----------------------------

	["gbr_platoon_hq"] =
	{
		members = {
			"gbrbren",
			"gbrsten",
			"gbrrifle",
			"gbrrifle",
			"gbrsten",
			"gbrsten",
		},
		name = "HQ Combat Squad",
		description = "2 x Enfield Rifle, 3 x Sten SMG, 1 x Bren LMG: Small Combat Squad",
		buildCostMetal = 800,
		buildPic = "GBRRifle.png",
	},

	 ["gbr_platoon_rifle"] =
	{
		members = {
			"gbrrifle",
			"gbrrifle",
			"gbrrifle",
			"gbrrifle",
			"gbrrifle",
			"gbrrifle",
			"gbrrifle",
			"gbrrifle",
			"gbrrifle",
			"gbrrifle",
			"gbrsten",
			"gbrsten",
		},
		name = "Enfield Rifle Platoon",
		description = "10 x Enfield Rifle, 2 x Sten SMG: Long-Range Combat Platoon",
		buildCostMetal = 2140,
		buildPic = "GBRRifle.png",
	},

	["gbr_platoon_assault"] =
	{
		members = {
			"gbrsten",
			"gbrsten",
			"gbrsten",
			"gbrsten",
			"gbrsten",
			"gbrsten",
			"gbrsten",
			"gbrsten",
			"gbrsten",
			"gbrsten",
			"gbrcommando",
		},
		name = "Assault Platoon",
		description = "10 x STEN SMG, 1 x Commando: Close-Quarters Assault Infantry",
		buildCostMetal = 1960,
		buildPic = "GBRSTEN.png",
	},

	["gbr_platoon_mg"] =
	{
		members = {
			"gbrbren",
			"gbrvickers",
			"gbrbren",
			"gbrobserv",
		},
		name = "Machinegun Squad",
		description = "1 x Vickers, 2 x Bren Machineguns, 1 x Scout: Infantry Fire Support Squad",
		buildCostMetal = 1050,
		buildPic = "GBRBREN.png",
	},

	["gbr_platoon_sniper"] =
	{
		members = {
			"gbrsniper",
			"gbrobserv",
		},
		name = "Sniper Team",
		description = "1 x Enfield Sniper, 1 x Scout: Long-Range Fire Support",
		buildCostMetal = 1300,
		buildPic = "GBRSniper.png",
	},

	["gbr_platoon_mortar"] =
	{
		members = {
			"gbr3inmortar",
			"gbr3inmortar",
			"gbr3inmortar",
			"gbrobserv",
		},
		name = "3-inch Mortar Team",
		description = "3 x Mortar, 1 x Scout: Heavy Infantry Fire Support",
		buildCostMetal = 2140,
		buildPic = "GBR3InMortar.png",
	},

	["gbr_platoon_at"] =
	{
		members = {
			"gbrpiat",
			"gbrpiat",
			"gbrpiat",
		},
		name = "PIAT Anti-Tank Squad",
		description = "3 x PIAT: Anti-Tank Infantry",
		buildCostMetal = 350,
		buildPic = "GBRPIAT.png",
	},

	["gbr_platoon_scout"] =
	{
		members = {
			"gbrobserv",
			"gbrobserv",
			"gbrobserv",
		},
		name = "Scout Team",
		description = "3 x Scout: Reconaissance",
		buildCostMetal = 580,
		buildPic = "GBRObserv.png",
	},

	["gbr_platoon_commando"] =
	{
		members = {
			"gbrcommandoc",
		},
		name = "Commando Pathfinder Squad",
		description = "1 x Commando Pathfinder: Special-Ops, Can Call Airdrop",
		buildCostMetal = 970,
		buildPic = "GBRCommando.png",
	},

	["gbr_platoon_commando_lz"] =
	{
		members = {
            "gbrglidersupplies",
			"gbrcommando",
			"gbrcommando",
			"gbrcommando",
			"gbrcommando",
			"gbrcommando",
			"gbrcommando",
		},
		name = "Commando Squad",
		description = "6 x Commando: Special-Ops Infantry",
		buildCostMetal = 1800,
		buildPic = "GBRCommando.png",
	},

	["gbr_platoon_glider_horsa"] =
	{
		members = {
			"gbrcommando",
			"gbrcommando",
			"gbrcommando",
			"gbrpararifle",
			"gbrpararifle",
			"gbrpararifle",
			"gbrpararifle",
			"gbrpararifle",
			"gbrpararifle",
			"gbrpararifle",
			"gbrpararifle",
			"gbrparasten",
			"gbrparasten",
			"gbrpara3inmortar",
			"gbrparaobserv",
			"gbrparabren",
			"gbrparabren",
			"gbrparabren",
			"gbrparapiat",
			"gbrparapiat",
			"gbrparam8gun",
		},
		name = "Glider Platoon",
		description = "10 x STEN SMG, 1 x Commando: Close-Quarters Assault Infantry",
		buildCostMetal = 4000,
		buildPic = "GBRSTEN.png",
	},

	["gbr_platoon_landing"] =
	{
		members = {
			"gbrcommando",
			"gbrcommando",
			"gbrbren",
			"gbrsten",
			"gbrsten",
			"gbrsten",
			"gbrsten",
			"gbrsten",
			"gbrrifle",
			"gbrrifle",
			"gbrrifle",
			"gbrrifle",
			"gbrrifle",
			"gbrrifle",
			"gbrrifle",
			"gbrrifle",
			"gbrrifle",
			"gbrrifle",
			"gbrrifle",
			"gbrrifle",
		},
        buildCostMetal = 4000,
		-- other fields not needed for transport squads
	},

	["gbr_platoon_lct"] =
	{
		members = {
			"gbrcromwell",
			"gbrcromwell",
			"gbrcromwell",
			"gbrcromwell",
			"gbrm5halftrack",-- 5
			"gbrcromwellmkvi", --6
			"gbrm5halftrack", -- 7
			"gbrcromwellmkvi", -- 8
			"gbrcromwell",
		},
		-- other fields not needed for transport squads
	},
}

return gbrDefs
