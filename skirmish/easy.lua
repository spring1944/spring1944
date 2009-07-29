
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
local options = {

	--this is mandatory, min. 1 listitem
    {
	key    = "ai_team_ids",
	name   = "AI Teams",
	desc   = "used to map ai num <-> team id and define number of added AIs",
	type   = "list",
	def    = "0",
	items  = {
		{
		key  = "0",
		name = "2",
		desc = "put first AI into team 2",
		},
		{
		key  = "1",
		name = "3",
		desc = "put second AI into team 3",
		},
	  },
  },
  	--optional, list Side names for AI players. If left out first avail Side is chosen for AI
    {
	key    = "ai_sides",
	name   = "AI Sides",
	desc   = "used to map ai num <-> Side ",
	type   = "list",
	def    = "0",
	items  = {
		{
		key  = "0",
		name = "GER",
		desc = "",
		},
		{
		key  = "1",
		name = "US",
		desc = "",
		},
	  },
  },
	--optional, list min one item or leave out completely ( -> all avail maps are offered to the user )
    {
	key    = "suggested_maps",
	name   = "Suggested Maps",
	desc   = "add XX to this list to limit the choice of maps the player gets presented with",
	type   = "list",
	def    = "0",
	items  = {
		{
		key  = "0",
		name = "1944_Road_To_Rome_V3.smf",
		desc = "",
		},
		{
		key  = "1",
		name = "1944_BocageSmall.smf",
		desc = "",
		},
	  },
  },
  --optional, list min one item or leave out completely ( -> all avail Sides are offered to the user )
    {
	key    = "suggested_sides",
	name   = "Suggested Sides",
	desc   = "add XX to this list to limit the choice of Sides the player gets presented with",
	type   = "list",
	def    = "0",
	items  = {
		{
		key  = "0",
		name = "GER",
		desc = "",
		},
		{
		key  = "1",
		name = "GBR",
		desc = "",
		},
	  },
  },

  --all optional below, copy-paste any modoption you like and set a different default value to override
  {
    key    = "command_storage",
    name   = "Fixed Command Storage",
    desc   = "Fixes the command storage of all players. (key = 'command_storage')",
    type   = "number",
    def    = 20000,
    min    = 1000,
    max    = 1944000,
    step   = 1000,
  },
	
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--
--  C.R.A.I.G. specific option(s)
--
	{
		key    = "craig_difficulty",
		name   = "C.R.A.I.G. difficulty level",
		desc   = "Sets the difficulty level of the C.R.A.I.G. bot. (key = 'craig_difficulty')",
		type   = "list",
		def    = "1",
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
