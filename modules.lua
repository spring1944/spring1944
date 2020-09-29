-- MODULES

local MODULES_DIR = "modules/"

modules = {
	-- core
	message = {
		data = {
			path = MODULES_DIR .. "core/api/message/",
			head = "message.lua",	
		},
	},
	cmdDesc = {
		data = {
			path = MODULES_DIR .. "core/api/cmdDesc/",
			head = "cmdDesc.lua",	
		},
	},
	mathExt = {
		data = {
			path = MODULES_DIR .. "core/ext/mathExt/",
			head = "mathExt.lua",	
		},
	},
	stringExt = {
		data = {
			path = MODULES_DIR .. "core/ext/stringExt/",
			head = "stringExt.lua",
		},
	},
	tableExt = {
		data = {
			path = MODULES_DIR .. "core/ext/tableExt/",
			head = "tableExt.lua",
		},
	},
	timeExt = {
		data = {
			path = MODULES_DIR .. "core/ext/timeExt/",
			head = "timeExt.lua",	
		},
	},
	vec3 = {
		data = {
			path = MODULES_DIR .. "core/vec3/",
			head = "vec3.lua",	
		},
	},
	hmsf = {
		data = {
			path = MODULES_DIR .. "core/hmsf/",
			head = "hmsf.lua",	
		},
	},
	json = {
		data = {
			path = MODULES_DIR .. "core/json/",
			head = "json.lua",	
		},
	},
	actionTypes = {
		data = {
			path = MODULES_DIR .. "core/tsp/actionTypes/",
			head = "actionTypes.lua",
		},
	},
	attach = {
		data = {
			path = MODULES_DIR .. "core/mod/attach/",
			head = "attach.lua",
		},
	},
	
	-- full modules
	customCommands = {
		data = {
			path = MODULES_DIR .. "customCommands/data/",
			head = "init.lua",	
		},	
	},
	goals = {
		data = {
			path = MODULES_DIR .. "goals/data/",
			head = "goals.lua"
		}
	},
	strongpoints = {
		data = {
			path = MODULES_DIR .. "strongpoints/data/",
			head = "init.lua",	
		},	
	},
}
