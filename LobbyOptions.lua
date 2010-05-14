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
	key    = "scenarios",
	name   = "scenarios",
	desc   = "",
	type   = "list",
	def    = "easy",
	items  =
		{
			{
				key  = "easy", 		--put the options in skirmish_directory/KEY.lua
				name = "Easy mode", --will be displayed as radio box to click
				desc = "lalala",	--unused
			},
			{
				key  = "medium",
				name = "Medium Doh",
				desc = "more lalala",
			},
		},
	},
	{
		key    = "skirmish_directory",
		name   = "skirmish_directory",
		desc   = "directory where skirmish defintion files are located",
		type   = "string",
		def    = "skirmish",
	},
	{
		key    = "bg_image",
		name   = "bg_image",
		desc   = "BackgroundImage to be put on panes or such",
		type   = "string",
		--png/bmp should be fine, don't use transparency ( will look weird wrt controls )
		--the controls on startpage are v/h centered, best to leave around 40px "free" space (no text on bg)
		def    = "bitmaps/lobby_background.png", 
	},
	{
		key    = "icon",
		name   = "icon",
		desc   = "application icon",
		type   = "string",
		def    = "icons/sl_app.png", 	--bmp/png
	},
	{
		key    = "battlelist_filter",
		name   = "battlelist_filter",
		desc   = "simple string/regex filter that defines which battles are shown in multiplayer",
		type   = "string",
		def    = "1944",
	},
	{
		key    = "default_ai",
		name   = "default_ai",
		desc   = "default_ai",
		type   = "string",
		def    = "C.R.A.I.G.",
	},
	{	-- optional
		key    = "help_url",
		name   = "help_url",
		desc   = "the url that is opened in browser if help button is clicked",
		type   = "string",
		def    = "http://spring1944.net/phpBB3",
	},
	{
		-- optional
		key    = "gradient_top",
		name   = "gradient_top",
		desc   = "a rgb -> rgb gradient used on controls",
		type   = "string",
		def    = "132,125,132|74,69,74",
	},
	{
		-- optional
		key    = "gradient_bottom",
		name   = "gradient_bottom",
		desc   = "another rgb -> rgb gradient used on controls",
		type   = "string",
		def    = "0,0,0|57,56,75",
	},
	{
		-- mandatory
		key    = "fontcolour",
		name   = "fontcolour",
		desc   = "r,g,b",
		type   = "string",
		def    = "255,255,255",
	},
	{
		-- mandatory
		key    = "controls_background",
		name   = "controls_background",
		desc   = "r,g,b",
		type   = "string",
		def    = "0,0,0",
	}
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
}
return options
