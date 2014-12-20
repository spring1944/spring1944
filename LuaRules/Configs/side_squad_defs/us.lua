local usDefs = {
	 ----------------------------
	 -- US Platoons and Squads --
	 ----------------------------

    ["us_platoon_hq"] =
	{
		members = {
			"usgirifle",
			"usgithompson",
			"usgirifle",
			"usgirifle",
			"usgithompson",
			"usgirifle",
		},
		name = "Rifle Squad",
		description = "4 x Garand Rifle, 2 x Thompson SMG: Small Combat Squad",
		buildCostMetal = 570,
		buildPic = "USGIRifle.png",
		buildTime = 570,
		side = "US",
		objectName = "MortarShell.s3o",
	},

	["us_platoon_rifle"] = 
	{
		members = {
			"usgithompson",
			"usgithompson",
			"usgirifle",
			"usgirifle",
			"usgirifle",
			"usgirifle",
			"usgirifle",
			"usgirifle",
			"usgirifle",
			"usgirifle",
			"usgibar",
			"usgibar",
		},
		name = "Rifle Platoon",
		description = "8 x Garand Rifle, 2 x Thompson SMG, 2 x BAR Light Machinegun: Long-Range Combat Platoon",
		buildCostMetal = 1675,
		buildPic = "usgirifle.png",
		buildTime = 1675,
		side = "US",
		objectName = "MortarShell.s3o",
	},
	
	["us_platoon_assault"] = 
	{
		members = {
			"usgithompson",
			"usgithompson",
			"usgithompson",
			"usgithompson",
			"usgithompson",
			"usgithompson",
			"usgithompson",
			"usgithompson",
			"usgibazooka",
			"usgiflamethrower",
			"usgibar",
			"usgibar",
		},
		name = "Assault Platoon",
		description = "8 x Thompson SMG, 2 x BAR, 1 x Flamethrower, 1 x Bazooka: Close Quarters Assault Infantry",
		buildCostMetal = 1540,
		buildPic = "usgithompson.png",
		buildTime = 1540,
		side = "US",
		objectName = "MortarShell.s3o",
	},
	
	["us_platoon_mg"] = 
	{
		members = {
			"usgimg",
			"usgimg",
			"usgimg",
			"usobserv",
		},
		name = "Machinegun Squad",
		description = "3 x Browning .30 Cal Machinegun, 1 x Scout: Infantry Fire Support Squad",
		buildCostMetal = 1050,
		buildPic = "usgimg.png",
		buildTime = 1050,
		side = "US",
		objectName = "MortarShell.s3o",
	},
	
	["us_platoon_sniper"] = 
	{
		members = {
			"usgisniper",
			"usobserv",
		},
		name = "Sniper Team",
		description = "1 x Springfield Sniper, 1 x Scout: Long-Range Fire Support",
		buildCostMetal = 1240,
		buildPic = "usgisniper.png",
		buildTime = 1240,
		side = "US",
		objectName = "MortarShell.s3o",
	},
	
	["us_platoon_mortar"] = 
	{
		members = {
			"usm1mortar",
			"usm1mortar",
			"usm1mortar",
			"usobserv",
		},
		name = "Mortar Team",
		description = "3 x M1 Mortar, 1 x Scout: Heavy Infantry Fire Support",
		buildCostMetal = 1850,
		buildPic = "usm1mortar.png",
		buildTime = 1850,
		side = "US",
		objectName = "MortarShell.s3o",
	},
	
	["us_platoon_at"] = 
	{
		members = {
			"usgibazooka",
			"usgibazooka",
			"usgibazooka",
		},
		name = "Anti-Tank Squad",
		description = "3 x Bazooka: Anti-Tank Infantry",
		buildCostMetal = 350,
		buildPic = "usgibazooka.png",
		buildTime = 350,
		side = "US",
		objectName = "MortarShell.s3o",
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
		buildTime = 440,
		side = "US",
		objectName = "MortarShell.s3o",
	},
	
	["us_platoon_flame"] = 
	{
		members = {
			"usgiflamethrower",
			"usgiflamethrower",
			"usgiflamethrower",
			"usgiflamethrower",
		},
		name = "Flamethrower Squad",
		description = "4 x Flamethrower: Specialized Assault Infantry",
		buildCostMetal = 800,
		buildPic = "usgiflamethrower.png",
		buildTime = 800,
		side = "US",
		objectName = "MortarShell.s3o",
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
		buildTime = 1290,
		side = "US",
		objectName = "MortarShell.s3o",
	},
	
	["us_platoon_landing"] =
	{
		members = {
			"usobserv",
			"usobserv",
			"usgimg",
			"usgibar",
			"usgibar",
			"usgibar",
			"usgibar",
			"usgithompson",
			"usgithompson",
			"usgithompson",	
			"usgithompson",
			"usgithompson",
			"usgithompson",
			"usgirifle",
			"usgirifle",
			"usgirifle",
			"usgirifle",
			"usgirifle",
			"usgirifle",
			"usgirifle",
			"usgirifle",
			"usgirifle",
			"usgirifle",
			"usgirifle",
			"usgirifle",
		},
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
