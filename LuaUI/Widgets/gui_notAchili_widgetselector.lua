function widget:GetInfo()
  return {
    name      = "1944 notAchili Widget Selector", --needs epic menu to dynamically update widget checkbox colors.
    desc      = "v1.0 notAchili Widget Selector", 
    author    = "CarRepairer",
    date      = "2012-01-11",
    license   = "GNU GPL, v2 or later",
    layer     = -100000,
    handler   = true,
    experimental = false,	
    enabled   = true,
	alwaysStart = true,
  }
end

function MakeWidgetList() end
function KillWidgetList() end
local window_widgetlist

options_path = 'Settings/Misc'
options =
{
	widgetlist = {
		name = 'Widget List',
		type = 'button',
		hotkey = {key='f11', mod=''},
		advanced = true,
		OnChange = function(self)
			if window_widgetlist then
				KillWidgetList()
			elseif not window_widgetlist then
				MakeWidgetList()
			end
		end
	}
}


--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

local echo = Spring.Echo

--------------------------------------------------------------------------------

-- Config file data
local VFSMODE      = VFS.RAW_FIRST

--------------------------------------------------------------------------------

local SS44_UI_DIRNAME = "modules/notAchili/ss44UI/"
local file = SS44_UI_DIRNAME .. "config/epicmenu_conf.lua"
local confdata = VFS.Include(file, nil, VFSMODE)
local color = confdata.color


-- NotAchili control classes
local NotAchili
local Button
local Label
local Colorbars
local Checkbox
local Window
local ScrollPanel
local StackPanel
local LayoutPanel
local Grid
local Trackbar
local TextBox
local Image
local Progressbar
local Colorbars
local screen0

--------------------------------------------------------------------------------
-- Global notAchili controls


local widget_categorize = true

--------------------------------------------------------------------------------
-- Misc
local B_HEIGHT = 26
local C_HEIGHT = 16

local scrH, scrW = 0,0

local window_w
local window_h
local window_x
local window_y


--------------------------------------------------------------------------------
--For widget list
local widget_checks = {}
local green = {0,1,0,1}
local orange =  {1,0.5,0,1}
local gray =  {0.7,0.7,0.7,1}
local groupDescs = {
	api     = "For Developers",
	camera  = "Camera",
	cmd     = "Commands",
	dbg     = "For Developers",
	gfx     = "Effects",
	gui     = "GUI",
	hook    = "Commands",
	ico     = "GUI",
	init    = "Initialization",
	map		= "Map",
	minimap = "Minimap",
	mission	= "Mission",
	snd     = "Sound",
	test    = "For Developers",
	unit    = "Units",
	ungrouped    = "Ungrouped",
}
----------------------------------------------------------------
--May not be needed with new notAchili functionality
local function AdjustWindow(window)
	local nx
	if (0 > window.x) then
		nx = 0
	elseif (window.x + window.width > screen0.width) then
		nx = screen0.width - window.width
	end

	local ny
	if (0 > window.y) then
		ny = 0
	elseif (window.y + window.height > screen0.height) then
		ny = screen0.height - window.height
	end

	if (nx or ny) then
		window:SetPos(nx,ny)
	end
end

-- Adding functions because of "handler=true"
local function AddAction(cmd, func, data, types)
	return widgetHandler.actionHandler:AddAction(widget, cmd, func, data, types)
end
local function RemoveAction(cmd, types)
	return widgetHandler.actionHandler:RemoveAction(widget, cmd, types)
end


-- returns whether widget is enabled
local function WidgetEnabled(wname)
	local order = widgetHandler.orderList[wname]
	return order and (order > 0)
end
			




-- Update colors for labels of widget checkboxes in widgetlist window
local function checkWidget(widget)
	local name = (type(widget) == 'string') and widget or widget.whInfo.name
	
	local wcheck = widget_checks[name]
	if wcheck then
		local wdata = widgetHandler.knownWidgets[name]
		local hilite_color = (wdata.active and green) or (WidgetEnabled(name) and orange) or gray
		wcheck.font:SetColor(hilite_color)
	end
end
WG.cws_checkWidget = function(widget)
	checkWidget(widget)
end

-- Kill Widgetlist window
KillWidgetList = function()
	if window_widgetlist then
		window_x = window_widgetlist.x
		window_y = window_widgetlist.y
		
		window_h = window_widgetlist.clientHeight
		window_w = window_widgetlist.clientWidth
		
	end
	window_widgetlist:Dispose()
	window_widgetlist = nil
end

-- Make widgetlist window
MakeWidgetList = function()

	widget_checks = {}

	if window_widgetlist then
		window_widgetlist:Dispose()
	end

	local widget_children = {}
	local widgets_cats = {}
	
	
	local buttonWidth = window_w - 20
	
	for name,data in pairs(widgetHandler.knownWidgets) do if not data.alwaysStart then 
		local name = name
		local name_display = name .. (data.fromZip and ' (mod)' or '')
		local data = data
		local _, _, category = string.find(data.basename, "([^_]*)")
		
		if not groupDescs[category] then
			category = 'ungrouped'
		end
		local catdesc = groupDescs[category]
		if not widget_categorize then
			catdesc = 'Ungrouped'
		end
		widgets_cats[catdesc] = widgets_cats[catdesc] or {}
			
		widgets_cats[catdesc][#(widgets_cats[catdesc])+1] = 
		{	
			catname 		= catdesc,
			name_display	= name_display,
			name		 	= name,
			active 			= data.active,
			desc 			= data.desc,
			author 			= data.author,
		}
	end 
	end 
	
	local widgets_cats_i = {}
	for catdesc, catwidgets in pairs(widgets_cats) do
		widgets_cats_i[#widgets_cats_i + 1] = {catdesc, catwidgets}
	end
	
	--Sort widget categories
	table.sort(widgets_cats_i, function(t1,t2)
		return t1[1] < t2[1]
	end)
	
	for _, data in pairs(widgets_cats_i) do
		local catdesc = data[1]
		local catwidgets = data[2]
	
		--Sort widget names within this category
		table.sort(catwidgets, function(t1,t2)
			return t1.name_display < t2.name_display
		end)
		widget_children[#widget_children + 1] = 
			Label:New{ caption = '- '.. catdesc ..' -', textColor = color.sub_header, align='center', }
		
		for _, wdata in ipairs(catwidgets) do
			local enabled = WidgetEnabled(wdata.name)
			
			--Add checkbox to table that is used to update checkbox label colors when widget becomes active/inactive
			widget_checks[wdata.name] = Checkbox:New{ 
					caption = wdata.name_display, 
					checked = enabled,
					tooltip = '(By ' .. tostring(wdata.author) .. ")\n" .. tostring(wdata.desc),
					boxsize = 20,
					OnChange = { 
						function(self) 
							widgetHandler:ToggleWidget(wdata.name)
						end,
					},
				}
			widget_children[#widget_children + 1] = widget_checks[wdata.name]
			checkWidget(wdata.name) --sets color of label for this widget checkbox
		end
	end
	
	window_widgetlist = Window:New{
		x = window_x,
		y = window_y,
		clientWidth  = window_w,
		clientHeight = window_h,
		parent = screen0,
		backgroundColor = color.sub_bg,
		caption = 'Widget List (F11)',
		minWidth = 300,
		minHeight = 400,
		
		children = {
			ScrollPanel:New{
				x=1,
				y=15,
				right=5, 
				bottom = C_HEIGHT*2,
				
				children = {
					StackPanel:New{
						x=1,
						y=1,
						height = #widget_children*C_HEIGHT,
						right = 1,
						
						itemPadding = {1,1,1,1},
						itemMargin = {0,0,0,0},		
						children = widget_children,
					},
				},
			},
			
			--Close button
			Button:New{ 
				caption = 'Close', 
				OnMouseUp = { KillWidgetList }, 
				backgroundColor=color.sub_close_bg, 
				textColor=color.sub_close_fg, 
				
				x=1,
				bottom=1,
				width='40%',
				height=C_HEIGHT,
				styleKey = "buttonResizable",
			},
			--Categorization checkbox
			Checkbox:New{ 
				caption = 'Categorize', 
				tooltip = 'List widgets by category',
				OnMouseUp = { function() widget_categorize = not widget_categorize end, KillWidgetList, MakeWidgetList }, 
				textColor=color.sub_fg, 
				checked = widget_categorize,
				x = '50%',
				width = '40%',
				boxsize = 20,
				height= C_HEIGHT,
				bottom=1,
			},

		},
	}
	AdjustWindow(window_widgetlist)
end


function widget:Initialize()
	if (not WG.NotAchili) then
		widgetHandler:RemoveWidget(widget)
		return
	end
	-- setup NotAchili
	NotAchili = WG.NotAchili
	Button = NotAchili.Button
	Label = NotAchili.Label
	Colorbars = NotAchili.Colorbars
	Checkbox = NotAchili.Checkbox
	Window = NotAchili.Window
	ScrollPanel = NotAchili.ScrollPanel
	StackPanel = NotAchili.StackPanel
	LayoutPanel = NotAchili.LayoutPanel
	Grid = NotAchili.Grid
	Trackbar = NotAchili.Trackbar
	TextBox = NotAchili.TextBox
	Image = NotAchili.Image
	Progressbar = NotAchili.Progressbar
	Colorbars = NotAchili.Colorbars
	screen0 = NotAchili.Screen0
	
	widget:ViewResize(Spring.GetViewGeometry())
	window_w = 200
	window_h = 300
	window_x = (scrW - window_w)/2
	window_y = (scrH - window_h)/2
	
	Spring.SendCommands({
		"unbindkeyset f11"
	})
	
end

function widget:ViewResize(vsx, vsy)
	scrW = vsx
	scrH = vsy
end


function widget:Shutdown()
	  -- restore key binds
  Spring.SendCommands({
    "bind f11  luaui selector"
  })
end
