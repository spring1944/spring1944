--  Custom Options Definition Table format

--  NOTES:
--  - using an enumerated table lets you specify the options order

--
--  These keywords must be lowercase for LuaParser to read them.
--
--  key:      the string used in the script.txt
--  name:     the displayed name
--  desc:     the description (could be used as a tooltip)
--  type:     the option type
--  def:      the default value;
--  min:      minimum value for number options
--  max:      maximum value for number options
--  step:     quantization step, aligned to the def value
--  maxlen:   the maximum string length for string options
--  items:    array of item strings for list options
--  scope:    'all', 'player', 'team', 'allyteam'      <<< not supported yet >>>


--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
local options = {
	{ 
		key = 'always_visible_flags', 
		name = 'Always Visible Flags', 
		desc = 'Flags and their capping status can be seen without LOS', 
		type = 'bool', 
		def = false, 
	},		
	{ 
		key = 'fast_supply', 
		name = 'Faster resupply schedule', 
		desc = 'Weapons cost 2.25x to refill, resupply comes every 5 minutes instead of every 10.', 
		type = 'bool', 
		def = false, 
	},
	{
    key    = 'weapon_range_mult',
    name   = 'Weapon range multiplier',
    desc   = 'Applies a multiplier to all the weapon ranges ingame',
    type   = 'number',
    def    = 1.0,
    min	   = 0.1,
    max    = 10,
    step   = 0.1,
  },
  {
    key    = 'weapon_reload_mult',
    name   = 'Weapon reload multiplier',
    desc   = 'Applies a multiplier to all the weapon reloadtimes ingame',
    type   = 'number',
    def    = 1.0,
    min	   = 0.1,
    max    = 10,
    step   = 0.1,
  },
  {
    key    = 'unit_los_mult',
    name   = 'Unit sight (los/airLoS) multiplier',
    desc   = 'Applies a multiplier to all the LoS ranges ingame',
    type   = 'number',
    def    = 1.0,
    min	   = 0.1,
    max    = 10,
    step   = 0.1,
  },  
  {
    key    = 'unit_speed_mult',
    name   = 'Unit speed multiplier',
    desc   = 'Applies a multiplier to all the unit speeds and acceleration values ingame',
    type   = 'number',
    def    = 1.0,
    min	   = 0.1,
    max    = 10,
    step   = 0.1,
  },  
  {
    key    = 'unit_metal_mult',
    name   = 'Metal extraction multiplier',
    desc   = 'Applies a multiplier to all the metal extraction values',
    type   = 'number',
    def    = 1.0,
    min	   = 0.1,
    max    = 10,
    step   = 0.05,
  },
    {
    key    = 'weapon_aoe_mult',
    name   = 'AoE multiplier',
    desc   = 'Applies a multiplier to all the weapon AoE values',
    type   = 'number',
    def    = 1.0,
    min	   = 0.1,
    max    = 10,
    step   = 0.05,
  },
  
   {
    key    = 'weapon_hedamage_mult',
    name   = 'HE damage multiplier',
    desc   = 'Applies a multiplier to all the HE damage values',
    type   = 'number',
    def    = 1.0,
    min	   = 0.1,
    max    = 10,
    step   = 0.05,
  },
  {
    key    = 'weapon_edgeeffectiveness_mult',
    name   = 'Weapon edgeeffectiveness multiplier',
    desc   = 'Applies a multiplier to all the weapon edgeeffectiveness ingame',
    type   = 'number',
    def    = 1.0,
    min	   = 0.01,
    max    = 10,
    step   = 0.1,
  }--[[
  {
    key    = 'unit_buildable_airfields',
    name   = 'Airfield enabler',
    desc   = 'Adds/removes airfields from build trees',
    type   = 'number',
    def    = 0,
    min	   = 0,
    max    = 1,
    step   = 1,
  },
    {
    key    = 'unit_hq_platoon',
    name   = 'HQ-centric infantry game',
    desc   = 'Removes rifle/assault squads from barracks, puts them in HQ',
    type   = 'number',
    def    = 0,
    min	   = 0,
    max    = 1,
    step   = 1,
  }]]--
}

return options
