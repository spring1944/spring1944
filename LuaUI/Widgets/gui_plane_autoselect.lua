
function widget:GetInfo()
  return {
    name      = "1944 Aircraft Selection Buttons",
    desc      = "Automatically creates selection buttons for newly entered aircraft.",
    author    = "Ray Modified by Godde, Szunti, kmar",
    date      = "Sep 6, 2011",
    license   = "GNU GPL, v2 or later",
    layer     = 0,
    enabled   = true  --  loaded by default?
  }
end

-----------------------------
-- Customisable parameters
-----------------------------
local MAX_ICONS = 15
local ICON_SIZE_X = 70
local ICON_SIZE_Y = 70
local CONDENSE = false -- show one icon for all planes of same type
local POSITION_X = 0.5 -- horizontal centre of screen
local POSITION_Y = 0.175 -- near bottom, not used
local useModels = false

-------------------------------------------------------------------------------
-- Localisations
-------------------------------------------------------------------------------

local floor                    = math.floor
local fmod                     = math.fmod
local insert                   = table.insert

----------------
-- OpenGL
----------------
local glBlending               = gl.Blending
local glBlendFunc              = gl.BlendFunc
local glClear                  = gl.Clear
local glColor                  = gl.Color
local glCulling                = gl.Culling
local glDepthMask              = gl.DepthMask
local glDepthTest              = gl.DepthTest
local glLighting               = gl.Lighting
local glMaterial               = gl.Material
local glPopMatrix              = gl.PopMatrix
local glPushMatrix             = gl.PushMatrix
local glRect                   = gl.Rect
local glRotate                 = gl.Rotate
local glScale                  = gl.Scale
local glScissor                = gl.Scissor
local glShape                  = gl.Shape
local glTexRect                = gl.TexRect
local glText                   = gl.Text
local glTexture                = gl.Texture
local glTranslate              = gl.Translate
local glUnit                   = gl.Unit
local glUnitShape              = gl.UnitShape
local glDrawGroundCircle	   = gl.DrawGroundCircle


-----------------
-- Unsynced Read
-----------------
local GetUnitDefDimensions   = Spring.GetUnitDefDimensions
local GetUnitDefID           = Spring.GetUnitDefID
local GetUnitHealth 		 = Spring.GetUnitHealth
local GetUnitRulesParam 	 = Spring.GetUnitRulesParam
local GetMyTeamID            = Spring.GetMyTeamID
local GetTeamUnitsSorted     = Spring.GetTeamUnitsSorted
local GetModKeyState         = Spring.GetModKeyState
local GetMouseState          = Spring.GetMouseState
local GetUnitPosition        = Spring.GetUnitPosition

--------------------
-- Unsynced Control
--------------------
local SelectUnitArray        = Spring.SelectUnitArray
local SendCommands           = Spring.SendCommands

-----------------------------------------------------
-- Constants
-----------------------------------------------------
local MINIMAP_X_MUL          = 1/(Game.mapX*512)
local MINIMAP_Y_MUL          = 1/(Game.mapY*512)

-----------------
-- OpenGl
-----------------
local GL_FRONT                  = GL.FRONT
local GL_LINE_LOOP              = GL.LINE_LOOP
local GL_QUADS                  = GL.QUADS
local GL_ONE                    = GL.ONE
local GL_ONE_MINUS_SRC_ALPHA    = GL.ONE_MINUS_SRC_ALPHA
local GL_SRC_ALPHA              = GL.SRC_ALPHA
local GL_DEPTH_BUFFER_BIT       = GL.DEPTH_BUFFER_BIT

require("colors.lua")

---------------------------------------------------------------------------
-- Variables
-------------------------------------------------------------------------------

local DrawUnitIcons
local vsx, vsy = widgetHandler:GetViewSizes()

function widget:ViewResize(viewSizeX, viewSizeY)
  vsx = viewSizeX
  vsy = viewSizeY
end

local X_MIN = 0
local X_MAX = 0
local Y_MIN = 0
local Y_MAX = 0
local drawTable = {}
local PlaneList = {}
local activePress = false
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

local function IsPlane(unitID)
	local udef = GetUnitDefID(unitID)
	local ud = UnitDefs[udef]
	if ud.canFly == true then  --- can fly
		return true
    end
	return false
end

local function DrawBoxes(number)
	glColor({ 0, 0, 0, 0.65 })
	X_MIN = POSITION_X*vsx-0.5*number*ICON_SIZE_X
	X_MAX = POSITION_X*vsx+0.5*number*ICON_SIZE_X
	Y_MIN = 64 + 16  --POSITION_Y*vsy+0.5*ICON_SIZE_Y
	Y_MAX = Y_MIN + ICON_SIZE_Y  --POSITION_Y*vsy-0.5*ICON_SIZE_Y
	local X1 = X_MIN
	local ct = 0
	while (ct < number) do
		ct = ct + 1
		local X2 = X1 + ICON_SIZE_X

		glShape(GL_LINE_LOOP, {
	    { v = { X1, Y_MIN } },
	    { v = { X2, Y_MIN } },
	    { v = { X2, Y_MAX } },
	    { v = { X1, Y_MAX } },
		})
		X1 = X2

	end
end

local function SetupModelDrawing()
  glDepthTest(true)
  glDepthMask(true)
  glCulling(GL_FRONT)
  glLighting(true)
  glBlending(false)
  glMaterial({
    ambient  = { 1.0, 1.0, 1.0, 1.0 },
    diffuse  = { 1.0, 1.0, 1.0, 1.0 },
    emission = { 0.0, 0.0, 0.0, 1.0 },
    specular = { 0.3, 0.2, 0.2, 1.0 },
    shininess = 16.0
  })
end


local function RevertModelDrawing()
  glBlending(true)
  glLighting(false)
  glCulling(false)
  glDepthMask(false)
  glDepthTest(false)
end

local function CenterUnitDef(unitDefID)
  local ud = UnitDefs[unitDefID]
  if (not ud) then
    return
  end
  if (not ud.dimensions) then
    ud.dimensions = GetUnitDefDimensions(unitDefID)
  end
  if (not ud.dimensions) then
    return
  end

  local d = ud.dimensions
  local xSize = (d.maxx - d.minx)
  local ySize = (d.maxy - d.miny)
  local zSize = (d.maxz - d.minz)

  local hSize -- maximum horizontal dimension
  if (xSize > zSize) then hSize = xSize else hSize = zSize end

  -- aspect ratios
  local mAspect = hSize / ySize
  local vAspect = ICON_SIZE_X / ICON_SIZE_Y

  -- scale the unit to the box (maxspect)
  local scale
  if (mAspect > vAspect) then
    scale = (ICON_SIZE_X / hSize)
  else
    scale = (ICON_SIZE_Y / ySize)
  end
  scale = scale * 0.8
  glScale(scale, scale, scale)

  -- translate to the unit's midpoint
  local xMid = 0.5 * (d.maxx + d.minx)
  local yMid = 0.5 * (d.maxy + d.miny)
  local zMid = 0.5 * (d.maxz + d.minz)
  glTranslate(-xMid, -yMid, -zMid)
end



local function DrawUnitModels(number)
	if not drawTable then
		return -1
	end

	local ct = 0
	local X1, X2
	glTexture(false)
	SetupModelDrawing()

	glScissor(true)
	while (ct < number) do
		ct = ct + 1

		glPushMatrix()
		X1 = X_MIN+(ICON_SIZE_X*(ct-1))
		X2 = X1+ICON_SIZE_X

		glScissor(X1, Y_MIN, X2 - X1, Y_MAX - Y_MIN)

		glTranslate(0.5*(X2+X1), 0.5*(Y_MAX+Y_MIN), 0)
		glRotate(-90.0, 1, 0, 0)

		CenterUnitDef(drawTable[ct].unitDefID)

		glUnitShape(drawTable[ct].unitDefID, GetMyTeamID())

		glScissor(false)
		glPopMatrix()

		if CONDENSE then
			local NumberCondensed = #drawTable[ct].units
			if NumberCondensed > 1 then
				glText(NumberCondensed, (X1 + X2) * 0.5, Y_MAX + 2, ICON_SIZE_Y * 0.25, "oc")
			end

		end
	end
	RevertModelDrawing()
end

local function DrawUnitBuildPics(number)
	if not drawTable then
		return -1
	end

	local ct = 0
	local X1, X2
	X1 = X_MIN

	glColor(1,1,1,1)
	while (ct < number) do
		ct = ct + 1
		X2 = X1+ICON_SIZE_X

		glTexture("#" .. drawTable[ct].unitDefID)
		glTexRect(X1, Y_MIN, X2, Y_MAX)
		glTexture(false)

		X1 = X2

		if CONDENSE then
			local NumberCondensed = #drawTable[ct].units
			if NumberCondensed > 1 then
				glText(NumberCondensed, (X1 - ICON_SIZE_X / 2), Y_MAX + 2,ICON_SIZE_Y * 0.25, "oc")
			end
			--++kmar 07-01-2016 added fuel indicator for unstacked aircraft
		else


			local sHP, sMaxHP = GetUnitHealth(drawTable[ct].units)
			local sRatio = sHP/sMaxHP

			if sRatio > 0.75 then
				glColor(0,1,0)
			else
				if sRatio > 0.5 then
					glColor(1,1,0)
				else
					glColor(1,0,0)
				end
			end
			glRect( X1 - ICON_SIZE_X, Y_MAX, X1 - ICON_SIZE_X*(1 - (sHP/sMaxHP) ), Y_MAX - 4)
			glColor(1,1,1)
			local sFuel = floor(GetUnitRulesParam(drawTable[ct].units, "fuel") or 0)
			glText(sFuel, X1, Y_MIN + 2,ICON_SIZE_Y * 0.18, "or")
			----kmar 07-01-2016
		end

	end
end

local function MouseOverIcon(x, y)
	if not drawTable then return -1 end

	local NumOfIcons = #drawTable
	if (x < X_MIN)   then return -1 end
	if (x > X_MAX)   then return -1 end
	if (y < Y_MIN)   then return -1 end
	if (y > Y_MAX)   then return -1 end

	local icon = floor((x-X_MIN)/ICON_SIZE_X)
	if (icon < 0) then
		icon = 0
	end
	if (icon >= NumOfIcons) then
		icon = (NumOfIcons - 1)
	end
	return icon
end


function DrawIconQuad(iconPos, color)
  local X1 = X_MIN + (ICON_SIZE_X * iconPos)
  local X2 = X1 + ICON_SIZE_X

  glColor(color)
  glBlendFunc(GL_SRC_ALPHA, GL_ONE)
  glShape(GL_QUADS, {
    { v = { X1, Y_MIN } },
    { v = { X2, Y_MIN } },
    { v = { X2, Y_MAX } },
    { v = { X1, Y_MAX } },
  })

  glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA)
end


------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------
local Clicks = {}
local mouseOnUnitID = nil


function widget:Initialize()
	if useModels then
		DrawUnitIcons = DrawUnitModels
	else
		DrawUnitIcons = DrawUnitBuildPics
	end
--[[
  local _, _, spec = Spring.GetPlayerInfo(Spring.GetMyPlayerID())
  if spec then
   -- WG.RemoveWidget(self)
   -- return false
  end
]]--

end

--[[function widget:GetConfigData(data)
  return {
    position_x = POSITION_X,
    position_y = POSITION_Y,
    max_icons = MAX_ICONS
  }
end

function widget:SetConfigData(data)
  POSITION_X = data.position_x or POSITION_X
	POSITION_Y = data.position_y or POSITION_Y
	MAX_ICONS = data.max_icons or MAX_ICONS
end]]


function widget:Update()
	PlaneList = {}
	local myUnits = GetTeamUnitsSorted(GetMyTeamID())
	local unitCount = 0
	for unitDefID, unitTable in pairs(myUnits) do
		if type(unitTable) == 'table' then
			for count, unitID in pairs(unitTable) do
				if count ~= 'n' and IsPlane(unitID) then
					unitCount = unitCount + 1
					if PlaneList[unitDefID] then
						insert(PlaneList[unitDefID], unitID)
					else
						PlaneList[unitDefID] = {unitID}
					end
				end
			end
		else

		end
	end

	if unitCount >= MAX_ICONS then
		CONDENSE = true
	else
		CONDENSE = false
	end

end



--[[function widget:TweakMouseMove(x, y, dx, dy, button)
	local right = (x + (0.5*MAX_ICONS*ICON_SIZE_X))/vsx
	local left = (x - (0.5*MAX_ICONS*ICON_SIZE_X))/vsx
	local top = (y + (0.5*ICON_SIZE_Y))/vsy
	local bottom = (y - (0.5*ICON_SIZE_Y))/vsy
	if right > 1 then
		right = 1
		left = 1 - (MAX_ICONS*ICON_SIZE_X)/vsx
	end
	if left < 0 then
		left = 0
		right = (MAX_ICONS*ICON_SIZE_X)/vsx
	end
	if top > 1 then
		top = 1
		bottom = 1 - ICON_SIZE_Y/vsy
	end
	if bottom < 0 then
		bottom = 0
		top = ICON_SIZE_Y/vsy
	end

	POSITION_X = 0.5*(right+left)
	POSITION_Y = 0.5*(top+bottom)
end

function widget:TweakMousePress(x, y, button)
	local iconNum = MouseOverIcon(x, y)
  if iconNum >= 0 then return true end
end

function widget:MouseWheel(up, value)
	if not widgetHandler:InTweakMode() then return false end

	local x,y,_,_,_ = Spring.GetMouseState()
	local iconNum = MouseOverIcon(x, y)
  if iconNum < 0 then return false end

	if up then
		MAX_ICONS = MAX_ICONS + 1
	else
		MAX_ICONS = MAX_ICONS - 1
		if MAX_ICONS < 1 then MAX_ICONS = 1 end
	end
	return true
end]]

function widget:DrawScreen()

	--[[if widgetHandler:InTweakMode() then
		DrawBoxes(MAX_ICONS)
		local line1 = "Idle cons tweak mode"
		local line2 = "Click and drag here to move icons around, hover over icons and move mouse wheel to change max number of icons"
		gl.Text(line1, POSITION_X*vsx, POSITION_Y*vsy, 15, "c")
		gl.Text(line2, POSITION_X*vsx, (POSITION_Y*vsy)-10, 10, "c")
		return
	end]]

	local noOfIcons = 0
	drawTable = {}

	for unitDefID, units in pairs(PlaneList) do
		if CONDENSE then
			insert(drawTable, {unitDefID = unitDefID, units = units})
			noOfIcons = noOfIcons + 1
		else
			for _, unitID in pairs(units) do
				insert(drawTable, {unitDefID = unitDefID, units = unitID})
			end
			noOfIcons = noOfIcons + #units
		end


	end
	if noOfIcons > MAX_ICONS then
		noOfIcons = MAX_ICONS
	elseif noOfIcons == 0 then
		return
	end
	glClear(GL_DEPTH_BUFFER_BIT)

	DrawBoxes(noOfIcons)
	DrawUnitIcons(noOfIcons)

	local x, y, lb, mb, rb = GetMouseState()
	local icon = MouseOverIcon(x, y)
	if (icon >= 0) then
		if (lb or mb or rb) then
			DrawIconQuad(icon, { 1, 0, 0, 0.333 })
		else
			DrawIconQuad(icon, { 0, 0.1, 0.8, 0.433 })
		end
	end

end

--]]

function widget:DrawWorld()
	-- 104 bug: attempt to call method 'InTweakMode' (a nil value)
	local inTweak
	if widgetHandler.InTweakMode then
		inTweak = widgetHandler:InTweakMode()
	else
		inTweak = widgetHandler.tweakMode
	end
	if inTweak then return -1 end

	local x,y,_,_,_ = GetMouseState()
	local iconNum = MouseOverIcon(x, y)
  if iconNum < 0 then
		mouseOnUnitID = nil
		return -1
	end

	local unitID = drawTable[iconNum+1].units
	local unitDefID = drawTable[iconNum+1].unitDefID
	if Clicks[unitDefID] == nil then
		Clicks[unitDefID] = 1
	end
	if type(unitID) == 'table' then
		unitID = unitID[fmod(Clicks[unitDefID]+1, #unitID)+1]
	end

	mouseOnUnitID = unitID
	-- hilight the unit we are about to click on
	glUnit(unitID, true)
	local ux, uy, uz = GetUnitPosition(mouseOnUnitID)

	-- should help for cases when currently selected plane dies
	if ux and uy and uz then
		glDrawGroundCircle( ux, uy, uz, 3200, 24 ) --++kmar 07-01-2016 Might be a bit over kill, although a 8 sided circle isn't hard to draw i think
		glDrawGroundCircle( ux, uy, uz, 1600, 20 ) --and no, this is not how i imagined it, but it is kinda more usefull then how i imagined it
		glDrawGroundCircle( ux, uy, uz, 800, 16 )
		glDrawGroundCircle( ux, uy, uz, 400, 12 )
		glDrawGroundCircle( ux, uy, uz, 200, 8 )
	end
end

function widget:DrawInMiniMap(sx, sz)
	if not mouseOnUnitID then return -1 end

	local ux, uy, uz = GetUnitPosition(mouseOnUnitID)
  if (not ux or not uy or not uz) then
    return
  end
	local xr = ux*MINIMAP_X_MUL
	local yr = 1 - uz*MINIMAP_Y_MUL --might fix minimap rectangle highlighting
	glColor(1,0,0)
	--glRect((xr*sx)-2, (yr*sz)-2, (xr*sx)+2, (yr*sz)+2) --++kmar 07-01-2016 changed a rectangle on the minimap to a huge cross to be way more noticable when in panic
	glRect(xr*sx, 0, (xr*sx)+1, Game.mapY*512)
	glRect(0, yr*sz, Game.mapX*512, (yr*sz)+1)
end


function widget:MousePress(x, y, button)
  local icon = MouseOverIcon(x, y)
  activePress = (icon >= 0)
  return activePress
end


function widget:MouseRelease(x, y, button)
  if not activePress then return -1 end
  activePress = false

  local iconNum = MouseOverIcon(x, y)
	if iconNum < 0 then return -1 end

  local unitID = drawTable[iconNum+1].units
	local unitDefID = drawTable[iconNum+1].unitDefID

	if type(unitID) == 'table' then
		if Clicks[unitDefID] then
			Clicks[unitDefID] = Clicks[unitDefID] + 1
		else
			Clicks[unitDefID] = 1
		end
		unitID = unitID[fmod(Clicks[unitDefID], #unitID)+1]
	end

  local alt, ctrl, meta, shift = GetModKeyState()

  if (button == 1) then -- left mouse
  	SelectUnitArray({unitID}, shift) -- ++kmar 05-01-2016 - allow shift clicking to append
  elseif (button == 2) then -- middle mouse
    SelectUnitArray({unitID}, shift) -- ++kmar 05-01-2016
    SendCommands({"viewselection"})
  end

  return -1
end

function widget:GetTooltip(x, y)
  local iconNum = MouseOverIcon(x, y)
  local units = drawTable[iconNum+1].units
	if type(units) == 'table' then
		units = units[1]
	end
  local unitDefID = GetUnitDefID(units)
  local ud = UnitDefs[unitDefID]
  return ud.humanName .. "\nLeft mouse: select unit\nMiddle mouse: move to unit\n"
end

function widget:IsAbove(x, y)
  if MouseOverIcon(x, y) == -1 then
    return false
  else
   return true
  end
end

function echo(msg)
	if type(msg) == 'string' or type(msg) == 'number' then
		SendCommands({"echo " .. msg})
	elseif type(msg) == 'table' then
		SendCommands({"echo echo failed on table"})
	else
		SendCommands({"echo broke :-"})
	end
end
