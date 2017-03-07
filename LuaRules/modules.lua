-- MODULES
-- * mandatory include-config file for all technolgies/modules refencing any notAlab submodule with other submodules dependencies
-- * ALTERNATIVE DESCRIPTION: here you just fill paths for 3rd and higher levels potential dependencies

local MODULES_DIR = "LuaRules/modules/"

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
	timeExt = {
		data = {
			path = MODULES_DIR .. "core/ext/timeExt/",
			head = "timeExt.lua",	
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
		config = {
			path = MODULES_DIR .. "customCommands/config/",
			files = {},
		},
		data = {
			path = MODULES_DIR .. "customCommands/data/",
			head = "init.lua",	
		},	
	},
}