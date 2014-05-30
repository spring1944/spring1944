local rusDefs = {
	 -----------------------------
	 -- RUS Platoons and Squads --
	 -----------------------------
	 ["rus_platoon_commissar"] =
	{
		"ruscommissar",
		"ruscommissar",
		"ruscommissar",
		name = "Political Commissar Group",
		description = "3 x Commissar: Rapidly Captures Territory",
		buildCostMetal = 1150,
		buildPic = "ruscommissar.png",
		buildTime = 1150,
		side = "RUS",
	},
	
	 ["rus_platoon_rifle"] =
	{
		"rusptrd",
		"rusrifle",
  		"rusrifle",
  		"rusrifle",
  		"rusrifle",
  		"rusrifle",
  		"rusrifle",
  		"rusrifle",
  		"rusrifle",
		"rusrifle",
		"rusppsh",
		"rusppsh",
		name = "Rifle Platoon",
		description = "9 x Mosin-Nagant Rifle, 2 x PPsh-43 SMG, 1 x PTRD Anti-Tank Rifle: Long-Range Combat Platoon",
		buildCostMetal = 1100,
		buildPic = "RUSRifle.png",
		buildTime = 1100,
		side = "RUS",
	},
	

	["rus_platoon_assault"] =
	{
		"rusrpg43",
		"rusppsh",
		"rusppsh",
		"rusppsh",
		"rusppsh",
		"rusppsh",
		"rusppsh",
		"rusppsh",
		"rusppsh",
		"rusppsh",
		"rusppsh",
		"rusppsh",
		"rusdp",
		name = "Assault Platoon",
		description = "11 x PPsh-43 SMG, 1 x RPG43, 1 x DP Light Machinegun: Close-Quarters Assault Infantry",
		buildCostMetal = 1150,
		buildPic = "RUSPPsh.png",
		buildTime = 1150,
		side = "RUS",
	},
    	
    ["rus_platoon_partisan"] =
	{
		"ruspartisanrifle",
		"ruspartisanrifle",
		"ruspartisanrifle",
		"ruspartisanrifle",
		"ruspartisanrifle",
		"ruspartisanrifle",
		"ruspartisanrifle",
		"ruspartisanrifle",
		"ruspartisanrifle",
		"ruspartisanrifle",
		"ruspartisanrifle",
		"ruspartisanrifle",
		name = "Partisan Contingent",
		description = "12 x Partisans: Conscripted Partisan Infantry",
		buildCostMetal = 1050,
		buildPic = "RUSRifle.png",
		buildTime = 1050,
		side = "RUS",
	},
	
	["rus_platoon_mg"] =
	{
		"rusdp",
		"rusmaxim",
		"rusdp",
		"rusobserv",
		name = "Machinegun Squad",
		description = "1 x Maxim Heavy Machinegun, 2 x DP Light Machinegun, 1 x Scout: Infantry Fire Support Squad",
		buildCostMetal = 900,
		buildPic = "RUSDP.png",
		buildTime = 900,
		side = "RUS",
	},

	["rus_platoon_sniper"] =
	{
		"russniper",
		"rusobserv",
		name = "Sniper Team",
		description = "1 x Mosin-Nagant Sniper, 1 x Scout: Long-Range Fire Support",
		buildCostMetal = 1120,
		buildPic = "russniper.png",
		buildTime = 1120,
		side = "RUS",
	},

	["rus_platoon_mortar"] =
	{
		"rusmortar",
		"rusmortar",
		"rusmortar",
		"rusobserv",
		name = "Mortar Team",
		description = "3 x M1937 Mortar, 1 x Scout: Heavy Infantry Fire Support",
		buildCostMetal = 1540,
		buildPic = "RUSMortar.png",
		buildTime = 1540,
		side = "RUS",
	},

	["rus_platoon_atlight"] =
	{
		"rusptrd",
		"rusptrd",
		"rusptrd",
		name = "Anti-Tank Rifle Squad",
		description = "3 x PTRD Anti-Tank Rifle: Light Anti-Tank Infantry",
		buildCostMetal = 820,
		buildPic = "RUSPTRD.png",
		buildTime = 820,
		side = "RUS",
	},

    ["rus_platoon_atheavy"] =
	{
		"rusrpg43",
		"rusptrd",
		"rusrpg43",
		"rusptrd",
		"rusrpg43",
		name = "Anti-Tank Assault Squad",
		description = "3 x RPG-43 Anti-Tank Grenade, 2 x PTRD Anti-Tank Rifle: Heavy Anti-Tank Infantry",
		buildCostMetal = 750,
		buildPic = "RUSRPG43.png",
		buildTime = 750,
		side = "RUS",
	},
	
	["rus_platoon_scout"] =
	{
		"rusobserv",
		"rusobserv",
		"rusobserv",
		name = "Scout Team",
		description = "3 x Scout: Reconaissance",
		buildCostMetal = 340,
		buildPic = "RUSObserv.png",
		buildTime = 340,
		side = "RUS",
	},
}

return rusDefs
