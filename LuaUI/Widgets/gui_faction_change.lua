
function widget:GetInfo()
	return {
		name	= 'Faction Change',
		desc	= 'Adds button to switch faction',
		author	= 'Niobium (addapted to s44 by Jose Luis Cercos-Pita)',
		date	= 'May 2011',
		license	= 'GNU GPL v2',
		layer	= -100,
		enabled	= true,
	}
end

--------------------------------------------------------------------------------
-- Var
--------------------------------------------------------------------------------
local wWidth, wHeight = Spring.GetWindowGeometry()
local px, py = 50, 0.55*wHeight

--------------------------------------------------------------------------------
-- Speedups
--------------------------------------------------------------------------------
local teamList = Spring.GetTeamList()
local myTeamID = Spring.GetMyTeamID()

local glTexCoord = gl.TexCoord
local glVertex = gl.Vertex
local glColor = gl.Color
local glRect = gl.Rect
local glTexture = gl.Texture
local glTexRect = gl.TexRect
local glDepthTest = gl.DepthTest
local glBeginEnd = gl.BeginEnd
local GL_QUADS = GL.QUADS
local GL_TRIANGLE_FAN = GL.TRIANGLE_FAN
local glPushMatrix = gl.PushMatrix
local glPopMatrix = gl.PopMatrix
local glTranslate = gl.Translate
local glBeginText = gl.BeginText
local glEndText = gl.EndText
local glText = gl.Text
local glCallList = gl.CallList
local glCreateList = gl.CreateList
local glDeleteList = gl.DeleteList

local spGetTeamStartPosition = Spring.GetTeamStartPosition
local spGetTeamInfo = Spring.GetTeamInfo
local spGetTeamRulesParam = Spring.GetTeamRulesParam
local spSetTeamRulesParam = Spring.SetTeamRulesParam
local spGetGroundHeight = Spring.GetGroundHeight
local spSendLuaRulesMsg = Spring.SendLuaRulesMsg
local spGetSpectatingState = Spring.GetSpectatingState
-- local spGetSideData = Spring.GetSideData  -- Overloaded by a custom sidedata

local amNewbie = (spGetTeamRulesParam(myTeamID, 'isNewbie') == 1)
local mySide = select(5, spGetTeamInfo(myTeamID))

local factionChangeList

local RADIUS = 128
local SIDEDATA = {
	[1] = {
		sideName	= "random team (gm)",
		description = "Random team"
	},
    -- Axis
	[2] = {
		sideName	= "ger",
		description = "        Germany\n\nWell balanced\nfaction, with strong\ntanks and army"
	},
	[3] = {
		sideName	= "jpn",
		description = "            Japan\n\nProbably the most\npowerful faction at\nthe early stages\nof the battle"
	},
	[4] = {
		sideName	= "ita",
		description = "                 Italy\n\nVery good infantry,\nconveniently supported\nby gun trucks"
	},
	[5] = {
		sideName	= "hun",
		description = "           Hungary\n\nVery competitive at\nair and sea, with\nsome aces at terrain,\nlike Nimrod and TAS"
	},
    -- Allies
	[6] = {
		sideName	= "gbr",
		description = "  United Kingdom\n\nDeploy infantry\neverywhere with\nGliders and sneak\ncommandos in\nenemy lines"
	},
	[7] = {
		sideName	= "rus",
		description = "             USSR\n\nSmash your enemies\nwith your T34 tanks\nand the infantry\nsupport"
	},
	[8] = {
		sideName	= "us",
		description = "           USA\n\nEnjoy the great\nSherman armour\nand infiltrate the\n101 airborne\nparatroopers"
	},
    -- Neutral
	[9] = {
		sideName	= "swe",
		description = "         Sweden\n\nDominate the sea\nand pack up your\nfactories if\nneeded"
	},
    --[[
	[10] = {
		sideName	= "fin",
		description = "Finland\n\n???????"
	},
    --]]
}
local N_AXIS = 4
local N_ALLIES = 3
local N_NEUTRAL = 2  -- Random team is considered neutral


--------------------------------------------------------------------------------
-- Functions
--------------------------------------------------------------------------------
function spGetSideData()
    return SIDEDATA
end

function getTeamName()
	local side = mySide
	if side == "" then
		side = "random team (gm)"
	end
	return side
end

function getTeamNumber()
	local side = getTeamName()
	local sidedata = spGetSideData()
	for i=1,#sidedata do
		if side == sidedata[i].sideName then
			return i
		end
	end

	-- Error, return 0, and let's see
	return 0
end

function getTeamNameByNumber(teamNum)
	local sidedata = spGetSideData()
	while teamNum < 1 do
		teamNum = teamNum + #sidedata
	end
	while teamNum > #sidedata do
		teamNum = teamNum - #sidedata
	end

	local side = sidedata[teamNum].sideName
    -- Convert the "OVNI" into a random team
    if side == "random team (gm)" then
        side = ""
    end
    return side
end

function readAll(file)
    local f = io.open(file, "rb")
    local content = f:read("*all")
    f:close()
    return content
end

--------------------------------------------------------------------------------
-- Callins
--------------------------------------------------------------------------------
function widget:Initialize()
	if spGetSpectatingState() or
	   Spring.GetGameFrame() > 0 or
	   amNewbie then
		widgetHandler:RemoveWidget(self)
	end
	-- Check that game_setup.lua has a faction already set
	spSendLuaRulesMsg('\138' .. mySide)
end

function widget:DrawScreen()

	-- Spectator check
	if spGetSpectatingState() then
		widgetHandler:RemoveWidget(self)
		return
	end

	-- Positioning
	glPushMatrix()
	glTranslate(px, py, 0)
	--call list
	if factionChangeList then
		glCallList(factionChangeList)
	else 
		factionChangeList = glCreateList(FactionChangeList)
	end
	glPopMatrix()

	
end

function DrawCircle()
	local n = 32
    local r = RADIUS
	glVertex(r, r)

    for i=0,n do
		glVertex(
            r + (r * math.cos(i * 2.0 * math.pi / n)), 
		    r + (r * math.sin(i * 2.0 * math.pi / n))
		)
	end
end

function FactionChangeList()
	-- Panel
	glColor(0, 0, 0, 0.5)
	glBeginEnd(GL_TRIANGLE_FAN, DrawCircle)

    -- Teams
	local sidedata = spGetSideData()
    local selTeam = getTeamNumber()
    local R = RADIUS
    local n = #sidedata
    local r = math.pi * R / n
	glColor(1, 1, 1, 1)
	for i=1,n do
        x = R + ((R - 0.7 * r) * math.sin((i-1) * 2.0 * math.pi / n))
        y = R + ((R - 0.7 * r) * math.cos((i-1) * 2.0 * math.pi / n))
	    glTexture('LuaUI/Widgets/faction_change/' .. sidedata[i].sideName .. '.png')
	    glTexRect(x - 0.5 * r, y - 0.5 * r,
                  x + 0.5 * r, y + 0.5 * r)
	    glTexture(false)
		if selTeam == i then
	        glTexture('LuaUI/Widgets/faction_change/Selected Team.png')
	        glTexRect(x - 0.5 * r, y - 0.5 * r,
                      x + 0.5 * r, y + 0.5 * r)
	        glTexture(false)
		end
	end

	-- Determine the side
	local side = getTeamNumber()
	-- Add a description
	glBeginText()
		glText(sidedata[side].description, R, R, 12, 'cv')
	glEndText()
end



function widget:MousePress(mx, my, mButton)

    -- Check we are on the circle
    local R = RADIUS
    local rx = mx - (px + R)
    local ry = my - (py + R)
    if rx*rx + ry*ry >= R*R then
        return true
    end

    if (mButton == 2 or mButton == 3) then
		-- Dragging
		return true
    end

	-- Spectator check before any action
	if spGetSpectatingState() then
		widgetHandler:RemoveWidget(self)
		return false
	end

    -- Check if we are selecting a new team
	local sidedata = spGetSideData()
    local n = #sidedata
    local r = math.pi * R / n
    if rx*rx + ry*ry <= (R - 1.4*r)*(R - 1.4*r) then
        return true
    end

    -- Get the new team
    local da = 2.0 * math.pi / n
    local a = math.atan2(rx, ry) + 0.5 * da
    local i = math.floor(a / da) + 1
    mySide = getTeamNameByNumber(i)
    spSendLuaRulesMsg('\138' .. mySide)
	if factionChangeList then
		glDeleteList(factionChangeList)
	end
	factionChangeList = glCreateList(FactionChangeList)
	return true
end

function widget:MouseMove(mx, my, dx, dy, mButton)
	-- Dragging
	if mButton == 2 or mButton == 3 then
		px = px + dx
		py = py + dy
	end
end

function widget:GameStart()
	widgetHandler:RemoveWidget(self)
end

