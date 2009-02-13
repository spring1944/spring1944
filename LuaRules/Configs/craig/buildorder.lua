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
		"gbr_platoon_hq", "gbr_platoon_hq", "gbr_platoon_hq", "gbr_platoon_hq",
		"gbr_platoon_hq", "gbr_platoon_hq", "gbr_platoon_hq", "gbr_platoon_hq",
	},
	gbrbarracks = {
		"gbrengineer", "gbrengineer",
		"gbr_platoon_rifle", "gbr_platoon_assault",
		"gbr_platoon_rifle", "gbr_platoon_mortar",
		"gbr_platoon_rifle", "gbr_platoon_at",
		"gbr_platoon_rifle", "gbr_platoon_mg",
		"gbr_platoon_rifle", "gbr_platoon_sniper",
		"gbr_platoon_rifle", "gbr_platoon_rifle",
	},
	gbrvehicleyard = {
		"gbrmatadorengvehicle",
		"gbrdaimler", "gbrdaimler",
		"gbrm5halftrack",
		"gbrdaimler", "gbrdaimler",
		"gbrm5halftrack",
	},
	-- it can not upgrade tank yard yet!
	gbrtankyard = {
		"gbrcromwell", "gbrcromwellmkvi",
		"gbrcromwell", "gbrcromwellmkvi",
		"gbraecmkii", --antitank
		"gbrshermanfirefly", "gbrshermanfirefly",
	},
	-- Russia
	rusbarracks = {
		-- no engineer yet, someone else may continue the build orders :-)
		"rus_platoon_rifle", "rus_platoon_assault",
		"rus_platoon_rifle", "rus_platoon_atheavy",
		"rus_platoon_rifle", "rus_platoon_atlight",
		"rus_platoon_rifle", "rus_platoon_atlight",
		"rus_platoon_rifle", "rus_platoon_mg",
		"rus_platoon_rifle", "rus_platoon_mortar",
		"rus_platoon_rifle", "rus_platoon_sniper",
		"rus_platoon_rifle", "rus_platoon_rifle",
	},
}

-- Format: side = { "unit to build 1", "unit to build 2", ... }
gadget.baseBuildOrder = {
	gbr = {
		-- I used storages basically to delay tech up a bit :P
		"gbrbarracks", "gbrbarracks",
		"gbrstorage", "gbrstorage",
		"gbrbarracks",
		"gbrvehicleyard",
		"gbrstorage", "gbrstorage",
		-- GBR doesn't have packed howitzers, and C.R.A.I.G. doesn't know
		-- about deploying yet, so no point making a Towed Gun Yard.
		--"gbrgunyard",
		"gbrtankyard",
		"gbrsupplydepot",
		"gbrstorage", "gbrstorage",
	},
	rus = {
		-- TODO: add veh / tanks / towed guns (if rus has packed howitzers)
		"ruscommissar", "ruscommissar", -- due to unconventional build tree setup
		"ruscommissar", "ruscommissar", -- commissars are considered buildings :-)
		"rusbarracks", "rusbarracks", "rusbarracks",
		"russtorage", "russtorage", "russtorage",
	},
}

-- this lists all the units (of all sides) that are considered "base builders"
gadget.baseBuilders = {
	"gbrhqengineer",
	"gbrengineer",
	"gbrmatadorengvehicle",
	"gerengineer",
	"gerhqengineer",
	--TODO: ger eng vehicle
	"ruscommander", -- contrary to other sides Russia can start immediately
	"ruscommissar", -- after game start with base building...
	"rusengineer",
	--TODO: rus eng vehicle
	"ushqengineer",
	"usengineer",
	"usgmcengvehicle",
}
