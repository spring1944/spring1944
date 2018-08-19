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
		funcName = "ToggleWeapon",
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
		funcName = "ToggleWeapon",
		tooltip = 'Toggle between Ambush and Normal modes',
		id = "CMD_TOGGLE_AMBUSH",
	
	},
	priorityAPHE = {
		states = {
			{
				name = "Prefer AP",
				toggle = {
					[1] = 1,
					[2] = 2,
				},
			},
			{
				name = "Prefer HE",
				toggle = {
					[1] = 2,
					[2] = 1,
				},
			},
		},
		action = "togglepriority",
		funcName = "TogglePriority",
		tooltip = 'Change ammunition priorities',
		id = "CMD_TOGGLE_PRIORITY",
	},

	priorityHEATAP = {
		states = {
			{
				name = "Prefer AP",
				toggle = {
					[1] = 2,
					[2] = 1,
				},
			},
			{
				name = "Prefer HEAT",
				toggle = {
					[1] = 1,
					[2] = 2,
				},
			},
		},
		action = "togglepriority",
		funcName = "TogglePriority",
		tooltip = 'Change ammunition priorities',
		id = "CMD_TOGGLE_PRIORITY_HTAP",
	},

	priorityHEATHE = {
		states = {
			{
				name = "Prefer HE",
				toggle = {
					[1] = 2,
					[2] = 1,
				},
			},
			{
				name = "Prefer HEAT",
				toggle = {
					[1] = 1,
					[2] = 2,
				},
			},
		},
		action = "togglepriority",
		funcName = "TogglePriority",
		tooltip = 'Change ammunition priorities',
		id = "CMD_TOGGLE_PRIORITY_HTHE",
	},

	priorityAPHEATHE = {
		states = {
			{
				name = "Prefer HEAT",
				toggle = {
					[1] = 1,
					[2] = 3,
					[3] = 2,
				},
			},
			{
				name = "Prefer AP",
				toggle = {
					[1] = 3,
					[2] = 1,
					[3] = 2,
				},
			},
			{
				name = "Prefer HE",
				toggle = {
					[1] = 2,
					[2] = 3,
					[3] = 1,
				},
			},
		},
		action = "togglepriority",
		funcName = "TogglePriority",
		tooltip = 'Change ammunition priorities',
		id = "CMD_TOGGLE_PRIORITY_HEAT",
	},
}

return defs
