local versionNumber = "v1.9"

function widget:GetInfo()
	return {
		name = "1944 AI Build Radius",
		desc = versionNumber .. " AI build radius indicator for Spring 1944. Commands: \luaui s44_supplyradius_"
				.. "show[always | rollover | select] to change display options"
				.. "viewdistance [number] to change view distance (negative for fixed point size)"
				.. "minimapsize to change minimap point size (nonpositive to disable)",
		author = "Evil4Zerggin (adapted for AI build radius by Tobi Vollebregt)",
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
local color = {1, 0, 0, 0.75}
local previewColor = {1, 0, 0, 0.25}
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

local abs = math.abs
local sin, cos = math.sin, math.cos
local ceil, floor = math.ceil, math.floor
local min, max = math.min, math.max
local PI = math.pi

local mainList

--format: unitDefID = {radius, numSegments, segmentAngle, oddX, oddZ}
local supplyDefInfos = {}

--format: unitID = {[1] = bool, [2] = bool, ... [numSegments] = bool, r = number, numSegments = number, segmentAngle = number, x = number, y = number, z = number}
local supplyInfos = {}

--format: unitID = {supplyDefInfo = table, x = number, z = number}
local inBuildSupplyInfos = {}

--format: unitDefID = bool
local generalTruckDefIDs = {}
local supplyTruckDefIDs = {}

local generalTruckDefInfo = {450, ceil(450 / segmentLength), 2 * PI / ceil(450 / segmentLength)}
local supplyTruckDefInfo = {625, ceil(625 / segmentLength), 2 * PI / ceil(625 / segmentLength)}
local supplyTruckMobileDefInfo = {200, ceil(200 / segmentLength), 2 * PI / ceil(200 / segmentLength)}

local myTeamID

------------------------------------------------
--speedups and constants
------------------------------------------------
local GetUnitSeparation = Spring.GetUnitSeparation
local GetUnitPosition = Spring.GetUnitPosition
local AreTeamsAllied = Spring.AreTeamsAllied
local GetUnitDefID = Spring.GetUnitDefID
local GetUnitTeam = Spring.GetUnitTeam
local GetGroundHeight = Spring.GetGroundHeight
local GetCameraPosition = Spring.GetCameraPosition
local GetCameraDirection = Spring.GetCameraDirection
local GetActiveCommand = Spring.GetActiveCommand
local GetUnitIsStunned = Spring.GetUnitIsStunned
local GetVisibleUnits = Spring.GetVisibleUnits
local GetAllUnits = Spring.GetAllUnits
local GetMyTeamID = Spring.GetMyTeamID

local GetMouseState = Spring.GetMouseState
local TraceScreenRay = Spring.TraceScreenRay
local GetSelectedUnitsCounts = Spring.GetSelectedUnitsCounts

local glColor = gl.Color
local glLineWidth = gl.LineWidth
local glPointSize = gl.PointSize
local glBlending = gl.Blending
local glSmoothing = gl.Smoothing

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
local GL_SRC_ALPHA = GL.SRC_ALPHA
local GL_ONE_MINUS_SRC_ALPHA = GL.ONE_MINUS_SRC_ALPHA

local strFind = string.find
local strSub = string.sub

local MAP_SIZE_X = Game.mapSizeX
local MAP_SIZE_Z = Game.mapSizeZ

local DEFAULT_BUILD_RANGE = 250

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
		local _, dy = GetCameraDirection()
		local gwh = max(GetGroundHeight(cx, cz), 0)
		local size = max(viewDistance / max(cy - gwh, 1), 1) * abs(dy)
		return size
	else
		return -viewDistance
	end
end

local function GetMouseBuildPosition(oddX, oddZ)
	local mx, my = GetMouseState()
	local _, coords = TraceScreenRay(mx, my, true, true)

	if not coords then return nil end

	local x, z = coords[1], coords[3]
	local bx, bz

	if (oddX) then
		bx = (floor( x / 16) + 0.5) * 16
	else
		bx = floor( x / 16 + 0.5) * 16
	end

	if (oddZ) then
		bz = (floor( z / 16) + 0.5) * 16
	else
		bz = floor( z / 16 + 0.5) * 16
	end

	return bx, bz
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
local function DrawSupplyRing(supplyInfo)
	local supplyDefInfo = supplyInfo.supplyDefInfo
	local angle = 0
	local r = supplyInfo.r
	local segmentAngle = supplyInfo.segmentAngle
	local x, y, z = supplyInfo.x, supplyInfo.y, supplyInfo.z
	local vertices = {}
	local vi = 1
	for i=1, supplyInfo.numSegments do
		if (supplyInfo[i]) then
			local gx, gz = x + r * cos(angle), z + r * sin(angle)
			local gy =  max(GetGroundHeight(gx, gz), 0)
			if gy then
				vertices[vi] = {
					v = {gx, gy, gz}
				}
				vi = vi + 1
			end
		end
		angle = angle + segmentAngle
	end

	glPushMatrix()
		glShape(GL_POINTS, vertices)
	glPopMatrix()
end

local function DrawSupplyRingFull(supplyDefInfo, x, z)
	local r = supplyDefInfo[1]
	local segmentAngle = supplyDefInfo[3]

	local vertices = {}
	local angle = 0
	local vi = 1
	for i=1, supplyDefInfo[2] do
		local gx, gz = x + r * cos(angle), z + r * sin(angle)
		local gy =  max(GetGroundHeight(gx, gz), 0)
		if gy then
			vertices[vi] = {
				v = {gx, gy, gz}
			}
			vi = vi + 1
		end
		angle = angle + segmentAngle
	end

	glPushMatrix()
		glShape(GL_POINTS, vertices)
	glPopMatrix()
end

local function DrawTrucks()
	local visibleUnits = GetVisibleUnits()

	if not visibleUnits then return end
	for i=1,#visibleUnits do
		local unitID = visibleUnits[i]
		local unitDefID = GetUnitDefID(unitID)
		local unitTeam = GetUnitTeam(unitID)
		local x, _, z = GetUnitPosition(unitID)
		if AreTeamsAllied(unitTeam, myTeamID) then
			if generalTruckDefIDs[unitDefID] then
				glColor(previewColor)
				DrawSupplyRingFull(generalTruckDefInfo, x, z)
			elseif supplyTruckDefIDs[unitDefID] then
				glColor(previewColor)
				DrawSupplyRingFull(supplyTruckDefInfo, x, z)
				glColor(color)
				DrawSupplyRingFull(supplyTruckMobileDefInfo, x, z)
			end
		end
	end
end

local function DrawMain()
	glColor(color)

	for _, supplyInfo in pairs(supplyInfos) do
		DrawSupplyRing(supplyInfo)
	end

	glColor(previewColor)

	for _, inBuildSupplyInfo in pairs(inBuildSupplyInfos) do
		local x, z = inBuildSupplyInfo.x, inBuildSupplyInfo.z
		local supplyDefInfo = inBuildSupplyInfo.supplyDefInfo
		DrawSupplyRingFull(supplyDefInfo, x, z)
	end

	glColor(1, 1, 1, 1)
end

local function CallMain()
	local supplyDefInfo
	local _, cmd_id = GetActiveCommand()
	if cmd_id then
		local unitDefID = -cmd_id
		supplyDefInfo = supplyDefInfos[unitDefID]
	end

	if supplyDefInfo then
		local bx, bz = GetMouseBuildPosition(supplyDefInfo[4], supplyDefInfo[5])
		if bx then
			glColor(previewColor)
			DrawSupplyRingFull(supplyDefInfo, bx, bz)
		end
	end

	if (showAlways or supplyDefInfo) then
		DrawTrucks()
		glCallList(mainList)
		return
	end

	if (showRollover) then
		local mx, my = GetMouseState()
		local mouseTargetType, mouseTarget = TraceScreenRay(mx, my)
		if mouseTargetType == "unit" then
			local targetDefID = GetUnitDefID(mouseTarget)
			if supplyInfos[mouseTarget]
					or inBuildSupplyInfos[mouseTarget]
					or generalTruckDefIDs[targetDefID]
					or supplyTruckDefIDs[targetDefID] then
				DrawTrucks()
				glCallList(mainList)
				return
			end
		end
	end

	if (showSelect) then
		local selectedUnitsCounts = GetSelectedUnitsCounts()
		for unitDefID, _ in pairs(selectedUnitsCounts) do
			if supplyDefInfos[unitDefID]
					or generalTruckDefIDs[unitDefID]
					or supplyTruckDefIDs[unitDefID] then
				DrawTrucks()
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

local function Reset()
	inBuildSupplyInfos = {}
	supplyInfos= {}

	local allUnits = GetAllUnits()
	for i=1,#allUnits do
		local unitID = allUnits[i]
		widget:UnitCreated(unitID, GetUnitDefID(unitID), GetUnitTeam(unitID))
	end

	UpdateLists()
end

------------------------------------------------
--callins
------------------------------------------------

function widget:UnitCreated(unitID, unitDefID, unitTeam, builderID)

	local _, _, inBuild = GetUnitIsStunned(unitID)
	if not inBuild then
		widget:UnitFinished(unitID, unitDefID, unitTeam)
		return
	end

	if (not AreTeamsAllied(unitTeam, myTeamID)) then
		return
	end

	local supplyDefInfo = supplyDefInfos[unitDefID]

	if (not supplyDefInfo) then return end

	--enter info
	local supplyInfo = {}
	supplyInfo.supplyDefInfo = supplyDefInfo

	local x, _, z = GetUnitPosition(unitID)
	supplyInfo.x, supplyInfo.z = x, z

	inBuildSupplyInfos[unitID] = supplyInfo

	UpdateLists()
end

function widget:UnitFinished(unitID, unitDefID, unitTeam)
	inBuildSupplyInfos[unitID] = nil

	if (not AreTeamsAllied(unitTeam, myTeamID)) then
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
	local _, _, inBuild = GetUnitIsStunned(unitID)
	if inBuild then
		widget:UnitCreated(unitID, unitDefID, unitTeam)
	else
		widget:UnitFinished(unitID, unitDefID, unitTeam)
	end
end

function widget:UnitTaken(unitID, unitDefID, unitTeam, newTeam)
	local _, _, inBuild = GetUnitIsStunned(unitID)
	if inBuild then
		widget:UnitCreated(unitID, unitDefID, unitTeam)
	else
		widget:UnitFinished(unitID, unitDefID, unitTeam)
	end
end

function widget:UnitDestroyed(unitID, unitDefID, unitTeam)
	local doUpdate = false
	local inBuildSupplyInfo = inBuildSupplyInfos[unitID]
	if inBuildSupplyInfo then
		inBuildSupplyInfos[unitID] = nil
		doUpdate = true
	end

	local supplyInfo = supplyInfos[unitID]
	if supplyInfo then
		supplyInfos[unitID] = nil
		UpdateRemove(unitID, supplyInfo)
		doUpdate = true
	end

	if doUpdate then
		UpdateLists()
	end
end

function widget:DrawWorldPreUnit()
	glPointSize(GetCameraScale())
	glSmoothing(true, false, false)
	glBlending(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA)
	CallMain()
	glSmoothing(false, false, false)
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
		if (unitDef.humanName ~= "Flag" and unitDef.speed == 0) then
			local radius = unitDef.customParams.buildrange or DEFAULT_BUILD_RANGE
			local numSegments = ceil(radius / segmentLength)
			local segmentAngle = 2 * PI / numSegments
			local oddX, oddZ
			if (unitDef.xsize % 4 == 2) then
				oddX = true
			end
			if (unitDef.zsize % 4 == 2) then
				oddZ = true
			end
			supplyDefInfos[unitDefID] = {radius, numSegments, segmentAngle, oddX, oddZ}
			inUse = true
		end
	end

	--remove self if unused
	if (not inUse) then
		widgetHandler:RemoveWidget()
	end

	myTeamID = GetMyTeamID()

	Reset()

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

function widget:Update(dt)
	local newMyTeamID = GetMyTeamID()
	if not AreTeamsAllied(newMyTeamID, myTeamID) then
		myTeamID = newMyTeamID
		Reset()
	else
		myTeamID = newMyTeamID
	end
end
