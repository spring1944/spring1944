--[[
	Spawn tiering depends on distance to closest player start point. Closest = tier 1, and it goes up from there up to max tier number found in this config file.
	Flags will be evenly (as evenly as possible) distributed between tiers based on that distance. And then only units from that tier will be spawned on that flag.
	So it is possible to keep more interesting things closer to map center
]]--

local unitDefs = {
	["mines"] = {
		{
			"",
		},	-- tier 1: no mines
		{	-- tier 2: 1/3 mines
			"",
			"",
			"gerapminesign",
		},
		{	-- tier 3: 2/3 mines
			"",
			"gerapminesign",
			"gerapminesign",
		},
		{	-- tier 4: all mines
			"gerapminesign",
		},
	},
}

return unitDefs