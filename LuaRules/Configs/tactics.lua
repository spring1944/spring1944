-- $Id: tactics.lua 3171 2008-11-06 09:06:29Z det $
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--
--  file:    LuaRules/Configs/deployment.lua
--  brief:   LuaRules deployment mode configuration
--  author:  Dave Rodgers
--
--  Copyright (C) 2007.
--  Licensed under the terms of the GNU GPL, v2 or later.
--
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------


local noCustomBuilds = false

if (Spring.GetModOptions) then
  modOptions = Spring.GetModOptions()
end
local commandLimit
if (modOptions.command_mult) then
	if (modOptions.command_mult == '0') then
		commandLimit = 5000
	end
	if (modOptions.command_mult == '1') then
		commandLimit = 10000
	end
	if (modOptions.command_mult == '2') then
		commandLimit = 20000
	end
	if (modOptions.command_mult == '3') then
		commandLimit = 40000
	end
	if (modOptions.command_mult == '4') then
		commandLimit = 80000
	end
end
local deployment = {

  maxFrames = 60 * Game.gameSpeed,

  maxUnits  = 5000,

  maxMetal  = commandLimit,
  maxEnergy = 5,

  maxRadius = 1024,

  maxAutoBuildLevels = 2,

  customBuilds = {

['gerhqbunker'] = {
      allow = {
    		"ger_platoon_rifle",
    		"ger_platoon_assault",
    		"ger_platoon_mg",
    		"ger_platoon_scout",
    		"ger_platoon_at",
    		"ger_platoon_sniper",
    		"ger_platoon_mortar",
			"geropelblitz",
    		"gersdkfz250",
    		"gersdkfz251",
    		"germarder",
    		"gerleig18_gunyard",
    		"gerpak40_truck",
    		"gerlefh18_truck",
    		"gernebelwerfer_truck",
    		"gerpanzeriii",
    		"gerpanzeriv",
    		"gerstugiii",
    		"gerjagdpanzeriv",
    		"gerpanther",
    		"gertiger",
    		"gertigerii",
    		"gersturmboot",
			"tankobstacle",
    		"apmine",
    		"atmine"
      },
      forbid = {
      },
    },
	
	['gbrhq'] = {
      allow = {
    		"gbr_platoon_rifle",
    		"gbr_platoon_assault",
    		"gbr_platoon_mg",
    		"gbr_platoon_scout",
    		"gbr_platoon_at",
    		"gbr_platoon_sniper",
    		"gbr_platoon_mortar",
			"gbr_platoon_commando",
			"gbrbedfordtruck",
    		"gbrdaimler",
    		"gbrm5halftrack",
    		"gbrkangaroo",
    		"gbr17pdr_truck",
    		"gbr25pdr_truck",
    		"gbraecmkii",
    		"gbrcromwell",
    		"gbrshermanfirefly",
    		"gbrcromwellmkvi",
    		"gbrm10achilles",
    		"gbrchurchillmkvii",
    		"gbrsexton",
    		"rubberdingy",
			"tankobstacle",
    		"apmine",
    		"atmine"
      },
      forbid = {
      },
    },
    ['ruscommander'] = {
      allow = {
    		"rus_platoon_rifle",
    		"rus_platoon_assault",
    		"rus_platoon_mg",
    		"rus_platoon_scout",
    		"rus_platoon_atlight",
			"rus_platoon_atheavy",
    		"rus_platoon_sniper",
    		"rus_platoon_mortar",
			"rus_platoon_partisan",
			"ruszis5",
			"rusba64",
    		"rust60",
    		"rusm5halftrack",
    		"russu76",
    		"ruszis3_truck",
    		"ruszis2_truck",
    		"rusm30_truck",
    		"rust70",
    		"rust3476",
    		"rusisu152",
    		"rust3485",
    		"rusis2",
    		"rusbm13n",
    		"ruslighttender",
			"tankobstacle",
    		"apmine",
    		"atmine"
      },
      forbid = {
      },
    },
	
    ['ushq'] = {
      allow = {
    		"us_platoon_rifle",
    		"us_platoon_assault",
    		"us_platoon_mg",
    		"us_platoon_scout",
    		"us_platoon_at",
    		"us_platoon_sniper",
			"us_platoon_flame",
    		"us_platoon_mortar",
			"usgmctruck",
    		"usm8greyhound",
    		"usm3halftrack",
    		"usm8scott",
    		"usm8gun_bax",
    		"usm5gun_truck",
    		"usm2gun_truck",
    		"usm5stuart",
    		"usm4a4sherman",
    		"usm10wolverine",
    		"usm4a376sherman",
    		"usm4a3105sherman",
    		"usm4jumbo",
    		"rubberdingy",
			"tankobstacle",
    		"apmine",
			"atmine"
      },
      forbid = {
      },
    },
  },
}


if (noCustomBuilds) then
  deployment.customBuilds = {}  -- FIXME --
end


--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

return deployment

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
