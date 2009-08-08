--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

function widget:GetInfo()
  return {
    name      = "Crude Menu",
    desc      = "v0.62 Crude Chili Menu.",
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
local color, multiweapon, title_text, iconFormat = VFS.Include(file, nil, VFSMODE)

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

local cmfunctions = {}


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
}

local th
local old_ttstr
local old_mx, old_my = -1,-1
local mx, my = -1,-1
local showToolTip =false
local stillCursorTime = 0

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
	return unitDef.customParams and unitDef.customParams['description' .. suffix] or unitDef.customParams.description_en or 'Description error'
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
	
	local helptextbox = TextBox:New{ text = getHelpText(ud, lang), textColor = color.stats_fg, width = 220, } 
	local stackchildrenheight = 80
	if helptextbox.height > 80 then
		stackchildrenheight = helptextbox.height 
	end
	local stackchildren = {
		StackPanel:New{
			padding = {0,0,0,0},
			itemPadding = {0,0,0,0},
			itemMargin = {0,0,0,0},
			height = stackchildrenheight,
			width = 40,
			resizeItems = false,
			children = icons,
		},
		helptextbox,
				
	}
	
	stackchildren[#stackchildren+1] = Label:New{ caption = 'STATS', width = 200, height=20, textColor = color.stats_header,}
	
	stackchildren[#stackchildren+1] = Label:New{ caption = '   Cost: ' .. comma_value(ud.metalCost), width = 200,  textColor = color.stats_fg, height=15}
	stackchildren[#stackchildren+1] = Label:New{ caption = '   Max HP: ' .. comma_value(ud.health), width = 200,  textColor = color.stats_fg, height=15}
	if ud.speed > 0 then
		stackchildren[#stackchildren+1] = Label:New{ caption = '   Speed: ' .. ToSI(ud.speed,2), width = 200,  textColor = color.stats_fg, height=15}
	end
	
	local cells = printWeapons(ud)
	
	if cells and #cells > 0 then
		stackchildren[#stackchildren+1] = Label:New{ caption = '', width = 250,  textColor = color.stats_header,}
		stackchildren[#stackchildren+1] = Label:New{ caption = 'WEAPONS', width = 250,  textColor = color.stats_header,}
		for _,v in ipairs(cells) do
			stackchildren[#stackchildren+1] = Label:New{ caption = v, width = 250,  textColor = color.stats_fg, height=15}
		end
	end
	
	stackchildren[#stackchildren+1] = Label:New{ caption = '--', width = 250,  textColor = color.stats_fg, height=20}
	
	return 
	
	StackPanel:New{
		y=0,
		autoSize = true,
		children = stackchildren,
		padding = {0,0,0,0},
		itemPadding = {0,0,0,0},
		itemMargin = {0,0,0,0},
		resizeItems = false,
	}
end

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

local function SetCursor(cursorSet)
  for _, cursor in ipairs(cursorNames) do
    local topLeft = (cursor == 'cursornormal' and cursorSet ~= 'k_haos_girl')
    Spring.ReplaceMouseCursor(cursor, cursorSet.."/"..cursor, topLeft)
  end
end

local function RestoreCursor()
  for _, cursor in ipairs(cursorNames) do
    local topLeft = (cursor == 'cursornormal')
    Spring.ReplaceMouseCursor(cursor, cursor, topLeft)
  end
end

local function getShortTooltip()
	local tooltip = spGetCurrentTooltip()
	local start,fin = tooltip:find([[ - ]], 1, true) 
	if tooltip:find('Build') == 1 then
		if not start then
			return false
		end
		--return tooltip:gsub('([^-]*)\-.*', '%1'):sub(8,-2), 'Build: ', tooltip:gsub('[^-]*\- (.*)', '%1')
		return tooltip:sub(8,start-1), 'Build: ', tooltip:sub(fin+1)
	elseif tooltip:find('Morph') == 5 then
		return tooltip:gsub('([^(time)]*)\(time).*', '%1'):sub(18), 'Morph to: ', ''
		
	elseif tooltip:find('Selected') == 1 then
		if not start then
			return false
		end
		--return tooltip:gsub('([^-]*)\-.*', '%1'):sub(11,-2), 'Selected: ', tooltip:gsub('[^-]*\- (.*)', '%1')
		return tooltip:sub(11,start-1), 'Selected: ', tooltip:sub(fin+1)
			
	end
	return false, false
	
end

----------------------------------------------------------------

local screen0 = Chili.Screen:New{}
local subwindows = {}
local window_parents = {}
local window_widgetlist
local window_unitcontext = Window:New{ visible=false, parent = screen0, }
local window_unitstats = Window:New{ visible=false, parent = screen0, }
local main_menu_window 
local game_menu_window 
local window_crude 
local window_flags
local window_tooltip
local window_volume 
local window_cmsettings


local function hideWindow(window)
	window.x = -1000
	window.y = -1000
	window.visible = false
end

local function showWindow(window, x, y)
	window.visible = true
	if x then
		window.x = x
		window.y = y
	else
		window.x = settings.sub_pos_x
		window.y = settings.sub_pos_y
	end
end

local function hideAll(self)
	for _, window in ipairs(subwindows) do
		hideWindow(window)
	end
end

local function saveSubPos(self)
	settings.sub_pos_x = self.parent.parent.x
	settings.sub_pos_y = self.parent.parent.y
	--setSubPos()
end
local function saveSubPosSpecial(self)
	settings.sub_pos_x = self.parent.x
	settings.sub_pos_y = self.parent.y
	--setSubPos()
end

local function setSubPos()
	for _, window in ipairs(subwindows) do
		window.x = settings.sub_pos_x
		window.y = settings.sub_pos_y
	end
end

local function MakeStatsWindow(ud, x,y, backbutton)
	hideWindow(window_unitcontext)
	
	local y = scrH-y
	
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
			--y = 0,
			width = window_width - 5,
			height = window_height - B_HEIGHT*4,
			horizontalScrollbar = false,
			children = {
				printunitinfo(ud, settings.lang, buttonWidth)
			},
		},
		(backbutton 
			and Button:New{ 
					caption = 'Back', 
					OnMouseUp = { function(self) hideWindow(self.parent) showWindow(window_unitcontext, x, y) end }, 
					x=0, y=window_height - B_HEIGHT, 
					width=buttonWidth, 
					backgroundColor=color.sub_back_bg, 
					textColor=color.sub_back_fg,
				}
			),
	}
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
					
	local y2 = scrH-y
	if window_unitcontext then
		window_unitcontext:Dispose()
	end
	
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
	
	if ceasefires and myAlliance ~= alliance then
		window_height = window_height + B_HEIGHT*2
		children[#children+1] = Button:New{ caption = 'Vote for ceasefire', OnMouseUp = { function() spSendLuaRulesMsg('cf:y'..alliance) end }, x=0, y=100, width=buttonWidth}
		children[#children+1] = Button:New{ caption = 'Break ceasefire/unvote', OnMouseUp = { function() spSendLuaRulesMsg('cf:n'..alliance) spSendLuaRulesMsg('cf:b'..alliance) end }, x=0, y=120, width=buttonWidth}
	end
	
	window_unitcontext = Window:New{  
		x = x,  
		y = y2,  
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
			Label:New{ 
				caption = catdesc, x=20, y = i * B_HEIGHT, width=buttonWidth, textColor = color.sub_header,
				anchors = {top=true,left=true,bottom=true,right=true},
			}
		
		for _, wdata in ipairs(catwidgets) do
			i=i+1
			widget_children[#widget_children + 1] = Checkbox:New{ 
					x = 20, 
					y = i * B_HEIGHT, 
					caption = wdata.name_display, 
					width=buttonWidth-30, 
					checked = wdata.active,
					textColor = color.sub_fg,
					OnMouseUp = { function() widgetHandler:ToggleWidget(wdata.name)end },
					anchors = {top=true,left=true,bottom=true,right=true},
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
			ScrollPanel:New{
				x = 0,
				y = 0,
				width = window_width - 10,
				height = window_height - B_HEIGHT*3,
				children = widget_children,
				anchors = {top=true,left=true,bottom=true,right=true},
				
			},
			Button:New{ caption = 'Back', OnMouseUp = { function() showWindow(window_parents[window_widgetlist]) hideWindow(window_widgetlist) end  }, x=10, y=window_height - B_HEIGHT*2, width=buttonWidth, backgroundColor=color.sub_back_bg, textColor=color.sub_back_fg, anchors = {bottom=true, },},
			Button:New{ caption = 'Close', OnMouseUp = { function() hideWindow(window_widgetlist) end}, x=10, y=window_height - B_HEIGHT, width=buttonWidth, backgroundColor=color.sub_close_bg, textColor=color.sub_close_fg, anchors = {bottom=true},},
			
		}
	}
	
end

local function MakeToolTip(x,y, ttstr, ud, playerName)
	local y = scrH-y
	
	if cycle ~= 1 and window_tooltip and ttstr == old_ttstr then
		window_tooltip.x = x
		window_tooltip.y = y
		return
	end
	old_ttstr = ttstr

	if window_tooltip then
		window_tooltip:Dispose()
	end
	
	local ttstr = ttstr
	if playerName then
		ttstr = ttstr .. ' (' .. playerName .. ')'
	end
	
	local text_count = #ttstr
	
	if settings.simple_tooltip or not ud then
		local tt_width = text_count * 7
		window_tooltip = Window:New{  
			x = x,  
			y = y,  
			clientWidth  = tt_width,
			clientHeight = 15,
			resizable = false,
			draggable = false,
			parent = screen0,
			backgroundColor = color.tooltip_bg, 
			children = {
				Label:New{ caption = ttstr, width=tt_width, height='10', textColor=color.tooltip_fg, valign='center'},
			}
		}
		return
	
	end
	if text_count < #(ud.tooltip) then
		text_count = #(ud.tooltip)
	end
	if text_count < 25 then
		text_count = 25
	end
	local tt_width = text_count * 6
	local blip_size = 18
	
	local tt_children = {}
	if ud.iconType ~= 'default' then
		tt_children[#tt_children + 1] = 
			Image:New{
				file='icons/'.. ud.iconType ..iconFormat,
				height= blip_size,
				width= blip_size,
			}
	end	
	tt_children[#tt_children + 1] = Label:New{ caption = ttstr, width=tt_width, height='10', textColor=color.tooltip_fg,  }
	tt_children[#tt_children + 1] = Label:New{ caption = ud.tooltip or 'desc error', width=tt_width, height='10',valign='center', textColor=color.tooltip_fg,  }
	
	
	local _,_,_,buildUnitName = Spring.GetActiveCommand()
	if not buildUnitName then
		tt_children[#tt_children+1] = Label:New{ caption = '(Space+click for options)', width=tt_width, height='10',align='right', textColor=color.tooltip_fg,   }
	end
	
	local stack_tooltip = StackPanel:New{
		width=tt_width + blip_size + 5,
		height=(#tt_children-1)*10 + blip_size,
		padding = {0,0,0,0},
		itemPadding = {1,1,1,1},
		itemMargin = {0,0,0,0},
		resizeItems=false,
		children = tt_children,
	}
	
	local buildpic = 'unitpics/'.. (ud.buildpicname ~= '' and ud.buildpicname or (ud.name .. '.png'))
	local window_height = 60
	local window_width = stack_tooltip.width + window_height
	window_tooltip = Window:New{  
		x = x,  
		y = y,  
		clientWidth  = window_width,
		clientHeight = window_height,
		resizable = false,
		draggable = false,
		parent = screen0,
		backgroundColor = color.tooltip_bg, 
		children = {
			StackPanel:New{
				orientation='horizontal',
				width  = window_width,
				height = window_height,
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
			},
		},
	}

end

local file2 = LUAUI_DIRNAME .. "Configs/crudemenu_tree.lua"
local menu_tree, game_menu_tree = VFS.Include(file2, nil, VFSMODE)

local function ShowWidgetList(self)
	spSendCommands{"luaui selector"} 
end

cmfunctions.ShowWidgetList2 = function(self)
	saveSubPos(self)
	hideWindow(self.parent.parent)
	MakeWidgetList()
	window_parents[window_widgetlist] = self.parent.parent --oogly
end


cmfunctions.ShowFlags = function(self)
	saveSubPos(self)
	hideWindow(self.parent.parent)
	window_parents[window_flags] = self.parent.parent --oogly
	showWindow(window_flags)
end


local function makeCrudeMenu()
	
	if window_crude then
		settings.pos_x = window_crude.x
		settings.pos_y = window_crude.y
		window_crude:Dispose()
	end
	
	local label_width = #title_text*7
	if label_width < 55 then
		label_width = 55
	end	
	local button_width = label_width
	local crude_width = button_width + 5
	local crude_height = 70
	
	if settings.horizontal then
		button_width = 50
		crude_width = 100 + label_width + 10
		crude_height = B_HEIGHT + 4
	end
	
	window_crude = Window:New{  
		x = settings.pos_x ,  
		y = settings.pos_y ,
		--width = 80,
		--height = 80,
		clientWidth = crude_width,
		clientHeight = crude_height,
		draggable = true,
		resizable = false,
		parent = screen0,
		OnMouseUp = {ShowCrudeMenuSettings},
		backgroundColor = color.main_bg,
		
		
		children = {
			StackPanel:New{
				width = crude_width,
				height = crude_height,
				resizeItems = false,
				padding = {1,1,1,1},
				itemPadding = {1,1,1,1},
				itemMargin = {0,0,0,0},		
				children = {
					Label:New{ caption= title_text, textColor=color.main_fg, height=B_HEIGHT, width=label_width, valign='center', align='center', },
					Button:New{caption = "Menu", OnMouseUp = { function() hideAll() showWindow(main_menu_window) end, ShowCrudeMenuSettings, }, backgroundColor=color.menu_bg, textColor=color.menu_fg, height=B_HEIGHT, width=button_width, },
					Button:New{caption = "Game", OnMouseUp = { function() hideAll() showWindow(game_menu_window) end, ShowCrudeMenuSettings,}, backgroundColor=color.game_bg, textColor=color.game_fg, height=B_HEIGHT, width=button_width, align='center'},
					
				}
			}
		}
	}
end
local function checkChecks()
	if settings.noVolBar then
		settings.vol_x = window_volume.x
		settings.vol_y = window_volume.y
		window_volume.x = -1000
		window_volume.y = -1000
		window_volume.visible = false
	else
		if settings.vol_x < 1 or settings.vol_y < 1 then
			settings.vol_x = 1
			settings.vol_y = 1
		end
		window_volume.x = settings.vol_x
		window_volume.y = settings.vol_y
		window_volume.visible = true
	end
	
	if WG.Layout.hideUnits ~= settings.hideUnits then
		WG.Layout.hideUnits = settings.hideUnits
		Spring.ForceLayoutUpdate()
	end
	makeCrudeMenu()
end

local function make_menu(menu_name, tree, previous_window)
	
	local children = {}
	children[#children + 1] = Label:New{ caption = menu_name, width=150, textColor = color.sub_header,}
	
	local parent_id = #window_parents+1
	window_parents[parent_id] = true
	
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
						width =100,height=300,
						text = tree,
						textColor = color.sub_fg,
					},
					
				}				
			}
		
	else
		local charlength = 0
		for _, data in ipairs(tree) do
			local name = data[1]
			if name and #name > charlength then
				charlength = #name
			end
		end
		buttonWidth = charlength*7
		buttonWidth = buttonWidth < 100 and 100 or buttonWidth
		for i, data in ipairs(tree) do
			local name = data[1]
			local action = data[2]
			if name and not action then
				children[#children + 1] = Label:New{ caption = name, width=buttonWidth,textColor = color.sub_fg,}
			elseif name and name:sub(1,4) == 'cmf_' and action then
				children[#children + 1] = Button:New{ caption = name:sub(5), OnMouseUp = {cmfunctions[action]},textColor = color.sub_fg,  backgroundColor = color.sub_button_bg,textColor = color.sub_button_fg,}
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
				local subwindow = make_menu(name, action, parent_id)
				children[#children + 1] = Button:New{ caption = name..'...', OnMouseUp = {saveSubPos, hideAll,  function() showWindow(subwindow) end },textColor = color.sub_fg, backgroundColor = color.sub_button_bg,textColor = color.sub_button_fg,}
			elseif name and action then
				children[#children + 1] = Button:New{ caption =name, OnMouseUp = {action},textColor = color.sub_fg,  backgroundColor = color.sub_button_bg,textColor = color.sub_button_fg,}
			else
				children[#children + 1] = Label:New{ caption = '', width=buttonWidth,textColor = color.sub_fg,}
			end
		end
		
		window_height = (#children + 2) * B_HEIGHT
	end
	children[#children + 1] = Label:New{ caption = '', }
	if previous_window then
		window_height = window_height + B_HEIGHT
		children[#children + 1] = Button:New{ caption = 'Back', OnMouseUp = {saveSubPos, hideAll,  function() showWindow(window_parents[previous_window]) end }, backgroundColor = color.sub_back_bg,textColor = color.sub_back_fg, }
		
		--temporary solution until stackpanels with scrollbars work better.
		if type(tree) == 'string' then
			children[#children] = Button:New{ caption = 'Back', OnMouseUp = {saveSubPosSpecial, hideAll, function() showWindow(window_parents[previous_window]) end },textColor = color.sub_back_fg, backgroundColor = color.sub_back_bg,textColor = color.sub_back_fg, }
		end
			
	end
	children[#children + 1] = Button:New{ caption = 'Close', OnMouseUp = {saveSubPos, hideAll }, textColor = color.sub_close_fg, backgroundColor = color.sub_close_bg,}
	
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
	
	local window_return = Window:New{  
		x = settings.sub_pos_x,  
		y = settings.sub_pos_y, 
		width = buttonWidth + 10,
		height = window_height + 10,
		
		resizable = false,
		parent = screen0,
		backgroundColor = color.sub_bg,
		children = children_window
	}
	window_parents[parent_id] = window_return
	subwindows[#subwindows+1] = window_return
	
	if menu_name == 'Crude Menu' then
		window_cmsettings = window_return
	end
	return window_return
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
function widget:DrawScreen()
	if (not th) then
		th = Chili.textureHandler
		th.Initialize()
	end

	th.Update()

	gl.PushMatrix()
	local vsx,vsy = gl.GetViewSizes()
	gl.Translate(0,vsy,0)
	gl.Scale(1,-1,1)
	screen0:Draw()
	
	local unitName, buildType, tooltip = getShortTooltip()
	if unitName then
		if not window_tooltip or cycle == 1 or mx ~= old_mx or my ~= old_my then
			local ud = getUdFromName(unitName, tooltip)
			if ud then
				MakeToolTip(mx+20,my-20, buildType .. unitName, ud)
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
					MakeToolTip(mx+20,my-20, ud.humanName, ud, playerName)
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
						MakeToolTip(mx+20,my-20, ud.humanName .. desc, ud)
					else
						MakeToolTip(mx+20,my-20, fd.tooltip or feature_name )
					end
				end
				
			elseif window_tooltip then
				window_tooltip:Dispose()
				window_tooltip = nil
				old_ttstr = ''
			end
		else
			showToolTip = false
		end
	elseif window_tooltip then
		window_tooltip:Dispose()
		window_tooltip = nil
		old_ttstr = ''	
	end
	
	gl.PopMatrix()
end

function widget:Update(dt)
	cycle = cycle%100 + 1
	old_mx, old_my = mx,my
	local _,_,meta,_ = Spring.GetModKeyState()
	mx,my = Spring.GetMouseState()
	if meta then
		showToolTip = true
	else
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

function widget:MousePress(x,y,button)

	local alt, ctrl, meta, shift = Spring.GetModKeyState()
	local mods = {alt=alt, ctrl=ctrl, meta=meta, shift=shift}
	
	if not settings.noContextClick and meta then
		--local unitName = getShortTooltip()
		local unitName, buildType, tooltip = getShortTooltip()
		
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

function widget:MouseMove(x,y,dx,dy,...)

	local alt, ctrl, meta, shift = Spring.GetModKeyState()
	local mods = {alt=alt, ctrl=ctrl, meta=meta, shift=shift}

	if screen0:MouseMove(x,y,dx,dy,button,mods) then
		return true
	end

end


function ShowCrudeMenuSettings(self, x,y,button,mods) 
	if mods.meta then
		hideAll()
		showWindow(window_cmsettings)
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
	
	main_menu_window = make_menu('Main Menu', menu_tree)
	game_menu_window = make_menu('Game Menu', game_menu_tree)
	
	makeCrudeMenu()
	
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
	local window_height = 230
	local window_width = 150
	window_flags = Window:New{  
		x = settings.sub_pos_x,  
		y = settings.sub_pos_y,  
		clientWidth  = window_width,
		clientHeight = window_height,
		resizable = false,
		parent = screen0,
		backgroundColor = color.sub_bg,
		children = {
			ScrollPanel:New{
				x=0,y=0,
				width  = window_width,
				height = window_height - B_HEIGHT*3 ,
				horizontalScrollbar = false,
				children = {
					Grid:New{
						columns=2,
						x=0,y=0,
						width=140,
						height=400,
						children = flagChildren
					}
				}
			},
			Button:New{ caption = 'Back', OnMouseUp = { saveSubPosSpecial, hideAll,  function() showWindow(window_parents[window_flags]) end }, x=10, y=window_height - B_HEIGHT*2, width=window_width-20, backgroundColor = color.sub_back_bg, textColor = color.sub_back_fg, },
			Button:New{ caption = 'Close', OnMouseUp = { saveSubPosSpecial, function(self) hideWindow(self.parent) end }, x=10, y=window_height - B_HEIGHT, width=window_width-20, backgroundColor = color.sub_close_bg, textColor = color.sub_close_fg,},
		}
	}
	
	subwindows[#subwindows + 1] = window_flags
	
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
	hideAll()
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
				window_volume.x = settings.vol_x
				window_volume.y = settings.vol_y
			end
			
		end
	end
	--setSubPos()
end