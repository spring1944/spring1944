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
--  scope:    "all", "player", "team", "allyteam"      <<< not supported yet >>>


--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
local options = {
	{
		key = '2victormode',
		name = 'Game Mode Settings',
		desc = 'Victory settings',
		type = 'section',
	},
	
	{
		key = "victorymode",
		name = "Victory Mode",
		desc = "What leads to victory? (key = 'victorymode')",
		type = "list",
		def = "strategicdominance",
		section = '2victormode',
		items = {
			{
				key = "annihilation",
				name = "Annihilation",
				desc = "Only goal is complete and total annihilation of the enemy",
			},
			{
				key = "strategicdominance",
				name = "Strategy Dominance",
				desc = "The goal is to capture specified partition of strongpoints and survive the countdown",
			},
		},
	},
	{
		key = "strongpointsratio",
		name = "Strongpoints Ratio",
		desc = "Portion of strongpoints necessary to win strategic dominance victory mode",
		type = "list",
		section	= '2victormode',
		def = "0.7",
		items = {
			{ key = "0.51", name = "51 %"},
			{ key = "0.6", name = "60 %"},
			{ key = "0.7", name = "70 %"},
			{ key = "0.8", name = "80 %"},
			{ key = "0.9", name = "90 %"},
			{ key = "1.0", name = "100 %"},
		},
	},
	{
		key = "dominancetimeout",
		name = "Dominance Timeout",
		desc = "Time for which you need to hold captured strongpoints to win Strategic Dominance mode",
		type = "list",
		section	= '2victormode',
		def = "6",
		items = {
			{ key = "2", name = "2 Minutes"},
			{ key = "3", name = "3 Minutes"},
			{ key = "4", name = "4 Minutes"},
			{ key = "6", name = "6 Minutes"},
			{ key = "8", name = "8 Minutes"},
			{ key = "10", name = "10 Minutes"},
		},
	},
	{
		key = "dominancetimeoutreset",
		name = "Dominance Timeout Reset",
		desc = "Is dominance timeout reset everytime the dominance threshold is met again?",
		type = "list",
		section	= '2victormode',
		def = "nowithpenalty",
		items = {
			{ key = "yes", name = "Yes", desc = "Timeout is always reset once the dominance is reached."},
			{ key = "no", name = "No", desc = "Countdown starts from last timeout value once the dominance is reached again."},
			{ key = "nowithpenalty", name = "No with Penalty", desc = "Countdown starts approximately on last time value once the dominance is reached again but small penalty is added to its value"},
		},
	},
	{
		key = "spoilsofwar",
		name = "Spoils of War",
		desc = "Captureable Neutral units",
		type = "list",
		section	= '2victormode',
		def = "disabled",
		items = {
			{
				key = "disabled",
				name = "None",
				desc = "No neutral units",
			},
			{
				key = "trucks",
				name = "Trucks",
				desc = "Neutral Trucks",
			},
			{
				key = "france",
				name = "French Legacy",
				desc = "French units for capture",
			},
			{
				key = "mines",
				name = "Minefields",
				desc = "Some flags will start out with anti-personnel minefields (more likely father from player starts)",
			},
		},
	},
	{
		key = '3resources',
		name = 'Resource Settings',
		desc = 'Sets various options related to the in-game resources, Command and Logistics',
		type = 'section',
	},
	{
		key = "command_mult",
		name = "Command Point Income/Battle Significance",
		desc = "Sets level of Command Point income - use to adjust maps that provide too much or too little command points (key = 'command_mult')",
		type = "list",
		section = '3resources',
		def = "2",
		items = {
			{
				key = "0",
				name = "Very Low",
				desc = "Very limited resources. Nothing but a minor skirmish, you must make the most of what resources you have.",
			},
			{
				key = "1",
				name = "Low",
				desc = "Limited Command Points. This battle is insignificant, and you will be struggling to maintain infantry battalions",
			},
			{
				key = "2",
				name = "Normal",
				desc = "Standard Command Points. The supreme commanders are keeping an eye on the outcome of this engagement. Expect medium numbers of infantry with considerable vehicle support, with armor and gun batteries appearing later.",
			},
			{
				key = "3",
				name = "High",
				desc = "Abundant Command Points. The command has deemed this battle vital. You must win at all costs, and your available resources reflect that urgency.",
			},
			{
				key = "4",
				name = "Very High",
				desc = "Excessive Command Points. High command has an emotional attachment to your skirmish, and they want it won.",
			},
		},
	},

	{
		key = "logistics_period",
		name = "Logistics Resupply Frequency",
		desc = "Sets the gap between Logistics Resupply (key = 'logistics_period')",
		type = "list",
		section = '3resources',
		def = "450",
		items = {
			{
				key = "675",
				name = "Low - 11.25 minute gap",
				desc = "Limited logistics supply. Conservative play - storage buildings and well supplied infantry are the order of the day.",
			},
			{
				key = "450",
				name = "Normal - 7.5 minute gap",
				desc = "Normal logistics supply. Supplies come on a frequent enough basis to keep the warmachine rumbling, but beware of large artillery batteries or armored thrusts.",
			},
			{
				key = "225",
				name = "High - 3.75 minute gap",
				desc = "Abundant logistics supply. Supply deliveries arrive early and often, allowing for much more aggressive play.",
			},
		},
	},
  
	{
		key = "command_storage",
		name = "Fixed Command Storage",
		desc = "Fixes the command storage of all players. (key = 'command_storage')",
		type = "number",
		def = 10000,
		min = 1000,
		max = 50000,
		section = '3resources',
		step = 1000,
	},
  
	{
		key = "map_command_per_player",
		name = "Map Command Per Player",
		desc = "Sets the total command on the map to some number per player (negative to disable). (key = 'map_command_per_player')",
		type = "number",
		def = -10,
		min = -10,
		max = 5000,
		section = '3resources',
		step = 10,
	},

	{
		key = "communism_mode",
		name = "Communism Mode",
		desc = "Distributes income from flags evenly between allied players. (key = 'communism_mode')",
		type = "bool",
		def = true,
		section = '3resources',
	},

	{
		key = "base_command_income",
		name = "Base Command Income",
		desc = "Gives each player a permanent income of at least this amount (key = 'base_command_income')",
		type = "number",
		def = 25,
		min = 0,
		max = 1000000,
		section = '3resources',
		step = 5,
	},
  	
	{
		key = '4other',
		name = 'Other Settings',
		desc = 'Various other settings',
		type = 'section',
	},
	
	{
		key = "gm_team_enable",
		name = "Enable Sandbox/GM tools faction",
		desc = "Allows the sandbox/game master tools faction to spawn, rather than changing to a random team (key = 'gm_team_enable')",
		type = "bool",
		section = '4other',
		def = false,
	},

	{
		key = "qtpfs",
		name = "QTPFS",
		desc = "Switch between Legacy or QTPFS pathfinder.)",
		type = "bool",
		section = '4other',
		def = false,
	},
	
	{
		key = "weapon_range_mult",
		name = "Range multiplier",
		desc = 'Multiplies the range of all weapons, adjusting accuracy and weapon velocity as well. 1 is default, 8 is "realistic".',
		type = "number",
		def = 1.0,
		min = 0.1,
		max = 8.0,
		section = '4other',
		step = 0.1,
	},

	{
		key = "weapon_bulletdamage_mult",
		name = "Bullet Damage Multiplier",
		desc = 'Multiplies the damage of smallarms (high smallarms damage best used with high range multipliers)',
		type = "number",
		def = 1.0,
		min = 0.1,
		max = 10.0,
		section = '4other',
		step = 0.1,
	},
	
	{
		key = "unit_los_mult",
		name = "Unit sight (los/airLoS) multiplier",
		desc = "Applies a multiplier to all the LoS ranges ingame",
		type = "number",
		def = 1.0,
		min = 0.1,
		max = 10,
		section = '4other',
		step = 0.1,
	},
	
	{
		key = "unit_radar_mult",
		name = "Unit radar multiplier",
		desc = "Applies a multiplier to all the radar ranges ingame, which affects spotting of tanks outside LoS",
		type = "number",
		def = 1.0,
		min = 0.1,
		max = 10,
		section = '4other',
		step = 0.1,
	},
  
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--
--  C.R.A.I.G. specific option(s)
--
	{
		key = '5ai',
		name = 'A.I. Settings',
		desc = "Sets C.R.A.I.G's options",
		type = 'section',
	},
	{
		key = "craig_difficulty",
		name = "C.R.A.I.G. difficulty level",
		desc = "Sets the difficulty level of the C.R.A.I.G. bot. (key = 'craig_difficulty')",
		type = "list",
		section = "5ai",
		def = "2",
		items = {
			{
				key = "1",
				name = "Easy",
				desc = "No resource cheating."
			},
			{
				key = "2",
				name = "Medium",
				desc = "Little bit of resource cheating."
			},
			{
				key = "3",
				name = "Hard",
				desc = "Infinite resources."
			},
		}
	},
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

}
return options
