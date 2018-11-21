local versionNumber = "v2.1"

function widget:GetInfo()
	return {
		name = "1944 Resource Bars",
		desc = versionNumber .. " Custom resource bars for Spring 1944",
		author = "Evil4Zerggin",
		date = "11 July 2009",
		license = "GNU LGPL, v2.1 or later",
		layer = 1,
		enabled = true,
	}
end

------------------------------------------------
--constants
------------------------------------------------
local mainScaleHeight = 0.045 --height as a proportion of screen height; sets the overall scale of things
local mainScaleWidth = 0.75 --width as a proportion of screen width

local barHeight = 0.125

local endLength = 1.5

local IMAGE_DIRNAME = LUAUI_DIRNAME .. "Images/Bitmaps/"
local FONT_FILE = LUAUI_DIRNAME .. "Fonts/cmuntb.otf"

------------------------------------------------
--locals
------------------------------------------------
local vsx, vsy --viewsize
local mainSize --size in pixels
local mainWidth --width in terms of height

local barLength --bar length as a proportion of total width

local mCurr, mStor, mPull, mInco, mExpe, mShar, mSent, mReci = 0, 0, 0, 0, 0, 0, 0, 0
local eCurr, eStor, ePull, eInco, eExpe, eShar, eSent, eReci = 0, 0, 0, 0, 0, 0, 0, 0

local resupplyPeriod = 450 * 30
local resupplyString = ""
local lastStor
local estimatedSupplySurplus = 1

local activeClick

local font

------------------------------------------------
--speedups
------------------------------------------------
local abs = math.abs
local floor, ceil = math.floor, math.ceil

local strFormat = string.format

local GetTeamResources = Spring.GetTeamResources
local GetMyTeamID = Spring.GetMyTeamID
local IsGUIHidden = Spring.IsGUIHidden
local SetShareLevel = Spring.SetShareLevel

local glLineWidth = gl.LineWidth

local glColor = gl.Color
local glPolygonMode = gl.PolygonMode

local glPushMatrix = gl.PushMatrix
local glPopMatrix = gl.PopMatrix
local glTranslate = gl.Translate
local glScale = gl.Scale
local glRotate = gl.Rotate

local glRect = gl.Rect
local glShape = gl.Shape

local glTexture = gl.Texture
local glTexRect = gl.TexRect

local GL_LINE = GL.LINE
local GL_FILL = GL.FILL

local GL_TRIANGLES = GL.TRIANGLES
local GL_FRONT_AND_BACK = GL.FRONT_AND_BACK

------------------------------------------------
--util
------------------------------------------------

local function ToSI(num)
  if (num == 0) then
    return "0"
  else
    local absNum = abs(num)
    if (absNum < 0.1) then
      return "0" --too small to matter
    elseif (absNum < 1e3) then
      return strFormat("%.2f", num)
    elseif (absNum < 1e6) then
      return strFormat("%.2fk", 1e-3 * num)
    elseif (absNum < 1e9) then
      return strFormat("%.2fM", 1e-6 * num)
    else
      return strFormat("%.2fB", 1e-9 * num)
    end
  end
end

local function FramesToTimeString(n)
  local seconds = n / 30
  return strFormat(floor(seconds / 60) .. ":" .. strFormat("%02i", ceil(seconds % 60)))
end

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
		glColor(0.75, 0.75, 0.75, 1)
	end
end

------------------------------------------------
--drawing
------------------------------------------------

local function DrawShareMarker()
  glPolygonMode(GL_FRONT_AND_BACK, GL_LINE)
  local vertices = {
    {v = {0, 1, 0}},
    {v = {2, 3, 0}},
    {v = {-2, 3, 0}},
    
    {v = {0, -1, 0}},
    {v = {-2, -3, 0}},
    {v = {2, -3, 0}},
  }
  glShape(GL_TRIANGLES, vertices)
  glPolygonMode(GL_FRONT_AND_BACK, GL_FILL)
end

local function DrawCommand()
  --icon
  glPushMatrix()
    glTranslate(-mainWidth, -1, 0)
    glColor(1, 1, 1, 1)
    glTexture(IMAGE_DIRNAME .. "ResComIcon.png")
    glTexRect(0, 0, 1, 1)
    glTexture(false)
  glPopMatrix()

  --resource bar
  glPushMatrix()
    glTranslate(-mainWidth + 1, -0.5, 0)
    glScale(barLength, barHeight, 1)
    glColor(0.375, 0.375, 0.375, 1)
    glRect(0, -1, 1, 1)
    glColor(0.75, 0.75, 0.75, 1)
    glRect(0, -1, mCurr / mStor, 1)
    
    glPushMatrix()
      glTranslate(mShar, 0, 0)
      glScale(barHeight / barLength, 1, 1)
      ShareColor(mSent, mReci)
      DrawShareMarker()
    glPopMatrix()
  glPopMatrix()
  
  --curr/change
  glPushMatrix()
    glTranslate(-mainWidth + 1 + barLength / 2, -1.05, 0)
    font:Print("\255\192\192\192Command: \255\255\255\255" .. ToSI(mCurr), 0, 0, 0.375, "cnd")
    font:Print("\255\1\255\1+" .. ToSI(mInco) .. " \255\255\1\1-" .. ToSI(mPull), 0, 0.5 + barHeight, 0.375, "cnd")
  glPopMatrix()
  
  --storage
  glPushMatrix()
    glTranslate(-mainWidth + 1 + barLength, -0.75, 0)
    font:Print("\255\255\255\255" .. ToSI(mStor), 0, 0, 0.375)
  glPopMatrix()
end

local function DrawSupply()
  --icon
  glPushMatrix()
    glTranslate(-barLength - 1 - endLength, -1, 0)
    glColor(1, 1, 1, 1)
    glTexture(IMAGE_DIRNAME .. "ResLogIcon.png")
    glTexRect(0, 0, 1, 1)
    glTexture(false)
  glPopMatrix()
  
  --resource bar
  glPushMatrix()
    glTranslate(-barLength - endLength, -0.5, 0)
    glScale(barLength, barHeight, 1)
    glColor(0.5, 0.5, 0, 1)
    glRect(0, -1, 1, 1)
    glColor(1, 1, 0, 1)
    glRect(0, -1, eCurr / eStor, 1)
    if estimatedSupplySurplus < eCurr then
      glColor(1, 0, 0, 1)
      glRect(estimatedSupplySurplus / eStor, -1, eCurr / eStor, 1)
    end
    
    glPushMatrix()
      glTranslate(eShar, 0, 0)
      glScale(barHeight / barLength, 1, 1)
      ShareColor(eSent, eReci)
      DrawShareMarker()
    glPopMatrix()
  glPopMatrix()
  
  --curr/resupply
  glPushMatrix()
    glTranslate(-endLength - barLength / 2, -1.05, 0)
    font:Print("\255\255\255\1Supply: \255\255\255\255" .. ToSI(eCurr), 0, 0, 0.375, "cnd")
    font:Print("\255\255\1\1-" .. ToSI(ePull) .. " \255\255\255\255(Resupply in " .. resupplyString .. ")", 0, 0.5 + barHeight, 0.375, "cnd")
  glPopMatrix()
  
  --storage
  glPushMatrix()
    glTranslate(-endLength, -0.75, 0)
    font:Print("\255\255\255\255" .. ToSI(eStor), 0, 0, 0.375)
  glPopMatrix()
end

local function DrawMain()
  glColor(0, 0, 0, 0.25)
  glRect(-mainWidth, -1, 0, 0)
  glPushMatrix()
    DrawCommand()
    DrawSupply()
    --WG.VectorImages.DrawCircle({1, 1, 1}, {1, 1, 1}, 16)
  glPopMatrix()
end

------------------------------------------------
--callins
------------------------------------------------
function widget:Initialize()
  --[[if (Game.modShortName ~= "S44") then
    WG.RemoveWidget(self)
    return
  end]]
  
  Spring.SendCommands("resbar 0")
  
  local viewSizeX, viewSizeY = Spring.GetViewGeometry()
  widget:ViewResize(viewSizeX, viewSizeY)
  widget:GameFrame(0)
  
  font = WG.S44Fonts.TypewriterBold16
  
  resupplyPeriod = Spring.GetGameRulesParam("resupplyPeriod") or 450 * 30
end

function widget:ViewResize(viewSizeX, viewSizeY)
  vsx = viewSizeX
  vsy = viewSizeY
  mainSize = mainScaleHeight * vsy
  mainWidth = vsx * mainScaleWidth / mainSize
  barLength = mainWidth / 2 - 1 - endLength
end

function widget:DrawScreen()
  glLineWidth(1)
  glPushMatrix()
    glTranslate(vsx, vsy, 0)
    glScale(mainSize, mainSize, 1)
    if (not IsGUIHidden()) then
      DrawMain()
    end
  glPopMatrix()
end

function widget:GameFrame(n)
  local myTeamID = GetMyTeamID()
  mCurr, mStor, mPull, mInco, mExpe, mShar, mSent, mReci = GetTeamResources(myTeamID, "metal")
  eCurr, eStor, ePull, eInco, eExpe, eShar, eSent, eReci = GetTeamResources(myTeamID, "energy")
  
  if not lastStor then lastStor = eStor end
  
  local elapsedSupplyTime = n % resupplyPeriod
  local remainingSupplyTime = resupplyPeriod - n % resupplyPeriod
  
  if remainingSupplyTime == 0 or n <= 32 then
    estimatedSupplySurplus = 1
    lastStor = eStor
  else
    estimatedSupplySurplus = lastStor - (lastStor - eCurr) * resupplyPeriod / elapsedSupplyTime
    if estimatedSupplySurplus > eStor then
      estimatedSupplySurplus = eStor
    elseif estimatedSupplySurplus < 0 then
      estimatedSupplySurplus = 0
    end
  end
  
  resupplyString = FramesToTimeString(remainingSupplyTime)
end

------------------------------------------------
--mouse
------------------------------------------------

local function MainTransform(x, y)
  return (x - vsx) / mainSize, (y - vsy) / mainSize
end

local function CommandShare(tx)
  local result = (tx + mainWidth - 1) / barLength
  if result < 0 then return 0 end
  if result > 1 then return 1 end
  return result
end

local function SupplyShare(tx)
  local result = (tx + barLength + endLength) / barLength
  if result < 0 then return 0 end
  if result > 1 then return 1 end
  return result
end

local function GetComponent(x, y)
  local tx, ty = MainTransform(x, y)
  
  if ty < 0 and ty > -1 then
    if tx > -mainWidth + 1 and tx < -mainWidth + barLength + 1 then
      return "commandbar"
    elseif tx > -endLength - barLength and tx < -endLength then
      return "supplybar"
    end
  end
end

local function ReleaseActiveClick(x, y)
  local tx, ty = MainTransform(x, y)
  if activeClick == "commandbar" then
    SetShareLevel("metal", CommandShare(tx))
  elseif activeClick == "supplybar" then
    SetShareLevel("energy", SupplyShare(tx))
  end
  activeClick = false
end

function widget:MousePress(x, y, button)
  local component = GetComponent(x, y)
  if (component and not IsGUIHidden()) then
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
