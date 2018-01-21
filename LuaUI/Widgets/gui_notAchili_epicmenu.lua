function widget:GetInfo()
  return {
    name      = "EPIC Menu",
    desc      = "v1.302 Extremely Powerful Ingame NotAchili Menu.",
    author    = "CarRepairer",
    date      = "2009-06-02",
    license   = "GNU GPL, v2 or later",
    layer     = -100001, -- smaller layer, loaded first
    handler   = true,
    experimental = false,	
    enabled   = true,
	alwaysStart = true,
  }
end

----------------------------------------------------------------------------------------------------
-- Config file data
----------------------------------------------------------------------------------------------------
local confdata		= include( "Widgets/notAchili/ss44UI/config/epicmenu_conf.lua" )

local epic_options	= confdata.eopt
local epic_colors	= confdata.color
local title_text	= confdata.title
local title_image	= confdata.title_image
----------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------
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
----------------------------------------------------------------------------------------------------
--                                        Local constants                                         --
----------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------
--                                        Local variables                                         --
----------------------------------------------------------------------------------------------------
-- Global notAchili controls
local window_crude
--local window_exit
--local window_flags
local window_help
local window_getkey
local window_sub_cur
--local lbl_gtime, lbl_fps, lbl_clock, img_flag
local mainWindowWidget
local pauseButton
local ingameTimeWidget
local confirmWidget

-- Controls size
local globalSize = 2.5

local buttonW, buttonH = 52 * globalSize, 10 * globalSize

local mainMenuWidth  = 90 * globalSize

local mainCrudeWidth = 296 * globalSize
local mainCrudeHeight = buttonH + 6 * globalSize

local mainW, mainH = 80 * globalSize,  14 * globalSize
local menuW, menuH = 100 * globalSize, 120 * globalSize

local confirmW, confirmH = menuW, 100 * globalSize

local fontSize = 4.8 * globalSize

-- Misc
local scrH, scrW = 0,0

local curSubKey = ''
local curPath = ''

local init = false
local myCountry = 'wut'

local pathOptions = {}	
local alloptions = {}	
local pathOrders = {}

--local exitWindowVisible = false

----------------------------------------------------------------------------------------------------
--                                      Function declarations                                     --
----------------------------------------------------------------------------------------------------
local function MakeSubWindow( key ) end


local function CreateMenuWindow() end

local function ShowMenuWindow() end
local function HideMenuWindow() end

local function ConfirmExitGameAction() end
local function ConfirmResignAction() end

local function ShowConfirmWidget( title, description, action ) end
local function HideConfirmWindow() end
local function IsVisibleConfirmWidget() end

local function CreateVerticalSeparator( size ) end
local function CenterWidgetInParent( widget ) end

local function ToCamelStyle( str ) end
local function GetIndex( t, v ) end

local function GetFullKey( option ) end
local function GetActionName( option ) end

----------------------------------------------------------------------------------------------------
local SpGetConfigInt = Spring.GetConfigInt
local SpSendCommands = Spring.SendCommands
local min = math.min
local max = math.max

local echo = Spring.Echo

include( "Widgets/notAchili/ss44UI/tools.lua" )
local GetTimeString		= TOOLS.GetTimeString
local BoolToInt			= TOOLS.BoolToInt
local IntToBool			= TOOLS.IntToBool
local SplitStringToArray= TOOLS.SplitStringToArray
local DeepCopyArray		= TOOLS.DeepCopyArray

----------------------------------------------------------------------------------------------------
-- Key bindings
include("keysym.h.lua")
local keysyms = {}
for k, v in pairs( KEYSYMS ) do
	keysyms[ '' .. v ] = k	
end

local get_key = false
local kb_option
local kb_path

local transkey = {
	leftbracket 	= '[',
	rightbracket 	= ']',
	--delete 			= 'del',
	comma 			= ',',
	period 			= '.',
	slash 			= '/',
	backslash 			= '\\',
	
	kp_multiply		= 'numpad*',
	kp_divide		= 'numpad/',
	kp_add			= 'numpad+',
	kp_subract		= 'numpad-',
	kp_period		= 'numpad.',
	
	kp0				= 'numpad0',
	kp1				= 'numpad1',
	kp2				= 'numpad2',
	kp3				= 'numpad3',
	kp4				= 'numpad4',
	kp5				= 'numpad5',
	kp6				= 'numpad6',
	kp7				= 'numpad7',
	kp8				= 'numpad8',
	kp9				= 'numpad9',
}
----------------------------------------------------------------------------------------------------
-- Widget globals
WG.crude = {}
--[[
if not WG.Layout then
	WG.Layout = {}
end

WG.GetWidgetOption = function( wname, path, key )  -- still fails if path and key are un-concatenatable
	return ( pathOptions and path and key and wname 
				and pathOptions[ path ] and pathOptions[ path ][ wname..key ] )
			or {}
end
--]]

----------------------------------------------------------------------------------------------------
-- Used in Configs\epicmenu_conf.lua
----------------------------------------------------------------------------------------------------
WG.crude.SetSkin = function( Skin )
	if NotAchili then
		NotAchili.theme.skin.general.skinName = Skin
	end
end

----------------------------------------------------------------------------------------------------
--Reset custom widget settings, defined in Initialize
WG.crude.ResetSettings 	= function() end

----------------------------------------------------------------------------------------------------
--Reset hotkeys, defined in Initialized
WG.crude.ResetKeys 		= function() end

WG.crude.OpenPath = function( path )
	MakeSubWindow( path )
end

----------------------------------------------------------------------------------------------------
-- Luaui config settings
local settings = {
	versionmin = 50,
	lang = 'en',
	widgets = {},
	show_crudemenu = true,
	music_volume = 0.5,
}
----------------------------------------------------------------------------------------------------


----------------------------------------------------------------------------------------------------
-- These functions for creating and removing custom actions, that can be binded to hotkey later or
-- called via console
----------------------------------------------------------------------------------------------------
local function AddAction( cmd, func, data, types )
	return widgetHandler.actionHandler:AddAction( widget, cmd, func, data, types )
end

local function RemoveAction( cmd, types )
	return widgetHandler.actionHandler:RemoveAction( widget, cmd, types )
end
----------------------------------------------------------------------------------------------------
			
----------------------------------------------------------------------------------------------------
-- Kill submenu window
local function KillSubWindow()
	if window_sub_cur then
		if window_sub_cur then
			settings.sub_pos_x = window_sub_cur.x
			settings.sub_pos_y = window_sub_cur.y
		end
		window_sub_cur:Dispose()
		window_sub_cur = nil
		curPath = ''
	end
end

----------------------------------------------------------------------------------------------------
--Make help text window
local function MakeHelp( caption, text )
	local window_height = 400
	local window_width = 400
	
	window_help = Window:New{
		caption = caption or 'Help?',
		x = settings.sub_pos_x,  
		y = settings.sub_pos_y,  
		clientWidth  = window_width,
		clientHeight = window_height,
		parent = screen0,
		backgroundColor = epic_colors.sub_bg,
		children = {
			ScrollPanel:New{
				x=0,y=15,
				right=5,
				bottom=buttonH,
				height = window_height - buttonH*3 ,
				children = {
					TextBox:New{ x=0,y=10, text = text, textColor = epic_colors.sub_fg, width  = window_width - 40, }
				}
			},
			--Close button
			Button:New{ 
				caption = 'Close',
				OnMouseUp = { function(self) 
					self.parent:Dispose() 
				end },
				x=10, bottom=1, right=50, height=buttonH,
				backgroundColor = epic_colors.sub_close_bg,
				textColor = epic_colors.sub_close_fg,
			},
		}
	}
end

----------------------------------------------------------------------------------------------------
local function HotkeyFromUikey( uikey_hotkey )
	local uikey_table = SplitStringToArray( '+', uikey_hotkey )
	local alt, ctrl, meta, shift

	for i = 1, #uikey_table do
		local str2 = uikey_table[i]:lower()
		if str2 == 'alt' 		then alt = true
		elseif str2 == 'ctrl' 	then ctrl = true
		elseif str2 == 'shift' 	then shift = true
		elseif str2 == 'meta' 	then meta = true
		end
	end
	
	local modstring = '' ..
		( alt	and 'A+' or '' ) ..
		( ctrl	and 'C+' or '' ) ..
		( meta	and 'M+' or '' ) ..
		( shift	and 'S+' or '' )
	return {
		key = uikey_table[ #uikey_table ],
		mod = modstring,
	}
end

local function GetReadableHotkeyMod( mod )
	return (mod:lower():find('a+') and 'Alt+' or '') ..
		(mod:lower():find('c+') and 'Ctrl+' or '') ..
		(mod:lower():find('m+') and 'Meta+' or '') ..
		(mod:lower():find('s+') and 'Shift+' or '') ..
		''		
end


-- Assign a keybinding to settings and other tables that keep track of related info
--local function AssignKeyBind(hotkey, menukey, itemindex, item, verbose)
local function AssignKeyBind(hotkey, path, option, verbose) -- param4 = verbose

	if not (hotkey.key and hotkey.mod) then
		Spring.Log(widget:GetInfo().name, LOG.ERROR, '<EPIC Menu> Wacky assign keybind error #1')
		return
	end
	
	local kbfunc = option.OnChange
	
	if option.type == 'bool' then
		kbfunc = function()
			if not pathOptions[path] or not pathOptions[path][option.wname..option.key] then
				Spring.Echo("Warning, detected keybind mishap. Please report this info and help us fix it:")
				Spring.Echo("Option path is "..path)
				Spring.Echo("Option name is "..option.wname..option.key)
				if pathOptions[path] then --pathOptions[path] table still intact, but option table missing
					Spring.Echo("case: option table was missing")
					pathOptions[path][option.wname..option.key] = option --re-add option table
				else --both option table & pathOptions[path] was missing, probably was never initialized
					Spring.Echo("case: whole path was never initialized")
					pathOptions[path] = {}
					pathOptions[path][option.wname..option.key] = option
				end
				-- [f=0088425] Error: LuaUI::RunCallIn: error = 2, ConfigureLayout, [string "LuaUI/Widgets/gui_epicmenu.lua"]:583: attempt to index field '?' (a nil value)
			end
			local wname = option.wname
			newValue = not pathOptions[path][option.wname..option.key].value	
			pathOptions[path][option.wname..option.key].value	= newValue
			-- [f=0088425] Error: LuaUI::RunCallIn: error = 2, ConfigureLayout, [string "LuaUI/Widgets/gui_epicmenu.lua"]:583: attempt to index field '?' (a nil value)
			
			option.OnChange({checked=newValue})
			
			if path == curPath then
				MakeSubWindow(path)
			end
		end
	end
	
	local actionName = GetActionName( option)
	
	if verbose then
		local actions = Spring.GetKeyBindings(hotkey.mod .. hotkey.key)
		if (actions and #actions > 0) then
			echo( 'Warning: There are other actions bound to this hotkey combo (' .. GetReadableHotkeyMod(hotkey.mod) .. hotkey.key .. '):' )
			for i=1, #actions do
				for actionCmd, actionExtra in pairs(actions[i]) do
					echo ('  - ' .. actionCmd .. ' ' .. actionExtra)
				end
			end
		end
		echo( 'Hotkey (' .. GetReadableHotkeyMod(hotkey.mod) .. hotkey.key .. ') bound to action: ' .. actionName )
	end
	
	--actionName = actionName:lower()
	settings.keybounditems[actionName] = hotkey
	AddAction(actionName, kbfunc, nil, "t")
	Spring.SendCommands( "bind " .. hotkey.mod .. hotkey.key .. " " .. actionName )
end

local function GetUikeyHotkeyStr(action)
	local uikey_hotkey_strs = Spring.GetActionHotKeys(action)
	if uikey_hotkey_strs and uikey_hotkey_strs[1] then
		return (uikey_hotkey_strs[1])
	end
	return false
end

-- Unsssign a keybinding from settings and other tables that keep track of related info
local function UnassignKeyBind(path, option)
	
	local actionName = GetActionName( option )
	
	if option.action then --if keybindings was hardcoded by widget:
		local uikey_hotkey_str = GetUikeyHotkeyStr(actionName)
		if uikey_hotkey_str then
			-- unbindaction doesn't work on a command+params, must be command only!
			local actionName_split = SplitStringToArray(' ', actionName)
			local actionName_cmd = actionName_split[1]
			--echo('unassign', "unbind " .. uikey_hotkey_str .. ' ' .. actionName_cmd)
			Spring.SendCommands("unbind " .. uikey_hotkey_str .. ' ' .. actionName_cmd) 
		end
	else --if keybindings were supplied by users:
		--echo('unassign', "unbindaction " .. actionName)
		Spring.SendCommands("unbindaction " .. actionName:lower()) -- this only works if lowercased, even if /keyprint says otherwise!
	end
	
	settings.keybounditems[actionName] = 'none'
end

----------------------------------------------------------------------------------------------------
-- BUILD CUSTOM WIDGET OPTIONS
----------------------------------------------------------------------------------------------------
local function AddOption( path, option, wname )
--echo(path, wname, option)

	if not wname then
		wname = path
	end

	if not option then
		if not pathOptions[ path ] then
			pathOptions[ path ] = {}
			pathOrders[ path ] = {}
		end
		local pathexploded = SplitStringToArray( '/', path )
		local pathend = pathexploded[ #pathexploded ]
		pathexploded[ #pathexploded ] = nil
		
		local path2 = path
		path = table.concat( pathexploded, '/' )
		
		option = {
			type = 'button',
			name = pathend .. '...',
			OnChange = function( self )
				MakeSubWindow( path2 )
			end,
			desc = path2,
		}
	end
	
	if not pathOptions[ path ] then
		AddOption( path )
	end
	
	if not option.key then
		option.key = option.name
	end
	option.wname = wname
	
	local curkey = path .. '_' .. option.key
	local fullkey = GetFullKey( option )
	fullkey = fullkey:gsub( ' ', '_' )
	
	--get spring config setting
	local valuechanged = false
	local newValue
	if option.springsetting ~= nil then --nil check as it can be false but maybe not if springconfig only assumes numbers
		newValue = Spring.GetConfigInt( option.springsetting, 0 )
		if option.type == 'bool' then
			newValue = IntToBool(newValue)
		end
	else
		--load option from widget settings
		if settings.config[ fullkey ] ~= nil then --nil check as it can be false
			newValue = settings.config[ fullkey ]
		end
	end
	
	if option.default == nil then
		if option.value ~= nil then
			option.default = option.value
		else
			option.default = newValue
		end	
	end
	
	if newValue ~= nil and option.value ~= newValue then --must nilcheck newValue
		valuechanged = true
		option.value = newValue
	end
	
	
	
	local origOnChange = option.OnChange or function() end
	
	local controlfunc
	if option.type == 'button' then
		controlfunc = 
			function( self )
				if option.action then --if keybindings supplied by widgets
					Spring.SendCommands{ option.action }
				end
			end
	elseif option.type == 'bool' then
		
		controlfunc = 
			function(self)
				if self then
					option.value = self.checked
				end
				if option.springsetting then --if widget supplies option for springsettings
					Spring.SetConfigInt( option.springsetting, BoolToInt(option.value) )
				end
				settings.config[fullkey] = option.value
			end
	elseif option.type == 'number' then
		if option.valuelist then
			option.min 	= 1
			option.max 	= #(option.valuelist)
			option.step	= 1
		end
						
		controlfunc = 
			function(self) 
				if self then
					if option.valuelist then
						option.value = option.valuelist[self.value]
					else
						option.value = self.value
					end
				end
				
				if option.springsetting then
					if not option.value then
						echo ('<EPIC Menu> Error #444', fullkey)
					else
						Spring.SetConfigInt( option.springsetting, option.value )
					end
				end
				settings.config[fullkey] = option.value
			end
	
	elseif option.type == 'colors' then
		controlfunc = 
			function(self) 
				if self then
					option.value = self.color
				end
				settings.config[fullkey] = option.value
			end
	
	elseif option.type == 'list' then
		controlfunc = 
			function(key)
				option.value = key
				settings.config[fullkey] = option.value
			end
	
	end
	option.OnChange = function(self)
		controlfunc( self )
		origOnChange( option )
	end
	
	--call onchange once
	if valuechanged 
		and option.type ~= 'button'
		and origOnChange ~= nil
		--and not option.springsetting --need a different solution
	then 
		origOnChange( option )
	end
	
	--Keybindings
	if option.type == 'button' or option.type == 'bool' then
		local actionName = GetActionName( option )
		
		local uikey_hotkey_str = GetUikeyHotkeyStr(actionName)
		local uikey_hotkey = uikey_hotkey_str and HotkeyFromUikey(uikey_hotkey_str)
		
		if option.hotkey then
		  local orig_hotkey = {}
		  DeepCopyArray( orig_hotkey, option.hotkey )
		  option.orig_hotkey = orig_hotkey
		  --echo( option.key, option.orig_hotkey.key )
		end
		
		local hotkey = settings.keybounditems[actionName] or option.hotkey or uikey_hotkey
		if hotkey and hotkey ~= 'none' then
			if uikey_hotkey then
				UnassignKeyBind( path, option )
			end
			AssignKeyBind( hotkey, path, option, false )
		end 
	end
	
	pathOptions[path][wname..option.key] = option
	alloptions[path..wname..option.key] = option
	local temp = #(pathOrders[path])
	pathOrders[path][temp+1] = wname..option.key	
end

local function RemOption(path, option, wname )
	if not pathOrders[path] then
		--this occurs when a widget unloads itself inside :init
		--echo ('<epic menu> error #333 ', wname, path)
		--echo ('<epic menu> ...error #333 ', (option and option.key) )
		return
	end
	for i=1, #pathOrders[path] do
		if pathOrders[path][i] == (wname..option.key) then
			table.remove(pathOrders[path], i)
		end
	end
	pathOptions[path][wname..option.key] = nil
	alloptions[path..wname..option.key] = nil
end
----------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------
-- WIDGET INTEGRATION
-- sets key and wname for each option so that GetOptionHotkey can work before widget initialization completes
----------------------------------------------------------------------------------------------------
local function PreIntegrateWidget(w)
	
	local options = w.options
	if type(options) ~= 'table' then
		return
	end
	
	local wname = w.whInfo.name
	local defaultpath = w.options_path or ('Settings/Misc/' .. wname)
	
	if w.options.order then
		echo ("<EPIC Menu> " .. wname ..  ", don't index an option with the word 'order' please, it's too soon and I'm not ready.")
		w.options.order = nil
	end
	
	--Generate order table if it doesn't exist
	if not w.options_order then
		w.options_order = {}
		for k,v in pairs(options) do
			w.options_order[#(w.options_order) + 1] = k
		end
	end
	

	for i=1, #w.options_order do
		local k = w.options_order[i]
		local option = options[k]
		if not option then
			Spring.Log(widget:GetInfo().name, LOG.ERROR,  '<EPIC Menu> Error in loading custom widget settings in ' .. wname .. ', order table incorrect.' )
			return
		end
		
	
		option.key = k
		option.wname = wname
	end
end


--(Un)Store custom widget settings for a widget
local function IntegrateWidget(w, addoptions, index)
	
	local options = w.options
	if type(options) ~= 'table' then
		return
	end
	
	local wname = w.whInfo.name
	local defaultpath = w.options_path or ('Settings/Misc/' .. wname)
	
	
	--[[
	--If a widget disables itself in widget:Initialize it will run the removewidget before the insertwidget is complete. this fix doesn't work
	if not WidgetEnabled(wname) then
		return
	end
	--]]
	
	if w.options.order then
		echo ("<EPIC Menu> " .. wname ..  ", don't index an option with the word 'order' please, it's too soon and I'm not ready.")
		w.options.order = nil
	end
	
	--Generate order table if it doesn't exist
	if not w.options_order then
		w.options_order = {}
		for k,v in pairs(options) do
			w.options_order[#(w.options_order) + 1] = k
		end
	end
	
	
	for i=1, #w.options_order do
		local k = w.options_order[i]
		local option = options[k]
		if not option then
			Spring.Log(widget:GetInfo().name, LOG.ERROR,  '<EPIC Menu> Error in loading custom widget settings in ' .. wname .. ', order table incorrect.' )
			return
		end
		
		--Add empty onchange function if doesn't exist
		if not option.OnChange or type(option.OnChange) ~= 'function' then
			w.options[k].OnChange = function(self) end
		end
		
		--store default
		w.options[k].default = w.options[k].value
		
		
		option.key = k
		option.wname = wname
		
		local origOnChange = w.options[k].OnChange
		
		if option.type ~= 'button' then
			option.OnChange = 
				function( self )
					if self then
						w.options[k].value = self.value
					end
					origOnChange( self )
				end
		else
			option.OnChange = 
				function( self )
					origOnChange( self )
				end
		end
		
		local path = option.path or defaultpath
		
		
		-- [[
		local value = w.options[k].value
		w.options[k].value = nil
		w.options[k].priv_value = value
		
		
		--setmetatable( w.options[k], temp )
		--local temp = w.options[k]
		--w.options[k] = {}
		w.options[k].__index = function(t, key)
			if key == 'value' then
				if(
					not wname:find('NotAchili Chat')
					) then
					--echo ('get val', wname, k, key, t.priv_value)
				end
				--return t.priv_value
				return t.priv_value
			end
		end
		
		w.options[k].__newindex = function(t, key, val)
			-- For some reason this is called twice per click with the same parameters for most options
			-- a few rare options have val = nil for their second call which resets the option.
			
			if key == 'value' then
				if val ~= nil then -- maybe this isn't needed
				  --echo ('set val', wname, k, key, val)
				  t.priv_value = val
				  
				  local fullkey = GetFullKey( option )
				  fullkey = fullkey:gsub(' ', '_')
				  settings.config[fullkey] = option.value
				end
			else
			  rawset(t,key,val)
			end
			
		end
		
		setmetatable( w.options[k], w.options[k] )
		--]]
		if addoptions then
			AddOption(path, option, wname )
		else
			RemOption(path, option, wname )
		end
		
	end
	
	MakeSubWindow(curPath)
	
end

--Store custom widget settings for all active widgets
local function AddAllCustSettings()
	local cust_tree = {}
	for i=1,#widgetHandler.widgets do
		IntegrateWidget(widgetHandler.widgets[i], true, i)
	end
end

local function RemakeEpicMenu()
end
----------------------------------------------------------------------------------------------------

--[[
-- Spring's widget list
local function ShowWidgetList(self)
	SpSendCommands{"luaui selector"} 
end

-- Crudemenu's widget list
WG.crude.ShowWidgetList2 = function(self)
	MakeWidgetList()
end

WG.crude.ShowFlags = function()
	MakeFlags()
end
--]]

----------------------------------------------------------------------------------------------------
--Make little window to indicate user needs to hit a keycombo to save a keybinding
----------------------------------------------------------------------------------------------------
local function MakeKeybindWindow( path, option, hotkey ) 
	if hotkey then
		UnassignKeyBind(path, option)
	end
	
	local window_height = 80
	local window_width = 300
	
	get_key = true
	kb_mkey = menukey
	kb_mindex = i
	kb_item = item
	
	kb_option = option
	kb_path = path
		
	window_getkey = Window:New{
		caption = 'Set a HotKey',
		x = (scrW-window_width)/2,  
		y = (scrH-window_height)/2,  
		clientWidth  = window_width,
		clientHeight = window_height,
		parent = screen0,
		backgroundColor = epic_colors.sub_bg,
		resizable=false,
		draggable=false,
		children = {
			Label:New{ y=10, caption = 'Press a key combo', textColor = epic_colors.sub_fg, },
			Label:New{ y=30, caption = '(Hit "Escape" to clear keybinding)', textColor = epic_colors.sub_fg, },
		}
	}
end

WG.crude.GetHotkey = function(actionName)
	local hotkey = settings.keybounditems[actionName]
	if not hotkey or hotkey == 'none' then
	  return ''
	end
	return GetReadableHotkeyMod(hotkey.mod) .. ToCamelStyle(hotkey.key)
end

----------------------------------------------------------------------------------------------------
--Get hotkey action and readable hotkey string
local function GetHotkeyData(path, option)
	local actionName = GetActionName( option )
	local hotkey = settings.keybounditems[actionName]
	if hotkey and hotkey ~= 'none' then
		return hotkey, GetReadableHotkeyMod(hotkey.mod) .. ToCamelStyle( hotkey.key )
	end
	
	return nil, 'None'
end



--Make a stack with control and its hotkey button
local function MakeHotkeyedControl(control, path, option)

	local hotkey, hotkeystring = GetHotkeyData(path, option)
	local kbfunc = function() 
			if not get_key then
				MakeKeybindWindow( path, option, hotkey ) 
			end
		end

	local hklength = math.max( hotkeystring:len() * 10, 20)
	local control2 = control
	control.x = 0
	control.right = hklength+2
	control:DetectRelativeBounds()
	
	local hkbutton = Button:New{
		minHeight = 30,
		right=0,
		width = hklength,
		--x=-30,
		caption = hotkeystring, 
		OnMouseUp = { kbfunc },
		backgroundColor = epic_colors.sub_button_bg,
		textColor = epic_colors.sub_button_fg, 
		tooltip = 'Hotkey: ' .. hotkeystring,
		styleKey = "buttonResizable",
	}
	
	return StackPanel:New{
		width = "100%",
		orientation='horizontal',
		resizeItems = false,
		centerItems = false,
		autosize = true,
		itemMargin = {0,0,0,0},
		margin = {0,0,0,0},
		itemPadding = {2,0,0,0},
		padding = {0,0,0,0},
		children={
			control2,
			hkbutton
		},
	}
end
----------------------------------------------------------------------------------------------------

local function ResetWinSettings(path)
	for _,optionkey in ipairs(pathOrders[path]) do
		local option = pathOptions[path][optionkey]
		if option.default ~= nil then --fixme : need default
			if option.type == 'bool' or option.type == 'number' then
				option.value = option.valuelist and GetIndex(option.valuelist, option.default) or option.default
				option.checked = option.value
				option.OnChange(option)
			elseif option.type == 'list' then
				option.value = option.default
				option.OnChange(option.default)
			elseif option.type == 'colors' then
				option.color = option.default
				option.OnChange(option)
			end
		else
			Spring.Log(widget:GetInfo().name, LOG.ERROR, '<EPIC Menu> Error #627', option.name)
		end
	end
end

--[[ WIP
WG.crude.MakeHotkey = function(path, optionkey)
	local option = pathOptions[path][optionkey]
	local hotkey, hotkeystring = GetHotkeyData(path, option)
	if not get_key then
		MakeKeybindWindow( path, option, hotkey ) 
	end
	
end
--]]

----------------------------------------------------------------------------------------------------
-- Make submenu window based on index from flat window list
--local function MakeSubWindow(key)
----------------------------------------------------------------------------------------------------
MakeSubWindow = function(path)
	if not pathOptions[path] then return end
	
	local explodedpath = SplitStringToArray('/', path)
	explodedpath[#explodedpath] = nil
	local parent_path = table.concat(explodedpath,'/')
	
	local settings_height = #(pathOrders[path]) * buttonH
	local settings_width = 270
	
	local tree_children = {}
	local hotkeybuttons = {}
	
	for _,optionkey in ipairs(pathOrders[path]) do
		local option = pathOptions[path][optionkey]
		
		local optionkey = option.key
		
		--fixme: shouldn't be needed
		if not option.OnChange then
			option.OnChange = function( self )
			end
		end
		if not option.desc then
			option.desc = ''
		end
		
		
		if option.advanced and not settings.config['epic_Settings_Show_Advanced_Settings'] then
			--do nothing
		elseif option.type == 'button' then
			local hide = false
			
			if option.wname == 'epic' then --menu
				local menupath = option.desc
				if pathOrders[menupath] and #(pathOrders[menupath]) == 0 then
					hide = true
					settings_height = settings_height - buttonH
				end
			end
			
			if not hide then
				local button = Button:New{
					x=0,
					--right = 30,
					minHeight = 30,
					caption = option.name, 
					OnMouseUp = {option.OnChange},
					backgroundColor = epic_colors.sub_button_bg,
					textColor = epic_colors.sub_button_fg, 
					tooltip = option.desc,
					styleKey = "buttonResizable",
				}
				tree_children[#tree_children+1] = MakeHotkeyedControl(button, path, option)
			end
			
		elseif option.type == 'label' then	
			tree_children[#tree_children+1] = Label:New{
				caption = option.value or option.name,
				textColor = epic_colors.sub_header,
			}
			
		elseif option.type == 'text' then	
			tree_children[#tree_children+1] = 
				Button:New{
					width = "100%",
					minHeight = 30,
					caption = option.name, 
					OnMouseUp = { function() MakeHelp(option.name, option.value) end },
					backgroundColor = epic_colors.sub_button_bg,
					textColor = epic_colors.sub_button_fg, 
					tooltip=option.desc,
					styleKey = "buttonResizable",
				}
			
		elseif option.type == 'bool' then				
			local chbox = Checkbox:New{ 
				x=0,
				right = 35,
				caption = option.name, 
				checked = option.value or false, 
				
				OnMouseUp = { option.OnChange, }, 
				textColor = epic_colors.sub_fg, 
				tooltip   = option.desc,
			}
			tree_children[#tree_children+1] = MakeHotkeyedControl(chbox,  path, option)
			
		elseif option.type == 'number' then	
			settings_height = settings_height + buttonH
			tree_children[#tree_children+1] = Label:New{ caption = option.name, textColor = epic_colors.sub_fg, }
			if option.valuelist then
				option.value = GetIndex( option.valuelist, option.value )
			end
			tree_children[#tree_children+1] = 
				Trackbar:New{ 
					width = "100%",
					caption = option.name, 
					value = option.value, 
					trackColor = epic_colors.sub_fg, 
					min = option.min or 0, 
					max = option.max or 100, 
					step = option.step or 1, 
					OnMouseUp = { option.OnChange }, 
					tooltip=option.desc 
				}
			
			
		elseif option.type == 'list' then	
			tree_children[ #tree_children+1 ] = Label:New{
				caption = option.name, 
				textColor = epic_colors.sub_header,
			}

			for i=1, #option.items do
				local item = option.items[i]
				settings_height = settings_height + buttonH 
				tree_children[ #tree_children + 1 ] = Button:New{
					width = "100%",
					caption = item.name, 
					OnMouseUp = { function( self )
						option.OnChange( item.key ) 
					end },
					backgroundColor = epic_colors.sub_button_bg,
					textColor = epic_colors.sub_button_fg, 
					tooltip = item.desc,
					styleKey = "buttonResizable",
				}
			end
			
		elseif option.type == 'colors' then
			settings_height = settings_height + buttonH*2.5
			tree_children[#tree_children+1] = Label:New{ 
				caption = option.name, textColor = epic_colors.sub_fg,
			}

			tree_children[#tree_children+1] = Colorbars:New{
				width = "100%",
				height = buttonH*2,
				tooltip=option.desc,
				color = option.value or {1,1,1,1},
				OnMouseUp = { option.OnChange, },
			}
				
		end
	end
	
	local window_height = 400
	if settings_height < window_height then
		window_height = settings_height+10
	end
	local window_width = 300
	
		
	local window_children = {}
	window_children[#window_children+1] =
		ScrollPanel:New{
			x=0,y=15,
			bottom=buttonH+20,
			width = '100%',
			children = {
				StackPanel:New{
					x=0,
					y=0,
					right=0,
					orientation = "vertical",
					--width  = "100%",
					height = "100%",
					backgroundColor = epic_colors.sub_bg,
					children = tree_children,
					itemMargin = {2,2,2,2},
					resizeItems = false,
					centerItems = false,
					autosize = true,
				},
				
			}
		}
	
	window_height = window_height + buttonH
	local backButton 
	--back button
	if parent_path then
		window_children[#window_children+1] = Button:New{ 
			caption = 'Back', 
			OnMouseUp = { 
				KillSubWindow, 
				function() MakeSubWindow(parent_path) end,
			},
			backgroundColor = epic_colors.sub_back_bg,
			textColor = epic_colors.sub_back_fg,
			x=0, 
			bottom=1, 
			width='33%', 
			height=buttonH,
			styleKey = "buttonResizable",
		}
	end
	
	
	--reset button
	window_children[#window_children+1] = Button:New{
		caption = 'Reset', 
		OnMouseUp = { 
			function() ResetWinSettings(path); RemakeEpicMenu(); end 
		},
		textColor = epic_colors.sub_close_fg,
		backgroundColor = epic_colors.sub_close_bg,
		width='33%',
		x='33%',
		right='33%',
		bottom=1,
		height=buttonH,
		styleKey = "buttonResizable",
	}
	
	
	--close button
	window_children[ #window_children + 1 ] = Button:New{ 
		caption = 'Close', 
		OnMouseUp = { function() 
			KillSubWindow()
			ShowMenuWindow()
		end }, 
		textColor = epic_colors.sub_close_fg,
		backgroundColor = epic_colors.sub_close_bg,
		width='33%', x='66%', right=1, bottom=1,
		height=buttonH,
		styleKey = "buttonResizable",
	}
	
	
	
	KillSubWindow()
	
	curPath = path -- must be done after KillSubWindow
	
	window_sub_cur = Window:New{  
		caption=path,
		x = settings.sub_pos_x,  
		y = settings.sub_pos_y, 
		clientWidth = window_width,
		clientHeight = window_height+buttonH*4,
		minWidth = 250,
		minHeight = 350,		
		--resizable = false,
		parent = settings.show_crudemenu and screen0 or nil,
		backgroundColor = epic_colors.sub_bg,
		children = window_children,
	}
end
----------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------
-- Show or hide menubar
----------------------------------------------------------------------------------------------------
local function ShowHideCrudeMenu()
	WG.crude.visible = settings.show_crudemenu -- HACK set it to wg to signal to player list 
	if settings.show_crudemenu then
		if window_crude then
			screen0:AddChild(window_crude)
			--WG.chat.showConsole()
			window_crude:UpdateClientArea()
		end
		--[[
		if window_sub_cur then
			screen0:AddChild(window_sub_cur)
		end
		--]]
	else
		if window_crude then
			screen0:RemoveChild(window_crude)
			--WG.chat.hideConsole()
		end
		if window_sub_cur then
			screen0:RemoveChild(window_sub_cur)
		end
	end
end

----------------------------------------------------------------------------------------------------
-- Make menu bar in right top corner
----------------------------------------------------------------------------------------------------
--[[
local function MakeCrudeExitWindow()
	local exit_menu_width = 210
    local exit_menu_height = 280
    local exit_menu_btn_width = 7*exit_menu_width/8
    local exit_menu_btn_height = max(exit_menu_height/8, 30)
    local exit_menu_cancel_width = exit_menu_btn_width/2
    local exit_menu_cancel_height = 2*exit_menu_btn_height/3
	
	local screen_width,screen_height = Spring.GetWindowGeometry()


	window_exit = Window:New{
		name='exitwindow',
		x = screen_width/2 - exit_menu_width/2,  
		y = screen_height/2 - exit_menu_height/2,  
		dockable = false,
		clientWidth = exit_menu_width,
		clientHeight = exit_menu_height,
		draggable = false,
		tweakDraggable = true,
		resizable = false,
		minimizable = false,
		backgroundColor = epic_colors.main_bg,
		color = {1,1,1,0.5},
		margin = {0,0,0,0},
		padding = {0,0,0,0},
		
		children = {
				
			Label:New{ 
				caption = 'Would you like to quit?', 
				width = exit_menu_width,
                x = 0,
                y = 2*exit_menu_height/64,
				align="center",
				textColor = epic_colors.main_fg },
				
			Button:New{
                caption = "Resign and spectate",
                OnMouseUp = { function()
						SpSendCommands{"spectator"}
						screen0:RemoveChild(window_exit)
						exitWindowVisible = false
					end, }, 
				height=exit_menu_btn_height, 
				width=exit_menu_btn_width,
                x = exit_menu_width/2 - exit_menu_btn_width/2, 
                y = 24*exit_menu_height/64 - exit_menu_btn_height/2, 
			},
			
			
			Button:New{
				caption = "Exit game", OnMouseUp = { function() 
					if WG.SS44_UI and WG.SS44_UI.ShowExitScreen then
						WG.SS44_UI.ShowExitScreen()
					else
						Spring.SendCommands{ "quit", "quitforce" }
					end
				end, },
				height=exit_menu_btn_height, 
				width=exit_menu_btn_width,
                x = exit_menu_width/2 - exit_menu_btn_width/2,  
                y = 36*exit_menu_height/64 - exit_menu_btn_height/2,
			},
			
			Button:New{
				caption = "Cancel", 
				OnMouseUp = { function() 
						screen0:RemoveChild(window_exit) 
						exitWindowVisible = false
					end, }, 
			
				height = exit_menu_cancel_height, 
				width = exit_menu_cancel_width,
                x = 4*exit_menu_width/8, -- exit_menu_cancel_width,
                y = 58*exit_menu_height/64 - exit_menu_cancel_height/2,
			},
		},
	}
end
--]]

local function MakeMenuBar()

	--local btn_padding = { 4, 4, 4, 4 }
	--local btn_margin = { 0, 0, 0, 0 }
	
	--[[
	lbl_fps = Label:New{ name='lbl_fps', caption = 'FPS:', textColor = epic_colors.sub_header,  }
	lbl_gtime = Label:New{ name='lbl_gtime', caption = 'Time:', textColor = epic_colors.sub_header, align="center" }
	lbl_clock = Label:New{ name='lbl_clock', caption = 'Clock:', width = 35, height=5, textColor = epic_colors.main_fg, autosize=false, }
	img_flag = Image:New{ tooltip='Choose Your Location', file=":cn:".. LUAUI_DIRNAME .. "Images/flags/".. settings.country ..'.png', width = 16,height = 11, OnClick = { MakeFlags }, margin={4,4,4,4}  }
	--]]
			
	window_crude = Window:New{
		parent = screen0,
		name='epicmenubar',
		right = 0,  
		y = 0,
		--dockable = true,
		clientWidth = mainCrudeWidth,
		clientHeight = mainCrudeHeight,
		draggable = false,
		tweakDraggable = false,
		resizable = false,
		minimizable = false,
		backgroundColor = epic_colors.main_bg,
		color = {1,1,1,1},
		margin = {0,0,0,0},
		padding = {0,0,0,0},
		font = { size = fontSize },
	}
	
	do
		local panel = StackPanel:New{
			name = 'stack_main',
			orientation = 'horizontal',
			width = mainMenuWidth, right = 0,
			height = '100%',
			resizeItems = true,
			--centerItems = true,
			--autosize = true,
			padding = { 5, 5, 5, 6 },
			itemPadding = {1,1,1,1},
			itemMargin = {1,1,1,1},
			autoArrangeV = false,
			autoArrangeH = false,
			--[[
			children = {
				--GAME LOGO GOES HERE
				Image:New{ tooltip = title_text, file = title_image, height=buttonH, width=buttonH, },
				
				-- odd-number button width keeps image centered
				Button:New{
					caption = "", OnMouseUp = { function() MakeSubWindow('Game') end, }, textColor=epic_colors.game_fg, height=buttonH+4, width=buttonH+5,
					padding = btn_padding, margin = btn_margin,	tooltip = 'Game Actions and Settings...',
					children = {
						Image:New{file=LUAUI_DIRNAME .. 'Images/epicmenu/game.png', height=buttonH-2,width=buttonH-2},
					},
				},
				Button:New{
					caption = "", OnMouseUp = { function() MakeSubWindow('Settings') end, }, textColor=epic_colors.menu_fg, height=buttonH+4, width=buttonH+5,
					padding = btn_padding, margin = btn_margin,	tooltip = 'General Settings...', 
					children = {
						Image:New{ tooltip = 'Settings', file=LUAUI_DIRNAME .. 'Images/epicmenu/settings.png', height=buttonH-2,width=buttonH-2, },
					},
				},
				Button:New{
					caption = "", OnMouseUp = { function() SpSendCommands{"luaui tweakgui"} end, }, textColor=epic_colors.menu_fg, height=buttonH+4, width=buttonH+5, 
					padding = btn_padding, margin = btn_margin, tooltip = "Move and resize parts of the user interface (\255\0\255\0Ctrl+F11\008) (Hit ESC to exit)",
					children = {
						Image:New{ file=LUAUI_DIRNAME .. 'Images/epicmenu/move.png', height=buttonH-2,width=buttonH-2, },
					},
				},
				
				Grid:New{
					height = '100%',
					width = 100,
					columns = 2,
					rows = 2,
					resizeItems = false,
					margin = {0,0,0,0},
					padding = {0,0,0,0},
					itemPadding = {1,1,1,1},
					itemMargin = {1,1,1,1},
					
					
					children = {
						--Label:New{ caption = 'Vol', width = 20, textColor = epic_colors.main_fg },
						Image:New{ tooltip = 'Volume', file=LUAUI_DIRNAME .. 'Images/epicmenu/vol.png', width= 18,height= 18, },
						Trackbar:New{
							tooltip = 'Volume',
							height=15,
							width=70,
							trackColor = epic_colors.main_fg,
							value = SpGetConfigInt("snd_volmaster", 50),
							OnChange = { function(self)	Spring.SendCommands{"set snd_volmaster " .. self.value} end	},
						},
						
						Image:New{ tooltip = 'Music', file=LUAUI_DIRNAME .. 'Images/epicmenu/vol_music.png', width= 18,height= 18, },
						Trackbar:New{
							tooltip = 'Music',
							height=15,
							width=70,
							min = 0,
							max = 1,
							step = 0.01,
							trackColor = epic_colors.main_fg,
							value = settings.music_volume or 0.5,
							prevValue = settings.music_volume or 0.5,
							OnChange = { 
								function(self)	
									if (WG.music_start_volume or 0 > 0) then 
										Spring.SetSoundStreamVolume( self.value / WG.music_start_volume ) 
									else 
										Spring.SetSoundStreamVolume( self.value ) 
									end 
									settings.music_volume = self.value
									WG.music_volume = self.value
									if (self.prevValue > 0 and self.value <=0) then widgetHandler:DisableWidget("Music Player") end 
									if (self.prevValue <=0 and self.value > 0) then widgetHandler:EnableWidget("Music Player") end 
									self.prevValue = self.value
								end	
							},
						},
					},
				
				},
				
				Grid:New{
					orientation = 'horizontal',
					columns = 2,
					rows = 2,
					width = 120,
					height = '100%',
					--height = 40,
					resizeItems = true,
					autoArrangeV = true,
					autoArrangeH = true,
					padding = {0,0,0,0},
					itemPadding = {0,0,0,0},
					itemMargin = {0,0,0,0},
					
					children = {
						
						lbl_fps,
						StackPanel:New{
							orientation = 'horizontal',
							width = 60,
							height = '100%',
							resizeItems = false,
							autoArrangeV = false,
							autoArrangeH = false,
							padding = {0,0,0,0},
							itemMargin = {2,0,0,0},
							children = {
								Image:New{ file= LUAUI_DIRNAME .. 'Images/epicmenu/game.png', width = 20,height = 20,  },
								lbl_gtime,
							},
						},
						
						
						img_flag,
						StackPanel:New{
							orientation = 'horizontal',
							width = 60,
							height = '100%',
							resizeItems = false,
							autoArrangeV = false,
							autoArrangeH = false,
							padding = {0,0,0,0},
							itemMargin = {2,0,0,0},
							children = {
								Image:New{ file= LUAUI_DIRNAME .. 'Images/clock.png', width = 20,height = 20,  },
								lbl_clock,
							},
						},
						
					},
				},
				
				Button:New{
					caption = "", OnMouseUp = { function() MakeSubWindow('Help') end, }, textColor=epic_colors.menu_fg, height=buttonH+4, width=buttonH+5,
					padding = btn_padding, margin = btn_margin, tooltip = 'Help...', 
					children = {
						Image:New{ file=LUAUI_DIRNAME .. 'Images/epicmenu/questionmark.png', height=buttonH-2,width=buttonH-2,  },
					},
				},
				Button:New{
					caption = "", OnMouseUp = { function() 
							if not exitWindowVisible then
								screen0:AddChild(window_exit) 
								exitWindowVisible = true
							end
						end, }, 
					textColor=epic_colors.menu_fg, height=buttonH+4, width=buttonH+5,
					padding = btn_padding, margin = btn_margin, tooltip = 'Exit or Resign...',
					children = {
						Image:New{file=LUAUI_DIRNAME .. 'Images/epicmenu/quit.png', height=buttonH-2,width=buttonH-2,  }, 
					},
				},
			}
			--]]
		}
		ingameTimeWidget = Label:New( {
			caption = '00:00:00',
			align = "center",
			backgroundColor = { 0, 0, 0, 1 },
			font = { size = fontSize },
		} )
		panel:AddChild( ingameTimeWidget )
					
		local button = Button:New( {
			caption = "Menu",
			backgroundColor = { 1, 1, 1, 1 },
			font = { size = fontSize },
			OnMouseUp = { ShowMenuWindow },
			styleKey = "buttonResizable",
		} )
		panel:AddChild( button )
		
		window_crude:AddChild( panel )
	end
	
	CreateMenuWindow()
	--MakeCrudeExitWindow()
	
	--ShowHideCrudeMenu()
end
----------------------------------------------------------------------------------------------------

--Remakes crudemenu and remembers last submenu open
RemakeEpicMenu = function()
	local lastPath = curPath
	KillSubWindow()
	if lastPath ~= '' then	
		MakeSubWindow(lastPath)
	end
end

----------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------
function widget:Initialize()
	
	Spring.SendCommands( "unbindaction quitmenu" ) -- http://springrts.com/mantis/view.php?id=2944
	
	if not WG.NotAchili then
		widgetHandler:RemoveWidget(widget)
		return
	end
	init = true
	
	--Spring.SendCommands( "unbindaction hotbind" )
	--Spring.SendCommands( "unbindaction hotunbind" )
	

	-- setup NotAchili
	NotAchili = WG.NotAchili
	Button		= NotAchili.Button
	Label		= NotAchili.Label
	Colorbars	= NotAchili.Colorbars
	Checkbox	= NotAchili.Checkbox
	Window		= NotAchili.Window
	ScrollPanel	= NotAchili.ScrollPanel
	StackPanel	= NotAchili.StackPanel
	LayoutPanel	= NotAchili.LayoutPanel
	Grid		= NotAchili.Grid
	Trackbar	= NotAchili.Trackbar
	TextBox		= NotAchili.TextBox
	Image		= NotAchili.Image
	Progressbar	= NotAchili.Progressbar
	Colorbars	= NotAchili.Colorbars
	screen0		= NotAchili.Screen0
	
	widget:ViewResize(Spring.GetViewGeometry())
	
	-- Set default positions of windows on first run
	if not settings.sub_pos_x then
		settings.sub_pos_x = scrW/2
		settings.sub_pos_y = scrH/2
	end
	if not settings.wl_x then -- widget list
		settings.wl_h = 0.7*scrH
		settings.wl_w = 300
		
		settings.wl_x = (scrW - settings.wl_w)/2
		settings.wl_y = (scrH - settings.wl_h)/2
	end
	if not settings.keybounditems then
		settings.keybounditems = {}
	end
	if not settings.config then
		settings.config = {}
	end
	
	if not settings.country or settings.country == 'wut' then
		myCountry = select( 8, Spring.GetPlayerInfo( Spring.GetLocalPlayerID() ) ) 
		if not myCountry or myCountry == '' then
			myCountry = 'wut'
		end
		settings.country = myCountry
	end
	
	WG.country = settings.country	
	WG.lang = settings.lang
	
	-- add custom widget settings to crudemenu
	AddAllCustSettings()

	--this is done to establish order the correct button order
	AddOption('Settings/Reset Settings')
	AddOption('Settings/Camera')
	AddOption('Settings/Graphics')	
	AddOption('Settings/Interface')
	AddOption('Settings/Interface/Mouse Cursor')
	AddOption('Settings/Misc')

	-- Add pre-configured button/options found in epicmenu config file
	local options_temp ={}
	DeepCopyArray(options_temp , epic_options);
	for i=1, #options_temp do
		local option = options_temp[i]
		AddOption(option.path, option)
	end
	
	-- Clears all saved settings of custom widgets stored in crudemenu's config
	WG.crude.ResetSettings = function()
		for path, _ in pairs( pathOptions ) do
			ResetWinSettings( path )
		end
		RemakeEpicMenu()
		echo 'Cleared all settings.'
	end
	
	-- clear all keybindings
	WG.crude.ResetKeys = function()
		for actionName,_ in pairs(settings.keybounditems) do
			--local actionNameL = actionName:lower()
			local actionNameL = actionName
			Spring.SendCommands({"unbindaction " .. actionNameL})
		end
		
		settings.keybounditems = {}
		
		for _,option in pairs(alloptions) do
		    if option.orig_hotkey then
			  AssignKeyBind(option.orig_hotkey, option.path, option, false)
		    end
		end
		
		echo 'Reset all hotkeys to default.'
	end
	
	-- Add custom actions for the following keybinds
	AddAction("crudemenu", ActionMenu, nil, "t")
	--AddAction("exitwindow", ActionExitWindow, nil, "t")
	-- replace default keybinds for quitmenu
	Spring.SendCommands({
		"unbind esc quitmessage",
		"unbind esc quitmenu", --Upgrading to 0.82 doesn't change existing uikeys so pre-0.82 keybinds still apply.
	})
	Spring.SendCommands("bind esc crudemenu")
	--Spring.SendCommands("bind shift+esc exitwindow")

	MakeMenuBar()
	
	-- Update colors for labels of widget checkboxes in widgetlist window
	local function checkWidget(widget)
		if WG.cws_checkWidget then
			WG.cws_checkWidget(widget)
		end
	end
	
	-- Override widgethandler functions for the purposes of alerting crudemenu 
	-- when widgets are loaded, unloaded or toggled
	widgetHandler.OriginalInsertWidget = widgetHandler.InsertWidget
	widgetHandler.InsertWidget = function(self, widget)
		PreIntegrateWidget(widget)
		
		local ret = self:OriginalInsertWidget(widget)
		
		if type(widget) == 'table' and type(widget.options) == 'table' then
			IntegrateWidget(widget, true)
			if not (init) then
				RemakeEpicMenu()
			end
		end
		
		
		checkWidget(widget)
		return ret
	end
	
	widgetHandler.OriginalRemoveWidget = widgetHandler.RemoveWidget
	widgetHandler.RemoveWidget = function(self, widget)
		local ret = self:OriginalRemoveWidget(widget)
		if type(widget) == 'table' and type(widget.options) == 'table' then
			IntegrateWidget(widget, false)
			if not (init) then
				RemakeEpicMenu()
			end
		end
		
		checkWidget(widget)
		return ret
	end
	
	widgetHandler.OriginalToggleWidget = widgetHandler.ToggleWidget
	widgetHandler.ToggleWidget = function(self, name)
		local ret = self:OriginalToggleWidget(name)
		
		local w = widgetHandler:FindWidget(name)
		if w then
			checkWidget(w)
		else
			checkWidget(name)
		end
		return ret
	end
	init = false
end

----------------------------------------------------------------------------------------------------
function widget:Shutdown()
	-- Restore widgethandler functions to original states
	if widgetHandler.OriginalRemoveWidget then
		widgetHandler.InsertWidget = widgetHandler.OriginalInsertWidget
		widgetHandler.OriginalInsertWidget = nil

		widgetHandler.RemoveWidget = widgetHandler.OriginalRemoveWidget
		widgetHandler.OriginalRemoveWidget = nil
		
		widgetHandler.ToggleWidget = widgetHandler.OriginalToggleWidget
		widgetHandler.OriginalToggleWidget = nil
	end
	

  if window_crude then
    screen0:RemoveChild(window_crude)
  end
  if window_sub_cur then
    screen0:RemoveChild(window_sub_cur)
  end

  RemoveAction("crudemenu")
 
  -- restore key binds
  --[[
  Spring.SendCommands({
    "bind esc quitmessage",
    "bind esc quitmenu", -- FIXME made for licho, removed after 0.82 release
  })
  --]]
  Spring.SendCommands("unbind esc crudemenu")
end

----------------------------------------------------------------------------------------------------
function widget:ViewResize( vsx, vsy )
	scrW = vsx
	scrH = vsy
	
	if( window_crude ) then
		window_crude:SetPos( vsx - window_crude.width + 3, -3 )
	end
end

----------------------------------------------------------------------------------------------------
function widget:GetConfigData()
	return settings
end

function widget:SetConfigData( data )
	if ( data and type( data ) == 'table' ) then
		if data.versionmin and data.versionmin >= 50 then
			settings = data
		end
	end
	WG.music_volume = settings.music_volume or 0.5
end

----------------------------------------------------------------------------------------------------
local timer = math.huge
local updateIntervalSeconds = 0.3

function widget:Update( dt )

	if timer < updateIntervalSeconds then
		timer = timer + dt
		return
	end
	
	timer = 0
	
	if ingameTimeWidget then
		ingameTimeWidget:SetCaption( GetTimeString() )
	end

	--[[
	--Update clock, game timer and fps meter that show on menubar
	if lbl_fps then
		lbl_fps:SetCaption( 'FPS: ' .. Spring.GetFPS() )
	end
	
	if lbl_gtime then
		lbl_gtime:SetCaption( GetTimeString() )
	end
	
	if lbl_clock then
		--local displaySeconds = true
		--local format = displaySeconds and "%H:%M:%S" or "%H:%M"
		local format = "%H:%M" --fixme: running game for over an hour pushes time label down
		--lbl_clock:SetCaption( 'Clock\n ' .. os.date(format) )
		lbl_clock:SetCaption( os.date(format) )
	end
	--]]
end

----------------------------------------------------------------------------------------------------
function widget:KeyPress(key, modifier, isRepeat)
	if key == KEYSYMS.LCTRL 
		or key == KEYSYMS.RCTRL 
		or key == KEYSYMS.LALT
		or key == KEYSYMS.RALT
		or key == KEYSYMS.LSHIFT
		or key == KEYSYMS.RSHIFT
		or key == KEYSYMS.LMETA
		or key == KEYSYMS.RMETA
		or key == KEYSYMS.SPACE
		then
		
		return
	end
	
	local modstring = 
		(modifier.alt and 'A+' or '') ..
		(modifier.ctrl and 'C+' or '') ..
		(modifier.meta and 'M+' or '') ..
		(modifier.shift and 'S+' or '')
	
	--Set a keybinding 
	if get_key then
		get_key = false
		window_getkey:Dispose()
		local standardKey = keysyms[ ''..key ]:lower()
		translatedkey = transkey[ standardKey ] or standardKey
		local hotkey = { key = translatedkey, mod = modstring, }		
		
		if key ~= KEYSYMS.ESCAPE then		
			AssignKeyBind( hotkey, kb_path, kb_option, true ) -- param4 = verbose
		else
			local actionName = GetActionName( kb_option )
			echo( 'Unbound hotkeys from action: ' .. actionName )
		end
		
		if kb_path == curPath then
			MakeSubWindow(kb_path)
		end
		
		return true
	end
	
end

----------------------------------------------------------------------------------------------------
local beginAlpha, endAlpha, currentAlpha = 0.0, 0.5
local stepAlpha = ( endAlpha - beginAlpha ) / 30
local beginAnimationTime, currentAnimationTime
local stepAnimationTime = 0.008

function widget:DrawScreen()
	if IsVisibleConfirmWidget() then
		
		if not beginAnimationTime then
			beginAnimationTime = os.clock()
			currentAlpha = beginAlpha
		end
		
		currentAnimationTime = os.clock()
		local deltaTime = currentAnimationTime - beginAnimationTime
		if( deltaTime > stepAnimationTime ) then
			if currentAlpha < endAlpha then
				currentAlpha = currentAlpha + stepAlpha
			end
			beginAnimationTime = currentAnimationTime
		end
	
		gl.Color( 0, 0, 0, currentAlpha )
		gl.Rect( 0, 0, screen0.width, screen0.height )
	else
		beginAnimationTime = nil
	end
end

----------------------------------------------------------------------------------------------------
--
----------------------------------------------------------------------------------------------------
--[[
function ActionExitWindow()
	if exitWindowVisible then
		screen0:RemoveChild(window_exit) 
		exitWindowVisible = false
	else
		screen0:AddChild(window_exit) 
		exitWindowVisible = true
	end						
end
--]]

----------------------------------------------------------------------------------------------------
function ActionMenu()
	--settings.show_crudemenu = not settings.show_crudemenu
	--ShowHideCrudeMenu()
	ShowMenuWindow()
end

function WG.crude.ShowMenu() --// allow other widget to toggle-up Epic-Menu. This'll enable access to game settings' Menu via click on other GUI elements.
	if not settings.show_crudemenu then 
		settings.show_crudemenu = true
		ShowHideCrudeMenu()
	end
end

----------------------------------------------------------------------------------------------------
--                                         Implementation                                         --
----------------------------------------------------------------------------------------------------
function CreateMenuWindow()
	mainWindowWidget = Window:New( {
		name	= 'mainWindow',
		caption = 'Main Menu',
		width	= menuW,
		height	= menuH,
		margin	= { 0, 0, 0, 0 },
		padding	= { 2, 8.8 * globalSize, 2, 2 },
		--dockable = true,
		--clientWidth = mainCrudeWidth,
		--clientHeight = mainCrudeHeight,
		draggable		= false,
		tweakDraggable	= false,
		resizable		= false,
		minimizable		= false,
		--backgroundColor = epic_colors.main_bg,
		font = { size = fontSize },
		--color = {1,1,1,0.5},
	} )
	do
		local stackPanel = StackPanel:New( {
			width = "100%", height = "100%",
			resizeItems = false,
			centerItems = true,
			autosize = true,
		} )
		do		
			local pauseButton = Button:New( {
				width = buttonW, height = buttonH,
				caption = "Pause",
				backgroundColor = { 1, 1, 1, 1 },
				font = { size = fontSize },
				OnMouseUp = { function()
					Spring.SendCommands{ "pause" }
				end },
				styleKey = "buttonResizable",
			} )
		
			local settingsButton = Button:New( {
				width = buttonW, height = buttonH,
				caption = "Settings",
				backgroundColor = { 1, 1, 1, 1 },
				font = { size = fontSize },
				OnMouseUp = { function() 
					HideMenuWindow()
					MakeSubWindow( 'Settings' ) 
				end },
				styleKey = "buttonResizable",
			} )
			
			local resignButton = Button:New( {
				width = buttonW, height = buttonH,
				caption = "Resign",
				backgroundColor = { 1, 1, 1, 1 },
				font = { size = fontSize },
				OnMouseUp = { ConfirmResignAction },
				styleKey = "buttonResizable",
			} )
			
			local exitGameButton = Button:New( {
				width = buttonW, height = buttonH,
				caption = "Exit Game",
				backgroundColor = { 1, 1, 1, 1 },
				font = { size = fontSize },
				OnMouseUp = { ConfirmExitGameAction },
				styleKey = "buttonResizable",
			} )
			
			local exitMenuButton = Button:New( {
				width = buttonW, height = buttonH,
				caption = "Back to Game",
				backgroundColor = { 1, 1, 1, 1 },
				font = { size = fontSize },
				OnMouseUp = { HideMenuWindow },
				styleKey = "buttonResizable",
			} )
			
			stackPanel:AddChild( CreateVerticalSeparator( 8 * globalSize ) )
			stackPanel:AddChild( pauseButton )
			stackPanel:AddChild( CreateVerticalSeparator( 2 * globalSize ) )
			stackPanel:AddChild( settingsButton )
			stackPanel:AddChild( CreateVerticalSeparator( 2 * globalSize ) )
			stackPanel:AddChild( resignButton )
			stackPanel:AddChild( exitGameButton )
			stackPanel:AddChild( CreateVerticalSeparator( 8 * globalSize ) )
			stackPanel:AddChild( exitMenuButton )
			stackPanel:AddChild( CreateVerticalSeparator( 2 * globalSize ) )
		end
		mainWindowWidget:AddChild( stackPanel )
	end
end

function ShowMenuWindow()
	
	if mainWindowWidget.parent then
		screen0:RemoveChild( mainWindowWidget )
		return
	elseif window_sub_cur then
		KillSubWindow()
	elseif IsVisibleConfirmWidget() then
		HideConfirmWindow()
	--[[
	elseif exitWindowVisible then
		ActionExitWindow()
		return
	--]]
	end
	
	screen0:AddChild( mainWindowWidget )
	CenterWidgetInParent( mainWindowWidget )
end

function HideMenuWindow()
	screen0:RemoveChild( mainWindowWidget )
end

----------------------------------------------------------------------------------------------------
function ConfirmResignAction()
	ShowConfirmWidget( 
		"Resign",
		"You want to RESIGN,\n      are you sure?",
		function()
			HideConfirmWindow()
			Spring.SendCommands{ "spectator" }
		end
	)
end

----------------------------------------------------------------------------------------------------
function ConfirmExitGameAction()
	
	ShowConfirmWidget( 
		"Exit Game",
		"You want to exit game,\n      are you sure?",
		function()
			HideConfirmWindow()
			if WG.SS44_UI and WG.SS44_UI.ShowExitScreen then
				WG.SS44_UI.ShowExitScreen()
			else
				Spring.SendCommands{ "quit", "quitforce" }
			end
		end
	)
end

function ShowConfirmWidget( title, description, action )

	confirmWidget = Window:New{ name = 'confirmWidget', font = { size = fontSize } } do
		confirmWidget.caption	= title
		confirmWidget.width		= confirmW
		confirmWidget.height	= confirmH
		confirmWidget.margin	= { 0, 0, 0, 0 }
		confirmWidget.padding	= { 2, 8.8 * globalSize, 2, 2 }
		confirmWidget.draggable			= false
		confirmWidget.tweakDraggable	= false
		confirmWidget.resizable			= false
		confirmWidget.minimizable		= false
	
		local stackPanel = StackPanel:New{ width = "100%", height = "100%" } do
			stackPanel.resizeItems = false
			stackPanel.centerItems = true
			stackPanel.autosize = true
		
			local textWidget = Label:New{ 
				caption = description, 
				width = "100%",
				font = { size = fontSize },
			}
			--textWidget.align	= "center"
			--textWidget.valign	= "center"
			
			local confirmButton = Button:New{
				width = buttonW, height = buttonH,
				caption = "Ok",
				backgroundColor = { 1, 1, 1, 1 },
				font = { size = fontSize },
				OnMouseUp = { action },
				styleKey = "buttonResizable",
			}

			local cancelButton = Button:New{
				width = buttonW, height = buttonH,
				caption = "Cancel",
				backgroundColor = { 1, 1, 1, 1 },
				font = { size = fontSize },
				OnMouseUp = { function()
						HideConfirmWindow()
						ShowMenuWindow()
					end
				},
				styleKey = "buttonResizable",
			}
			
			stackPanel:AddChild( CreateVerticalSeparator( 16 * globalSize ) )
			stackPanel:AddChild( textWidget )
			stackPanel:AddChild( CreateVerticalSeparator( 16 * globalSize ) )
			stackPanel:AddChild( confirmButton )
			stackPanel:AddChild( cancelButton )
			stackPanel:AddChild( CreateVerticalSeparator( 2 * globalSize ) )
		end
		
		confirmWidget:AddChild( stackPanel )
	end
	
	screen0:AddChild( confirmWidget )

	CenterWidgetInParent( confirmWidget )
	HideMenuWindow()
end

function HideConfirmWindow()
	screen0:RemoveChild( confirmWidget )
end

function IsVisibleConfirmWidget()
	return confirmWidget and confirmWidget.parent
end

----------------------------------------------------------------------------------------------------
function CreateVerticalSeparator( size )
	return Label:New( { caption = "", minHeight = size } )
end

----------------------------------------------------------------------------------------------------
function CenterWidgetInParent( widget )
	if widget then
		local parent = widget.parent
		if parent then
			
			local midX = ( parent.width  - widget.width  ) * 0.5
			local midY = ( parent.height - widget.height ) * 0.5
			
			widget:SetPos( midX, midY )
		end
	end
end
----------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------
--                                        Helper Functions                                        --
----------------------------------------------------------------------------------------------------
function ToCamelStyle( str )
	local str = str:lower()
	str = str:gsub( '_', ' ' )
	str = str:sub( 1, 1 ):upper() .. str:sub( 2 )
	
	str = str:gsub( ' (.)', function( x )
		return ( ' ' .. x ):upper()
	end )
	
	return str
end

----------------------------------------------------------------------------------------------------
function GetIndex( t, v )
	local idx = 1
	while ( t[ idx ] < v ) and ( t[ idx + 1 ] ) do
		idx = idx + 1
	end 
	return idx
end

----------------------------------------------------------------------------------------------------
function GetFullKey( option )
	local fullkey = ( 'epic_' .. option.wname .. '_' .. option.key )
	return fullkey:gsub( ' ', '_' )
end

----------------------------------------------------------------------------------------------------
function GetActionName( option )
	local fullkey = GetFullKey( option ):lower()
	return option.action or fullkey
end

----------------------------------------------------------------------------------------------------
WG.crude.ResetWidget = function( params )
	KillSubWindow()
	
	if window_crude then
		window_crude:Dispose()
	end
	
	if window_exit then
		window_crude:Dispose()
	end
	
	if mainWindowWidget then
		mainWindowWidget:Dispose()
	end
	
	globalSize = params.globalSize

	buttonW, buttonH = 52 * globalSize, 10 * globalSize

	mainMenuWidth = 90 * globalSize

	mainCrudeWidth = 390 * globalSize -- 296 * globalSize
	mainCrudeHeight = buttonH + 6 * globalSize

	mainW, mainH = 80 * globalSize,  14 * globalSize
	menuW, menuH = 100 * globalSize, 120 * globalSize

	confirmW, confirmH = menuW, 100 * globalSize
	
	fontSize = math.floor( 4.8 * globalSize )
	
	MakeMenuBar()
end
----------------------------------------------------------------------------------------------------
