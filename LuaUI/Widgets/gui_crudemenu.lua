--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

function widget:GetInfo()
  return {
    name      = "Crude Menu",
    desc      = "v0.67 Crude Chili Menu.",
    author    = "CarRepairer",
    date      = "2009-06-02",
    license   = "GNU GPL, v2 or later",
    layer     = 0,
	handler   = true,
    enabled   = true  --  loaded by default?
  }
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

local spGetConfigInt    		= Spring.GetConfigInt
local spSendCommands			= Spring.SendCommands
local spSendLuaRulesMsg			= Spring.SendLuaRulesMsg
local spGetCurrentTooltip		= Spring.GetCurrentTooltip

local spGetUnitDefID			= Spring.GetUnitDefID
local spGetUnitAllyTeam			= Spring.GetUnitAllyTeam
local spGetUnitTeam				= Spring.GetUnitTeam
local spTraceScreenRay			= Spring.TraceScreenRay
local spGetTeamInfo				= Spring.GetTeamInfo
local spGetPlayerInfo			= Spring.GetPlayerInfo
local spGetTeamColor			= Spring.GetTeamColor

local spGetModKeyState			= Spring.GetModKeyState
local spGetMouseState			= Spring.GetMouseState


local abs						= math.abs
local strFormat 				= string.format

local echo = Spring.Echo

local VFSMODE      = VFS.RAW_FIRST
local file = LUAUI_DIRNAME .. "Configs/crudemenu_conf.lua"
local menu_tree, game_menu_tree, color, multiweapon, title_text, iconFormat = VFS.Include(file, nil, VFSMODE)

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

local Chili = VFS.Include(LUAUI_DIRNAME.."Widgets/chiligui/chiligui.lua")
local Button = Chili.Button
local Control = Chili.Control
local Label = Chili.Label
local Colorbars = Chili.Colorbars
local Checkbox = Chili.Checkbox
local Trackbar = Chili.Trackbar
local Window = Chili.Window
local ScrollPanel = Chili.ScrollPanel
local StackPanel = Chili.StackPanel
local Grid = Chili.Grid
local TextBox = Chili.TextBox
local Image = Chili.Image
local LayoutPanel = Chili.LayoutPanel

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

local B_HEIGHT = 20

local scrH, scrW = 0,0
local myAlliance = Spring.GetLocalAllyTeamID()
local ceasefires = true
local cycle = 1
local game_menu_index = -1
local cmfunctions = {}

WG.crude = {}
if not WG.Layout then
	WG.Layout = {}
end

local settings = {
	versionmin = 50,
	pos_x,
	pos_y,
	sub_pos_x,
	sub_pos_y,
	vol_x,
	vol_y,
	lang = 'en',
	noContextClick = false,
	noVolBar = false,
	hideUnits = WG.Layout.hideUnits,
	hideUnits = WG.Layout.hideUnits,
	horizontal = false,
	simple_tooltip = false,
	disable_idle_cursor_tooltip = false,
}

local th
local old_ttstr
local old_mx, old_my = -1,-1
local mx, my = -1,-1
local showToolTip =false
local stillCursorTime = 0

local screen0 = Chili.Screen:New{}
local subwindows = {}
local window_parents = {}
local window_widgetlist
local window_unitcontext = Window:New{ visible=false, parent = screen0,x=-1000 }
local window_unitstats = Window:New{ visible=false, parent = screen0,x=-1000 }
local window_crude 
local window_flags
local window_selection
local window_tooltip
local window_volume 
local cmsettings_index = -1
local window_sub_cur

local flatwindowlist = {}
local flatwindowlistcount = 0

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
  minimap = "Minimap",
  snd     = "Sound",
  test    = "For Developers",
  unit    = "Units",
  ungrouped    = "Ungrouped",
}

local cursorNames = {
  'cursornormal',
  'cursorareaattack',
  'cursorattack',
  'cursorattack',
  'cursorbuildbad',
  'cursorbuildgood',
  'cursorcapture',
  'cursorcentroid',
  'cursordwatch',
  'cursorwait',
  'cursordgun',
  'cursorattack',
  'cursorfight',
  'cursorattack',
  'cursorgather',
  'cursorwait',
  'cursordefend',
  'cursorpickup',
  'cursormove',
  'cursorpatrol',
  'cursorreclamate',
  'cursorrepair',
  'cursorrevive',
  'cursorrepair',
  'cursorrestore',
  'cursorrepair',
  'cursorselfd',
  'cursornumber',
  'cursorwait',
  'cursortime',
  'cursorwait',
  'cursorunload',
  'cursorwait',
}

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

local function tobool(val)
  local t = type(val)
  if (t == 'nil') then return false
  elseif (t == 'boolean') then	return val
  elseif (t == 'number') then	return (val ~= 0)
  elseif (t == 'string') then	return ((val ~= '0') and (val ~= 'false'))
  end
  return false
end

if tobool(Spring.GetModOptions().noceasefire) or Spring.FixedAllies() then
  ceasefires = false
end 


local function comma_value(amount)
  local formatted = amount
  while true do  
    formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2')
    if (k==0) then
      break
    end
  end
  return formatted
end

--from rooms widget by quantum
local function ToSI(num)
  if type(num) ~= 'number' then
	return 'CrudeMenu wacky error #55'
  end
  if (num == 0) then
    return "0"
  else
    local absNum = abs(num)
    if (absNum < 0.001) then
      return strFormat("%.2fu", 1000000 * num)
    elseif (absNum < 1) then
      return strFormat("%.2fm", 1000 * num)
    elseif (absNum < 1000) then
      return strFormat("%.2f", num)
    elseif (absNum < 1000000) then
      return strFormat("%.2fk", 0.001 * num)
    else
      return strFormat("%.2fM", 0.000001 * num)
    end
  end
end
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

local function getUdFromName(unitName, tooltip)
	local unitName = unitName:gsub('[^a-zA-Z]', '')
	for _,ud in pairs(UnitDefs) do
		local humanName = ud.humanName:gsub('[^a-zA-Z]', '')
		local scrunched_tooltip = tooltip:match('([a-zA-Z0-9 :,]*)')
		local scrunched_udtooltip = ud.tooltip:match('([a-zA-Z0-9 :,]*)')

		if humanName == unitName then
			if tooltip == '' or scrunched_tooltip == scrunched_udtooltip then
				return ud
			end
		end
	end
	return false
end

local function getHelpText(unitDef, lang)
	local suffix = (lang == 'en') and '' or ('_' .. lang)	
	return unitDef.customParams and unitDef.customParams['helptext' .. suffix] 
		or unitDef.customParams.helptext
		or "No help text available for this unit."
end	

local function getDescription(unitDef, lang)
	if not lang or lang == 'en' then 
		return unitDef.tooltip
	end
	local suffix  = ('_' .. lang)
	return unitDef.customParams and unitDef.customParams['description' .. suffix] or unitDef.tooltip or 'Description error'
end	


local function weapons2Table(cells, weaponStats, ws, merw, index)
	local cells = cells
	local mainweapon = merw and merw[index]
	if not ws.slaveTo then
		if mainweapon then
			for _,index2 in ipairs(mainweapon) do
				wsm = weaponStats[index2]
				ws.damw = ws.damw + wsm.bestTypeDamagew
				ws.dpsw = ws.dpsw + wsm.dpsw
				ws.dam = ws.dam + wsm.bestTypeDamage
				ws.dps = ws.dps + wsm.dps
			end
		end
		
		local dps_str, dam_str = '', ''
		if ws.dps > 0 then
			dam_str = dam_str .. ToSI(ws.dam,2)
			dps_str = dps_str .. ToSI(ws.dps,2)
		end
		if ws.dpsw > 0 then
			if dps_str ~= '' then
				dps_str = dps_str .. ' || '
				dam_str = dam_str .. ' || '
			end
			dam_str = dam_str .. ToSI(ws.damw,2) .. ' (P)'
			dps_str = dps_str .. ToSI(ws.dpsw,2) .. ' (P)'
		end
		cells[#cells+1] = '- '.. ws.wname ..' -'
		cells[#cells+1] = '     Damage: '.. dam_str
		cells[#cells+1] = '     Reloadtime: ' .. ToSI(ws.reloadtime,2) ..'s'
		cells[#cells+1] = '     Damage/second: '.. dps_str
		cells[#cells+1] = '     Range: '.. ToSI(ws.range,2)
		cells[#cells+1] = ' '
	end
	return cells
end

local function printWeapons(unitDef)
	local weaponStats = {}
	local bestDamage, bestDamageIndex, bestTypeDamage = 0,0,0

	local merw = {}

	local wd = WeaponDefs
	if not wd then return false end	
	
	for i, weapon in ipairs(unitDef.weapons) do
		local weaponID = weapon.weaponDef
		local weaponDef = WeaponDefs[weaponID]
	
		local weaponName = weaponDef.description
		
		if (weaponName) then
			
			local wsTemp = {}
			wsTemp.slaveTo = (weapon.slavedTo ~= 0) and weapon.slavedTo or nil

			if wsTemp.slaveTo then
				merw[wsTemp.slaveTo] = merw[wsTemp.slaveTo] or {}
				merw[wsTemp.slaveTo][#(merw[wsTemp.slaveTo])+1] = i
			end
			wsTemp.bestTypeDamage = 0
			wsTemp.bestTypeDamagew = 0
			wsTemp.paralyzer = weaponDef.paralyzer	
			for unitType, damage in pairs(weaponDef.damages) do
				
				if (wsTemp.bestTypeDamage <= (damage+0) and not wsTemp.paralyzer)
					or (wsTemp.bestTypeDamagew <= (damage+0) and wsTemp.paralyzer)
					then

					if wsTemp.paralyzer then
						wsTemp.bestTypeDamagew = (damage+0)
					else
						wsTemp.bestTypeDamage = (damage+0)
					end
					
					wsTemp.burst = weaponDef.burst or 1
					wsTemp.projectiles = weaponDef.projectiles or 1
					wsTemp.dam = 0
					wsTemp.damw = 0
					if wsTemp.paralyzer then
						wsTemp.damw = wsTemp.bestTypeDamagew * wsTemp.burst * wsTemp.projectiles
					else
						wsTemp.dam = wsTemp.bestTypeDamage * wsTemp.burst * wsTemp.projectiles
					end
					wsTemp.reloadtime = weaponDef.reload or ''
					wsTemp.airWeapon = weaponDef.toAirWeapon or false
					wsTemp.range = weaponDef.range or ''
					wsTemp.wname = weaponDef.description or 'NoName Weapon'
					wsTemp.dps = 0
					wsTemp.dpsw = 0
					if  wsTemp.reloadtime ~= '' and wsTemp.reloadtime > 0 then
						if wsTemp.paralyzer then
							wsTemp.dpsw = math.floor(wsTemp.damw/wsTemp.reloadtime + 0.5)
						else
							wsTemp.dps = math.floor(wsTemp.dam/wsTemp.reloadtime + 0.5)
						end
					end
					--echo('test', unitDef.unitname, wsTemp.wname, bestDamage, bestDamageIndex)
					if wsTemp.dam > bestDamage then
						bestDamage = wsTemp.dam	
						bestDamageIndex = i
					end
					if wsTemp.damw > bestDamage then
						bestDamage = wsTemp.damw
						bestDamageIndex = i
					end
					
				end
			end
			if not wsTemp.wname then print("BAD", unitDef.unitname) return false end -- stupid negative in corhurc is breaking me.
			weaponStats[i] = wsTemp
		end
	end
	
	local cells = {}
	
	if multiweapon then
		local weaponList = multiweapon[unitDef.name]
		if not weaponList then
			if bestDamageIndex == 0 then
				return false
			end
			weaponList = { bestDamageIndex }
		end
		
		for _,index in pairs(weaponList) do
			local ws = weaponStats[index]
			cells = weapons2Table(cells, weaponStats, ws, merw, index)
		end
	
	else
		for index,ws in pairs(weaponStats) do
			cells = weapons2Table(cells, weaponStats, ws, merw, index)
		end
		
	end
	return cells
end

local function printunitinfo(ud, lang, buttonWidth)	
	local buildpic = 'unitpics/'.. (ud.buildpicname ~= '' and ud.buildpicname or (ud.name .. '.png'))
	local icons = {
		Image:New{
			file=buildpic,
			height=40,
			width=40,
		}
	}
	if ud.iconType ~= 'default' then
		icons[#icons + 1] = 
			Image:New{
				file='icons/'.. ud.iconType ..iconFormat,
				height=40,
				width=40,
			}
	end
	
	local helptextbox = TextBox:New{ text = getHelpText(ud, lang), textColor = color.stats_fg, width = 210, x=40} 
	local blurbheight = 80
	if helptextbox.height > 80 then
		blurbheight = helptextbox.height 
	end
	local statschildren = {}
	
	statschildren[#statschildren+1] = Label:New{ caption = 'STATS', textColor = color.stats_header, width=150,}
	
	statschildren[#statschildren+1] = Label:New{ caption = '   Cost: ' .. comma_value(ud.metalCost), textColor = color.stats_fg, }
	statschildren[#statschildren+1] = Label:New{ caption = '   Max HP: ' .. comma_value(ud.health), textColor = color.stats_fg, }
	if ud.speed > 0 then
		statschildren[#statschildren+1] = Label:New{ caption = '   Speed: ' .. ToSI(ud.speed,2), textColor = color.stats_fg, }
	end
	
	local cells = printWeapons(ud)
	
	if cells and #cells > 0 then
		statschildren[#statschildren+1] = Label:New{ caption = '', textColor = color.stats_header,}
		statschildren[#statschildren+1] = Label:New{ caption = 'WEAPONS', textColor = color.stats_header,}
		for _,v in ipairs(cells) do
			statschildren[#statschildren+1] = Label:New{ caption = v, textColor = color.stats_fg, }
		end
	end
	
	return 
		{
			StackPanel:New{
				autoArrangeV  = false,
				padding = {0,0,0,0},
				itemPadding = {0,0,0,0},
				itemMargin = {0,0,0,0},
				height = blurbheight + (#statschildren)*15 +170,
				width = 250 + 30,
				resizeItems = false,
				children = {
				
					StackPanel:New{
						autoArrangeV  = false,
						padding = {0,0,0,0},
						itemPadding = {0,0,0,0},
						itemMargin = {0,0,0,0},
						height = blurbheight,
						width = 40,
						resizeItems = false,
						children = icons,
					},
					
					helptextbox,
					
					StackPanel:New{
						autoArrangeV  = false,
						height = (#statschildren)*15,
						width = 200,
						children = statschildren,
						padding = {0,0,0,0},
						itemPadding = {0,0,0,0},
						itemMargin = {0,0,0,0},
					},
					
				},
			},
			
		}
	
end

WG.crude.SetCursor = function(cursorSet)
  for _, cursor in ipairs(cursorNames) do
    local topLeft = (cursor == 'cursornormal' and cursorSet ~= 'k_haos_girl')
    Spring.ReplaceMouseCursor(cursor, cursorSet.."/"..cursor, topLeft)
  end
end

WG.crude.RestoreCursor = function()
  for _, cursor in ipairs(cursorNames) do
    local topLeft = (cursor == 'cursornormal')
    Spring.ReplaceMouseCursor(cursor, cursor, topLeft)
  end
end

local function tooltipBreakdown()
	local tooltip = spGetCurrentTooltip()
	local start,fin = tooltip:find([[ - ]], 1, true) 
	if tooltip:find('Build:') == 1 then
		if not start then
			return false
		end
		--return tooltip:gsub('([^-]*)\-.*', '%1'):sub(8,-2), 'Build: ', tooltip:gsub('[^-]*\- (.*)', '%1')
		return tooltip:sub(fin+1), tooltip:sub(8,start-1), 'Build: '
	elseif tooltip:find('Morph') == 5 then
		return '', tooltip:gsub('([^(time)]*)\(time).*', '%1'):sub(18), 'Morph to: '
		
	elseif tooltip:find('Selected') == 1 then
		if not start then
			return false
		end
		--return tooltip:gsub('([^-]*)\-.*', '%1'):sub(11,-2), 'Selected: ', tooltip:gsub('[^-]*\- (.*)', '%1')
		return tooltip:sub(fin+1), tooltip:sub(11,start-1), 'Selected: '
	else
		return tooltip
	end
	return false, false
	
end

----------------------------------------------------------------

local function killWindow(self)
	self.parent.parent:Dispose()
end

local function saveSubPos()
	if window_sub_cur then
		settings.sub_pos_x = window_sub_cur.x
		settings.sub_pos_y = window_sub_cur.y
	end
end


local function killSubWindow()
	if window_sub_cur then
		saveSubPos()
		window_sub_cur:Dispose()
	end
end

local function killWindow2(self)
	self.parent:Dispose()
end

local function hideWindow(window)
	window:SetPos(-1000, -1000)
	window.visible = false
end

local function showWindow(window, x, y)
	window.visible = true
	if x then
		window:SetPos(x,y)
	end
end

local function MakeStatsWindow(ud, x,y, backbutton)
	hideWindow(window_unitcontext)
	
	local y = scrH-y
	local x = x
	
	if window_unitstats then
		window_unitstats:Dispose()
	end
	
	local window_width = 300
	local buttonWidth = window_width - 20
	local window_height = 350

	local children = {
		Label:New{ caption = ud.humanName ..' - '.. getDescription(ud, settings.lang), x=0, y =0, width=buttonWidth,textColor = color.stats_header,},
		ScrollPanel:New{
			x = 0,
			y = B_HEIGHT*1,
			width = window_width - 5,
			height = window_height - B_HEIGHT*4,
			horizontalScrollbar = false,
			children = printunitinfo(ud, settings.lang, buttonWidth) ,
		},
	}
	if backbutton then
		children[#children+1] = 
			Button:New{ 
				caption = 'Back', 
				OnMouseUp = { function(self) hideWindow(self.parent) showWindow(window_unitcontext, x, y) end }, 
				x=0, y=window_height - B_HEIGHT, 
				width=buttonWidth, 
				backgroundColor=color.sub_back_bg, 
				textColor=color.sub_back_fg,
			}
	end
	
	if x > scrW * (.75) then
		x = x - window_width - 20
	else
		x = x + 20
	end
	if y > scrH * (.75) then
		y = y - window_height - 20
	else
		y = y + 20
	end
	window_unitstats:Dispose()
	window_unitstats = Window:New{  
		x = x,  
		y = y,  
		clientWidth  = window_width,
		clientHeight = window_height,
		resizable = false,
		parent = screen0,
		backgroundColor = color.stats_bg, 
		children = children
	}
end

local function MakeUnitContextMenu(unitID,x,y)
	
	hideWindow(window_unitstats)
					
	local udid 			= spGetUnitDefID(unitID)
	local ud 			= UnitDefs[udid]
	if not ud then return end
	local alliance 		= spGetUnitAllyTeam(unitID)
	local team			= spGetUnitTeam(unitID)
	local _, player 	= spGetTeamInfo(team)
	local playerName 	= spGetPlayerInfo(player) or 'noname'
	local teamColor 	= {spGetTeamColor(team)}
		
	local window_width = 160
	local buttonWidth = window_width - 0
	local window_height = B_HEIGHT*5

	
	local children = {
		Label:New{ caption =  ud.humanName ..' - '.. getDescription(ud, settings.lang) , x=0, y = 0, width=buttonWidth, textColor = color.context_header,},
		Button:New{ 
			caption = 'Unit Help', 
			OnMouseUp = { function() MakeStatsWindow(ud,x,y, true) end }, 
			x=20, y=25, width=buttonWidth-40,
			backgroundColor=color.sub_back_bg, 
			textColor=color.sub_back_fg,
		},
		
		Label:New{ caption = '', x=0, y = 40, },
		
		Label:New{ caption = 'Alliance - ' .. alliance .. '    Team - ' .. team, x=0, y = 60, width=buttonWidth ,textColor = color.context_fg,},
		Label:New{ caption = 'Player: ' .. playerName, x=0, y = 80, width=buttonWidth, textColor=teamColor },
	}
	local y = scrH-y
	local x = x
	
	if ceasefires and myAlliance ~= alliance then
		window_height = window_height + B_HEIGHT*2
		children[#children+1] = Button:New{ caption = 'Vote for ceasefire', OnMouseUp = { function() spSendLuaRulesMsg('cf:y'..alliance) end }, x=0, y=100, width=buttonWidth}
		children[#children+1] = Button:New{ caption = 'Break ceasefire/unvote', OnMouseUp = { function() spSendLuaRulesMsg('cf:n'..alliance) spSendLuaRulesMsg('cf:b'..alliance) end }, x=0, y=120, width=buttonWidth}
	end
	
	if x > scrW * (.75) then
		x = x - window_width - 20
	else
		x = x + 20
	end
	if y > scrH * (.75) then
		y = y - window_height - 20
	else
		y = y + 20
	end
	if window_unitcontext then
		window_unitcontext:Dispose()
	end
	window_unitcontext = Window:New{  
		x = x,  
		y = y,  
		clientWidth  = window_width,
		clientHeight = window_height,
		resizable = false,
		parent = screen0,
		backgroundColor = color.context_bg, 
		children = children,
	}
end

local function MakeWidgetList()

	if window_widgetlist then
		window_widgetlist:Dispose()
	end

	local widget_children = {}
	local widgets_cats = {}
	
	local window_height = 400
	local window_width = 300
	local buttonWidth = window_width - 20
	
	for name,data in pairs(widgetHandler.knownWidgets) do
		local name = name
		local name_display = name .. (data.fromZip and ' (mod)' or '')
		local data = data
		local _, _, category = string.find(data.basename, "([^_]*)")
		
		if not groupDescs[category] then
			category = 'ungrouped'
		end
		local catdesc = groupDescs[category]
		widgets_cats[catdesc] = widgets_cats[catdesc] or {}
			
		widgets_cats[catdesc][#(widgets_cats[catdesc])+1] = 
		{
			name_display	= name_display,
			name		 	= name,
			active 			= data.active,
		}
	end
	i=0
	
	for catdesc, catwidgets in pairs(widgets_cats) do
		local catwidgets = catwidgets
			
		table.sort(catwidgets, function(t1,t2)
			return t1.name_display < t2.name_display
		end)
		i=i+1
		widget_children[#widget_children + 1] = 
			Label:New{ caption = '-='.. catdesc ..'=-', textColor = color.sub_header, align='center', }
		
		for _, wdata in ipairs(catwidgets) do
			i=i+1
			
			local order = widgetHandler.orderList[wdata.name]
			local enabled = order and (order > 0)
			local hilite_color = (wdata.active and {0,1,0,1}) or (enabled  and {1,1,0.5,1}) or {1,0,0,1}
        
			widget_children[#widget_children + 1] = Checkbox:New{ 
					caption = wdata.name_display, 
					checked = wdata.active,
					textColor = hilite_color,
					OnMouseUp = { 
						function(self) 
							widgetHandler:ToggleWidget(wdata.name)
							self.textColor = self.checked and {0,1,0,1} or {1,0,0,1}
							self:UpdateClientArea()
						end,
					},
				}
		end
	end
	
	window_widgetlist = Window:New{  
		x = 650,  
		y = 400,  
		clientWidth  = window_width,
		clientHeight = window_height,
		parent = screen0,
		backgroundColor = color.sub_bg,
		children = {
			--[[
			StackPanel:New{
				height = window_height,
				width = window_width,
				padding = {0,0,0,0},
				itemPadding = {1,1,1,1},
				itemMargin = {0,0,0,0},	
				--resizeItems = false,
				children = {
				--]]
					Label:New{ caption = 'Widget List', textColor = color.sub_header, align='center', width =window_width-10, anchors = {top=true,left=true,right=true} },
					ScrollPanel:New{
						y=B_HEIGHT,
						width = window_width-10,
						height = window_height - B_HEIGHT*3,
						
						children = {
							StackPanel:New{
								height = #widget_children*B_HEIGHT,
								width = window_width-40,
								padding = {0,0,0,0},
								itemPadding = {1,1,1,1},
								itemMargin = {0,0,0,0},					
								children = widget_children,
							},
						},
						anchors = {top=true,left=true,bottom=true,right=true},
					},
					
					Button:New{ 
						caption = 'Close', 
						OnMouseUp = { killWindow2 }, width=window_width-10, 
						backgroundColor=color.sub_close_bg, 
						textColor=color.sub_close_fg, 
						anchors = {bottom=true, right=true,left=true,},
						y = window_height - B_HEIGHT,
					},
				--},
			--},
		},
	}
	
end

local function MakeFlags()
	local countries = {
		'au',
		'br',
		'bz',
		'ca',
		'fi', 
		'fr', 
		'gb',
		'my', 
		'nz',
		'pl',
		'pt',
		'us', 
	}
	local country_langs = {
		br='bp',
		fi='fi', 
		fr='fr', 
		my='my', 
		pl='pl',
		pt='pt',
	}

	local flagChildren = {}
	local flagCount = 0
	for _,country in ipairs(countries) do
		local countryLang = country_langs[country] or 'en'
		flagCount = flagCount + 1
		flagChildren[#flagChildren + 1] = Image:New{ file= LUAUI_DIRNAME .. "Images/flags/".. country ..'.png', }
		flagChildren[#flagChildren + 1] = Button:New{ caption = country:upper(), 
			textColor = color.sub_button_fg,
			backgroundColor = color.sub_button_bg,
			OnMouseUp = { 
				function(self) 
					Spring.Echo('Setting local language to "' .. countryLang .. '"') 
					WG.lang = countryLang 
					settings.lang = countryLang
				end 
			} 
		}
	end
	local window_height = 300
	local window_width = 170
	window_flags = Window:New{  
		x = settings.sub_pos_x,  
		y = settings.sub_pos_y,  
		clientWidth  = window_width,
		clientHeight = window_height,
		parent = screen0,
		backgroundColor = color.sub_bg,
		children = {
			ScrollPanel:New{
				x=0,y=0,
				width  = window_width,
				height = window_height - B_HEIGHT*3 ,
				anchors={top=true, bottom=true, left=true, right=true},
				children = {
					Grid:New{
						columns=2,
						x=0,y=0,
						width=window_width-40,
						height=400,
						children = flagChildren,
					}
				}
			},
			Button:New{ caption = 'Close', OnMouseUp = { killWindow2 }, x=10, y=window_height - B_HEIGHT, width=window_width-20, backgroundColor = color.sub_close_bg, textColor = color.sub_close_fg, anchors={bottom=true, left=true,},},
		}
	}
	
	subwindows[#subwindows + 1] = window_flags
end

local function MakeToolTip(x,y, ttstr, ud, playerName)
	local y = scrH-y
	local x=x
	
	if cycle ~= 1 and window_tooltip and ttstr == old_ttstr then
		if x > scrW * (.75) then
			x = x - window_tooltip.width - 20
		else
			x = x + 20
		end
		if y > scrH * (.75) then
			y = y - window_tooltip.height - 20
		else
			y = y + 20
		end
	
		window_tooltip:SetPos(x,y)
		return
	end
	
	old_ttstr = ttstr
	
	local ttstr = ttstr
	if playerName then
		ttstr = ttstr .. ' (' .. playerName .. ')'
	end
	
	if settings.simple_tooltip or not ud then
		local tt_width = 260
		if not ttstr:find("\n") then
			tt_width = #ttstr*8
		end
		
		local tt_label = TextBox:New{ text = ttstr, textColor=color.tooltip_fg, width=tt_width, align=center }
		tt_label:UpdateLayout()
		
		if x > scrW * (.75) then
			x = x - tt_width - 20
		else
			x = x + 20
		end
		if y > scrH * (.75) then
			y = y - tt_label.height - 20
		else
			y = y + 20
		end
		
		if window_tooltip then
			window_tooltip:Dispose()
		end		
		window_tooltip = Window:New{  
			x = x,  
			y = y,  
			clientWidth  = tt_width,
			clientHeight = tt_label.height, 
			resizable = false,
			draggable = false,
			parent = screen0,
			backgroundColor = color.tooltip_bg, 
			children = { tt_label, }
		}
		return
	
	end
	local blip_size = 18
	
	local tt_children = {}
	local tt_label = Label:New{ caption = ttstr, textColor=color.tooltip_fg,  }
	if ud.iconType ~= 'default' then
		tt_children[#tt_children + 1] = 
			StackPanel:New{
				centerItems = false,
				orientation='horizontal',
				resizeItems=false,
				--width = tt_label.width + blip_size -160,
				height = blip_size + 20,
				padding = {0,0,0,0},
				itemPadding = {1,1,1,1},
				itemMargin = {0,0,0,0},
				children = {
					Image:New{
						file='icons/'.. ud.iconType ..iconFormat,
						height= blip_size,
						width= blip_size,
					},
					tt_label,
				},
			}
		
	else
		tt_children[#tt_children + 1] = tt_label
	end	
	
	local desc_label = Label:New{ caption = ud.tooltip or 'desc error', valign='center', textColor=color.tooltip_fg,  }
	tt_children[#tt_children + 1] = desc_label
	
	
	local _,_,_,buildUnitName = Spring.GetActiveCommand()
	local sc_label 
	if not buildUnitName then
		sc_label = Label:New{ caption = '(Space+click for options)', textColor=color.tooltip_fg,   }
		tt_children[#tt_children+1] = sc_label
	end
	
	local tt_width = tt_label.width
	if desc_label.width > tt_width then
		tt_width = desc_label.width
	end
	if sc_label and sc_label.width > tt_width then
		tt_width = sc_label.width
	end
	local stack_tooltip = StackPanel:New{
		autoArrangeV = false,
		width = tt_width + blip_size + 5,
		height=(#tt_children)*20,
		padding = {0,0,0,0},
		itemPadding = {1,1,1,1},
		itemMargin = {0,0,0,0},
		--resizeItems=false,
		children = tt_children,
	}
	local buildpic = 'unitpics/'.. (ud.buildpicname ~= '' and ud.buildpicname or (ud.name .. '.png'))
	
	local mainstack_height = 55
	if stack_tooltip.height > mainstack_height then
		mainstack_height = stack_tooltip.height
	end
	local mainstack = 
		StackPanel:New{
			orientation='horizontal',
			width  = 55 + stack_tooltip.width + 5,
			height = mainstack_height + 2,
			resizeItems=false,
			padding = {0,0,0,0},
			itemPadding = {1,1,1,1},
			itemMargin = {0,0,0,0},
			children = {
				Image:New{
					file=buildpic,
					height=55,
					width=55,
				},
				stack_tooltip,
			},
		}
	
	if x > scrW * (.75) then
		x = x - mainstack.width - 20
	else
		x = x + 20
	end
	if y > scrH * (.75) then
		y = y - mainstack.height - 20
	else
		y = y + 20
	end
	if window_tooltip then
		window_tooltip:Dispose()
	end
	
	window_tooltip = Window:New{  
		x = x,  
		y = y,  
		clientWidth  = mainstack.width,
		clientHeight = mainstack.height,
		resizable = false,
		draggable = false,
		parent = screen0,
		backgroundColor = color.tooltip_bg, 
		children = {
			mainstack
		},
	}
	
end

local function flattenMenu(tree, first_title)
	local function flattenTree(tree, parent, title)
		if title == 'Game Menu' then
			game_menu_index = flatwindowlistcount+1
		end
		
		if type(tree) == 'table' and #tree == 2 then
			local tree1 = tree[1]
			if tree1:sub(1,3) == 'tr_' 
				or tree1:sub(1,3) == 'ch_' 
				or tree1:sub(1,4) == 'cmf_' 
				then
				
				return tree
			end
		end
	
		if type(tree) == 'table' and #tree > 0 and type(tree[1]) ~= 'table' and type(tree[2]) == 'table' then
			
			local title = tree[1]
			flatwindowlistcount = flatwindowlistcount + 1
			if title == 'Crude Menu' then
				cmsettings_index = flatwindowlistcount
			end
			local curcount = flatwindowlistcount
			local temptree = {}
			for i, subtree in ipairs(tree[2]) do
				temptree[#temptree+1] = flattenTree(subtree, curcount)
			end
			flatwindowlist[curcount] = {parent = parent, tree = temptree, title=title}
			return curcount
		elseif type(tree) == 'table'  and #tree > 0 and type(tree[1]) == 'table' then
			
			flatwindowlistcount = flatwindowlistcount + 1
			local curcount = flatwindowlistcount
			local temptree = {}
			for i, subtree in ipairs(tree) do
				temptree[#temptree+1] = flattenTree(subtree, curcount)
			end
			flatwindowlist[curcount] = {parent = parent, tree = temptree, title=title}
			return curcount
		
		elseif type(tree) == 'table'  and #tree == 2 and type(tree[1]) == 'string' and type(tree[2]) == 'string' then
			
			local title = tree[1]
			flatwindowlistcount = flatwindowlistcount + 1
			local curcount = flatwindowlistcount
						
			flatwindowlist[curcount] = {parent = parent, tree = tree[2], title=title}
			return curcount
		
		else
			return tree
		end
	end
	flattenTree(tree, 0, first_title)
end


flattenMenu(menu_tree, 'Main Menu')
flattenMenu(game_menu_tree, 'Game Menu')

local function ShowWidgetList(self)
	spSendCommands{"luaui selector"} 
end

cmfunctions.ShowWidgetList2 = function(self)
	MakeWidgetList()
	--window_parents[window_widgetlist] = self.parent_index
end

cmfunctions.ShowFlags = function(self)
	MakeFlags()
	--window_parents[window_flags] = self.parent_index
end

local function checkChecks()
end

local function make_menu(num)
	local menu_name = flatwindowlist[num].title
	local tree = flatwindowlist[num].tree
	local parent = flatwindowlist[num].parent
	
	local children = {}
	children[#children + 1] = Label:New{ caption = menu_name, width=150, textColor = color.sub_header,}
	
	local window_height = 0
	local buttonWidth = 0
	if type(tree) == 'string' then
	
		buttonWidth = 200
		window_height = 200
		children[#children + 1] = 
					
			ScrollPanel:New{
				width = 200 ,
				height = 140,
				
				horizontalScrollbar = false,
				children = {
					TextBox:New{
						y=30,
						width =80,height=300,
						text = tree,
						textColor = color.sub_fg,
					},
					
				}				
			}
		
	else
		local charlength = 0
		for _, data in ipairs(tree) do
			local name = 'none'
			if type(data) ~= 'table' then
				name = flatwindowlist[data].title
			else
				name = data[1]
			end
			
			if name and #name > charlength then
				charlength = #name
			end
		end
		
		buttonWidth = charlength*7
		buttonWidth = buttonWidth < 100 and 100 or buttonWidth
		for i, data in ipairs(tree) do

			local name = 'none'
			local action = ''
			if type(data) ~= 'table' then
				name = flatwindowlist[data].title
				action = flatwindowlist[data].tree
			else
				name = data[1]
				action = data[2]
			end
			
			
			if name and not action then
				children[#children + 1] = Label:New{ caption = name, width=buttonWidth,textColor = color.sub_fg,}
			elseif name and name:sub(1,4) == 'cmf_' and action then		
				children[#children + 1] = Button:New{ parent_index = num, caption = name:sub(5), OnMouseUp = {cmfunctions[action]},textColor = color.sub_fg,  backgroundColor = color.sub_button_bg,textColor = color.sub_button_fg,}
			elseif name and name:sub(1,3) == 'ch_' and action then
				children[#children + 1] = Checkbox:New{ caption = name:sub(4), checked = settings[action] or false, OnMouseUp = { function() settings[action] = not settings[action] checkChecks() end },textColor = color.sub_fg,}
			elseif name and name:sub(1,3) == 'tr_' and action then
				children[#children + 1] = Label:New{ caption = name:sub(4), width=buttonWidth,textColor = color.sub_fg,}
				if type(action) == 'table' then
					local action2 = action.action
					local trmin = action.min
					local trmax = action.max
					local trstep = action.step or 1
					children[#children + 1] = Trackbar:New{ OnMouseUp = { action2 },trackColor = color.sub_fg, min=trmin, max=trmax, step=trstep, value=abs(trmax-trmin)/2,}
				else
					children[#children + 1] = Trackbar:New{ OnMouseUp = { action },trackColor = color.sub_fg,}
				end
			elseif name and (type(action) == 'table' and action[1] or type(action) == 'string') then
				children[#children + 1] = Button:New{ caption = name..'...', OnMouseUp = { killSubWindow, function() make_menu(data) end },textColor = color.sub_fg, backgroundColor = color.sub_button_bg,textColor = color.sub_button_fg,}
				
				
			elseif name and action then
				children[#children + 1] = Button:New{ caption =name, OnMouseUp = {action},textColor = color.sub_fg,  backgroundColor = color.sub_button_bg,textColor = color.sub_button_fg,}
			else
				children[#children + 1] = Label:New{ caption = '', width=buttonWidth,textColor = color.sub_fg,}
			end
		end
		
		window_height = (#children + 2) * B_HEIGHT
	end
	children[#children + 1] = Label:New{ caption = '', }
	if parent > 0 then
		window_height = window_height + B_HEIGHT
		children[#children + 1] = Button:New{ caption = 'Back', OnMouseUp = { killSubWindow, function() make_menu(parent) end,  }, backgroundColor = color.sub_back_bg,textColor = color.sub_back_fg, width=buttonWidth}	
	end
	children[#children + 1] = Button:New{ caption = 'Close', OnMouseUp = { killSubWindow }, textColor = color.sub_close_fg, backgroundColor = color.sub_close_bg, width=buttonWidth}
	
	local children_window = {
		StackPanel:New{
			x=0,y=0,
			width  = buttonWidth,
			height = window_height,
			backgroundColor = color.sub_bg,
			children = children,
			padding = {0,0,0,0},
			itemPadding = {0,0,0,0},
			itemMargin = {0,0,0,0},
			autoArrangeV  = false,
			resizeItems=(type(tree) ~= 'string'),
		}
	}
	
	--temporary solution until stackpanels with scrollbars work better.
	if type(tree) == 'string' then
		children_window = children
	end
	
	killSubWindow()
	window_sub_cur = Window:New{  
		x = settings.sub_pos_x,  
		y = settings.sub_pos_y, 
		clientWidth = buttonWidth,
		height = window_height + 10,
		
		resizable = false,
		parent = screen0,
		backgroundColor = color.sub_bg,
		children = children_window
	}
	
end

local function makeCrudeMenu()
	
	if window_crude then
		settings.pos_x = window_crude.x
		settings.pos_y = window_crude.y
		window_crude:Dispose()
	end
	
	local label_title = Label:New{ caption= title_text, textColor=color.main_fg, valign='center', align='center', }
	local label_width = label_title.width
	local button_width = 55
	local crude_width = button_width
	local crude_height = 70
	
	if settings.horizontal then
		crude_width = button_width*2 + label_width + 15
		crude_height = B_HEIGHT + 5
	end
	
	window_crude = Window:New{  
		x = settings.pos_x ,  
		y = settings.pos_y ,
		clientWidth = crude_width,
		clientHeight = crude_height,
		draggable = true,
		resizable = false,
		parent = screen0,
		OnMouseUp = {ShowCrudeMenuSettings},
		backgroundColor = color.main_bg,
		
		children = {
			StackPanel:New{
				orientation = settings.horizontal and 'horizontal' or 'vertical',
				width = crude_width,
				height = crude_height,
				resizeItems = not settings.horizontal or false,
				padding = {0,0,0,0},
				itemPadding = {2,2,2,2},
				itemMargin = {0,0,0,0},
				children = {
					label_title,
					Button:New{caption = "Menu", OnMouseUp = { function() make_menu(1) end, ShowCrudeMenuSettings, }, backgroundColor=color.menu_bg, textColor=color.menu_fg, height=B_HEIGHT, width=button_width, },
					Button:New{caption = "Game", OnMouseUp = { function() make_menu(game_menu_index) end, ShowCrudeMenuSettings,}, backgroundColor=color.game_bg, textColor=color.game_fg, height=B_HEIGHT, width=button_width, },
					
				}
			}
		}
	}
end

checkChecks = function()
	if settings.noVolBar then
		settings.vol_x = window_volume.x
		settings.vol_y = window_volume.y
		hideWindow(window_volume)
	else
		if settings.vol_x < 1 or settings.vol_y < 1 then
			settings.vol_x = 200
			settings.vol_y = 200
		end
		showWindow(window_volume,settings.vol_x,settings.vol_y)
	end
	
	if WG.Layout.hideUnits ~= settings.hideUnits then
		WG.Layout.hideUnits = settings.hideUnits
		Spring.ForceLayoutUpdate()
	end
	makeCrudeMenu()
end


--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
function widget:DrawScreen()
	th.Update()
	gl.PushMatrix()
	local vsx,vsy = gl.GetViewSizes()
	gl.Translate(0,vsy,0)
	gl.Scale(1,-1,1)
	screen0:Draw()
	gl.PopMatrix()
	
	local tooltip, unitName, buildType  = tooltipBreakdown()
	if unitName then
		if not window_tooltip or cycle == 1 or mx ~= old_mx or my ~= old_my then
			local ud = getUdFromName(unitName, tooltip)
			if ud then
				MakeToolTip(mx,my, buildType .. unitName, ud)
			end
		end
	elseif showToolTip then
		if not window_tooltip or cycle == 1 or mx ~= old_mx or my ~= old_my then
			local type, data = spTraceScreenRay(mx, my)
			
			if (type == 'unit') then
			
				local unitID = data
				local udid 			= spGetUnitDefID(unitID)
				local ud 			= UnitDefs[udid]
				if ud then
				
					local alliance 		= spGetUnitAllyTeam(unitID)
					local team			= spGetUnitTeam(unitID)
					local _, player 	= spGetTeamInfo(team)
					local playerName 	= spGetPlayerInfo(player) or 'noname'
					--local teamColor 	= {spGetTeamColor(team)}
					MakeToolTip(mx,my, ud.humanName, ud, playerName)
				end
				
			elseif (type == 'feature') then
				
				local fdid = Spring.GetFeatureDefID(data)
				local fd = fdid and FeatureDefs[fdid]
				local feature_name = fd and fd.name
				if feature_name then
				
					local desc = ''
					if feature_name:find('dead2') then
						desc = ' (debris)'
					elseif feature_name:find('dead') then
						desc = ' (wreckage)'
					end
					local live_name = feature_name:gsub('([^_]*).*', '%1')
					local ud = UnitDefNames[live_name]
					if ud then
						MakeToolTip(mx,my, ud.humanName .. desc, ud)
					else
						MakeToolTip(mx,my, fd.tooltip or feature_name )
					end
				end
			--[[
			elseif window_tooltip then
				window_tooltip:Dispose()
				window_tooltip = nil
				old_ttstr = ''
				--]]
			else
				MakeToolTip(mx,my, tooltip)
			end
		else
			showToolTip = false
		end
	elseif window_tooltip then
		window_tooltip:Dispose()
		window_tooltip = nil
		old_ttstr = ''	
	end
	
end

function widget:Update(dt)
	if (not th) then
		th = Chili.textureHandler
		th.Initialize()
	end
	Chili.TaskHandler.Update()		
	
	
	cycle = cycle%100 + 1
	old_mx, old_my = mx,my
	local _,_,meta,_ = Spring.GetModKeyState()
	mx,my = Spring.GetMouseState()
	if meta then
		showToolTip = true
	elseif not settings.disable_idle_cursor_tooltip then
		if mx == old_mx and my == old_my then
			stillCursorTime = stillCursorTime + dt
		else
			stillCursorTime = 0 
		end
		
		if stillCursorTime > 2 then
			showToolTip = true
		else
			showToolTip = false
		end
		
	end
	
	
end

function widget:IsAbove(x,y)
  if screen0:IsAbove(x,y) then
    return true
  end
end


function widget:MousePress(x,y,button)

	local alt, ctrl, meta, shift = Spring.GetModKeyState()
	local mods = {alt=alt, ctrl=ctrl, meta=meta, shift=shift}
	
	if not settings.noContextClick and meta then
		local tooltip, unitName, buildType = tooltipBreakdown()
		
		if unitName then
			local _,_,_,buildUnitName = Spring.GetActiveCommand()
			if not buildUnitName then
				unitName = unitName:gsub('[^a-zA-Z]', '')
				local ud = getUdFromName(unitName, tooltip)
				MakeStatsWindow(ud,x,y)
				return true
			end
		end
		
		local type, data = spTraceScreenRay(x, y)
		if (type == 'unit') then
			local unitID = data
			MakeUnitContextMenu(unitID,x,y)
			return true
		elseif (type == 'feature') then
			local fdid = Spring.GetFeatureDefID(data)
			local fd = fdid and FeatureDefs[fdid]
			local feature_name = fd and fd.name
			if feature_name then
				local live_name = feature_name:gsub('([^_]*).*', '%1')
				local ud = UnitDefNames[live_name]
				if ud then
					MakeStatsWindow(ud,x,y)
					return true
				end
			end
		end
		
	end
	
	if screen0:MouseDown(x,y,button,mods) then
		return true
	end
	
	if window_unitcontext.visible or window_unitstats.visible then
		hideWindow(window_unitcontext)
		hideWindow(window_unitstats)
		return true
	end
  
end

function widget:MouseRelease(x,y,button)

  local alt, ctrl, meta, shift = Spring.GetModKeyState()
  local mods = {alt=alt, ctrl=ctrl, meta=meta, shift=shift}

  if screen0:MouseUp(x,y,button,mods) then
    return true
  end
  
end

function widget:MouseMove(x,y,dx,dy,button)
  local alt, ctrl, meta, shift = Spring.GetModKeyState()
  local mods = {alt=alt, ctrl=ctrl, meta=meta, shift=shift}

  if screen0:MouseMove(x,y,dx,dy,button,mods) then
    return true
  end

end


function ShowCrudeMenuSettings(self, x,y,button,mods) 
	if mods.meta then
		make_menu(cmsettings_index)
	end
end

function widget:ViewResize(vsx, vsy)
	scrW = vsx
	scrH = vsy
end

function widget:Initialize()
	widget:ViewResize(Spring.GetViewGeometry())
	
	if not settings.pos_x or not settings.vol_x or (settings.pos_x == settings.vol_x and settings.pos_y == settings.vol_y) then
		settings.pos_x = scrW/3
		settings.pos_y = scrH/3
		settings.sub_pos_x = scrW/2
		settings.sub_pos_y = scrH/2
		settings.vol_x = scrW/3
		settings.vol_y = scrH/2
	end
	
	makeCrudeMenu()
	
	window_volume = Window:New{
		x=settings.vol_x,
		y=settings.vol_y,
		height= 32,
		width=110,
		resizable=false,
		parent=screen0,
		OnMouseUp = { ShowCrudeMenuSettings, },
		backgroundColor = color.vol_bg,
		children = {
			Label:New{ caption = 'Vol', width = 20, textColor = color.vol_fg },
			Trackbar:New{
				x=20,
				height=20,
				width=80,
				trackColor = color.vol_fg,
				value = spGetConfigInt("SoundVolume", 50),
				OnMouseUp = { ShowCrudeMenuSettings, function(self)	Spring.SendCommands{"set snd_volmaster " .. self.value} end	},
			},
		}	
	}
	
	checkChecks() 
end

function widget:GetConfigData()
	if not window_crude then return end
	
	settings.pos_x = window_crude.x
	settings.pos_y = window_crude.y
	
	if window_volume.x ~= -1000 then
		settings.vol_x = window_volume.x
		settings.vol_y = window_volume.y
	end
	
	
	local data = settings

	return data
end

function widget:SetConfigData(data)
	if (data and type(data) == 'table') then
		if data.versionmin and data.versionmin >= 50 then
			settings = data
			settings.hideUnits = WG.Layout.hideUnits
			makeCrudeMenu()
			if window_volume then
				window_volume.x = settings.vol_x or 1
				window_volume.y = settings.vol_y or 1
			end
			if window_sub_cur then
				window_sub_cur.x = settings.sub_pos_x or 1
				window_sub_cur.y = settings.sub_pos_y or 1
			end
		end
	end
end