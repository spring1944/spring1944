local versionNumber = "v1.2"

function widget:GetInfo()
	return {
		name = "1944 Supply Radius",
		desc = versionNumber .. " Supply radius indicator for Spring 1944. Commands: \luaui s44_supplyradius_"
				.. "show[always | rollover | select] to change display options"
				.. "viewdistance [number] to change view distance (negative for fixed point size)"
				.. "minimapsize to change minimap point size (nonpositive to disable)",
		author = "Evil4Zerggin",
		date = "5 January 2009",
		license = "GNU LGPL, v2.1 or later",
		layer = 1,
		enabled = false
	}
end

------------------------------------------------
--config
------------------------------------------------
local viewDistance = 8192 --distance at which dots start getting bigger; fixed size if negative
local minimapSize = 1
local color = {1, 1, 0, 0.75}
local showAlways = false
local showRollover = true
local showSelect = true
local segmentLength = 5

function widget:GetConfigData(data)
	return {
		showAlways = showAlways,
		notShowRollover = not showRollover,
		notShowSelect = not showSelect,
		viewDistance = viewDistance,
		minimapSize = minimapSize,
	}
end

function widget:SetConfigData(data)
	showAlways = data.showAlways
	showRollover = not data.notShowRollover
	showSelect = not data.notShowSelect
	viewDistance = data.viewDistance or 8192
	minimapSize = data.minimapSize or 1
end

------------------------------------------------
--vars
------------------------------------------------

local mainList

--format: unitDefID = {radius, numSegments, segmentAngle}
local supplyDefInfos = {}

--format: unitID = {[1] = bool, [2] = bool, ... [numSegments] = bool, supplyDefInfo = table, x = number, y = number, z = number}
local supplyInfos = {}


------------------------------------------------
--speedups and constants
------------------------------------------------
local GetUnitSeparation = Spring.GetUnitSeparation
local GetUnitPosition = Spring.GetUnitPosition
local AreTeamsAllied = Spring.AreTeamsAllied
local GetMyTeamID = Spring.GetMyTeamID
local GetUnitDefID = Spring.GetUnitDefID
local GetUnitTeam = Spring.GetUnitTeam
local GetGroundHeight = Spring.GetGroundHeight
local GetCameraPosition = Spring.GetCameraPosition

local GetMouseState = Spring.GetMouseState
local TraceScreenRay = Spring.TraceScreenRay
local GetSelectedUnitsCounts = Spring.GetSelectedUnitsCounts

local glColor = gl.Color
local glLineWidth = gl.LineWidth
local glPointSize = gl.PointSize

local glCreateList = gl.CreateList
local glCallList = gl.CallList
local glDeleteList = gl.DeleteList

local glShape = gl.Shape

local glTranslate = gl.Translate
local glScale = gl.Scale
local glRotate = gl.Rotate
local glPopMatrix = gl.PopMatrix
local glPushMatrix = gl.PushMatrix

local GL_LINES = GL.LINES
local GL_LINE_LOOP = GL.LINE_LOOP
local GL_LINE_STRIP = GL.LINE_STRIP
local GL_POINTS = GL.POINTS

local sin, cos = math.sin, math.cos
local ceil, floor = math.ceil, math.floor
local min, max = math.min, math.max

local MAP_SIZE_X = Game.mapSizeX
local MAP_SIZE_Z = Game.mapSizeZ

local DEFAULT_SUPPLY_RANGE = 300
local PI = math.pi


------------------------------------------------
--util
------------------------------------------------
local function DistSq(x1, z1, x2, z2)
	local dx, dz = x2 - x1, z2 - z1
	return dx * dx + dz * dz
end

local function GetCameraScale()
	if (viewDistance > 0) then
		local cx, cy, cz = GetCameraPosition()
		local gwh = max(GetGroundHeight(cx, cz), 0)
		local size = max(viewDistance / max(cy - gwh, 1), 1)
		return size
	else
		return -viewDistance
	end
end

------------------------------------------------
--updates
------------------------------------------------
local function RemovePoints(supplyInfo, x, z, r)
	local r0 = supplyInfo.r
	local numSegments = supplyInfo.numSegments
	local segmentAngle = supplyInfo.segmentAngle
	local x0, z0 = supplyInfo.x, supplyInfo.z
	local angle = 0
	local segmentAngle = supplyInfo.segmentAngle
	local rSq = r * r
	for i=1,numSegments do
		local x1, z1 = x0 + r0 * cos(angle), z0 + r0 * sin(angle)
		if (supplyInfo[i]) then
			distSq = DistSq(x1, z1, x, z)
			if (distSq < rSq) then
				supplyInfo[i] = false
			end
		end
		angle = angle + segmentAngle
	end
end

local function UpdatePoint(unitID, x1, z1)
	for currUnitID, currSupplyInfo in pairs(supplyInfos) do
		--ignore self
		if (unitID ~= currUnitID) then
			local r = currSupplyInfo.r
			local rSq = r * r
			local x, z = currSupplyInfo.x, currSupplyInfo.z
			distSq = DistSq(x1, z1, x, z)
			if (distSq < rSq) then
				return false
			end
		end
	end
	return true
end

local function UpdatePoints(unitID, supplyInfo, x, z, r)
	local r0 = supplyInfo.r
	local numSegments = supplyInfo.numSegments
	local segmentAngle = supplyInfo.segmentAngle
	local x0, z0 = supplyInfo.x, supplyInfo.z
	local angle = 0
	local segmentAngle = supplyInfo.segmentAngle
	local rSq = r * r
	for i=1,numSegments do
		local x1, z1 = x0 + r0 * cos(angle), z0 + r0 * sin(angle)
		distSq = DistSq(x1, z1, x, z)
		if (distSq < rSq) then
			supplyInfo[i] = UpdatePoint(unitID, x1, z1)
		end
		angle = angle + segmentAngle
	end
end

local function UpdateAdd(unitID, supplyInfo)
	local r0 = supplyInfo.r
	local numSegments = supplyInfo.numSegments
	local x0, y0, z0 = supplyInfo.x, supplyInfo.y, supplyInfo.z
	
	--start with all true
	for i=1, supplyInfo.numSegments do
		supplyInfo[i] = true
	end
	
	for currUnitID, currSupplyInfo in pairs(supplyInfos) do
		--ignore self
		if (unitID ~= currUnitID) then
			--is there overlap?
			local r = currSupplyInfo.r
			local x, z = currSupplyInfo.x, currSupplyInfo.z
			local dist = GetUnitSeparation(unitID, currUnitID, true)
			if (dist < r0 + r) then
				RemovePoints(supplyInfo, x, z, r)
				RemovePoints(currSupplyInfo, x0, z0, r0)
			end
		end
	end
end

local function UpdateRemove(unitID, supplyInfo)
	local r0 = supplyInfo.r
	local numSegments = supplyInfo.numSegments
	local x0, z0 = supplyInfo.x, supplyInfo.z
	
	for currUnitID, currSupplyInfo in pairs(supplyInfos) do
		--ignore self
		if (unitID ~= currUnitID) then
			--is there overlap?
			local r = currSupplyInfo.r
			local x, z = currSupplyInfo.x, currSupplyInfo.z
			local dist = GetUnitSeparation(unitID, currUnitID, true)
			if (dist < r0 + r) then
				UpdatePoints(currUnitID, currSupplyInfo, x0, z0, r0)
			end
		end
	end
end

------------------------------------------------
--drawing
------------------------------------------------
local function DrawSupplyRing(unitID, supplyInfo)
	local supplyDefInfo = supplyInfo.supplyDefInfo
	local angle = 0
	local r = supplyInfo.r
	local segmentAngle = supplyInfo.segmentAngle
	local x, y, z = supplyInfo.x, supplyInfo.y, supplyInfo.z
	local vertices = {}
	local vi = 1
	for i=1, supplyInfo.numSegments do
		if (supplyInfo[i]) then
			vertices[vi] = {
				v = {cos(angle), 0, sin(angle)}
			}
			vi = vi + 1
		end
		angle = angle + segmentAngle
	end
	
	glPushMatrix()
		glTranslate(x, y, z)
		glScale(r, r, r)
		
		glShape(GL_POINTS, vertices)
	glPopMatrix()
end

local function DrawMain()
	glColor(color)
	
	for unitID, supplyInfo in pairs(supplyInfos) do
		DrawSupplyRing(unitID, supplyInfo)
	end
	
	glColor(1, 1, 1, 1)
end

local function CallMain()
	if (showAlways) then
		glCallList(mainList)
		return
	end
	
	if (showRollover) then
		local mx, my = GetMouseState()
		local mouseTargetType, mouseTarget = TraceScreenRay(mx, my)
		if (mouseTargetType == "unit" and supplyInfos[mouseTarget]) then
			glCallList(mainList)
			return
		end
	end
	
	if (showSelect) then
		local selectedUnitsCounts = GetSelectedUnitsCounts()
		for unitDefID, _ in pairs(selectedUnitsCounts) do
			if (supplyDefInfos[unitDefID]) then
				glCallList(mainList)
				return
			end
		end
	end
end

local function UpdateLists()
	if (mainList) then
		glDeleteList(mainList)
	end
	
	mainList = glCreateList(DrawMain)
end

local function ToggleShowAlways()
	showAlways = not showAlways
	if (showAlways) then
		Spring.Echo("<1944 Supply Radius>: Now showing always.")
	else
		Spring.Echo("<1944 Supply Radius>: Now not showing always.")
	end
end

local function ToggleShowRollover()
	showRollover = not showRollover
	if (showRollover) then
		Spring.Echo("<1944 Supply Radius>: Now showing on rollover.")
	else
		Spring.Echo("<1944 Supply Radius>: Now not showing on rollover.")
	end
end

local function ToggleShowSelect()
	showSelect = not showSelect
	if (showSelect) then
		Spring.Echo("<1944 Supply Radius>: Now showing on selection.")
	else
		Spring.Echo("<1944 Supply Radius>: Now not showing on selection.")
	end
end

local function SetViewDistance(_,_,words)
	local newViewDistance = tonumber(words[1])
	if (newViewDistance) then
		viewDistance = newViewDistance
		if (newViewDistance > 0) then
			Spring.Echo("<1944 Supply Radius>: View distance set to " .. viewDistance .. ".")
		else
			Spring.Echo("<1944 Supply Radius>: Point size set to " .. -viewDistance .. ".")
		end
	else
		Spring.Echo("<1944 Supply Radius>: Invalid view distance.")
	end
end

local function SetMinimapSize(_,_,words)
	local newMinimapSize = tonumber(words[1])
	if (newMinimapSize) then
		minimapSize = newMinimapSize
		Spring.Echo("<1944 Supply Radius>: Minimap point size set to " .. minimapSize .. ".")
	else
		Spring.Echo("<1944 Supply Radius>: Invalid minimap point size.")
	end
end

------------------------------------------------
--callins
------------------------------------------------


function widget:UnitCreated(unitID, unitDefID, unitTeam, builderID)
	if (not AreTeamsAllied(unitTeam, GetMyTeamID())) then 
		widget:UnitDestroyed(unitID, unitDefID, unitTeam)
		return
	end
	
	local supplyDefInfo = supplyDefInfos[unitDefID]
	
	if (not supplyDefInfo) then return end
	
	--enter info
	local supplyInfo = {}
	supplyInfo.r = supplyDefInfo[1]
	supplyInfo.numSegments = supplyDefInfo[2]
	supplyInfo.segmentAngle = supplyDefInfo[3]
	
	local x, y, z = GetUnitPosition(unitID)
	supplyInfo.x, supplyInfo.y, supplyInfo.z = x, y, z
	
	UpdateAdd(unitID, supplyInfo, supplyDefInfo)
	supplyInfos[unitID] = supplyInfo
	
	UpdateLists()
end

function widget:UnitGiven(unitID, unitDefID, unitTeam, oldTeam)
	widget:UnitCreated(unitID, unitDefID, unitTeam)
end

function widget:UnitTaken(unitID, unitDefID, unitTeam, newTeam)
	widget:UnitCreated(unitID, unitDefID, unitTeam)
end

function widget:UnitDestroyed(unitID, unitDefID, unitTeam)
	local supplyInfo = supplyInfos[unitID]
	if (not supplyInfo) then return end
	supplyInfos[unitID] = nil
	UpdateRemove(unitID, supplyInfo)
	UpdateLists()
end

function widget:DrawWorldPreUnit()
	glPointSize(GetCameraScale())
	CallMain()
	glPointSize(1)
end

function widget:DrawInMiniMap(sx, sy)
	if (minimapSize <= 0) then return end
	
	glPointSize(minimapSize)
	glPushMatrix()
		glTranslate(0, sy, 0)
		glRotate(90, 1, 0, 0)
		glScale(sx / MAP_SIZE_X, 1, sy / MAP_SIZE_Z)
		CallMain()
	glPopMatrix()
	glPointSize(1)
end

function widget:Initialize()
	local inUse = false
	for unitDefID=1,#UnitDefs do
		local unitDef = UnitDefs[unitDefID]
		if (unitDef.customParams.ammosupplier == "1") then
			local radius = unitDef.customParams.supplyrange or DEFAULT_SUPPLY_RANGE
			local numSegments = ceil(radius / segmentLength)
			local segmentAngle = 2 * PI / numSegments
			supplyDefInfos[unitDefID] = {radius, numSegments, segmentAngle}
			inUse = true
		end
	end
	
	--remove self if unused
	if (not inUse) then
		widgetHandler:RemoveWidget()
	end
	
	local allUnits = Spring.GetAllUnits()
	for i=1,#allUnits do
		local unitID = allUnits[i]
		widget:UnitCreated(unitID, GetUnitDefID(unitID), GetUnitTeam(unitID))
	end
	
	mainList = glCreateList(DrawMain)
	
	widgetHandler:AddAction("s44_supplyradius_showalways", ToggleShowAlways, nil, "t")
	widgetHandler:AddAction("s44_supplyradius_showrollover", ToggleShowRollover, nil, "t")
	widgetHandler:AddAction("s44_supplyradius_showselect", ToggleShowSelect, nil, "t")
	widgetHandler:AddAction("s44_supplyradius_viewdistance", SetViewDistance, nil, "t")
	widgetHandler:AddAction("s44_supplyradius_minimapsize", SetMinimapSize, nil, "t")
end

function widget:Shutdown()
	glDeleteList(mainList)
	widgetHandler:RemoveAction("s44_supplyradius_showalways")
	widgetHandler:RemoveAction("s44_supplyradius_showrollover")
	widgetHandler:RemoveAction("s44_supplyradius_showselect")
	widgetHandler:RemoveAction("s44_supplyradius_viewdistance")
	widgetHandler:RemoveAction("s44_supplyradius_minimapsize")
end
