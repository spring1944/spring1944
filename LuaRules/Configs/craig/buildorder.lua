-- Author: Tobi Vollebregt
-- License: GNU General Public License v2

-- unit names must be lowercase!

-- Just some very random proof of concept build order...
-- Reasonably complete for Great Britain, minimal for Russia.

-- TODO: add USA
-- TODO: add Germany

-- Format: factory = { "unit to build 1", "unit to build 2", ... }
gadget.unitBuildOrder = {
	-- Great Britain
	gbrhq = {
		"gbrhqengineer", "gbrhqengineer",
		"gbr_platoon_hq", "gbr_platoon_hq",
		"gbr_platoon_hq", "gbr_platoon_hq",
		"gbr_platoon_hq", "gbr_platoon_hq",
		"gbr_platoon_hq", "gbr_platoon_hq",
	},
	gbrbarracks = {
		"gbrengineer", "gbrengineer",
		"gbr_platoon_rifle", "gbr_platoon_assault",
		"gbr_platoon_rifle", "gbr_platoon_mortar",
		"gbr_platoon_rifle", "gbr_platoon_at",
		"gbr_platoon_rifle",
		"gbr_platoon_rifle", "gbr_platoon_sniper",
		"gbr_platoon_rifle", "gbr_platoon_rifle",
	},
	gbrvehicleyard = {
		"gbrmatadorengvehicle",
		"gbrdaimler", "gbrdaimler",
		"gbrdaimler", "gbrdaimler",
		"gbrm5halftrack",
		"gbrdaimler", "gbrdaimler",
		"gbrm5halftrack",
		"gbrdaimler", "gbrdaimler",
		"gbrm5halftrack",
	},
	-- it can not upgrade tank yard yet!
	gbrtankyard = {
		"gbrcromwell", "gbrcromwell",
		"gbrcromwell", "gbrshermanfirefly",
		"gbrshermanfirefly", "gbrcromwellmkvi",
		"gbraecmkii",
	},
	-- Russia
	rusbarracks = {
		"rus_platoon_rifle",
		"ruscommissar", "rusengineer",
		"rus_platoon_rifle", "rus_platoon_assault",
		"rus_platoon_rifle", "rus_platoon_atheavy",
		"rus_platoon_rifle", "rus_platoon_atlight",
		"rus_platoon_rifle",
		"rus_platoon_rifle",
		"rus_platoon_rifle", "rus_platoon_mortar",
		"rus_platoon_rifle", "rus_platoon_sniper",
		"rus_platoon_rifle", "rus_platoon_rifle",
	},
	ruspshack = {
		"rus_platoon_partisan",
	},
	rusvehicleyard = {
		-- Works J
		"rusk31",
		"rusba64",
		"rust60", "rust60",
		"rust60",
		"rusm5halftrack",
		"rust60", "rust60",
		"rust60",
		"rusm5halftrack",
		"russu76", "russu76",
		"russu76",
		"rusm5halftrack",
		"russu76", "russu76",
		"russu76",
	},
	rustankyard = {
		-- Works J
		"rust70", "rust3476",
		"rust3476", "rust3476",
		"rust3476", "rusisu152",
	},
	-- Germany
	gerhqbunker = {
		-- Works J
		"gerhqengineer", "gerhqengineer",
		"ger_platoon_hq", "ger_platoon_hq", "ger_platoon_hq",
		"ger_platoon_hq", "ger_platoon_hq",
	},
	gerbarracks = {
		-- Works J
		"gerengineer", "gerengineer",
		"ger_platoon_rifle","ger_platoon_rifle", "ger_platoon_rifle",
		"ger_platoon_rifle","ger_platoon_rifle", "ger_platoon_rifle",
		"ger_platoon_at", "ger_platoon_mg", "ger_platoon_sniper", "ger_platoon_mortar",
		"gerleig18_bax",
	},
	gervehicleyard = {
		-- Works J
		"gersdkfz9",
		"gersdkfz250", "gersdkfz250", "gersdkfz250",
		"germarder",
		"gersdkfz251",
		"gersdkfz250", "gersdkfz250", "gersdkfz250",
		"germarder",
		"gersdkfz251",
	},
	gertankyard = {
		-- Works J
		"gerpanzeriii", "gerpanzeriii", "gerpanzeriii",
		"gerstugiii", "gerstugiii", "gerstugiii",
		"gertiger",
	},
	ushq = {
		-- Works J
		"ushqengineer", "ushqengineer",
		"us_platoon_hq", "us_platoon_hq", "us_platoon_hq",
		"us_platoon_hq", "us_platoon_hq", "us_platoon_hq",
		"us_platoon_hq", "us_platoon_hq", "us_platoon_hq",
	},
	usbarracks = {
		-- Works J
		"usengineer", "usengineer",
		"us_platoon_rifle", "us_platoon_rifle", "us_platoon_rifle",
		"us_platoon_rifle", "us_platoon_rifle", "us_platoon_rifle",
		"us_platoon_assault", "us_platoon_at",
		"us_platoon_mortar", "us_platoon_sniper", "us_platoon_flame",
		"usm8gun_bax",
	},
	usvehicleyard = {
		-- Works J
		"usgmcengvehicle",
		"usm8greyhound", "usm8greyhound", "usm8greyhound",
		"usm3halftrack",
		"usm8scott",
		"usm8greyhound", "usm8greyhound", "usm8greyhound",
		"usm3halftrack",
		"usm8scott",
	},
	ustankyard = {
		-- Works J
		"usm4a4sherman", "usm4a4sherman", "usm4a4sherman",
		"usm10wolverine",
	},
}

-- Format: side = { "unit to build 1", "unit to build 2", ... }
gadget.baseBuildOrder = {
	gbr = {
		-- I used storages basically to delay tech up a bit :P Making GBR the easy faction to play against.
		"gbrbarracks", "gbrbarracks", "gbrbarracks",
		"gbrvehicleyard", "gbrvehicleyard",
		"gbrstorage",
		-- GBR doesn't have packed howitzers, and C.R.A.I.G. doesn't know
		-- about deploying yet, so no point making a Towed Gun Yard.
		--"gbrgunyard",
		"gbrtankyard",
		"gbrsupplydepot",
		"gbrstorage", "gbrstorage",
	},
	rus = {
		-- TODO: add veh / tanks / towed guns (if rus has packed howitzers) Russia will be the "expert"
		"ruscommissar", "ruscommissar", -- due to unconventional build tree setup
		"ruscommissar", "ruscommissar", -- commissars are considered buildings :-)
		"rusbarracks", "rusbarracks", "rusbarracks",
		"ruspshack", "ruspshack",
		"rusvehicleyard", "rusvehicleyard",
		"rustankyard", "rustankyard", "rustankyard", "rustankyard", "rustankyard", "rustankyard", "rustankyard", "rustankyard",

	},
	ger = {
		-- works J
		"gerbarracks", "gerbarracks", "gerbarracks",
		"gerstorage",
		"gervehicleyard", "gervehicleyard",
		"gerstorage",
		"gertankyard", "gertankyard", "gertankyard", "gertankyard",
		"gersupplydepot",
	},

	us = {
		-- Works J
		"usbarracks", "usbarracks", "usbarracks",
		"usstorage",
		"usvehicleyard", "usvehicleyard",
		"usstorage",
		"ustankyard", "ustankyard", "ustankyard", "ustankyard",
		"ussupplydepot",
	},

}

-- This lists all the units (of all sides) that are considered "base builders"
gadget.baseBuilders = {
	"gbrhqengineer",
	"gbrengineer",
	"gbrmatadorengvehicle",
	"gerhqengineer",
	"gerengineer",
	"gersdkfz9",
	"ruscommander", -- contrary to other sides Russia can start immediately
	"ruscommissar", -- after game start with base building...
	"rusengineer",
	"rusk31",
	"ushqengineer",
	"usengineer",
	"usgmcengvehicle",
}


-- Do not limit units spawned through LUA! (infantry that is build in platoons,
-- deployed supply trucks, deployed guns, etc.)
gadget.unitLimits = {
	gbrengineer = 3,
	gbrmatadorengvehicle = 1,
	gerengineer = 7,
	gersdkfz9 = 1,
	rusengineer = 7,
	rusk31 = 1,
	usengineer = 7,
	usgmcengvehicle = 1,
}
