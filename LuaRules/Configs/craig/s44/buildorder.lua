-- Author: Tobi Vollebregt
-- License: GNU General Public License v2

-- Misc config
FLAG_RADIUS = 230 --from S44 game_flagManager.lua
SQUAD_SIZE = 24

-- unit names must be lowercase!

-- Format: factory = { "unit to build 1", "unit to build 2", ... }
gadget.unitBuildOrder = UnitBag{
	-- Great Britain
	gbrhq = UnitArray{
		"gbrhqengineer", "gbrhqengineer",
		"gbr_platoon_hq", "gbr_platoon_hq",
		"gbr_platoon_hq", "gbr_platoon_hq",
		"gbr_platoon_hq", "gbr_platoon_hq",
		"gbr_platoon_hq", "gbr_platoon_hq",
	},
	gbrbarracks = UnitArray{
		"gbrhqengineer", "gbrhqengineer",
		"gbr_platoon_rifle", "gbr_platoon_assault",
		"gbr_platoon_rifle", "gbr_platoon_mortar",
		"gbr_platoon_rifle", "gbr_platoon_at",
		"gbr_platoon_rifle",
		"gbr_platoon_rifle", "gbr_platoon_sniper",
		"gbr_platoon_rifle", "gbr_platoon_rifle",
	},
	gbrvehicleyard = UnitArray{
		"gbrmatadorengvehicle",
		"gbrdaimler",
		"gbrm5halftrack",
		"gbrwasp",
	},
	gbrsupplydepot = UnitArray{
		"gbrm5halftrack",
	},
	-- it can not upgrade tank yard yet!
	gbrtankyard = UnitArray{
		"gbrcromwell", "gbrcromwell",
		"gbrcromwell", "gbrcromwellmkvi",
		"gbraecmkii",
	},
	gbrtankyard1 = UnitArray{
		-- Works J
		"gbrcromwell", 
		"gbrshermanfirefly",
	},
	gbrtankyard2 = UnitArray{
		-- Works J
		"gbrcromwell", 
		"gbrchurchillmkvii",
	},
	gbrspyard = UnitArray{
		-- Works J
		"gbrsexton",
	},
	gbrspyard1 = UnitArray{
		-- Works J
		"gbrm10achilles",
	},
	-- Russia
	ruspshack = UnitArray {
		"rus_platoon_partisan",
	},
	
	rusbarracks = UnitArray{
		"rus_platoon_rifle",
		"rusengineer",
		"rus_platoon_commissar",
		"rus_platoon_rifle", "rus_platoon_assault",
		"rus_platoon_rifle", "rus_platoon_atheavy",
		"rus_platoon_rifle",
		"rus_platoon_rifle",
		"rus_platoon_rifle",
		"rus_platoon_rifle", "rus_platoon_mortar",
		"rus_platoon_rifle", "rus_platoon_sniper",
		"rus_platoon_rifle", "rus_platoon_rifle",
	},
	rusvehicleyard = UnitArray{
		-- Works J
		"rusk31",
		"rusba64",
		"rusm5halftrack",
		"rust60",
		"rusm5halftrack",
		"russu76",
		"rusm5halftrack",
		"rust60",
		"rusm5halftrack",
		"russu76",
		"rusm5halftrack",
		"rust60",
		"rusm5halftrack",
		"russu76",
	},
	russupplydepot = UnitArray{
		"rusm5halftrack",
	},
	rustankyard = UnitArray{
		-- Works J
		"rust70", "rust3476",
		"rust3476", "rust3476",
		"rust3476", "rusisu152",
	},
	rustankyard1 = UnitArray{
		-- Works J
		"rust3485",
	},
	rustankyard2 = UnitArray{
		-- Works J
		"rusis2",
	},
	russpyard = UnitArray{
		-- Works J
		"rusbm13n",
	},
	russpyard1 = UnitArray{
		-- Works J
		"russu85", "russu100",
	},
	-- Germany
	gerhqbunker = UnitArray{
		-- Works J
		"gerhqengineer", "gerhqengineer",
		"ger_platoon_hq", "ger_platoon_hq", "ger_platoon_hq",
		"ger_platoon_hq", "ger_platoon_hq",
	},
	gerbarracks = UnitArray{
		-- Works J
		"gerhqengineer", "gerhqengineer",
		"ger_platoon_rifle","ger_platoon_rifle", "ger_platoon_rifle",
		"ger_platoon_rifle","ger_platoon_rifle", "ger_platoon_rifle",
		"ger_platoon_at", "ger_platoon_mg", "ger_platoon_sniper", "ger_platoon_mortar",
		"gerleig18",
	},
	gervehicleyard = UnitArray{
		-- Works J
		"gersdkfz9",
		"gersdkfz251",
		"gersdkfz250",
		"gersdkfz251",
		"gersdkfz250",
		"gersdkfz251",
		"germarder",
	},
	gersupplydepot = UnitArray{
		"gersdkfz251",
	},
	gertankyard = UnitArray{
		-- Works J
		"gerpanzeriii", "gerpanzeriv", "gerpanzeriv",
		"gerstugiii", "gerstugiii", "gerstugiii",
		"gertiger",
	},
	gertankyard1 = UnitArray{
		-- Works J
		"gerpanzeriii", 
		"gerpanzeriv",
		"gerstugiii",
		"gerpanther",
	},
	gertankyard2 = UnitArray{
		-- Works J
		"gerpanzeriii", 
		"gerpanzeriv",
		"gerstugiii",
		"gertigerii",
	},
	gerspyard = UnitArray{
		-- Works J
		"gerwespe",
	},
	gerspyard1 = UnitArray{
		-- Works J
		"gerjagdpanzeriv",
    	"gerjagdpanther",
	},
	-- United States
	ushq = UnitArray{
		-- Works J
		"ushqengineer", "ushqengineer",
		"us_platoon_hq", "us_platoon_hq", "us_platoon_hq",
		"us_platoon_hq", "us_platoon_hq", "us_platoon_hq",
		"us_platoon_hq", "us_platoon_hq", "us_platoon_hq",
	},
	usbarracks = UnitArray{
		-- Works J
		"ushqengineer", "ushqengineer",
		"us_platoon_rifle", "us_platoon_rifle", "us_platoon_rifle",
		"us_platoon_rifle", "us_platoon_rifle", "us_platoon_rifle",
		"us_platoon_assault", "us_platoon_at",
		"us_platoon_mortar", "us_platoon_sniper", "us_platoon_flame",
		"usm8gun",
	},
	usvehicleyard = UnitArray{
		-- Works J
		"usgmcengvehicle",
		"usm3halftrack",
		"usm8greyhound",
		"usm3halftrack",
		"usm8greyhound",
		"usm3halftrack",
		"usm8scott",
	},
	ussupplydepot = UnitArray{
		"usm3halftrack",
	},
	ustankyard = UnitArray{
		-- Works J
		"usm5stuart",
		"usm4a4sherman", "usm4a4sherman", "usm4a4sherman",
		"usm10wolverine",
	},
	usspyard = UnitArray{
		-- Works J
		"usm7priest",
	},
	ustankyard1 = UnitArray{
		-- Works J
		"usm4a376sherman", "usm4a3105sherman",
		"usm10wolverine",
	},
	ustankyard2 = UnitArray{
		-- Works J
		"usm4jumbo", "usm4a3105sherman",
		"usm10wolverine",
	},
		-- ITALY
	itahq = UnitArray{
		-- Works J
		"itahqengineer", "itahqengineer",
		"ita_platoon_hq", "ita_platoon_hq", "ita_platoon_hq",
		"ita_platoon_hq", "ita_platoon_hq", "ita_platoon_hq",
		"ita_platoon_hq", "ita_platoon_hq", "ita_platoon_hq",
	},
	itabarracks = UnitArray{
		-- Works J
		"itahqengineer", "itahqengineer",
		"ita_platoon_rifle", "ita_platoon_rifle", "ita_platoon_rifle",
		"ita_platoon_rifle", "ita_platoon_rifle", "ita_platoon_rifle",
		"ita_platoon_assault", --"ita_platoon_at",
		"ita_platoon_mortar", "ita_platoon_sniper",
		"itacannone65",
	},
	itavehicleyard = UnitArray{
		-- Works J
		"itabreda41",
		"itaas37",
		"itaab41",
		"itasemovente47",
		"itaab41",
		"itaas37",
		"itaautocannone75",
	},
	itasupplydepot = UnitArray{
		"itaas37",
	},
	itatankyard = UnitArray{
		-- Works J
		"ital6_40lf",
		"itam1542", "itam1542", "itam1542",
		"itasemovente75_18",
		"itasemovente90",
	},
		itaelitebarracks = UnitArray{
		-- Works J
		"itahqengineer", "itahqengineer",
		"ita_platoon_alpini", 
		"ita_platoon_bersaglieri","ita_platoon_bersaglieri",
		"ita_platoon_rifle",
	},
		itaspyard = UnitArray{
		-- Works J
		"itabreda41",
		"itaautocannone75",
		"itasemovente47",
		"itaautocannone100","itaautocannone100",
		"itaautocannone90",
	},
		itatankyard1 = UnitArray{
		-- Works J
		"itasemovente90",
		"itap40", "itap40", "itap40",
		"itasemovente105",
	},
	--[[
		itaradar = UnitArray{
	
	"ita_sortie_recon",
	"ita_sortie_interceptor",
	"ita_sortie_fighter",
	"ita_sortie_attack",
	},
	--]]
	-- Japan
	jpnhq = UnitArray{
		"jpnhqengineer", "jpnhqengineer",
		"jpn_platoon_hq", "jpn_platoon_hq",
		"jpn_platoon_hq", "jpn_platoon_hq",
		"jpn_platoon_hq", "jpn_platoon_hq",
		"jpn_platoon_hq", "jpn_platoon_hq",
	},
	jpnbarracks = UnitArray{
		"jpnhqengineer", "jpnhqengineer",
		"jpn_platoon_rifle", "jpn_platoon_assault",
		"jpn_platoon_rifle", "jpn_platoon_mortar",
		"jpn_platoon_rifle", "jpn_platoon_at",
		"jpn_platoon_rifle",
		"jpn_platoon_rifle", "jpn_platoon_sniper",
		"jpn_platoon_rifle", "jpn_platoon_rifle",
	},
	jpnvehicleyard = UnitArray{
		"jpnriki",
		--"jpnisuzutx40",
		"jpnhago",
		--"jpnisuzutype94_aa",
		"jpn_tankette_platoon_teke",
		"jpnhago",
		"jpn_tankette_platoon_teke",
	},
	jpnvehicleyard2 = UnitArray{
		"jpnriki",
		--"jpnisuzutx40",
		"jpnhago",
		--"jpnisuzutype94_aa",
		"jpnkatsu",
		"jpnkami",
	},
	jpnvehicleyard2 = UnitArray{
		"jpnriki",
		--"jpnisuzutx40",
		"jpnhago",
		--"jpnisuzutype94_aa",
		"jpnshinhotochiha",
	},
	jpnsupplydepot = UnitArray{
		"jpnhoha",
	},
	jpnspyard = UnitArray{
		"jpnhoniii",
		"jpnhonii",
	},
	jpnspyard1 = UnitArray{
		"jpntype5nato",
	},
	jpntankyard = UnitArray{
	
		"jpnriki",
		"jpnhago","jpnhoniiii",
		"jpnchiha",
		"jpnchihe","jpnchihe",
		"jpnchiha",
	},
	jpntankyard1 =
	{
		"jpnchinu",
		"jpnchiha120mm",
	},
	jpntankyard2 =
	{
		"jpnhoro",
		"jpnchinu",
	},
	-- SWE
	swehq = UnitArray{
		"sweengineer",
		"swe_platoon_hq",
		"swe_platoon_hq",
		"swe_platoon_hq",
	},
	swebarracks = UnitArray{
		"sweengineer",
		"swe_platoon_rifle",
		"swe_platoon_assault",
		"swe_platoon_rifle",
		"swe_platoon_sniper",
		"swe_platoon_rifle",
		"sweengineer",
		"swe_platoon_mortar",
		"swe_platoon_rifle",
		--"swe_platoon_mg",
		"swe_platoon_at",
	},
	swevehicleyard = UnitArray{
		"swepbilm40",
		"swetgbilm42",
		"swepbilm40",
		"swestrvm37",
		"swepbilm31",
		"swestrvm37",
	},
	swetankyard = UnitArray{
		"swestrvm40sii",
	},
	swetankyard1 = UnitArray{
		"swestrvm42",
	},
	swevehicleyard1 = UnitArray{
		"swestrvm41",
		"swetgbilm42",
		"swestrvm41",
		"swepbilm31",
	},
	swespyard = UnitArray{
		"swepbilm31",
	},
	swespyard1 = UnitArray{
		"swesavm43",
	},
	-- HUN
	hunhq = UnitArray{
		"hunengineer",
		"hunengineer",
		"hun_platoon_hq",
		"hun_platoon_hq",
		"hun_platoon_hq",
		"hun_platoon_hq",
	},
	hunbarracks = UnitArray{
		"hunengineer",
		"hun_platoon_rifle",
		"hunengineer",
		"hun_platoon_rifle",
		"hun_platoon_assault",
		"hun_platoon_rifle",
		"hun_platoon_mortar",
		"hun_platoon_rifle",
		"hun_platoon_rifle",
		--"hun_platoon_mg",
	},
	hunvehicleyard = UnitArray{
		"hunbergehetzer",
		"hun39mcsaba",
		"hun39mcsaba",
		"hun43mlehel",
		"hun40mnimrod",
		"huntoldiii",
		"huntoldiii",
	},
	huntankyard = UnitArray{
		"hunbergehetzer",
		"huntoldiiia",
		"hun40mturan",
		"hun41mturanii",
		"hun40mturan",
		"hun41mturanii",
	},
	hunvehicleyard1 = UnitArray{
		"hun40mturan",
		"hun43mlehel",
		"hun40mturan",
		"hun40mturan",
		"hun40mnimrod",
	},
	hunspyard = UnitArray{
		"hun43mzrynyiii",
	},
	hunspyard1 = UnitArray{
		"hunhetzer",
	},
	huntankyard1 = UnitArray{
		"hun43mturaniii",
	},
	huntankyard2 = UnitArray{
		"hun44mtas",
	},
}

-- Format: side = { "unit to build 1", "unit to build 2", ... }
gadget.baseBuildOrder = {
	gbr = UnitArray{
		-- I used storages basically to delay tech up a bit :P Making GBR the easy faction to play against.
		"gbrbarracks", "gbrbarracks",
		"gbrvehicleyard",
		"gbrstorage", "gbrstorage",
		-- GBR doesn't have packed howitzers, and C.R.A.I.G. doesn't know
		-- about deploying yet, so no point making a Towed Gun Yard.
		--"gbrgunyard",
		"gbrtankyard",
		"gbrsupplydepot",
		"gbrspyard",
		"gbrtankyard1",
		"gbrspyard1",
		"gbrtankyard2",
	},
	rus = UnitArray{
		-- TODO: add veh / tanks / towed guns (if rus has packed howitzers) Russia will be the "expert"
		"rusbarracks", "rusbarracks",
		"rusvehicleyard",
		"russtorage", "russtorage",
		"rustankyard",
		"russupplydepot",
		"ruspshack",
		"russpyard",
		"rustankyard1",
		"russpyard1",
		"rustankyard2",
	},
	ger = UnitArray{
		-- works J
		"gerbarracks", "gerbarracks",
		"gerstorage",
		"gervehicleyard",
		"gerstorage", "gerstorage",
		"gertankyard",
		"gersupplydepot",
		"gerspyard",
		"gertankyard1",
		"gerspyard1",
		"gertankyard2",
	},
	us = UnitArray{
		-- Works J
		"usbarracks", "usbarracks",
		"usvehicleyard",
		"usstorage", "usstorage",
		"ustankyard",
		"ussupplydepot",
		"usspyard",
		"ustankyard1",
		"ustankyard2",
	},
	ita = UnitArray{
		-- Works J
		"itabarracks", "itabarracks",
		"itavehicleyard",
		"itastorage", "itastorage",
		"itatankyard",
		"itasupplydepot",
		"itaelitebarracks",
		"itaspyard",
		"itatankyard1",
	},
		-- "itaradar",
	jpn = UnitArray{
		"jpnbarracks", "jpnbarracks",
		"jpnstorage",
		"jpnvehicleyard",
		"jpnstorage", "jpnstorage",
		"jpntankyard",
		"jpnsupplydepot",
		"jpnspyard",
		"jpnvehicleyard1",
		"jpnspyard1",
		"jpnvehicleyard2",
		"jpntankyard1",
		"jpntankyard2",
	},
	swe = UnitArray{
		"swebarracks",
		"swebarracks",
		"swevehicleyard",
		"swestorage",
		"swetankyard",
		"swestorage",
		"swevehicleyard1",
		"swespyard",
		"swestorage",
		"swespyard1",
		"swetankyard1",
	},
	hun = UnitArray{
		"hunbarracks",
		"hunbarracks",
		"hunvehicleyard",
		"hunstorage",
		"huntankyard",
		"hunstorage",
		"hunsupplydepot",
		"hunstorage",
		"huntankyard2",
		"hunvehicleyard1",
		"huntankyard1",
		"hunstorage",
		"hunspyard",
		"hunspyard1",
	},
}

-- This lists all the units (of all sides) that are considered "base builders"
gadget.baseBuilders = UnitSet{
	"gbrhqengineer",
	"gbrhqaiengineer",
	"gbrmatadorengvehicle",
	"gerhqengineer",
	"gerhqaiengineer",
	"gersdkfz9",
	"ruscommissar", -- contrary to other sides Russia can start immediately after game start with base building... #This WAS true in previous versions
	"rusaicommissar",
	"rusengineer",
	"rusk31",
	"ushqengineer",
	"ushqaiengineer",
	"usgmcengvehicle",
	"itahqengineer",
	"itahqaiengineer", 
	"itabreda41",
	"jpnriki",
	"jpnhqengineer",
	"jpnhqaiengineer",
	"sweengineer",
	"swehqaiengineer",
	"hunengineer",
	"hunhqaiengineer",
	"hunbergehetzer",
}

-- This lists all the units that should be considered flags.
gadget.flags = UnitSet{
	"flag",
}

-- This lists all the units (of all sides) that may be used to cap flags.
gadget.flagCappers = UnitSet{
	"gbrrifle", "gbrsten",
	"gerrifle", "germp40",
	"itarifle", "itam38",
	"usrifle", "usthompson",
	"jpnrifle", "jpntype100smg",
	"ruscommissar", --no commander because it is needed for base building
	"swerifle",
	"hunrifle",
}

-- Number of units per side used to cap flags.
gadget.reservedFlagCappers = {
	gbr = 24,
	ger = 24,
	us  = 24,
	ita = 24,
	jpn = 24,
	rus = 2,
	swe = 24,
	hun = 24,
}
