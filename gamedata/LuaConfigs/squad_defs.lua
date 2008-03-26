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
		"gbrrifle",
		"gbrrifle",
		"gbrrifle",
		"gbrsten",
		"gbrsten",
	},
	
	 ["gbr_platoon_rifle"] =
	{
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

	["gbr_platoon_assault"] =
	{
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
		"gbrsten",
		"gbrsten",
	},

	["gbr_platoon_mg"] =
	{
		"gbrbren",
		"gbrbren",
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
		"gbrpiat",
		"gbrpiat",
	},

	["gbr_platoon_scout"] =
	{
		"gbrobserv",
		"gbrobserv",
		"gbrobserv",
	},
	
	["gbr_platoon_commando"] =
	{
		"gbrcommando",
		"gbrcommando",
		"gbrcommando",
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
		"germp40",
		"gerpanzergren",
		"gerpanzergren",
		"gerpanzergren",
		"gerpanzergren",
		"gerpanzergren",
		"gerpanzergren",
		"gerpanzergren",
		"gerpanzergren",
		"gerpanzergren",
		"gerpanzergren",
	},
	
	["ger_platoon_assault"] = 
	{
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
		"germp40",
		"germp40",
	},
	
	["ger_platoon_mg"] = 
	{
		"germg42",
		"germg42",
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
		"gerpanzerfaust",
		"gerpanzerschrek",
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
  		"rusrifle",
  		"rusrifle",
  		"rusrifle",
  		"rusrifle",
  		"rusrifle",
  		"rusrifle",
  		"rusrifle",
		"rusppsh",
		"rusppsh",
		"rusppsh",
		"rusppsh",
	},

	["rus_platoon_assault"] =
	{
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
		"rusppsh",
		"rusppsh",
		"rusppsh",
		"rusppsh",
		"rusppsh",
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
	},
	
	["rus_platoon_mg"] =
	{
		"rusdp",
		"rusdp",
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
		"rusptrd",
		"rusptrd",
		"rusptrd",
	},

    ["rus_platoon_atheavy"] =
	{
		"rusrpg43",
		"rusrpg43",
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
	
	["us_platoon_assault"] = 
	{
		"usgithompson",
		"usgithompson",
		"usgithompson",
		"usgithompson",
		"usgithompson",
		"usgithompson",
		"usgithompson",
		"usgithompson",
		"usgithompson",
		"usgithompson",
		"usgithompson",
		"usgithompson",
	},
	
	["us_platoon_mg"] = 
	{
		"usgimg",
		"usgimg",
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
		"usgibazooka",
		"usgibazooka",
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
		"usgiflamethrower",
		"usgiflamethrower",
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