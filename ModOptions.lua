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
    key    = 'gamemode',
    name   = 'Game Modes',
    desc   = 'Change the game mode',
    type   = 'list',
    def    = 'normal',
    items  = {
      {
        key  = 'chickeneasy',
        name = 'Chicken (easy) - Work in progress',
        desc = 'Players must defeat wave after wave of chicken dinosaur zerglings',
      },
      {
        key  = 'chickennormal',
        name = 'Chicken (normal) - Work in progress',
        desc = 'Players must defeat wave after wave of chicken dinosaur zerglings',
      },
      {
        key  = 'chickenhard',
        name = 'Chicken (hard) - Work in progress',
        desc = 'Players must defeat wave after wave of chicken dinosaur zerglings',
      },
    },
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
    key    = 'weapon_edgeeffectiveness_mult',
    name   = 'Weapon edgeeffectiveness multiplier',
    desc   = 'Applies a multiplier to all the weapon edgeeffectiveness ingame',
    type   = 'number',
    def    = 1.0,
    min	   = 0.01,
    max    = 10,
    step   = 0.1,
  }
}

return options
