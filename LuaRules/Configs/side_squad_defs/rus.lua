local rusDefs = {
	 -----------------------------
	 -- RUS Platoons and Squads --
	 -----------------------------
	 ["rus_platoon_commissar"] =
	{
		members = {
			"ruscommissar",
			"ruscommissar",
			"ruscommissar",
		},
		name = "Political Commissar Group",
		description = "3 x Commissar: Rapidly Captures Territory",
		buildCostMetal = 1150,
		buildPic = "ruscommissar.png",
	},

	 ["rus_platoon_rifle"] =
	{
		members = {
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
		},
		name = "Rifle Platoon",
		description = "9 x Mosin-Nagant Rifle, 2 x PPsh-43 SMG, 1 x PTRD Anti-Tank Rifle: Long-Range Combat Platoon",
		buildCostMetal = 1100,
		buildPic = "RUSRifle.png",
	},


	["rus_platoon_assault"] =
	{
		members = {
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
		},
		name = "Assault Platoon",
		description = "11 x PPsh-43 SMG, 1 x RPG43, 1 x DP Light Machinegun: Close-Quarters Assault Infantry",
		buildCostMetal = 1150,
		buildPic = "RUSPPsh.png",
	},

	["rus_platoon_partisan"] =
	{
		members = {
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
		},
		name = "Partisan Contingent",
		description = "12 x Partisans: Conscripted Partisan Infantry",
		buildCostMetal = 1050,
		buildPic = "RUSRifle.png",
	},

	["rus_platoon_mg"] =
	{
		members = {
			"rusdp",
			"rusmaxim",
			"rusdp",
			"rusobserv",
		},
		name = "Machinegun Squad",
		description = "1 x Maxim Heavy Machinegun, 2 x DP Light Machinegun, 1 x Scout: Infantry Fire Support Squad",
		buildCostMetal = 1120,
		buildPic = "RUSDP.png",
	},

	["rus_platoon_sniper"] =
	{
		members = {
			"russniper",
			"rusobserv",
		},
		name = "Sniper Team",
		description = "1 x Mosin-Nagant Sniper, 1 x Scout: Long-Range Fire Support",
		buildCostMetal = 1060,
		buildPic = "russniper.png",
	},

	["rus_platoon_mortar"] =
	{
		members = {
			"rusmortar",
			"rusmortar",
			"rusmortar",
			"rusobserv",
		},
		name = "Mortar Team",
		description = "3 x M1937 Mortar, 1 x Scout: Heavy Infantry Fire Support",
		buildCostMetal = 2065,
		buildPic = "RUSMortar.png",
	},

	["rus_platoon_atlight"] =
	{
		members = {
			"rusptrd",
			"rusptrd",
			"rusptrd",
		},
		name = "Anti-Tank Rifle Squad",
		description = "3 x PTRD Anti-Tank Rifle: Light Anti-Tank Infantry",
		buildCostMetal = 820,
		buildPic = "RUSPTRD.png",
	},

	["rus_platoon_atheavy"] =
	{
		members = {
			"rusrpg43",
			"rusptrd",
			"rusrpg43",
			"rusrpg43",
			"rusrpg43",
		},
		name = "Anti-Tank Assault Squad",
		description = "4 x RPG-43 Anti-Tank Grenade, 1 x PTRD Anti-Tank Rifle: Heavy Anti-Tank Infantry",
		buildCostMetal = 400,
		buildPic = "RUSRPG43.png",
	},

	["rus_platoon_scout"] =
	{
		members = {
			"rusobserv",
			"rusobserv",
			"rusobserv",
		},
		name = "Scout Team",
		description = "3 x Scout: Reconaissance",
		buildCostMetal = 340,
		buildPic = "RUSObserv.png",
	},

	["rus_platoon_crew"] =
	{
		members = {
			"ruscrew",
			"ruscrew",
		},
		name = "Crew members",
		description = "2 x Crew: Guns and vehicles crew",
		buildCostMetal = 450,
		buildPic = "ruscrew.png",
	},

	["rus_platoon_landing"] =
	{
		members = {
			"rusobserv",
			"rusobserv",
			"rusdp",
			"ruscommissar",
			"rusppsh",
			"rusppsh",
			"rusppsh",
			"rusppsh",
			"rus_ni_rifle",
			"rus_ni_rifle",
			"rus_ni_rifle",
			"rus_ni_rifle",
			"rus_ni_rifle",
			"rus_ni_rifle",
			"rusrifle",
			"rusrifle",
			"rusrifle",
			"rusrifle",
			"rusrifle",
			"rusrifle",
		},
        buildCostMetal = 2100,
		-- other fields not needed for transport squads
	},

	["rus_platoon_lct"] =
	{
		members = {
			"rust3476",
			"rust3476",
			"rust3476",
			"rust3476",
			"rusm5halftrack",
		},
		-- other fields not needed for transport squads
	},
}

return rusDefs
