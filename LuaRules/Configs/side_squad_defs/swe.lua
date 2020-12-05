local sweDefs = {
	 ----------------------------
	 -- SWE Platoons and Squads --
	 ----------------------------

	["swe_platoon_hq"] =
	{
		members = {
			"swerifle",
			"swerifle",
			"swerifle",
			"sweagm42",
			"swekpistm3739",
		},
		name = "HQ Platoon",
		description = "3 x Gevär_M38, 1 x Automatgevär_M42, 1 x kpist37/39: Small Combat Squad",
		buildCostMetal = 577,
		buildPic = "swerifle.png",
	},

	["swe_platoon_rifle"] =
	{
		members = {
			"sweagm42",
			"sweagm42",
			"swerifle",
			"swerifle",
			"swerifle",
			"swerifle",
			"swerifle",
			"swerifle",
			"swerifle",
			"swerifle",
			"swekgm37",
			"swekgm37",
		},
		name = "Rifle Platoon",
		description = "2 x Automatgevär_M42, 8 x Gevär_M38, 2 x Kulsprutegevär Light Machinegun: Long-Range Combat Platoon",
		buildCostMetal = 1927,
		buildPic = "swerifle.png",
	},

	["swe_platoon_assault"] =
	{
		members = {
			"swekpistm3739",
			"swekpistm3739",
			"swekpistm3739",
			"swekpistm3739",
			"swekpistm3739",
			"swekpistm3739",
			"swekpistm3739",
			"swekpistm3739",
			"swepskottm45",
			"sweagm42",
			"sweagm42",
			"swekgm37",
		},
		name = "Assault Platoon",
		description = "8 x Kpist m/37 SMG, 2 x Automatgevär_M42, 1 x Kulsprutegevär, 1 x swepskottm45: Close Quarters Assault Infantry",
		buildCostMetal = 1771,
		buildPic = "swekpistm3739.png",
	},

	["swe_platoon_mg"] =
	{
		members = {
			"swemg",
			"swemg",
			"swemg",
			"sweobserv",
		},
		name = "Machinegun Squad",
		description = "3 x M1919A4Browning Machinegun, 1 x Scout: Infantry Fire Support Squad",
		buildCostMetal = 1280,
		buildPic = "swemg.png",
	},

	["swe_platoon_sniper"] =
	{
		members = {
			"swesniper",
			"sweobserv",
		},
		name = "Sniper Team",
		description = "1 x Enfieldfield Sniper, 1 x Scout: Long-Range Fire Support",
		buildCostMetal = 1140,
		buildPic = "swesniper.png",
	},

	["swe_platoon_mortar"] =
	{
		members = {
			"swemortar",
			"swemortar",
			"swemortar",
			"sweobserv",
		},
		name = "Mortar Team",
		description = "3 x M1 Mortar, 1 x Scout: Heavy Infantry Fire Support",
		buildCostMetal = 2140,
		buildPic = "swemortar.png",
	},

	["swe_platoon_at"] =
	{
		members = {
			"swepvgm42",
			"swepskottm45",
			"swepskottm45",
			"swepskottm45",
		},
		name = "Anti-Tank Squad",
		description = "1 x Pansarvärnsgevär m/42, 3 x Pansarskott m/45: Anti-Tank Infantry",
		buildCostMetal = 400,
		buildPic = "swepskottm45.png",
	},

	["swe_platoon_scout"] =
	{
		members = {
			"sweobserv",
			"sweobserv",
			"sweobserv",
		},
		name = "Scout Team",
		description = "3 x Scout: Reconaissance",
		buildCostMetal = 440,
		buildPic = "sweobserv.png",
	},

	["swe_platoon_crew"] =
	{
		members = {
			"swecrew",
			"swecrew",
		},
		name = "Crew members",
		description = "2 x Crew: Guns and vehicles crew",
		buildCostMetal = 450,
		buildPic = "swecrew.png",
	},

	["swe_platoon_landing"] =
	{
		members = {
			"sweobserv",
			"sweobserv",
			"swemg",
			"swekgm37",
			"swekgm37",
			"swekgm37",
			"swekgm37",
			"swekpistm3739",
			"swekpistm3739",
			"swekpistm3739",
			"swekpistm3739",
			"swekpistm3739",
			"swekpistm3739",
			"swerifle",
			"swerifle",
			"swerifle",
			"swerifle",
			"swerifle",
			"swerifle",
			"swerifle",
			"swerifle",
			"swerifle",
			"swerifle",
			"swerifle",
			"swerifle",
		},
		buildCostMetal = 3500,
		-- other fields not needed for transport squads
	},
	["swe_platoon_lct"] =
	{
		members = {
			"swestrvm42",
			"swestrvm42",
			"swestrvm42",
			"swesavm43",
			"swetgbilm42",
		},
		-- other fields not needed for transport squads
	},

}

return sweDefs
