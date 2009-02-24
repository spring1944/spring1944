--[[
	format:
	radiotowername = {sortie, sortie...}
	sortie = {
		name = string (default lead plane's description), --full name of sortie
		shortname = string (default nil), --displayed over icon
		cost = number (required), --command cost of sortie
		delay = number (at least 1 frame), --seconds it takes sortie to arrive
		cursor = string (default "Attack"), --cursor when ordering sortie
		units = {unitname, unitname...} (required) --planes in the sortie; first unitname is lead plane
	}
]]

local planeDefs = {
	gbrhq = {
		{
			--name = "Recon Plane",
			--shortname = "Rec",
			cost = 350,
			delay = 15,
			units = {
				"gbrauster",
			},
		},
	},
	gbrradar = {
		{
			--name = "Recon Plane",
			--shortname = "Rec",
			cost = 350,
			delay = 15,
			units = {
				"gbrauster",
			},
		},
		{
			--name = "Interceptor",
			--shortname = "Int",
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
			--name = "Fighter-Bomber",
			--shortname = "FB",
			cost = 4000,
			delay = 45,
			units = {
				"gbrspitfiremkix",
				"gbrspitfiremkix",
			},
		},
		{
			--name = "Attack Fighter",
			--shortname = "AF",
			cost = 5000,
			delay = 30,
			units = {
				"gbrtyphoon",
				"gbrtyphoon",
			},
		},
	},
	gerhqbunker = {
			{
			--name = "Recon Plane",
			--shortname = "Rec",
			cost = 350,
			delay = 15,
			units = {
				"gerfi156",
			},
		},
	},
	gerradar = {
		{
			--name = "Recon Plane",
			--shortname = "Rec",
			cost = 350,
			delay = 15,
			units = {
				"gerfi156",
			},
		},
		{
			--name = "Interceptor",
			--shortname = "Int",
			cost = 3000,
			delay = 15,
			units = {
				"gerbf109",
				"gerbf109",
				"gerbf109",
				"gerbf109",
			},
		},
		{
			--name = "Air Superiority Fighter",
			--shortname = "ASF",
			cost = 3500,
			delay = 30,
			units = {
				"gerfw190",
				"gerfw190",
				"gerfw190",
				"gerfw190",
			},
		},
		{
			--name = "Fighter-Bomber",
			--shortname = "FB",
			cost = 4000,
			delay = 45,
			units = {
				"gerfw190g",
				"gerfw190g",
			},
		},
		{
			--name = "Attack Fighter",
			--shortname = "AF",
			cost = 5000,
			delay = 30,
			units = {
				"gerju87g",
				"gerju87g",
				"gerju87g",
			},
		},
	},
	rusbarracks = {
		{
			--name = "Recon Plane",
			--shortname = "Rec",
			cost = 350,
			delay = 15,
			units = {
				"ruspo2",
			},
		},	
	},
	rusradar = {
		{
			--name = "Recon Plane",
			--shortname = "Rec",
			cost = 350,
			delay = 15,
			units = {
				"ruspo2",
			},
		},
		{
			--name = "Interceptor",
			--shortname = "Int",
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
			--name = "Air Superiority Fighter",
			--shortname = "ASF",
			cost = 3500,
			delay = 30,
			units = {
				"rusla5fn",
				"rusla5fn",
				"rusla5fn",
				"rusla5fn",
			},
		},
		{
			--name = "Attack Fighter",
			--shortname = "AF",
			cost = 5000,
			delay = 40,
			units = {
				"rusil2",
				"rusil2",
			},
		},
	},
	ushq = {
		{
			--name = "Recon Plane",
			--shortname = "Rec",
			cost = 350,
			delay = 15,
			units = {
				"usl4",
			},
		},
	},
	usradar = {
		{
			--name = "Recon Plane",
			--shortname = "Rec",
			cost = 350,
			delay = 15,
			units = {
				"usl4",
			},
		},
		{
			--name = "Interceptor",
			--shortname = "Int",
			cost = 3000,
			delay = 25,
			units = {
				"usp51dmustang",
				"usp51dmustang",
				"usp51dmustang",
				"usp51dmustang",
			},
		},
		{
			--name = "Fighter-Bomber",
			--shortname = "FB",
			cost = 4000,
			delay = 45,
			units = {
				"usp47thunderbolt",
				"usp47thunderbolt",
			},
		},
		{
			--name = "Attack Fighter",
			--shortname = "AF",
			cost = 5000,
			delay = 35,
			units = {
				"usp51dmustangga",
				"usp51dmustangga",
			},
		},
	},
}

return planeDefs