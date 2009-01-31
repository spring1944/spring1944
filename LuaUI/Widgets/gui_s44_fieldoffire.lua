local versionNumber = "v1.2"

function widget:GetInfo()
	return {
		name = "1944 Field of Fire",
		desc = versionNumber .. " Indicates field of fire for deployable weapons.",
		author = "Evil4Zerggin",
		date = "5 January 2009",
		license = "GNU LGPL, v2.1 or later",
		layer = 1,
		enabled = true
	}
end

------------------------------------------------
--config
------------------------------------------------
local alpha = 1
local color = {1, 0.5, 0, alpha} --if no color specified, picks a hashed color for each unit
local deployDivs = 64
local sandbagDivs = 32
local startDistDeployable = 24
local startDistSandbagable = 16
local lineWidth = 1

------------------------------------------------
--vars
------------------------------------------------
--format: unitDefID = range
local deployables = {} --90 degree
local deployed = {}

local sandbagables = {} --120 degree
local sandbagged = {}

local deployList, sandbagList, deployedList, sandbaggedList

------------------------------------------------
--speedups
------------------------------------------------
local GetSelectedUnitsSorted = Spring.GetSelectedUnitsSorted
local GetUnitHeading = Spring.GetUnitHeading
local GetUnitPosition = Spring.GetUnitPosition

local glLineWidth = gl.LineWidth
local glColor = gl.Color

local glPushMatrix = gl.PushMatrix
local glPopMatrix = gl.PopMatrix
local glTranslate = gl.Translate
local glRotate = gl.Rotate
local glScale = gl.Scale

local glBeginEnd = gl.BeginEnd
local glVertex = gl.Vertex

local glCreateList = gl.CreateList
local glCallList = gl.CallList
local glDeleteList = gl.DeleteList

local sin, cos = math.sin, math.cos
local deg, rad = math.deg, math.rad

local strFind = string.find
local strSub = string.sub

local GL_LINE_STRIP = GL.LINE_STRIP
local GL_LINE_LOOP = GL.LINE_LOOP

local PI = math.pi

------------------------------------------------
--helper functions
------------------------------------------------

local function glRotateToUnitHeading(unitID)
	local rotation = GetUnitHeading(unitID) * 360 / 65536
	glRotate(rotation, 0, 1, 0)
end

local function SectorVertices(maxAngleDif, divs)
	local divAngle = maxAngleDif / divs
	glVertex(0, 0, 0)
	local angle = -0.5 * maxAngleDif
	for i=0,divs do
		glVertex(sin(angle), 0, cos(angle))
		angle = angle + divAngle
	end
end

local function AngleVertices(maxAngleDif)
	local halfAngle = 0.5 * maxAngleDif
	glVertex(-sin(halfAngle), 0, cos(halfAngle))
	glVertex(0, 0, 0)
	glVertex(sin(halfAngle), 0, cos(halfAngle))
end

local function DrawDeploy()
	glBeginEnd(GL_LINE_LOOP, SectorVertices, rad(90), deployDivs)
end

local function DrawSandbag()
	glBeginEnd(GL_LINE_LOOP, SectorVertices, rad(120), sandbagDivs)
end

local function DrawDeployed()
	glBeginEnd(GL_LINE_STRIP, AngleVertices, rad(90))
end

local function DrawSandbagged()
	glBeginEnd(GL_LINE_STRIP, AngleVertices, rad(120))
end

local function DrawDeployableFieldOfFire(unitID, range)
	local x, y, z = GetUnitPosition(unitID)
	
	glPushMatrix()
		glTranslate(x, y, z)
		glRotateToUnitHeading(unitID)
		glScale(range, 1, range)
		glCallList(deployList)
	glPopMatrix()
end

local function DrawSandbagableFieldOfFire(unitID, range)
	local x, y, z = GetUnitPosition(unitID)
	
	glPushMatrix()
		glTranslate(x, y, z)
		glRotateToUnitHeading(unitID)
		glScale(range, 1, range)
		glCallList(sandbagList)
	glPopMatrix()
end

local function DrawDeployedFieldOfFire(unitID, range)
	local x, y, z = GetUnitPosition(unitID)
	
	glPushMatrix()
		glTranslate(x, y, z)
		glRotateToUnitHeading(unitID)
		glScale(range, 1, range)
		glCallList(deployedList)
	glPopMatrix()
end

local function DrawSandbaggedFieldOfFire(unitID, range)
	local x, y, z = GetUnitPosition(unitID)
	
	glPushMatrix()
		glTranslate(x, y, z)
		glRotateToUnitHeading(unitID)
		glScale(range, 1, range)
		glCallList(sandbaggedList)
	glPopMatrix()
end

------------------------------------------------
--callins
------------------------------------------------
function widget:Initialize()
	local inUse = false
	for unitDefID, unitDef in ipairs(UnitDefs) do
		local stationaryName = unitDef.name
		if strSub(stationaryName, -11) == "_stationary" then
			local mobileName = strSub(stationaryName, 1, -12)
			local mobileDef = UnitDefNames[mobileName]
			if (mobileDef) then
				local mobileDefID = mobileDef.id
				if (mobileDefID) then
					deployables[mobileDefID] = unitDef.maxWeaponRange
					deployed[unitDefID] = unitDef.maxWeaponRange
					inUse = true
				end
			end
			
			if mobileName then
			
				local truckName = mobileName .. "_truck"
				
				local truckDef = UnitDefNames[truckName]
				if (truckDef) then
					local truckDefID = truckDef.id
					if (truckDefID) then
						deployables[truckDefID] = unitDef.maxWeaponRange
						deployed[unitDefID] = unitDef.maxWeaponRange
						inUse = true
					end
				end
			end
		elseif strSub(stationaryName, -8) == "_sandbag" then
			local mobileName = strSub(stationaryName, 1, -9)
			
			local mobileDef = UnitDefNames[mobileName]
			if mobileDef then
				local mobileDefID = mobileDef.id
				if mobileDefID then
					sandbagables[mobileDefID] = unitDef.maxWeaponRange
					sandbagged[unitDefID] = unitDef.maxWeaponRange
					inUse = true
				end
			end
		end
	end
	
	--remove self if unused
	if (not inUse) then
		widgetHandler:RemoveWidget()
	end
	
	deployList = glCreateList(DrawDeploy)
	sandbagList = glCreateList(DrawSandbag)
	deployedList = glCreateList(DrawDeployed)
	sandbaggedList = glCreateList(DrawSandbagged)
end

function widget:Shutdown()
	glDeleteList(deployList)
	glDeleteList(sandbagList)
	glDeleteList(deployedList)
	glDeleteList(sandbaggedList)
end

function widget:DrawWorld()
	glColor(color)
	glLineWidth(lineWidth)
	
	local selectedUnitsSorted = GetSelectedUnitsSorted()
	
	for unitDefID, range in pairs(deployables) do
		local units = selectedUnitsSorted[unitDefID]
		if units then
			for i=1,#units do
				local unitID = units[i]
				DrawDeployableFieldOfFire(unitID, range)
			end
		end
	end
	
	for unitDefID, range in pairs(deployed) do
		local units = selectedUnitsSorted[unitDefID]
		if units then
			for i=1,#units do
				local unitID = units[i]
				DrawDeployedFieldOfFire(unitID, range)
			end
		end
	end
	
	for unitDefID, range in pairs(sandbagables) do
		local units = selectedUnitsSorted[unitDefID]
		if units then
			for i=1,#units do
				local unitID = units[i]
				DrawSandbagableFieldOfFire(unitID, range)
			end
		end
	end
	
	for unitDefID, range in pairs(sandbagged) do
		local units = selectedUnitsSorted[unitDefID]
		if units then
			for i=1,#units do
				local unitID = units[i]
				DrawSandbaggedFieldOfFire(unitID, range)
			end
		end
	end
	
	glLineWidth(1)
	glColor(1, 1, 1, 1)
end
