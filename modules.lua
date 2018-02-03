-- MODULES
-- * mandatory include-config file for all technolgies/modules refencing any notAlab submodule with other submodules dependencies
-- * ALTERNATIVE DESCRIPTION: here you just fill paths for 3rd and higher levels potential dependencies

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
	notAchili = {
		config = {
			ss44UI = {
				path = MODULES_DIR .. "notAchili/ss44UI/",
				files = {
					"tools.lua",
					"unitControlTools.lua",
					"minimapWidget.lua",
					"selectionWidget.lua",
					"ordersWidget.lua",
					"buildWidget.lua",
					"resourceBarWidget.lua",
					"consoleWidget.lua",
					"missionGoalsWidget.lua",
				},
			},
		},
		data = {
			path = MODULES_DIR .. "notAchili/data/",
			head = "init.lua",	
		},	
	},
	strongpoints = {
		data = {
			path = MODULES_DIR .. "strongpoints/data/",
			head = "init.lua",	
		},	
	},
}