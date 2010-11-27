
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
local options = {
	--mandatory descriptive text
	{
		key 	= "description",
		type	= "string",
		desc	= "basic html allowed",
		def 	= "<h1>Battle for that other place</h1><p>some other text</p>",
	},
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
	{
		key    = "craig_difficulty",
		name   = "C.R.A.I.G. difficulty level",
		desc   = "Sets the difficulty level of the C.R.A.I.G. bot. (key = 'craig_difficulty')",
		type   = "list",
		def    = "2",
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
