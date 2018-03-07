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

local MAP_HEIGHT_RATIO = 0.12

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

local oldUIWidgets = {
	"1944 Tooltip Replacement" -- in both lists, reset
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
			
	local mapX = math.floor(Game.mapSizeX / 512)
	local mapZ = math.floor(Game.mapSizeZ / 512)
	local x, z = Spring.GetScreenGeometry()
	local height = x * MAP_HEIGHT_RATIO
	Spring.SendCommands{"minimap geometry 2 2 " .. math.floor(mapZ / height) .. " " .. height }
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