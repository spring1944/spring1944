local unitDefs = {
	["trucks"] = {
		{	-- spawn tier 1
			"fracitroentype45",
		},
	},
	["france"] = {
		{	-- tier 1 - truck
			"fracitroentype45",
		},
		{	-- tier 2 - APC and scout
			"fralorraine38l",
			"fralafflyv15r",
		},
		{	-- tier 3 - bad light tanks
			"frar35",
			"frah35",
		},
		{	-- tier 4 - better light tanks, armored car
			"frar39",
			"frah39",
			"fraamd35",
		},
		{	-- tier 5 - medium tank
			"fras35",
		},
		--[[ NOOOOO, composite unit spawning doesn't work correctly here!
		{	-- tier 6 - heavy
			"fracharb1bis",
		},
		]]--
	},
}

return unitDefs