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
	},
	gbrsupplydepot = UnitArray{
		"gbrm5halftrack",
	},
	-- it can not upgrade tank yard yet!
	gbrtankyard = UnitArray{
		"gbrcromwell", "gbrcromwell",
		"gbrcromwell", "gbrshermanfirefly",
		"gbrshermanfirefly", "gbrcromwellmkvi",
		"gbraecmkii",
	},
	-- Russia
	rusbarracks = UnitArray{
		"rus_platoon_rifle",
		"rusengineer",
		"rus_platoon_rifle", "rus_platoon_assault",
		"rus_platoon_rifle", "rus_platoon_atheavy",
		"rus_platoon_rifle", "rus_platoon_atlight",
		"rus_platoon_rifle",
		"rus_platoon_rifle",
		"rus_platoon_rifle", "rus_platoon_mortar",
		"rus_platoon_rifle", "rus_platoon_sniper",
		"rus_platoon_rifle", "rus_platoon_rifle",
	},
	ruspshack = UnitArray{
		"rus_platoon_partisan",
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
		"gerpanzeriii", "gerpanzeriii", "gerpanzeriii",
		"gerstugiii", "gerstugiii", "gerstugiii",
		"gertiger",
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
		"usm4a4sherman", "usm4a4sherman", "usm4a4sherman",
		"usm10wolverine",
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
	},
	rus = UnitArray{
		-- TODO: add veh / tanks / towed guns (if rus has packed howitzers) Russia will be the "expert"
		"rusbarracks", "rusbarracks",
		"ruspshack", "ruspshack",
		"rusvehicleyard",
		"russtorage", "russtorage",
		"rustankyard",
		"russupplydepot",
	},
	ger = UnitArray{
		-- works J
		"gerbarracks", "gerbarracks",
		"gerstorage",
		"gervehicleyard",
		"gerstorage", "gerstorage",
		"gertankyard",
		"gersupplydepot",
	},
	us = UnitArray{
		-- Works J
		"usbarracks", "usbarracks",
		"usvehicleyard",
		"usstorage", "usstorage",
		"ustankyard",
		"ussupplydepot",
	},
}

-- This lists all the units (of all sides) that are considered "base builders"
gadget.baseBuilders = UnitSet{
	"gbrhqengineer",
	"gbrengineer",
	"gbrmatadorengvehicle",
	"gerhqengineer",
	"gerengineer",
	"gersdkfz9",
	"ruscommissar", -- contrary to other sides Russia can start immediately after game start with base building...
	"rusengineer",
	"rusk31",
	"ushqengineer",
	"usengineer",
	"usgmcengvehicle",
}

-- This lists all the units that should be considered flags.
gadget.flags = UnitSet{
	"flag",
}

-- This lists all the units (of all sides) that may be used to cap flags.
gadget.flagCappers = UnitSet{
	"gbrrifle", "gbrsten",
	"gerrifle", "germp40",
	"usgirifle", "usgithompson",
	"ruscommissar", --no commander because it is needed for base building
}

-- Number of units per side used to cap flags.
gadget.reservedFlagCappers = {
	gbr = 24,
	ger = 24,
	us  = 24,
	rus = 2,
}
