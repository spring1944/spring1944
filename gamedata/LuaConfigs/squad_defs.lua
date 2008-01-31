--[[

Syntax:

local squadDefs = {
	["squad_spawner"] = {
		"squad_member_1",
		"squad_member_2",
		"squad_member_3",
		...
		"squad_member_n",
	},
	... -- more squad spawners
}

where:

  squad_spawner is the unitname of the unit that spawns the
squad upon completion. This unit can be build from a factory, 
builder, spawned by Lua, anything. When it is created, it will
spawn the units specified in its squad_member array

  squad_member_n is the unit name of one of unit to spawn in
the squad. There can be as many squad_members as needed. All 
members of the squad will receive the orders assigned to the 
spawner unit. Thus, whole squads can be ordered around from
in a factory, like a normal unit would be.

]]--

local squadDefs = {

	 -----------------------------
	 -- GBR Platoons and Squads --
	 -----------------------------

    ["gbr_platoon_hq"] =
	{
		"gbrrifle",
		"gbrsten",
		"gbrrifle",
		"gbrrifle",
		"gbrsten",
		"gbrrifle",
	},
	
	 ["gbr_platoon_rifle"] =
	{
		"gbrsten",
		"gbrrifle",
		"gbrrifle",
		"gbrrifle",
		"gbrrifle",
		"gbrbren",
		"gbrsten",
		"gbrrifle",
		"gbrrifle",
		"gbrrifle",
		"gbrrifle",
		"gbrbren",
		"gbrsten",
		"gbrrifle",
		"gbrrifle",
		"gbrrifle",
		"gbrrifle",
		"gbrbren",
		"gbrsten",
		"gbrrifle",
		"gbrrifle",
		"gbrrifle",
		"gbrrifle",
		"gbrbren",
	},

	["gbr_platoon_assault"] =
	{
		"gbrbren",
		"gbrsten",
		"gbrsten",
		"gbrsten",
		"gbrsten",
		"gbrsten",
		"gbrsten",
		"gbrsten",
		"gbrsten",
		"gbrsten",
		"gbrpiat",
		"gbrbren",
		"gbrsten",
		"gbrsten",
		"gbrsten",
		"gbrsten",
		"gbrsten",
		"gbrsten",
		"gbrsten",
		"gbrsten",
		"gbrsten",
		"gbrpiat",
	},

	["gbr_platoon_mg"] =
	{
		"gbrobserv",
		"gbrbren",
		"usgirifle",
		"gbrbren",
		"gbrrifle",
		"gbrbren",
	},

	["gbr_platoon_sniper"] =
	{
		"gbrsniper",
		"gbrobserv",
	},

	["gbr_platoon_mortar"] =
	{
		"gbr3inmortar",
		"gbr3inmortar",
		"gbr3inmortar",
	},

	["gbr_platoon_at"] =
	{
		"gbrpiat",
		"gbrsten",
		"gbrpiat",
		"gbrsten",
		"gbrpiat",
		"gbrsten",
	},

	["gbr_platoon_scout"] =
	{
		"gbrobserv",
		"gbrobserv",
		"gbrobserv",
	},
	
	 -----------------------------
	 -- GER Platoons and Squads --
	 -----------------------------

	["ger_platoon_hq"] =
	{
		"gerpanzergren",
		"germp40",
		"gerpanzergren",
		"gerpanzergren",
		"germp40",
		"gerpanzergren",
	},
	
	["ger_platoon_rifle"] = 
	{
		"germp40",
		"gerpanzergren",
		"gerpanzergren",
		"gerpanzergren",
		"gerpanzergren",
		"germg42",
		"germp40",
		"gerpanzergren",
		"gerpanzergren",
		"gerpanzergren",
		"gerpanzergren",
		"germg42",
		"germp40",
		"gerpanzergren",
		"gerpanzergren",
		"gerpanzergren",
		"gerpanzergren",
		"germg42",
		"germp40",
		"gerpanzergren",
		"gerpanzergren",
		"gerpanzergren",
		"gerpanzergren",
		"germg42",
	},
	
	["ger_platoon_assault"] = 
	{
		"gerpanzergren",
		"germp40",
		"germp40",
		"germp40",
		"germp40",
		"gerpanzerfaust",
		"gerpanzergren",
		"germp40",
		"germp40",
		"germp40",
		"germp40",
		"gerpanzerfaust",
		"gerpanzergren",
		"germp40",
		"germp40",
		"germp40",
		"germp40",
		"gerpanzerfaust",
		"gerpanzergren",
		"germp40",
		"germp40",
		"germp40",
		"germp40",
		"gerpanzerfaust",
	},
	
	["ger_platoon_mg"] = 
	{
		"gerbeobinf",
		"germg42",
		"gerpanzergren",
		"germg42",
		"gerpanzergren",
		"germg42",
	},
	
	["ger_platoon_sniper"] = 
	{
		"gersniper",
		"gerbeobinf",
	},
	
	["ger_platoon_mortar"] = 
	{
		"gergrw34",
		"gergrw34",
		"gergrw34",
	},
	
	["ger_platoon_at"] = 
	{
		"gerpanzerfaust",
		"germp40",
		"gerpanzerfaust",
		"germp40",
		"gerpanzerschrek",
		"germp40",
	},
	
	["ger_platoon_scout"] = 
	{
		"gerbeobinf",
		"gerbeobinf",
		"gerbeobinf",
	},
	
	 -----------------------------
	 -- RUS Platoons and Squads --
	 -----------------------------

	 ["rus_platoon_rifle"] =
	{
  		"rusrifle",
		"rusppsh",
		"rusrifle",
		"rusppsh",
		"rusrifle",
		"rusppsh",
		"rusdp",
  		"rusrifle",
		"rusppsh",
		"rusrifle",
		"rusppsh",
		"rusdp",
		"rusrifle",
		"rusppsh",
		"rusrifle",
		"rusppsh",
		"rusrifle",
		"rusppsh",
		"rusdp",
  		"rusrifle",
		"rusppsh",
		"rusrifle",
		"rusppsh",
		"rusdp",
	},

	["rus_platoon_assault"] =
	{
		"rusppsh",
		"rusppsh",
		"rusppsh",
		"rusppsh",
		"rusdp",
		"rusppsh",
  		"rusppsh",
		"rusppsh",
		"rusppsh",
		"rusppsh",
		"rusppsh",
		"rusrpg43",
		"rusppsh",
		"rusppsh",
		"rusppsh",
		"rusppsh",
		"rusdp",
		"rusppsh",
		"rusppsh",
		"rusppsh",
		"rusppsh",
		"rusppsh",
		"rusppsh",
		"rusrpg43",
	},
    	
    ["rus_platoon_partisan"] =
	{
		"ruspartisan",
		"ruspartisan",
		"ruspartisan",
		"ruspartisan",
		"ruspartisan",
		"ruspartisan",
		"ruspartisan",
		"ruspartisan",
		"ruspartisan",
		"ruspartisan",
		"ruspartisan",
		"ruspartisan",
		"ruspartisan",
		"ruspartisan",
		"ruspartisan",
		"ruspartisan",
		"ruspartisan",
		"ruspartisan",
		"ruspartisan",
		"ruspartisan",
		"ruspartisan",
		"ruspartisan",
		"ruspartisan",
		"ruspartisan",
		"ruspartisan",
		"ruspartisan",
		"ruspartisan",
		"ruspartisan",
		"ruspartisan",
		"ruspartisan",
		"ruspartisan",
		"ruspartisan",
		"ruspartisan",
		"ruspartisan",
		"ruspartisan",
	},
	
	["rus_platoon_mg"] =
	{
		"rusobserv",
		"rusdp",
		"rusrifle",
		"rusdp",
		"rusppsh",
		"rusdp",
	},

	["rus_platoon_sniper"] =
	{
		"russniper",
		"rusobserv",
	},

	["rus_platoon_mortar"] =
	{
		"rusmortar",
		"rusmortar",
		"rusmortar",
	},

	["rus_platoon_atlight"] =
	{
		"rusrifle",
		"rusptrd",
		"rusrifle",
		"rusptrd",
		"rusrifle",
		"rusptrd",
	},

    ["rus_platoon_atheavy"] =
	{
		"rusppsh",
		"rusrpg43",
  		"rusppsh",
		"rusrpg43",
		"rusppsh",
		"rusrpg43",
	},
	
	["rus_platoon_scout"] =
	{
		"rusobserv",
		"rusobserv",
		"rusobserv",
	},
	
	 ----------------------------
	 -- US Platoons and Squads --
	 ----------------------------

    ["us_platoon_hq"] =
	{
		"usgirifle",
		"usgithompson",
		"usgirifle",
		"usgirifle",
		"usgithompson",
		"usgirifle",
	},

	["us_platoon_rifle"] = 
	{
		"usgithompson",
		"usgirifle",
		"usgirifle",
		"usgirifle",
		"usgirifle",
		"usgimg",
		"usgithompson",
		"usgirifle",
		"usgirifle",
		"usgirifle",
		"usgirifle",
		"usgibar",
		"usgithompson",
		"usgirifle",
		"usgirifle",
		"usgirifle",
		"usgirifle",
		"usgimg",
		"usgithompson",
		"usgirifle",
		"usgirifle",
		"usgirifle",
		"usgirifle",
		"usgibar",
	},
	
	["us_platoon_assault"] = 
	{
		"usgibar",
		"usgithompson",
		"usgithompson",
		"usgithompson",
		"usgithompson",
		"usgithompson",
		"usgithompson",
		"usgithompson",
		"usgithompson",
		"usgithompson",
		"usgibazooka",
		"usgirifle",
		"usgibar",
		"usgithompson",
		"usgithompson",
		"usgithompson",
		"usgithompson",
		"usgithompson",
		"usgithompson",
		"usgithompson",
		"usgithompson",
		"usgithompson",
		"usgibazooka",
		"usgirifle",
	},
	
	["us_platoon_mg"] = 
	{
		"usobserv",
		"usgimg",
		"usgirifle",
		"usgimg",
		"usgirifle",
		"usgimg",
	},
	
	["us_platoon_sniper"] = 
	{
		"usgisniper",
		"usobserv",
	},
	
	["us_platoon_mortar"] = 
	{
		"usm1mortar",
		"usm1mortar",
		"usm1mortar",
	},
	
	["us_platoon_at"] = 
	{
		"usgibazooka",
		"usgithompson",
		"usgibazooka",
		"usgithompson",
		"usgibazooka",
		"usgithompson",
	},
	
	["us_platoon_scout"] = 
	{
		"usobserv",
		"usobserv",
		"usobserv",
	},
	
	["us_platoon_flame"] = 
	{
		"usgiflamethrower",
		"usgithompson",
		"usgiflamethrower",
		"usgithompson",
		"usgiflamethrower",
		"usgithompson",
	},
	
}

-------------------------------------------------
-- Dont touch below here
-------------------------------------------------

local squadDefIDs = { }

for i, squad in pairs(squadDefs) do
	unitDef = UnitDefNames[i]
	if unitDef ~= nil then
		squadDefIDs[unitDef.id] = squad
	else
		Spring.Echo("  Bad unitName! " .. i)
	end
end

for i, squad in pairs(squadDefIDs) do
	squadDefs[i] = squad
end

return squadDefs