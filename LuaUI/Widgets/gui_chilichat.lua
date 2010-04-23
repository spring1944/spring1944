--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

function widget:GetInfo()
  return {
    name      = "Chili Chat Beta",
    desc      = "v0.31 Chili Chat Console.",
    author    = "CarRepairer",
    date      = "2009-07-07",
    license   = "GNU GPL, v2 or later",
    layer     = 0,
    enabled   = false
  }
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
local spSendCommands			= Spring.SendCommands

local abs						= math.abs

local echo = Spring.Echo

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

local Chili = VFS.Include(LUAUI_DIRNAME.."Widgets/chiligui/chiligui.lua")
local Button = Chili.Button
local Label = Chili.Label
local Colorbars = Chili.Colorbars
local Checkbox = Chili.Checkbox
local Window = Chili.Window
local ScrollPanel = Chili.ScrollPanel
local StackPanel = Chili.StackPanel
local Grid = Chili.Grid
--local LayoutPanel = Chili.LayoutPanel

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

local lines = {'Loading...'}
local lines_count = 0
local scrollbuffer = 150
local intbuffer = 160
local MIN_HEIGHT = 130
local MIN_WIDTH = 450

local def_settings = {
	minversion = 21,
	pos_x = 110,
	pos_y = 20,
	c_width = MIN_WIDTH,
	c_height = MIN_HEIGHT,
	
	col_bg = {0, 0, 0, 0.3},
	col_text = {1, 1, 1, 1},
	
	col_dup_in = '\255\180\80\80',
	col_text_in = '\255\255\255\255',
	col_othertext_in = '\255\180\180\180',	
	col_ally_in = '\255\80\255\80',	
	
	noColorName = false,
	
	hideSpec = false,
	hideAlly = false,
	hidePoint = false,
	hideLabel = false,
	
}
local settings = def_settings

local allowUpdate = true
local remakeSoon = false
local cycle = 1
local longcycle = 1
local screen0 = Chili.Screen:New{}
local th
local freeze = true

local rightmargin = 35
local pad = 7

local window_console, window_settings
local scroll_last_max = -1
local last_h = -1
local last_w = -1
local text_height = 10

local playernames = {}
local colorNames = {}
local colors = {}

local scrW, scrH
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

local function color2incolor(r,g,b,a)
	local colortable = {r,g,b,a}
	if type(r) == 'table' then
		colortable = r
	end
	local r,g,b,a = unpack(colortable)			
	if r == 0 then r = 0.01 end
	if g == 0 then g = 0.01 end
	if b == 0 then b = 0.01 end
	--if a == 0 then a = 0.01 end --seems transparent is bad in label text
	a = 1
	
	local inColor = '\255\255\255\255'
	if r then
		inColor = string.char(a*255) .. string.char(r*255) ..  string.char(g*255) .. string.char(b*255)
	end
	return inColor
end
local function incolor2color(inColor)
	
	--local a = string.byte(inColor:sub(1,1))
	local a = 255
	local r = string.byte(inColor:sub(2,2))
	local g = string.byte(inColor:sub(3,3))
	local b = string.byte(inColor:sub(4,4))
	color = {r/255, g/255, b/255, a/255}
	
	return color
end

local function setColorNames()
	for name,_ in pairs(playernames) do
		if settings.noColorName then
			colorNames[name] = colors[name] .. '<' .. settings.col_text_in .. name .. colors[name] .. '>  ' .. settings.col_text_in
		else
			colorNames[name] = colors[name] .. '<' ..  name .. '>  ' .. settings.col_text_in
		end
		
	end
end

local function setColorText(self) 
	settings.col_text_in = color2incolor(self.color) 
	settings.col_text = self.color
	setColorNames()
end
local function setColorAllyText(self) 
	settings.col_ally_in = color2incolor(self.color)
end
local function setColorOtherText(self) 
	settings.col_othertext_in = color2incolor(self.color)
end
local function setColorDup(self) 
	settings.col_dup_in = color2incolor(self.color)
end
local function setColorBg(self) 
	settings.col_bg = self.color
end

local function reset()
	settings = def_settings
	window_console.x = settings.pos_x
	window_console.y = settings.pos_y
	window_console.width = settings.c_width
	window_console.height = settings.c_height
end

local function makeSettingsWindow()
	if window_settings then
		window_settings:Dispose()
	end

	window_console.draggable = true
	window_console.resizable = true
	freeze = false	
	
	local window_height = 360
	local window_width = 250
	
	local caption_width = 130
	
	window_settings = Window:New{  
		x = 200,  
		y = 200,
		clientWidth  = window_width,
		clientHeight = window_height,
		parent = screen0,
		resizable = false,
		backgroundColor = {0.5, .5, .5, 1},
		children = {
			StackPanel:New{
				width  = window_width,
				height = window_height,
				resizeItems=false,
				padding = {0,0,0,0},
				itemPadding = {0,2,0,0},
				itemMargin = {0,0,0,0},
				columns = 1,
				
				children = {
					StackPanel:New{
						width  = window_width,
						height = 100,
						children = {
							Label:New{caption='Console Settings', textColor={1,1,1,1}},
							Label:New{caption='You can resize and move the chat window', },
							Label:New{caption='while this window is open',  },
							Label:New{caption='',  },
							Checkbox:New{
								caption=[[Don't Color Name]], 
								checked = settings.noColorName or false, 
								OnMouseUp = { function(self) settings.noColorName = self.checked end},  
								width=caption_width+50,
							},
							Label:New{caption='Adjust Console Colors', },
						},
					},
					
					
					Grid:New{
						width  = window_width,
						height = 200,
						columns=2,
						--resizeItems=false,
						
						children = {					
							Label:New{caption='Chat Text', },
							Colorbars:New{ OnMouseUp = {setColorText}, color=settings.col_text},
							
							Label:New{caption='Ally Text', },
							Colorbars:New{ OnMouseUp = {setColorAllyText}, color=incolor2color(settings.col_ally_in)},
							
							Label:New{caption='Other Text', },
							Colorbars:New{ OnMouseUp = {setColorOtherText}, color=incolor2color(settings.col_othertext_in)},
							
							Label:New{caption='Duplicate Text', },
							Colorbars:New{ OnMouseUp = {setColorDup}, color=incolor2color(settings.col_dup_in)},
							
							Label:New{caption='Background', },
							Colorbars:New{ OnMouseUp = {setColorBg}, color=settings.col_bg},
						},
					},
					Button:New{caption="Reset", OnMouseUp = {reset}, width=window_width },
					Button:New{caption="Close", 
						OnMouseUp = {
							function(self) 
								window_settings:Dispose() 
								window_console.draggable = false
								window_console.resizable = false
								freeze = true
							end
						} , width=window_width 
					},
				},
			},
		},
	}
end

local function makeNewConsole(x, y, w, h, scroll_cur)
	remakeSoon = false
	
	local h=h
	if h < MIN_HEIGHT then
		h = MIN_HEIGHT
	end
	local w = w
	if w < MIN_WIDTH then
		w = MIN_WIDTH
	end
	if x+w > scrW then
		x = scrW - w
	end
	
	local lines_tb = {}
	local lines_tb_count = 0
	local bufflen = lines_count < scrollbuffer and lines_count or scrollbuffer
	
	for i = 1, bufflen do
		local line = lines[lines_count-bufflen+i]
		local showLine = true
		if (line.mtype == "spectatormessage" and settings.hideSpec)
			or (line.mtype == "allymessage" and settings.hideAlly) 
			or (line.mtype == "playerpoint" and settings.hidePoint) 
			or (line.mtype == "playerlabel" and settings.hideLabel)
			then
			
			showLine = false
		end
		if showLine then
			local text = (line.dup > 1 and (settings.col_dup_in.. line.dup ..'x '.. settings.col_text_in) or settings.col_text_in)..line.text
			
			--lines_tb[i] = 
			lines_tb_count = lines_tb_count + 1
			lines_tb[lines_tb_count] = 
				Label:New{
				width = w-rightmargin,
				height = text_height,
				textColor = settings.col_text,
				caption = text,
			}
		end
	end	
	local children_console = StackPanel:New{
		width = w-rightmargin,
		height = bufflen*(text_height+pad ),
		padding = {0,0,0,0},
		itemPadding = {0,pad ,0,0},
		itemMargin = {0,0,0,0},
		autoArrangeV  = false,
		--resizeItems = false,
		children = lines_tb, 
	}
	
	local cur_max = children_console.height
	local scroll_y = scroll_cur
	--why less than h? I don't know.
	if abs(scroll_last_max - scroll_cur) < h or last_w ~= w or last_h ~= h then
		scroll_y = cur_max - h + 10 --why do I need -h? I don't know.
		--echo ('here', scroll_y, scroll_cur)
	end
	
	scroll_last_max = cur_max
	window_console = Window:New{  
		x = x,  
		y = y,
		width  = w,
		height = h,
		parent = screen0,
		backgroundColor = settings.col_bg,
		draggable = not freeze,
		resizable = not freeze,
		minimumSize = {MIN_WIDTH, MIN_HEIGHT },
		OnMouseUp = {
			function(self, x,y,button,mods) 
				if mods.meta then
					makeSettingsWindow()
				end
			end
		},
		children = {
			ScrollPanel:New{
				x = 0,
				y = 0,
				width = w-rightmargin,
				height = h-10,
				horizontalScrollbar = false,
				scrollPosY = scroll_y,
				--children = {children_console}, --strange
				children = lines_tb, --strange
				anchors = {right=true, left=true, top=true, bottom=true},
			},
			StackPanel:New{
				x=w-rightmargin+3,
				y=0,
				width=rightmargin-12,
				--width=rightmargin,
				height = h-10,
				
				padding = {0,0,0,0},
				itemPadding = {0,2,0,0},
				itemMargin = {0,0,0,0},
				anchors = {right=true, top=true, },
				resizeItems=false,
				children = {
					Button:New{
						width=rightmargin-12,
						caption = '!',
						OnMouseUp = {makeSettingsWindow},
					},
					Checkbox:New{
						width=rightmargin-12,
						caption = 'A',
						textColor = settings.col_text,
						checked = not settings.hideAlly,
						OnMouseUp = {function(self) settings.hideAlly = not self.checked echo('Ally Chat: ' .. (self.checked and 'show' or 'hide')) end},
					},
					Checkbox:New{
						width=rightmargin-12,
						caption = 'S',
						textColor = settings.col_text,
						checked = not settings.hideSpec,
						OnMouseUp = {function(self) settings.hideSpec = not self.checked echo('Spec Chat: ' .. (self.checked and 'show' or 'hide')) end},
					},
					Checkbox:New{
						width=rightmargin-12,
						caption = 'P',
						textColor = settings.col_text,
						checked = not settings.hidePoint,
						OnMouseUp = {function(self) settings.hidePoint = not self.checked echo('Points: ' .. (self.checked and 'show' or 'hide')) end},
					},
					Checkbox:New{
						width=rightmargin-12,
						caption = 'L',
						textColor = settings.col_text,
						checked = not settings.hideLabel,
						OnMouseUp = {function(self) settings.hideLabel = not self.checked echo('Labels: ' .. (self.checked and 'show' or 'hide')) end},
					},
				},
			},
		}
	}
	last_w = w
	last_h = h
	
end

local function remakeConsole()
	local x,y = window_console.x, window_console.y
	local w,h = window_console.width, window_console.height
	local scroll_cur = window_console.children[1].scrollPosY
	window_console:Dispose()
	makeNewConsole(x, y, w, h, scroll_cur)
end

local function addLine(msg)
	if lines_count>0 and lines[lines_count].msg == msg then
		lines[lines_count].dup = lines[lines_count].dup + 1
		return
	end
	local msgtype
	local message = msg
	local playername

	--adapted from lolui, removed the lol
	if (playernames[msg:sub(2,(msg:find("> Allies: ") or 1)-1)]) then
		msgtype = "allymessage"
		playername = msg:sub(2,msg:find("> ")-1)
		message = msg:sub(playername:len()+12)
		message = (playername and colorNames[playername] or '') .. settings.col_ally_in .. message
		
	elseif (playernames[msg:sub(2,(msg:find("> ") or 1)-1)]) then
		msgtype = "playermessage"
		playername = msg:sub(2,msg:find("> ")-1)
		message = msg:sub(playername:len()+4)
		message = (playername and colorNames[playername] or '') .. message
	
	elseif (playernames[msg:sub(2,(msg:find("] ") or 1)-1)]) then
		msgtype = "spectatormessage"
		playername = msg:sub(2,msg:find("] ")-1)
		message = msg:sub(playername:len()+4)
		message = settings.col_othertext_in..'  ['.. settings.col_text_in .. playername ..settings.col_othertext_in .. ']  '.. settings.col_text_in .. message
		
	elseif (playernames[msg:sub(2,(msg:find("(replay)") or 3)-3)]) then
		msgtype = "spectatormessage"
		playername = msg:sub(2,msg:find("(replay)")-3)
		message = msg:sub(playername:len()+13)
		message = '  (r)['.. playername ..'] '.. message
		
	elseif (playernames[msg:sub(1,(msg:find(" added point: ") or 1)-1)]) then
		playername = msg:sub(1,msg:find(" added point: ")-1)
		message = msg:sub(string.len(playername.." added point: ")+1)
		if message == '' then
			msgtype = "playerpoint"
			message = colors[playername] .. '* '.. settings.col_ally_in .. (playername or '') .. ' added a point.'
		else
			msgtype = "playerlabel"
			message = colors[playername] .. '*L '.. settings.col_ally_in .. (playername or '') .. ' added a label: ' .. message
		end
	
	elseif (msg:sub(1,1) == ">") then
		msgtype = "gamemessage"
		message = msg:sub(3)
		message = settings.col_othertext_in .. '> ' .. message
	else
		msgtype = "other"
		message = settings.col_othertext_in ..  message
	end
	
	lines_count = lines_count + 1
	lines[lines_count] = { msg=msg, text=message, dup=1, mtype=msgtype, player=playername}
	
	if lines_count > intbuffer then
		lines_count = intbuffer
		table.remove(lines, 1)
	end
	remakeSoon = true
end
local function setup()
	local myallyteamid = Spring.GetMyAllyTeamID()
	local playerroster = Spring.GetPlayerRoster()
	local playercount = #playerroster
	for i=1,playercount do
		local teamID = playerroster[i][3]
		local playerID = playerroster[i][2]
		local name = playerroster[i][1]
		playernames[name] = {playerroster[i][4],playerroster[i][5], teamID}
		
		local inColor = color2incolor(Spring.GetTeamColor(teamID))
		colors[name] = inColor
	end
	setColorNames()
	spSendCommands({"console 0"})
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
end


function widget:MousePress(x,y,button)
	local alt, ctrl, meta, shift = Spring.GetModKeyState()
	local mods = {alt=alt, ctrl=ctrl, meta=meta, shift=shift}
	
	if screen0:MouseDown(x,y,button,mods) then
		allowUpdate = false
		return true
	end	
end

function widget:MouseRelease(x,y,button)
	local alt, ctrl, meta, shift = Spring.GetModKeyState()
	local mods = {alt=alt, ctrl=ctrl, meta=meta, shift=shift}
	allowUpdate = true
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

function widget:AddConsoleLine(line,priority)
	addLine(line)
end

local inColors = {}

function widget:Update()
  if (not th) then
    th = Chili.textureHandler
    th.Initialize()
  end
	cycle = cycle % (8) + 1	
	longcycle = longcycle % (32*2) + 1	
	if longcycle == 1 then
		setup()
		if allowUpdate then
			remakeConsole()
		end 
	elseif (cycle == 1 and remakeSoon) then
		if allowUpdate then
			remakeConsole()
		end 
	end


  Chili.TaskHandler.Update()
end

function widget:IsAbove(x,y)
  if screen0:IsAbove(x,y) then
    return true
  end
end

function widget:SetConfigData(data)
	
	if data.minversion and data.minversion >= 21 then
		
		if (data and type(data) == 'table') then
			settings = data
			if window_console then
				window_console.x = settings.pos_x
				window_console.y = settings.pos_y
				window_console.width = settings.c_width
				window_console.height = settings.c_height
			end
		end
	end
	
end
function widget:GetConfigData()
	if not window_console then return end
	settings.pos_x=window_console.x
	settings.pos_y=window_console.y
	settings.c_width=window_console.width
	settings.c_height=window_console.height
	
	local data = settings
	return data
end

function widget:Shutdown()
	spSendCommands({"console 1"})
end

function widget:ViewResize(vsx, vsy)
	scrW = vsx
	scrH = vsy
end

function widget:Initialize()
	widget:ViewResize(Spring.GetViewGeometry())
	makeNewConsole(settings.pos_x, settings.pos_y, settings.c_width, settings.c_height, -1)
	setup()
end
