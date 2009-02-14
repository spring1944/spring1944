--[[
	format:
	radiotowershortname = {sortie, sortie...}
	sortie = {
		name = string (default ""), 
		shortname = string (default nil),
		cost = number (required), 
		delay = number (default 1 frame), 
		cursor = string (default "Attack"), 
		units = {unitname, unitname...} (required)
	}
]]

local planeDefs = {
	gbrflag = {
		{
			name = "Recon Plane",
			shortname = "Rec",
			cost = 500,
			delay = 15,
			units = {
				"gbrauster",
			},
		},
		{
			name = "Attack Fighter",
			shortname = "AF",
			cost = 3000,
			delay = 15,
			units = {
				"gbrspitfiremkxiv",
				"gbrspitfiremkxiv",
				"gbrspitfiremkxiv",
				"gbrspitfiremkxiv",
			},
		},
		{
			name = "Fighter-Bomber",
			shortname = "FB",
			cost = 4000,
			delay = 15,
			units = {
				"gbrspitfiremkix",
				"gbrspitfiremkix",
				"gbrspitfiremkix",
				"gbrspitfiremkix",
			},
		},
		{
			name = "Ground-Attack Aircraft",
			shortname = "GA",
			cost = 5000,
			delay = 15,
			units = {
				"gbrtyphoon",
				"gbrtyphoon",
				"gbrtyphoon",
				"gbrtyphoon",
			},
		},
	},
	gerflag = {
		{
			name = "Recon Plane",
			shortname = "Rec",
			cost = 500,
			delay = 15,
			units = {
				"gerfi156",
			},
		},
		{
			name = "Attack Fighter",
			shortname = "AF",
			cost = 3000,
			delay = 15,
			units = {
				"gerfw190",
				"gerfw190",
				"gerfw190",
				"gerfw190",
			},
		},
		{
			name = "Fighter-Bomber",
			shortname = "FB",
			cost = 4000,
			delay = 15,
			units = {
				"gerfw190g",
				"gerfw190g",
				"gerfw190g",
				"gerfw190g",
			},
		},
		{
			name = "Ground-Attack Aircraft",
			shortname = "GA",
			cost = 5000,
			delay = 15,
			units = {
				"gerju87g",
				"gerju87g",
				"gerju87g",
				"gerju87g",
			},
		},
	},
	rusflag = {
		{
			name = "Recon Plane",
			shortname = "Rec",
			cost = 500,
			delay = 15,
			units = {
				"ruspo2",
			},
		},
		{
			name = "Attack Fighter",
			shortname = "AF",
			cost = 3000,
			delay = 15,
			units = {
				"rusyak3",
				"rusyak3",
				"rusyak3",
				"rusyak3",
			},
		},
		{
			name = "Ground-Attack Aircraft",
			shortname = "GA",
			cost = 5000,
			delay = 15,
			units = {
				"rusil2",
				"rusil2",
				"rusil2",
				"rusil2",
			},
		},
	},
	usflag = {
		{
			name = "Recon Plane",
			shortname = "Rec",
			cost = 500,
			delay = 15,
			units = {
				"usl4",
			},
		},
		{
			name = "Attack Fighter",
			shortname = "AF",
			cost = 3000,
			delay = 15,
			units = {
				"usp51dmustang",
				"usp51dmustang",
				"usp51dmustang",
				"usp51dmustang",
			},
		},
		{
			name = "Fighter-Bomber",
			shortname = "FB",
			cost = 4000,
			delay = 15,
			units = {
				"usp47thunderbolt",
				"usp47thunderbolt",
				"usp47thunderbolt",
				"usp47thunderbolt",
			},
		},
		{
			name = "Ground-Attack Aircraft",
			shortname = "GA",
			cost = 5000,
			delay = 15,
			units = {
				"usp51dmustangga",
				"usp51dmustangga",
				"usp51dmustangga",
				"usp51dmustangga",
			},
		},
	},
}

return planeDefs