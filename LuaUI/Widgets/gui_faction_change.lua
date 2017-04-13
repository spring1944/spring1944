
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
local spGetSideData = Spring.GetSideData

local amNewbie = (spGetTeamRulesParam(myTeamID, 'isNewbie') == 1)
local mySide = select(5, spGetTeamInfo(myTeamID))

local factionChangeList

--------------------------------------------------------------------------------
-- Functions
--------------------------------------------------------------------------------
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

	return sidedata[teamNum].sideName
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

function FactionChangeList()
	-- Panel
	glColor(0, 0, 0, 0.5)
	glRect(0, 0, 128, 80)
	-- Determine the side
	local side = getTeamName()
	-- Icon
	glColor(1, 1, 1, 1)
	glTexture('sidepics/' .. side .. '.png')
	glTexRect(40, 14, 88, 62)
	glTexture(false)
	-- Text
	glBeginText()
		glText('Change Faction', 64, 64, 12, 'cd')
		glText(side, 64, 0, 12, 'cd')
	glEndText()
end



function widget:MousePress(mx, my, mButton)

	-- Check 3 of the 4 sides
	if mx >= px and mx <= px + 128 and my >= py and my < py + 80 then

		-- Check buttons
		if mButton == 1 then

			-- Spectator check before any action
			if spGetSpectatingState() then
				widgetHandler:RemoveWidget(self)
				return false
			end

			-- Get the next team of the list
			local teamN = getTeamNumber()
			mySide = getTeamNameByNumber(teamN + 1)
			spSendLuaRulesMsg('\138' .. mySide)
			--Remake gui
			if factionChangeList then
				glDeleteList(factionChangeList)
			end
			factionChangeList = glCreateList(FactionChangeList)
			return true
			
		elseif (mButton == 2 or mButton == 3) then
			-- Dragging
			return true
		end
	end
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

