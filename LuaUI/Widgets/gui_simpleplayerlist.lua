-------------------------------------------------------------------------------
--           DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
--                   Version 2, December 2004
--
--Copyright (C) 2009 BrainDamage
--Everyone is permitted to copy and distribute verbatim or modified
--copies of this license document, and changing it is allowed as long
--as the name is changed.
--
--           DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
--  TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION
--
-- 0. You just DO WHAT THE FUCK YOU WANT TO.
-------------------------------------------------------------------------------

function widget:GetInfo()
	return {
		name      = "Simple player list",
		desc      = "/info replacement in lua",
		author    = "BrainDamage",
		date      = "e^(-i*pi)",
		license   = "WTFPL",
		layer     = 0,
		enabled   = true,
	}
end

local FONT_SIZE = Spring.GetConfigInt( "SmallFontSize", 14 )
local VERTICAL_LINE_SPACING = 1
local HORIZONTAL_COLUMN_SPACING = 2
local BACKGROUND_COLOUR = { 0.2, 0.2, 0.2, Spring.GetConfigInt( "GuiOpacity", 0.3 ) }
local HEADING_COLOUR = { 1, 1, 1 }
local HIDESPECTATORS = false

local GetLocalPlayerID = Spring.GetLocalPlayerID
local GetLocalTeamID = Spring.GetLocalTeamID
local GetLocalAllyTeamID = Spring.GetLocalAllyTeamID
local GetPlayerRoster = Spring.GetPlayerRoster
local GetTeamColor = Spring.GetTeamColor
local ArePlayersAllied = Spring.ArePlayersAllied
local AreTeamsAllied = Spring.AreTeamsAllied
local IsGUIHidden = Spring.IsGUIHidden
local GetSpectatingState = Spring.GetSpectatingState

local glCreateList = gl.CreateList
local glCallList = gl.CallList
local glDeleteList = gl.DeleteList
local glPopMatrix = gl.PopMatrix
local glPushMatrix = gl.PushMatrix
local glTranslate = gl.Translate
local glScale = gl.Scale
local glGetTextWidth = gl.GetTextWidth
local glColor = gl.Color
local glRect = gl.Rect
local glText = gl.Text
local glGetViewSizes = gl.GetViewSizes
local glPolygonMode = gl.PolygonMode
local GL_FILL = GL.FILL
local GL_FRONT_AND_BACK = GL.FRONT_AND_BACK
local GL_LINE_STRIP = GL.LINE_STRIP

local max = math.max
local min = math.min
local ceil = math.ceil
local floor = math.floor
local sqrt = math.sqrt
local char = string.char

local name_heading = "Name"
local ping_heading = "Ping"
local cpu_heading = "Cpu"
local status_heading = " *"
local team_heading = "ID"
local ally_text = "A"
local enemy_text = "E"
local ceasefire_incoming_text = "T>"
local ceasefire_outgoing_text = "T<"
local ceasefire_bidirectional_text = "T="
local spectator_text = "S"
local name_size = glGetTextWidth(name_heading) * FONT_SIZE
local ping_size = glGetTextWidth(ping_heading) * FONT_SIZE
local cpu_size = glGetTextWidth(cpu_heading) * FONT_SIZE
local status_size = glGetTextWidth(status_heading) * FONT_SIZE
local team_size = glGetTextWidth(team_heading) * FONT_SIZE
local maxscreenx, maxscreeny = glGetViewSizes()
local sizemultiplier = sqrt( maxscreenx * maxscreeny ) / 1000
local columnsizes = { team_size, status_size, name_size, cpu_size, ping_size }
local topleftx = 0
local toplefty = 0
local bottomrightx = maxscreenx
local bottomrighty = 0
local playerlist
local count = 0
local sorting = Spring.GetConfigInt( "ShowPlayerInfo", 1 )
local myplayerid = GetLocalPlayerID()
local myteamid = GetLocalTeamID()
local myallyteamid = GetLocalAllyTeamID()


function widget:Initialize()
	-- disable default player roster
	Spring.SendCommands({"info 0"})
end

function widget:Shutdown()
	-- enable default player roster
	Spring.SendCommands({"info " .. sorting})
end

function getFontStyle(playerColor)
	local luminance  = (playerColor[1] * 0.299) + (playerColor[2] * 0.587) + (playerColor[3] * 0.114)
	if (luminance > 0.25) then
		-- black outline
		playerFontStyle = "o"
	else
		-- white outline
		playerFontStyle = "O"
	end
	return playerFontStyle
end

function convertColour(colorarray)
	local red = ceil(colorarray[1]*255)
	local green = ceil(colorarray[2]*255)
	local blue = ceil(colorarray[3]*255)
	red = max( red, 1 )
	green = max( green, 1 )
	blue = max( blue, 1 )
	red = min( red, 255 )
	green = min( green, 255 )
	blue = min( blue, 255 )
	return char(255,red,green,blue)
end

-- this function wants a value between 0 and 100 and fades colour from green to yellow to red accordingly
local function GetColourScale ( value )
	local colour = { 0, 1, 0, 1 }
	colour[1] = min( 50, value ) / 50
	colour[2] = 1 - ( max( 0, value - 50 ) / 50 )
	return colour
end

local function GetPingColour( ping )
	ping = max( 0, ping - 100 )
	ping = min( 1000, ping )
	ping = ping / 10
	return GetColourScale( ping )
end

local function GetCpuColour( cpu )
	return GetColourScale ( cpu )
end

local function RoundNumber( number)
	return floor ( number + 0.5 )
end

function widget:ViewResize(viewSizeX, viewSizeY)
    bottomrightx = viewSizeX
end

local function RefreshPlayerList(sortmode)
	if ( sortmode == nil ) then
		sortmode = 1
	end
	
	myplayerid = GetLocalPlayerID()
	myteamid = GetLocalTeamID()
	myallyteamid = GetLocalAllyTeamID()
	
	playerlist = GetPlayerRoster( sortmode )
	if ( playerlist == nil ) then
		return
	end
	
	-- fill plotting table with headers
	local headingcolourcode = convertColour( HEADING_COLOUR ) 
	local headingstyle = getFontStyle( HEADING_COLOUR ) .. "d"
	local playerlisttable = {}
	playerlisttable[1] = { { headingcolourcode .. team_heading, headingstyle }, { headingcolourcode .. status_heading, headingstyle }, { headingcolourcode .. name_heading, headingstyle }, { headingcolourcode .. cpu_heading, headingstyle }, { headingcolourcode .. ping_heading, headingstyle } }
	
	local tablecopy = playerlist -- used to safely remove elements
	local removedelements = 0
	-- get max sizes for each column, and fill table to plot
	columnsizes = { team_size, status_size, name_size, cpu_size, ping_size }
	for index,player in ipairs( playerlist ) do
		local spectator = player[5]
		if ( spectator ~= 0 and HIDESPECTATORS == true ) then
			table.remove( tablecopy, index - removedelements )
			removedelements = removedelements + 1
		else
			local team = player[3]
			local playerid = player[2]
			local allyteamid = player[4]
			local colour = {GetTeamColor( team )}
			local teamcolourcode = convertColour( colour ) 
			local teamstyle = getFontStyle ( colour ) .. "d"
			local name = player[1]
			local cpu = RoundNumber( player[6] * 100 )
			local cpucolour = GetCpuColour( cpu )
			local cpucolourcode = convertColour( cpucolour ) 
			local cpustyle = getFontStyle( cpucolour ) .. "d"
			local ping = RoundNumber( player[7] * 1000 )
			local pingcolour = GetPingColour( ping )
			local pingcolourcode = convertColour( pingcolour )
			local pingstyle = getFontStyle( pingcolour ) .. "d"
			local allystring = ""
			if ( spectator ~= 0 ) then -- spectator flag in GetPlayerRoster uses c/c++ convention for true/false
				allystring = spectator_text
			else
				if ( myallyteamid == allyteamid ) then
					allystring = ally_text
				else
					if ( AreTeamsAllied( team, myteamid ) == true ) then
						if ( AreTeamsAllied( myteamid, team ) == true ) then
							allystring = ceasefire_bidirectional_text
						else
							allystring = ceasefire_outgoing_text
						end
					else
						if ( AreTeamsAllied( myteamid, team ) == true ) then
							allystring = ceasefire_incoming_text
						else
							allystring = enemy_text
						end
					end
				end
			end

			columnsizes[1] = max( columnsizes[1], glGetTextWidth(team) * FONT_SIZE )
			columnsizes[2] = max( columnsizes[2], glGetTextWidth(allystring) * FONT_SIZE )
			columnsizes[3] = max( columnsizes[3], glGetTextWidth(name) * FONT_SIZE )
			columnsizes[4] = max( columnsizes[4], glGetTextWidth(cpu) * FONT_SIZE )
			columnsizes[5] = max( columnsizes[5], glGetTextWidth(ping) * FONT_SIZE )
		
			playerlisttable[index + 1] = { { teamcolourcode .. team, teamstyle }, { teamcolourcode .. allystring, teamstyle }, { teamcolourcode .. name, teamstyle }, { cpucolourcode .. cpu, cpustyle }, { pingcolourcode .. ping, pingstyle } }
		end		
	end
	playerlist = tablecopy
	
	local totalheight = #playerlist * ( FONT_SIZE + VERTICAL_LINE_SPACING )
	local totalwidth = 0
	for index, size in ipairs( columnsizes ) do
		totalwidth = totalwidth + size + HORIZONTAL_COLUMN_SPACING
	end
	
	topleftx = bottomrightx - totalwidth
	toplefty = bottomrighty + totalheight
	
	return playerlisttable
end

local function DrawPlayerList(playertable)
	if ( playertable == nil ) then
		return
	end
	
	-- draw background box
	glPolygonMode(GL_FRONT_AND_BACK, GL_FILL)
	glColor( BACKGROUND_COLOUR )
	glRect( topleftx, toplefty, bottomrightx, bottomrighty )
	
	-- draw text table
	local currentliney = toplefty 
	local currentlinex = topleftx
	for _, lineelements in ipairs( playertable ) do
		currentlinex = topleftx
		for column, cellelement in ipairs( lineelements ) do
			glText( cellelement[1], currentlinex, currentliney, FONT_SIZE , cellelement[2] )
			currentlinex = currentlinex + columnsizes[column] + HORIZONTAL_COLUMN_SPACING
		end
		currentliney = currentliney - FONT_SIZE - VERTICAL_LINE_SPACING
	end
end

function widget:DrawScreen()
	if IsGUIHidden() then
		return
	end
	local playertable = RefreshPlayerList(sorting)
	DrawPlayerList(playertable)
end

local function TranslateMouseCoordinatesToTable( mx, my )
	if ( mx > topleftx and my < ( toplefty + FONT_SIZE + VERTICAL_LINE_SPACING ) and mx < bottomrightx and my > bottomrighty ) then
		-- find the line
		local line = #playerlist - floor( my / ( FONT_SIZE + VERTICAL_LINE_SPACING ) )
		-- find the column
		local column = nil
		mx = mx - topleftx
		for index, size in ipairs( columnsizes ) do
			if ( mx < size ) then
				column = index
				break
			end
			mx = mx - size - HORIZONTAL_COLUMN_SPACING
		end
		return line,column
	else
		return
	end
end

function widget:MousePress(mx,my,mb)
	if IsGUIHidden() then
		return false
	end
	if ( mb ~= 1 and mb ~= 2 ) then
		return false
	end
	local line, column = TranslateMouseCoordinatesToTable( mx, my )
	-- is it within the widget area
	if ( line == nil or column == nil ) then
		return false
	end
	--hitting the header
	if ( line < 1 ) then
		local columnremap = { 2, 1, 3, 4, 5 } -- sort by: team, ally, name, cpu, ping
		sorting = columnremap[column]
		return true
	else
		local amispectator = GetSpectatingState()
		local selectedplayer = playerlist[line]
		local selectedplayerid = selectedplayer[2]
		local selectedteam = selectedplayer[3]
		local selectedally = selectedplayer[4]
		local selectedname = selectedplayer[1]
		local selectedspectator = selectedplayer[5]
		-- team column:	switch to spec the team  if spectating
		if ( column == 1 ) then
			if ( mb == 1 ) then
				if ( amispectator == true ) then
					if ( selectedspectator == 0 ) then -- spectator flag in GetPlayerRoster uses c/c++ convention for true/false
						Spring.SendCommands({ "specteam " .. selectedteam })
						return true
					end
				end
			end
		-- status column: toggle ally if you're a player
		elseif ( column == 2 ) then
			if ( mb == 1 ) then
				if ( amispectator == false ) then
					if ( selectedspectator == 0 ) then -- spectator flag in GetPlayerRoster uses c/c++ convention for true/false
						if ( myallyteamid ~= selectedally ) then
							local switchally = 1
							if ( AreTeamsAllied( selectedteam, myteamid ) == true ) then
								switchally = 0
							end
							Spring.SendCommands({ "ally " .. selectedteam .. " " .. switchally })
							return true
						end
					end
				end
			end
		-- name column: send PM to player or share units
		elseif ( column == 3 ) then
			if ( mb == 1 ) then -- left click
				if ( amispectator == false or selectedspectator ~= 0 ) then -- spectator flag in GetPlayerRoster uses c/c++ convention for true/false
					if ( selectedplayerid ~= myplayerid ) then -- don't whisper to yourself
						Spring.SendCommands({ "chatall", "pastetext /w " .. selectedname .. " >", })
						return true
					end
				end
			elseif ( mb == 2 ) then -- mid click
				if ( amispectator == false and selectedspectator == 0 ) then -- spectator flag in GetPlayerRoster uses c/c++ convention for true/false
					if ( selectedteam ~= myteamid ) then -- don't give units to your own team
						local selunitcount = Spring.GetSelectedUnitsCount()
						local selectedunits = Spring.GetSelectedUnits()
						Spring.ShareResources(selectedteam, "units")
						Spring.SendCommands({ "chatall", "w " .. selectedname .. " I gave you " .. selunitcount .. " units.", })
						for _,unitid in ipairs(selectedunits) do
							local ux,uy,uz = Spring.GetUnitPosition(unitid)
							Spring.MarkerAddPoint(ux,uy,uz)
						end
						return true
					end
				end
			end
		end
	end
	return false
end
