function widget:GetInfo()
	return {
		name      = "1944 Selection Buttons",
		desc      = "Buttons for the current selection or transport passengers",
		author    = "trepan (D. Rodgers), edited for S44 by FLOZi (C. Lawrence)",
		date      = "Jan 8, 2007",
		license   = "GNU GPL, v2 or later",
		layer     = 0,
		enabled   = false  --  loaded by default?
	}
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

-- localisations
-- OpenGL
local glBeginEnd               = gl.BeginEnd
local glBlending               = gl.Blending
local glBlendFunc              = gl.BlendFunc
local glClear                  = gl.Clear
local glColor                  = gl.Color
local glDepthMask              = gl.DepthMask
local glDepthTest              = gl.DepthTest
local glLighting               = gl.Lighting
local glLineWidth              = gl.LineWidth
local glMaterial               = gl.Material
local glPolygonMode            = gl.PolygonMode
local glPolygonOffset          = gl.PolygonOffset
local glPopMatrix              = gl.PopMatrix
local glPushMatrix             = gl.PushMatrix
local glRect                   = gl.Rect
local glRotate                 = gl.Rotate
local glScale                  = gl.Scale
local glScissor                = gl.Scissor
local glTexRect                = gl.TexRect
local glText                   = gl.Text
local glTexture                = gl.Texture
local glTranslate              = gl.Translate
local glUnitDef                = gl.UnitDef
local glUnitShape              = gl.UnitShape
local glVertex                 = gl.Vertex

-- Synced Read
local spGetTeamUnitsSorted     = Spring.GetTeamUnitsSorted
local spGetUnitDefDimensions   = Spring.GetUnitDefDimensions
local spGetUnitDefID           = Spring.GetUnitDefID
local spGetUnitIsTransporting  = Spring.GetUnitIsTransporting

-- Unsynced Read
local spGetModKeyState         = Spring.GetModKeyState
local spGetMouseState          = Spring.GetMouseState
local spGetMyTeamID            = Spring.GetMyTeamID
local spGetSelectedUnits       = Spring.GetSelectedUnits
local spGetSelectedUnitsCounts = Spring.GetSelectedUnitsCounts
local spGetSelectedUnitsSorted = Spring.GetSelectedUnitsSorted

-- Unsynced Ctrl
local spSelectUnitArray        = Spring.SelectUnitArray
local spSelectUnitMap          = Spring.SelectUnitMap
local spSendCommands           = Spring.SendCommands

-- Constants
local GL_DEPTH_BUFFER_BIT      = GL.DEPTH_BUFFER_BIT
local GL_FILL                  = GL.FILL
local GL_FRONT_AND_BACK        = GL.FRONT_AND_BACK
local GL_LINE                  = GL.LINE
local GL_LINE_LOOP             = GL.LINE_LOOP
local GL_ONE                   = GL.ONE
local GL_ONE_MINUS_SRC_ALPHA   = GL.ONE_MINUS_SRC_ALPHA
local GL_SRC_ALPHA             = GL.SRC_ALPHA

-- Variables
require("colors.lua")

local vsx, vsy = widgetHandler:GetViewSizes()

local useModels = false

local unitTypes = 0
local countsTable = {}
local activePress = false
local mouseIcon = -1
local currentDef = nil

local iconSizeX = math.floor(useModels and 80 or 64)
local iconSizeY = math.floor(iconSizeX * 1.0)
local fontSize = iconSizeY * 0.25

local rectMinX = 0
local rectMaxX = 0
local rectMinY = 0
local rectMaxY = 0


-- Local Functions
local function SortedUnits()
	local selUnits = spGetSelectedUnits()
	if (#selUnits ~= 1) then
		return spGetSelectedUnitsCounts() --{ n = 0 }
	end
	local transID = selUnits[1]
	local units = spGetUnitIsTransporting(transID)
	if (units == nil) then
		return spGetSelectedUnitsCounts() --{ n = 0 }
	end
	local typed = {}
	local typeCount = 0
	for _,uid in ipairs(units) do
		local udid = spGetUnitDefID(uid)
		local ud = UnitDefs[udid]
		if (udid) then
			local shipTurret = ud.customParams and ud.customParams.child
			if not shipTurret then
				if (typed[udid] == nil) then
					typed[udid] = 1
					typeCount = typeCount + 1
				else
					typed[udid] = typed[udid] + 1
				end
			end
		end
	end
	typed.n = typeCount
	return typed, transID
end

-- Setup Functions
function SetupDimensions(count)
	local xmid = vsx * 0.5
	local width = math.floor(iconSizeX * count)
	rectMinX = math.floor(xmid - (0.5 * width))
	rectMaxX = math.floor(xmid + (0.5 * width))
	rectMinY = math.floor(0) --floor(0 + iconSizeY * 2)
	rectMaxY = math.floor(rectMinY + iconSizeY)
end


function CenterUnitDef(unitDefID)
	local ud = UnitDefs[unitDefID] 
	if (not ud) then
		return
	end
	if (not ud.dimensions) then
		ud.dimensions = spGetUnitDefDimensions(unitDefID)
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
	local vAspect = iconSizeX / iconSizeY

	-- scale the unit to the box (maxspect)
	local scale
	if (mAspect > vAspect) then
		scale = (iconSizeX / hSize)
	else
		scale = (iconSizeY / ySize)
	end
	scale = scale * 0.8
	glScale(scale, scale, scale)

	-- translate to the unit's midpoint
	local xMid = 0.5 * (d.maxx + d.minx)
	local yMid = 0.5 * (d.maxy + d.miny)
	local zMid = 0.5 * (d.maxz + d.minz)
	glTranslate(-xMid, -yMid, -zMid)
end


local function SetupModelDrawing()
	glDepthTest(true) 
	glDepthMask(true)
	glLighting(true)
	glBlending(false)
	glMaterial({
		ambient  = { 0.2, 0.2, 0.2, 1.0 },
		diffuse  = { 1.0, 1.0, 1.0, 1.0 },
		emission = { 0.0, 0.0, 0.0, 1.0 },
		specular = { 0.2, 0.2, 0.2, 1.0 },
		shininess = 16.0
	})
end


local function RevertModelDrawing()
	glBlending(true)
	glLighting(false)
	glDepthMask(false)
	glDepthTest(false)
end


local function SetupBackgroundColor(ud)
	local alpha = 0.95
	if (ud.canFly) then
		glColor(0.5, 0.5, 0.0, alpha)
	elseif (not ud.isGroundUnit and not ud.isAirUnit) then
		glColor(0.0, 0.0, 0.5, alpha)
	elseif (ud.isBuilder) then
		glColor(0.0, 0.5, 0.0, alpha)
	else
		glColor(.5, .5, .5, alpha)
	end
end

-- Draw Functions
function DrawUnitDefModel(unitDefID, iconPos, count)
	local xmin = math.floor(rectMinX + (iconSizeX * iconPos))
	local xmax = xmin + iconSizeX
	if ((xmax < 0) or (xmin > vsx)) then return end  -- bail
	
	local ymin = rectMinY
	local ymax = rectMaxY
	local xmid = (xmin + xmax) * 0.5
	local ymid = (ymin + ymax) * 0.5

	local ud = UnitDefs[unitDefID] 

	-- draw background quad
--  glColor(0.3, 0.3, 0.3, 1.0)
--  glTexture('#'..unitDefID)
	glTexture(false)
	--SetupBackgroundColor(ud)
	glRect(xmin + 1, ymin + 1, xmax, ymax)


	-- draw the 3D unit
		--[[SetupModelDrawing()

	glPushMatrix()
	glScissor(xmin, ymin, xmax - xmin, ymax - ymin)
	glTranslate(xmid, ymid, 0)
	glRotate(15.0, 1, 0, 0)
	local timer = 1.5 * widgetHandler:GetHourTimer()
	glRotate(math.cos(0.5 * math.pi * timer) * 60.0, 0, 1, 0)

	CenterUnitDef(unitDefID)
	
	local scribe = false
	if (scribe) then
		glLighting(false)
		glColor(0,0,0,1)
	end

	glUnitShape(unitDefID, spGetMyTeamID())

	if (scribe) then
--    glLineWidth(0.1)
		glLighting(false)
		glDepthMask(false)
		glColor(1,1,1,1)
		glPolygonOffset(-4, -4)
		glPolygonMode(GL_FRONT_AND_BACK, GL_LINE)
		glUnitDef(unitDefID, spGetMyTeamID())
		glPolygonMode(GL_FRONT_AND_BACK, GL_FILL)
		glPolygonOffset(false)
--    glLineWidth(1.0)
	end

	glScissor(false)
	glPopMatrix()

		RevertModelDrawing()]]

	-- draw the count text
	glText(count, (xmin + xmax) * 0.5, ymax + 2, fontSize, "oc")

	-- draw the border  (note the half pixel shift for drawing lines)
	glColor(1, 1, 1)
	glBeginEnd(GL_LINE_LOOP, function()
		glVertex(xmin + 0.5, ymin + 0.5)
		glVertex(xmax + 0.5, ymin + 0.5)
		glVertex(xmax + 0.5, ymax + 0.5)
		glVertex(xmin + 0.5, ymax + 0.5)
	end)
end


function DrawUnitDefTexture(unitDefID, iconPos, count)
	local xmin = math.floor(rectMinX + (iconSizeX * iconPos))
	local xmax = xmin + iconSizeX
	if ((xmax < 0) or (xmin > vsx)) then return end  -- bail
	
	local ymin = rectMinY
	local ymax = rectMaxY
	local xmid = (xmin + xmax) * 0.5
	local ymid = (ymin + ymax) * 0.5

	local ud = UnitDefs[unitDefID] 

	--glColor(1, 1, 1)
	glTexture('#' .. unitDefID)
	glTexRect(xmin, ymin, xmax, ymax)
	glTexture(false)

	-- draw the count text
	glText(count, (xmin + xmax) * 0.5, ymax + 2, fontSize, "oc")

	-- draw the border  (note the half pixel shift for drawing lines)
	glBeginEnd(GL_LINE_LOOP, function()
		glVertex(xmin + 0.5, ymin + 0.5)
		glVertex(xmax + 0.5, ymin + 0.5)
		glVertex(xmax + 0.5, ymax + 0.5)
		glVertex(xmin + 0.5, ymax + 0.5)
	end)
end


function DrawIconQuad(iconPos, color)
	local xmin = rectMinX + (iconSizeX * iconPos)
	local xmax = xmin + iconSizeX
	local ymin = rectMinY
	local ymax = rectMaxY
	glColor(color)
	glBlendFunc(GL_SRC_ALPHA, GL_ONE)
	glRect(xmin, ymin, xmax, ymax)
	glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA)
end

-- Mouse functions
local function LeftMouseButton(unitDefID, unitTable)
	local alt, ctrl, meta, shift = spGetModKeyState()
	if (not ctrl) then
		-- select units of icon type
		if (alt or meta) then
			spSelectUnitArray({ unitTable[1] })  -- only 1
		else
			spSelectUnitArray(unitTable)
		end
	else
		-- select all units of the icon type
		local sorted = spGetTeamUnitsSorted(spGetMyTeamID())
		local units = sorted[unitDefID]
		if (units) then
			spSelectUnitArray(units, shift)
		end
	end
end


local function MiddleMouseButton(unitDefID, unitTable)
	local alt, ctrl, meta, shift = spGetModKeyState()
	-- center the view
	if (ctrl) then
		-- center the view on the entire selection
		spSendCommands({"viewselection"})
	else
		-- center the view on this type on unit
		local selUnits = spGetSelectedUnits()
		spSelectUnitArray(unitTable)
		spSendCommands({"viewselection"})
		spSelectUnitArray(selUnits)
	end
end


local function RightMouseButton(unitDefID, unitTable)
	local alt, ctrl, meta, shift = spGetModKeyState()
	-- remove selected units of icon type
	local selUnits = spGetSelectedUnits()
	local map = {}
	for _,uid in ipairs(selUnits) do map[uid] = true end
	for _,uid in ipairs(unitTable) do
		map[uid] = nil
		if (ctrl) then break end -- only remove 1 unit
	end
	spSelectUnitMap(map)
end


function MouseOverIcon(x, y)
	if (unitTypes <= 0) then return -1 end
	if (x < rectMinX)   then return -1 end
	if (x > rectMaxX)   then return -1 end
	if (y < rectMinY)   then return -1 end
	if (y > rectMaxY)   then return -1 end

	local icon = math.floor((x - rectMinX) / iconSizeX)
	-- clamp the icon range
	if (icon < 0) then
		icon = 0
	end
	if (icon >= unitTypes) then
		icon = (unitTypes - 1)
	end
	return icon
end


-- Call Ins

function widget:DrawScreen()
	unitCounts, transID = SortedUnits()--spGetSelectedUnitsCounts()
	unitTypes = unitCounts.n
	if transID then unitTypes = unitTypes + 1 end
	if (unitTypes <= 0) then
		countsTable = {}
		activePress = false
		currentDef  = nil
		return
	end
	
	SetupDimensions(unitTypes)

	-- unit model rendering uses the depth-buffer
	glClear(GL_DEPTH_BUFFER_BIT)

	local x,y,lb,mb,rb = spGetMouseState()
	local mouseIcon = MouseOverIcon(x, y)

	-- draw the buildpics
	unitCounts.n = nil  
	local icon = 0
	-- draw transporter first
	if transID then
		local udid = spGetUnitDefID(transID)
		glColor(1, 1, 1)
		if (useModels) then
			DrawUnitDefModel(udid, icon, 1)
		else
			DrawUnitDefTexture(udid, icon, 1)
		end
		if (icon == mouseIcon) then
			currentDef = UnitDefs[udid]
		end
		icon = icon + 1
		glColor(0.5, 0.5, 0.5, 0.8)
	else -- This block is all rather ugly
		local transCount = {}
		local units = spGetSelectedUnits()
		for _,uid in ipairs(units) do
			local udid = spGetUnitDefID(uid)
			if (udid) then
				local transported = spGetUnitIsTransporting(uid)
				if transported then
						if not transCount[udid] then 
							transCount[udid] = #transported
						else 
							transCount[udid] = transCount[udid] + #transported
						end
				end
			end
		end
		for udid,count in pairs(unitCounts) do
			if transCount[udid] and transCount[udid] > 0 then
				unitCounts[udid] = count .. "(+" .. transCount[udid] .. ")"
			end
		end
		glColor(1, 1, 1)
	end
	for udid,count in pairs(unitCounts) do
		if (useModels) then
			DrawUnitDefModel(udid, icon, count)
		else
			DrawUnitDefTexture(udid, icon, count)
		end
			
		if (icon == mouseIcon) then
			currentDef = UnitDefs[udid]
		end
		icon = icon + 1
	end
	glColor(1,1,1,1)
	-- draw the highlights
	-- 104 bug: attempt to call method 'InTweakMode' (a nil value)
	local inTweak
	if widgetHandler.InTweakMode then
		inTweak = widgetHandler:InTweakMode()
	else
		inTweak = widgetHandler.tweakMode
	end
	if (not inTweak and (mouseIcon >= 0)) then
		if (lb or mb or rb) then
			DrawIconQuad(mouseIcon, { 1, 0, 0, 0.333 })  --  red highlight
		else
			DrawIconQuad(mouseIcon, { 0, 0, 1, 0.333 })  --  blue highlight
		end
	end
end


function widget:IsAbove(x, y)
	local icon = MouseOverIcon(x, y)
	if (icon < 0) then
		return false
	end
	return true
end


function widget:GetTooltip(x, y)
	local ud = currentDef
	if (not ud) then
		return ''
	end
	return ud.humanName .. ' - ' .. ud.tooltip
end


function widget:MousePress(x, y, button)
	mouseIcon = MouseOverIcon(x, y)
	activePress = (mouseIcon >= 0)
	return activePress
end


function widget:MouseRelease(x, y, button)
	if (not activePress) then
		return -1
	end
	activePress = false
	local icon = MouseOverIcon(x, y)

	local units = spGetSelectedUnitsSorted()
	if (units.n ~= unitTypes) then
		--return -1  -- discard this click
	end
	units.n = nil

	local unitDefID = -1
	local unitTable = nil
	local index = 0
	for udid,uTable in pairs(units) do
		if (index == icon) then
			unitDefID = udid
			unitTable = uTable
			break
		elseif UnitDefs[udid].customParams.mother then
			local transported = spGetUnitIsTransporting(uTable[1])
			for _, unitID in pairs(transported) do
				index = index + 1
				if (index == icon) then
					unitDefID = Spring.GetUnitDefID(unitID)
					unitTable = {unitID, uTable[1]}
					break
				end
			end
		end
		index = index + 1
	end
	if (unitTable == nil) then
		return -1
	end
	
	local alt, ctrl, meta, shift = spGetModKeyState()
	
	if (button == 1) then
		LeftMouseButton(unitDefID, unitTable)
	elseif (button == 2) then
		MiddleMouseButton(unitDefID, unitTable)
	elseif (button == 3) then
		RightMouseButton(unitDefID, unitTable)
	end

	return -1
end


function widget:ViewResize(viewSizeX, viewSizeY)
	vsx = viewSizeX
	vsy = viewSizeY
end
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
