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
		"gbrbren",
		"gbrsten",
		"gbrrifle",
		"gbrrifle",
		"gbrsten",
		"gbrsten",
	},
	
	["gbr_platoon_hq_rifle"] =
	{
		"gbrbren",
		"gbrbren",
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
		"gbrrifle",
		"gbrrifle",
		"gbrrifle",
		"gbrrifle",
		"gbrrifle",
		"gbrrifle",
		"gbrsten",
		"gbrsten",
		"gbrsten",
		"gbrsten",
	},
	
	["gbr_platoon_hq_assault"] =
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
		"gbrcommando",
	},

	["gbr_platoon_mg"] =
	{
		"gbrbren",
		"gbrvickers",
		"gbrbren",
		"gbrobserv",
		"gbrobserv",
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
		"gbrobserv",
		"gbrobserv",
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
		"gbrcommandoc",
		"gbrcommandoc",
		"gbrcommandoc",
	},
	
	["gbr_platoon_commando_lz"] =
	{
		"gbrcommando",
		"gbrcommando",
		"gbrcommando",
		"gbrcommando",
		"gbrcommando",
		"gbrcommando",
	},
	
	["gbr_platoon_glider_horsa"] =
	{
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
	
	 -----------------------------
	 -- GER Platoons and Squads --
	 -----------------------------

	["ger_platoon_hq"] =
	{
		"gerrifle",
		"germp40",
		"gerrifle",
		"gerrifle",
		"germp40",
		"gerrifle",
	},
	
	["ger_platoon_hq_rifle"] =
	{
		"germg42",
		"germg42",
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
		"gerrifle",
		"gerrifle",
		"gerrifle",
		"gerrifle",
		"gerrifle",
		"gerrifle",
		"germp40",
		"germp40",
		"germp40",
		"germp40",
	},
	
	["ger_platoon_hq_assault"] =
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
	
	["ger_platoon_rifle"] = 
	{
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
		"gerpanzerfaust",
		"gerpanzerfaust",
	},
	
	["ger_platoon_mg"] = 
	{
		"germg42",
		"germg42",
		"germg42",
		"gerobserv",
		"gerobserv",
	},
	
	["ger_platoon_sniper"] = 
	{
		"gersniper",
		"gerobserv",
	},
	
	["ger_platoon_mortar"] = 
	{
		"gergrw34",
		"gerobserv",
		"gergrw34",
		"gerobserv",
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
		"gerobserv",
		"gerobserv",
		"gerobserv",
	},  
	
	 -----------------------------
	 -- ITA Platoons and Squads --
	 -----------------------------
	
	["ita_platoon_hq"] =
	{
		"itarifle",
		"itam38",
		"itarifle",
		"itarifle",
		"itasoloat",
	},
	
	["ita_platoon_rifle"] = 
	{
		"itam38",
		"itarifle",
		"itarifle",
		"itarifle",
		"itarifle",
		"itarifle",
		"itarifle",
		"itarifle",
		"itarifle",
		"itabreda30",
	},
	
	["ita_platoon_assault"] = 
	{
		"itam38",
		"itam38",
		"itam38",
		"itam38",
		"itam38",
		"itam38",
		"itam38",
		"itam38",
		"itam38",
		"itasoloat",
		"itasoloat",
	},
	
	["ita_platoon_mg"] = 
	{
		"itamg",
		"itamg",
		"itabreda30",
		"itaobserv",
		"itaobserv",
	},
	
	["ita_platoon_sniper"] = 
	{
		"itasniper",
		"itaobserv",
	},
	
	["ita_platoon_mortar"] = 
	{
		"itamortar",
		"itaobserv",
		"itamortar",
		"itaobserv",
		"itamorta",
	},
	
	["ita_platoon_at"] = 
	{
		"itasoloat",
		"itasoloat",
		"itasoloat",
		"itasoloat",
	},
	
	["ita_platoon_scout"] = 
	{
		"itaobserv",
		"itaobserv",
		"itaobserv",
	},
  	
	 -----------------------------
	 -- RUS Platoons and Squads --
	 -----------------------------
	 ["rus_platoon_commissar"] =
	{
		"ruscommissar",
		"ruscommissar",
		"ruscommissar",
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
	},
	
	["rus_platoon_big_rifle"] =
	{
  		"rusrifle",
  		"rusrifle",
  		"rusrifle",
  		"rusrifle",
  		"rusrifle",
  		"rusrifle",
  		"rusrifle",
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
		"rusppsh",
		"rusppsh",
		"rusppsh",
		"rusppsh",
		"rusppsh",
		"rusppsh",
	},

	 ["rus_platoon_guards"] =
	{
		"rusguardsdp",
		"rusguardsrifle",
  		"rusguardsrifle",
  		"rusguardsrifle",
  		"rusguardsrifle",
  		"rusguardsrifle",
  		"rusguardsrifle",
  		"rusguardsrifle",
		"rusguardsppsh",
		"rusguardsppsh",
	},
	
	["rus_platoon_big_assault"] =
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
		"rusppsh",
		"rusppsh",
		"rusppsh",
		"rusppsh",
		"rusppsh",
		"rusppsh",
		"rusppsh",
		"rusppsh",
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
	},
	
	["rus_platoon_mg"] =
	{
		"rusdp",
		"rusmaxim",
		"rusdp",
		"rusobserv",
		"rusobserv",
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
		"rusobserv",
		"rusobserv",
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
		"rusptrd",
		"rusrpg43",
		"rusptrd",
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
	
    ["us_platoon_hq_rifle"] =
	{
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
		"usgirifle",
		"usgirifle",
		"usgirifle",
		"usgirifle",
		"usgibar",
		"usgibar",
		"usgibar",
		"usgibar",
		"usgithompson",
		"usgithompson",
		"usgithompson",
		"usgithompson",
	},
	
    ["us_platoon_hq_assault"] =
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
		"usgibazooka",
		"usgiflamethrower",
		"usgibar",
		"usgibar",
	},
	
	["us_platoon_mg"] = 
	{
		"usgimg",
		"usgimg",
		"usgimg",
		"usobserv",
		"usobserv",
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
		"usobserv",
		"usobserv",
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