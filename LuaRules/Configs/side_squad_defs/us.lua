local usDefs = {
	 ----------------------------
	 -- US Platoons and Squads --
	 ----------------------------

	["us_platoon_hq"] =
	{
		members = {
			"usrifle",
			"usthompson",
			"usrifle",
			"usrifle",
			"usthompson",
			"usrifle",
		},
		name = "Rifle Squad",
		description = "4 x Garand Rifle, 2 x Thompson SMG: Small Combat Squad",
		buildCostMetal = 570,
		buildPic = "USRifle.png",
	},

	["us_platoon_rifle"] =
	{
		members = {
			"usthompson",
			"usthompson",
			"usrifle",
			"usrifle",
			"usrifle",
			"usrifle",
			"usrifle",
			"usrifle",
			"usrifle",
			"usrifle",
			"usbar",
			"usbar",
		},
		name = "Rifle Platoon",
		description = "8 x Garand Rifle, 2 x Thompson SMG, 2 x BAR Light Machinegun: Long-Range Combat Platoon",
		buildCostMetal = 1675,
		buildPic = "usrifle.png",
	},

	["us_platoon_assault"] =
	{
		members = {
			"usthompson",
			"usthompson",
			"usthompson",
			"usthompson",
			"usthompson",
			"usthompson",
			"usthompson",
			"usthompson",
			"usbazooka",
			"usflamethrower",
			"usbar",
			"usbar",
		},
		name = "Assault Platoon",
		description = "8 x Thompson SMG, 2 x BAR, 1 x Flamethrower, 1 x Bazooka: Close Quarters Assault Infantry",
		buildCostMetal = 1540,
		buildPic = "usthompson.png",
	},

	["us_platoon_mg"] =
	{
		members = {
			"usmg",
			"usmg",
			"usmg",
			"usobserv",
		},
		name = "Machinegun Squad",
		description = "3 x Browning .30 Cal Machinegun, 1 x Scout: Infantry Fire Support Squad",
		buildCostMetal = 1050,
		buildPic = "usmg.png",
	},

	["us_platoon_sniper"] =
	{
		members = {
			"ussniper",
			"usobserv",
		},
		name = "Sniper Team",
		description = "1 x Springfield Sniper, 1 x Scout: Long-Range Fire Support",
		buildCostMetal = 1240,
		buildPic = "ussniper.png",
	},

	["us_platoon_mortar"] =
	{
		members = {
			"usmortar",
			"usmortar",
			"usmortar",
			"usobserv",
		},
		name = "Mortar Team",
		description = "3 x M1 Mortar, 1 x Scout: Heavy Infantry Fire Support",
		buildCostMetal = 2100,
		buildPic = "usmortar.png",
	},

	["us_platoon_at"] =
	{
		members = {
			"usbazooka",
			"usbazooka",
			"usbazooka",
		},
		name = "Anti-Tank Squad",
		description = "3 x Bazooka: Anti-Tank Infantry",
		buildCostMetal = 350,
		buildPic = "usbazooka.png",
	},

	["us_platoon_scout"] =
	{
		members = {
			"usobserv",
			"usobserv",
			"usobserv",
		},
		name = "Scout Team",
		description = "3 x Scout: Reconaissance",
		buildCostMetal = 440,
		buildPic = "usobserv.png",
	},

	["us_platoon_flame"] =
	{
		members = {
			"usflamethrower",
			"usflamethrower",
			"usflamethrower",
			"usflamethrower",
		},
		name = "Flamethrower Squad",
		description = "4 x Flamethrower: Specialized Assault Infantry",
		buildCostMetal = 508,
		buildPic = "usflamethrower.png",
	},

	["us_platoon_infgun"] =
	{
		members = {
			"usobserv",
			"usm8gun",
		},
		name = "Pack Howitzer Team",
		description = "1 x 75mm M8, 1 x Scout: Long-Range Fire Support",
		buildCostMetal = 1290,
		buildPic = "USM8Gun.png",
	},

	["us_platoon_landing"] =
	{
		members = {
			"usobserv",
			"usobserv",
			"usmg",
			"usbar",
			"usbar",
			"usbar",
			"usbar",
			"usthompson",
			"usthompson",
			"usthompson",
			"usthompson",
			"usthompson",
			"usthompson",
			"usrifle",
			"usrifle",
			"usrifle",
			"usrifle",
			"usrifle",
			"usrifle",
			"usrifle",
			"usrifle",
			"usrifle",
			"usrifle",
			"usrifle",
			"usrifle",
		},
		buildCostMetal = 3500,
		-- other fields not needed for transport squads
	},

	["us_platoon_lct"] =
	{
		members = {
			"usm4a4sherman",
			"usm4a4sherman",
			"usm4a4sherman",
			"usm4a4sherman",
			"usm3halftrack",
		},
		-- other fields not needed for transport squads
	},
}

return usDefs
