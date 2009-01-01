local versionNumber = "v1.0"

function widget:GetInfo()
	return {
		name = "1944 Resource Bars",
		desc = versionNumber .. " Custom resource bars for Spring 1944",
		author = "Evil4Zerggin",
		date = "1 January 2009",
		license = "GNU LGPL, v2.1 or later",
		layer = 1,
		enabled = false
	}
end

------------------------------------------------
--config
------------------------------------------------
local lineWidth = 1
local mainScale = 24

------------------------------------------------
--speedups
------------------------------------------------

local GetMouseState = Spring.GetMouseState
local GetMyTeamID = Spring.GetMyTeamID
local GetTeamResources = Spring.GetTeamResources
local SetShareLevel = Spring.SetShareLevel

local glColor = gl.Color
local glLineWidth = gl.LineWidth
local glRect = gl.Rect
local glCreateList = gl.CreateList
local glCallList = gl.CallList
local glDeleteList = gl.DeleteList
local glPolygonMode = gl.PolygonMode
local glShape = gl.Shape
local glTranslate = gl.Translate
local glScale = gl.Scale
local glLoadIdentity = gl.LoadIdentity
local glPopMatrix = gl.PopMatrix
local glPushMatrix = gl.PushMatrix
local glText = gl.Text
local GL_LINE = GL.LINE
local GL_FILL = GL.FILL
local GL_FRONT_AND_BACK = GL.FRONT_AND_BACK
local GL_QUADS = GL.QUADS
local GL_TRIANGLE_FAN = GL.TRIANGLE_FAN
local GL_LINE_LOOP = GL.LINE_LOOP

local abs = math.abs
local ceil = math.ceil
local floor = math.floor
local min = math.min
local max = math.max
local strFormat = string.format

------------------------------------------------
--vars
------------------------------------------------
local once
local starDisplayList, bulletsDisplayList, shareDisplayList
local mainX, mainY
local vsx, vsy
local activeClick = false

local resupplyString = "?"
local resupplyResourceUpdates = 0
local resupplyPeriod = 300 -- default to 5 minutes

------------------------------------------------
--util
------------------------------------------------

local function ToSI(num)
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

local function ToPercent(num)
  return strFormat("%.2f%%", num * 100)
end

local function FramesToTimeString(n)
	local seconds = n / 30
	return strFormat(floor(seconds / 60) .. ":" .. strFormat("%02i", ceil(seconds % 60)))
end

------------------------------------------------
--display lists
------------------------------------------------

--size (-1, -1) to (1, 1)
local function DisplayListStar()
	local vertices = {
		{v = {0, 0, 0}},
		
		{v = {0, 1, 0}},
		{v = {0.29, 0.4, 0}},
		{v = {0.95, 0.31, 0}},
		{v = {0.48, -0.15, 0}},
		{v = {0.59, -0.81, 0}},
		{v = {0, -0.5, 0}},
		{v = {-0.59, -0.81, 0}},
		{v = {-0.48, -0.15, 0}},
		{v = {-0.95, 0.31, 0}},
		{v = {-0.29, 0.4, 0}},
		{v = {0, 1, 0}},
	}
	glLineWidth(2)
	glShape(GL_TRIANGLE_FAN, vertices)
end

--size (-1, -1) to (1, 1)
local function DisplayListBullet()
	local vertices = {
		{v = {-0.1, -1, 0}},
		{v = {0.1, -1, 0}},
		{v = {0.1, -0.9, 0}},
		{v = {-0.1, -0.9, 0}},
		
		{v = {-0.1, -0.8, 0}},
		{v = {0.1, -0.8, 0}},
		{v = {0.1, 0, 0}},
		{v = {-0.1, 0, 0}},
		
		{v = {-0.1, 0, 0}},
		{v = {0.1, 0, 0}},
		{v = {0.08, 0.4, 0}},
		{v = {-0.08, 0.4, 0}},
		
		{v = {-0.07, 0.4, 0}},
		{v = {0.07, 0.4, 0}},
		{v = {0.05, 0.8, 0}},
		{v = {-0.05, 0.8, 0}},
		
		{v = {-0.05, 0.8, 0}},
		{v = {0.05, 0.8, 0}},
		{v = {0.01, 1, 0}},
		{v = {-0.01, 1, 0}},
	}
	glLineWidth(1)
	glShape(GL_QUADS, vertices)
end


--size (-1, -1) to (1, 1)
local function DisplayListBullets()
	glPushMatrix()
	
	DisplayListBullet()
	glTranslate(-0.5, 0, 0)
	DisplayListBullet()
	glTranslate(1, 0, 0)
	DisplayListBullet()
	
	glPopMatrix()
end

--size (-1, -1) to (1, 1) relative to resource bar
local function DisplayListShare()
	local verticesBottom = {
		{v = {0, -0.25, 0}},
		{v = {-0.03125, -0.75, 0}},
		{v = {0.03125, -0.75, 0}},
	}
	
	local verticesTop = {
		{v = {0, 0.25, 0}},
		{v = {0.03125, 0.75, 0}},
		{v = {-0.03125, 0.75, 0}},
	}
	glLineWidth(2)
	glShape(GL_LINE_LOOP, verticesBottom)
	glShape(GL_LINE_LOOP, verticesTop)
end

local function CreateDisplayLists()
	starDisplayList = glCreateList(DisplayListStar)
	bulletsDisplayList = glCreateList(DisplayListBullets)
	shareDisplayList = glCreateList(DisplayListShare)
end

local function DeleteDisplayLists()
	glDeleteList(starDisplayList)
	glDeleteList(bulletsDisplayList)
	glDeleteList(shareDisplayList)
end

------------------------------------------------
--click
------------------------------------------------
local function MainTransform(x, y)
	return (x - vsx) / mainScale + 22, (y - vsy) / mainScale + 1
end

local function GetMShare(tx)
	local result = (tx + 18) / 16
	result = max(result, 0)
	result = min(result, 1)
	return result
end

local function GetEShare(tx)
	local result = (tx - 2) / 16
	result = max(result, 0)
	result = min(result, 1)
	return result
end

local function GetComponent(x, y)
	local tx, ty = MainTransform(x, y)
	
	if (ty > 1 or ty < -1) then return end
	
	if (tx >= -18 and tx <= -2) then
		return "mShare"
	elseif (tx >= 2 and tx <= 18) then
		return "eShare"
	end
end

local function DrawActiveClick()
	if (not activeClick) then return end
	
	local mx, my = GetMouseState()
	local tx, ty = MainTransform(mx, my)
	if (activeClick == "mShare") then
		local newShare = GetMShare(tx)
		local text = "\255\255\255\255Set Command share to " .. ToPercent(newShare)
		glText(text, tx, ty, 1.5, "r")
		glPushMatrix()
			glColor(1, 1, 1, 1)
			glTranslate(-18, 0, 0)
			glScale(16, 1, 1)
			glTranslate(newShare, 0, 0)
			glCallList(shareDisplayList)
		glPopMatrix()
	elseif (activeClick == "eShare") then
		local newShare = GetEShare(tx)
		local text = "\255\255\255\255Set Logistics share to " .. ToPercent(newShare)
		glText(text, tx, ty, 1.5, "r")
		glPushMatrix()
			glColor(1, 1, 1, 1)
			glTranslate(2, 0, 0)
			glScale(16, 1, 1)
			glTranslate(newShare, 0, 0)
			glCallList(shareDisplayList)
		glPopMatrix()
	end
end

local function ReleaseActiveClick(x, y)
	local tx, ty = MainTransform(x, y)
	
	if (activeClick == "mShare") then
		SetShareLevel("metal", GetMShare(tx))
	elseif (activeClick == "eShare") then
		SetShareLevel("energy", GetEShare(tx))
	end
		
	activeClick = false
end

------------------------------------------------
--drawing
------------------------------------------------

local function ShareColor(sent, reci)
	if (sent > 0) then
		if (reci > 0) then
			glColor(1, 1, 0, 1)
		else
			glColor(1, 0, 0, 1)
		end
	elseif (reci > 0) then
		glColor(0, 1, 0, 1)
	else
		glColor(0.5, 0.5, 0.5, 1)
	end
end

--main drawing function; size (-20, -1) to (20, 1)
local function DrawMain()
	--background
	glPolygonMode(GL_FRONT_AND_BACK, GL_FILL)
	glColor(0.5, 0.5, 0.5, 0.5)
	glRect(-20, -1, 20, 1)
	glColor(0, 0, 0, 1)
	glRect(-18, -0.25, -2, 0.25)
	glRect(2, -0.25, 18, 0.25)
	
	glPolygonMode(GL_FRONT_AND_BACK, GL_LINE)
	--star icon
	glPushMatrix()
		glTranslate(-19, 0, 0)
		glColor(0.75, 0.75, 0.75, 1)
		glCallList(starDisplayList)
	glPopMatrix()
	
	--bullet icon
	glPushMatrix()
		glColor(1, 1, 0, 1)
		glTranslate(1, 0, 0)
		glCallList(bulletsDisplayList)
	glPopMatrix()
	
	--resources
	local myTeamID = GetMyTeamID()
	local mCurr, mStor, mPull, mInco, mExpe, mShar, mSent, mReci = GetTeamResources(myTeamID, "metal")
	local eCurr, eStor, ePull, eInco, eExpe, eShar, eSent, eReci = GetTeamResources(myTeamID, "energy")
	
	local estimatedRemainingE = max(eCurr - resupplyResourceUpdates * ePull, 0)
	
	glPolygonMode(GL_FRONT_AND_BACK, GL_FILL)
	
	--command
	glPushMatrix()
		glColor(0.75, 0.75, 0.75, 1)
		glTranslate(-18, 0, 0)
		glScale(16, 1, 1)
		glRect(0, -0.25, mCurr / mStor, 0.25)
		glPushMatrix()
			ShareColor(mSent, mReci)
			glTranslate(mShar, 0, 0)
			glCallList(shareDisplayList)
		glPopMatrix()
	glPopMatrix()
	
	--current text
	glPushMatrix()
		glTranslate(-10, -1.1, 0)
		glText("\255\192\192\192Command: \255\255\255\255" .. ToSI(mCurr), 0, 0, 0.75, "c")
	glPopMatrix()
	
	--max text
	glPushMatrix()
		glTranslate(-2, -0.475, 0)
		glText("\255\255\255\255" .. ToSI(mStor), 0, 0, 0.75)
	glPopMatrix()
	
	--change text
	glPushMatrix()
		glTranslate(-10, 0.15, 0)
		glText("\255\1\255\1+" .. ToSI(mInco) .. " \255\255\1\1-" .. ToSI(mPull), 0, 0, 0.75, "c")
	glPopMatrix()
	
	--logistics
	glPushMatrix()
		glTranslate(2, 0, 0)
		glScale(16, 1, 1)
		glColor(1, 1, 0, 1)
		glRect(0, -0.25, eCurr / eStor, 0.25)
		glColor(1, 0, 0, 1)
		glRect(estimatedRemainingE / eStor, -0.25, eCurr / eStor, 0.25)
		glPushMatrix()
			glTranslate(eShar, 0, 0)
			ShareColor(eSent, eReci)
			glCallList(shareDisplayList)
		glPopMatrix()
	glPopMatrix()
	
	--current text
	glPushMatrix()
		glTranslate(10, -1.1, 0)
		glText("\255\255\255\1Logistics: \255\255\255\255" .. ToSI(eCurr), 0, 0, 0.75, "c")
	glPopMatrix()
	
	--max text
	glPushMatrix()
		glTranslate(18, -0.475, 0)
		glText("\255\255\255\255" .. ToSI(eStor), 0, 0, 0.75)
	glPopMatrix()
	
	--change text
	glPushMatrix()
		glTranslate(10, 0.15, 0)
		glText("\255\255\1\1-" .. ToSI(mPull) .. " \255\255\255\255(Resupply in " .. resupplyString .. ")", 0, 0, 0.75, "c")
	glPopMatrix()
	
	DrawActiveClick()
end

------------------------------------------------
--callins
------------------------------------------------
function widget:Initialize()
	CreateDisplayLists()
	Spring.SendCommands("resbar 0")
	once = true
end

function widget:ViewResize(viewSizeX, viewSizeY)
	vsx = viewSizeX
	vsy = viewSizeY
end

function widget:UnitCreated(unitID, unitDefID, unitTeam, builderID)
	local unitDef = UnitDefs[unitDefID]
	if (unitDef.customParams.hq == '1') then
		resupplyPeriod = tonumber(unitDef.customParams.arrivalgap) * 30
	end
end

function widget:GameFrame(n)
	resupplyString = FramesToTimeString(resupplyPeriod - n % resupplyPeriod)
	resupplyResourceUpdates = ceil((resupplyPeriod - n % resupplyPeriod) / 32)
end

function widget:Shutdown()
	DeleteDisplayLists()
	Spring.SendCommands("resbar 1")
end

function widget:DrawScreen()
	if (once) then
		local viewSizeX, viewSizeY = widgetHandler:GetViewSizes()
		widget:ViewResize(viewSizeX, viewSizeY)
		once = false
	end
	
	glPushMatrix()
		glTranslate(vsx - mainScale * 22, vsy - mainScale, 0)
		glScale(mainScale, mainScale, 1)
		DrawMain()
	glPopMatrix()
	
	glLineWidth(1)
end

function widget:MousePress(x, y, button)
  local component = GetComponent(x, y)
  if (component) then
    activeClick = component
    return true
  end
  return false
end

function widget:MouseRelease(x, y, button)
  if (activeClick) then
    ReleaseActiveClick(x, y)
    return true
  end
  return false
end

