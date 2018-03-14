function widget:GetInfo()
	return {
		name = "1944 Enable/Disable Old UI",
		desc = "Smooth enable of legacy UI by turning ON, revert by disabling",
		author = "PepeAmpere",
		date = "2018-03-06",
		license = "MIT",
		layer = 0,
		enabled = false, -- not loaded by default
	}
end

-- syntax + defaults from https://github.com/spring/spring/blob/104.0/doc/uikeys.txt
-- complex syntax: https://springrts.com/wiki/Uikeys.txt

local MAP_HEIGHT_RATIO = 0.12

local defaultKeyBinds = {
	"bind Ctrl+f1 viewfps",
	"bind Ctrl+f2 viewta",
	"bind Ctrl+f3 viewtw",
	"bind Ctrl+f4 viewrot",
	"bind Any+f1 showElevation",
	"bind Any+f2 ShowPathTraversability",
	"bind Any+f3 LastMsgPos",
	"bind Any+f4 ShowMetalMap",
	"bind Any+f5 hideinterface",
	"bind Any+f6 NoSound",
	"bind Shift+esc quitmenu",
	"bind Any+0xa7 drawinmap",
	"bind Any+; drawinmap", -- alternative for non-english keyboards
}

-- new UI
local newUIWidgets = {
	"1944 notAchili Cursor Tip 3",
	"1944 notAchili Vote Display",
	"1944 notAchili ss44 UI",
	"1944 notAchili Epic menu",
	"1944 notAchili Minimap",
	"1944 notAchili Widget Selector",
	"notAchili Framework",
	"1944 Tooltip Replacement", -- in both lists, reset
}

-- old UI
local oldUIWidgets = {
	"1944 Tooltip Replacement", -- in both lists, reset
	"1944 Resource Bars",
	"Chili Pro Console2",
	"Simple player list",
}

local oldUIunbinds = {
	"unbindkeyset f1",
	"unbindkeyset f2",
	"unbindkeyset f3",
	"unbindkeyset f4",	
	"unbindkeyset f5",
	"unbindkeyset Shift+esc",
	"unbindkeyset Any+0xa7",
}

function DisableNewUI()
	for i = 1, #newUIWidgets do
		local widgetName = newUIWidgets[i]
		
		Spring.SendCommands{
			"luaui disablewidget " .. widgetName,
		}
	end
	
	for i = 1, #oldUIWidgets do
		local widgetName = oldUIWidgets[i]
		
		Spring.SendCommands{
			"luaui enablewidget " .. widgetName,
		}
	end
	
	-- map reset
	local mapX = math.floor(Game.mapSizeX / 512)
	local mapZ = math.floor(Game.mapSizeZ / 512)
	local x, z = Spring.GetScreenGeometry()
	local height = x * MAP_HEIGHT_RATIO
	Spring.SendCommands{"minimap geometry 2 2 " .. math.floor(mapZ / height) .. " " .. height }
	
	-- unbind
	for i = 1, #oldUIunbinds do
		Spring.SendCommands{oldUIunbinds[i]}
	end
	
	-- default key binds reset
	for i = 1, #defaultKeyBinds do
		Spring.SendCommands{defaultKeyBinds[i]}
	end
end

function EnableNewUI()
	for i = #oldUIWidgets, 1, -1 do
		local widgetName = oldUIWidgets[i]
		
		Spring.SendCommands{
			"luaui disablewidget " .. widgetName,
		}
	end

	for i = #newUIWidgets, 1, -1 do
		local widgetName = newUIWidgets[i]
		
		Spring.SendCommands{
			"luaui enablewidget " .. widgetName,
		}
	end
end

function widget:Initialize()
	DisableNewUI()
end

function widget:Shutdown()
	EnableNewUI()
end