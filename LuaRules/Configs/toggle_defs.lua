local defs = {
	smoke = {
		states = {
			{
				name = "Fire HE",
				toggle = {
					[1] = true,
					[2] = false,
				},
			},
			{
				name = "Fire Smoke",
				toggle = {
					[1] = false,
					[2] = true,
				},
			},
		},
		action = "togglesmoke",
		tooltip = 'Toggle between High Explosive and Smoke rounds',
		id = "CMD_TOGGLE_SMOKE",
	},
	ambush = {
		states = {
			{
				name = "Normal",
				toggle = {
					[1] = true,
				},
			},
			{
				name = "Ambush",
				toggle = {
					[1] = false,
				},
			},
		},
		action = "toggleambush",
		tooltip = 'Toggle between Ambush and Normal modes',
		id = "CMD_TOGGLE_AMBUSH",
	},
}

return defs
