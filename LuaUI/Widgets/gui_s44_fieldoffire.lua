local versionNumber = "v1.4"

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
local lineWidth = 1
local divsPerRadian = 16

------------------------------------------------
--vars
------------------------------------------------
--format: unitDefID = {list, range}
local unitDefInfos = {}

local stationaryLists = {}
local mobileLists = {}

------------------------------------------------
--speedups
------------------------------------------------
local GetSelectedUnitsSorted = Spring.GetSelectedUnitsSorted
local GetUnitHeading = Spring.GetUnitHeading
local GetUnitPosition = Spring.GetUnitPosition

local glLineWidth = gl.LineWidth
local glColor = gl.Color

local glCreateList = gl.CreateList
local glCallList = gl.CallList
local glDeleteList = gl.DeleteList

local glPushMatrix = gl.PushMatrix
local glPopMatrix = gl.PopMatrix
local glTranslate = gl.Translate
local glRotate = gl.Rotate
local glScale = gl.Scale

local glShape = gl.Shape

local glDepthTest = gl.DepthTest

local vHeadingToDegrees = WG.Vector.HeadingToDegrees

local acos = math.acos
local sin, cos = math.sin, math.cos
local deg, rad = math.deg, math.rad
local ceil = math.ceil
local sqrt = math.sqrt

local strFind = string.find
local strSub = string.sub
local strLen = string.len

local GL_LINE_STRIP = GL.LINE_STRIP
local GL_LINE_LOOP = GL.LINE_LOOP

local PI = math.pi
local RAD1 = rad(1)

------------------------------------------------
--helper functions
------------------------------------------------

local function DrawMobile(maxAngleDif)
	local vertices = {
		{v = {0, 0, 0}},
	}
	
	local angle = acos(maxAngleDif)
	local divs = ceil(2 * angle * divsPerRadian)
	local angleIncrement = 2 * angle / divs
	local i = 2
	for j = 0, divs do
		vertices[i] = {v = {sin(angle), 0, cos(angle)}}
		angle = angle - angleIncrement
		i = i + 1
	end
	
	glShape(GL_LINE_LOOP, vertices)
end

local function DrawStationary(maxAngleDif)
	local length = maxAngleDif
	local width = sqrt(1 - maxAngleDif * maxAngleDif)
	local vertices = {
		{v = {-width, 0, length}},
		{v = {0, 0, 0}},
		{v = {width, 0, length}},
	}
	
	glShape(GL_LINE_STRIP, vertices)
end

local function DrawFieldOfFire(unitID, list, range)
	local x, y, z = GetUnitPosition(unitID)
	
	glPushMatrix()
		glTranslate(x, y, z)
		glRotate(vHeadingToDegrees(GetUnitHeading(unitID)), 0, 1, 0)
		glScale(range, range, range)
		glCallList(list)
	glPopMatrix()
end

local function GetUnitDefMaxAngleDif(unitDef)
	local weapons = unitDef.weapons
	if not weapons then return -1 end
	local weapon1 = weapons[1]
	if not weapon1 then return -1 end
	return weapon1.maxAngleDif
end

local function GetBasename(name)
	local underscoreIndex = strFind(name, "_")
	if underscoreIndex then
		return strSub(name, 1, underscoreIndex - 1)
	else
		return name
	end
end

------------------------------------------------
--callins
------------------------------------------------
function widget:Initialize()
	local inUse = false
	--outer loop: stationaries
	for stationaryUnitDefID, stationaryUnitDef in ipairs(UnitDefs) do
		local maxAngleDif = GetUnitDefMaxAngleDif(stationaryUnitDef)
		if maxAngleDif > 0 and stationaryUnitDef.speed == 0 then
			--create stationary list
			local list = stationaryLists[maxAngleDif]
			local range = stationaryUnitDef.maxWeaponRange
			if not list then
				list = glCreateList(DrawStationary, maxAngleDif)
				stationaryLists[maxAngleDif] = list
			end
			unitDefInfos[stationaryUnitDefID] = {list, range}
			
			inUse = true
			
			--look for mobiles
			local staticBasename = GetBasename(stationaryUnitDef.name)
			
			for mobileUnitDefID, mobileUnitDef in ipairs(UnitDefs) do
				if mobileUnitDef.speed > 0 then
					local mobileBasename = GetBasename(mobileUnitDef.name)
					if mobileBasename == staticBasename then
						local list = mobileLists[maxAngleDif]
						if not list then
							list = glCreateList(DrawMobile, maxAngleDif)
							mobileLists[maxAngleDif] = list
						end
						unitDefInfos[mobileUnitDefID] = {list, range}
					end
				end
			end
		end
	end
	
	--remove self if unused
	if (not inUse) then
		widgetHandler:RemoveWidget()
	end
end

function widget:Shutdown()
	for _, list in pairs(stationaryLists) do
		glDeleteList(list)
	end
	
	for _, list in pairs(mobileLists) do
		glDeleteList(list)
	end
end

function widget:DrawWorld()
	glColor(color)
	glLineWidth(lineWidth)
	glDepthTest(false)
	
	local selectedUnitsSorted = GetSelectedUnitsSorted()
	
	for unitDefID, info in pairs(unitDefInfos) do
		local units = selectedUnitsSorted[unitDefID]
		if units then
			for i=1,#units do
				local unitID = units[i]
				DrawFieldOfFire(unitID, info[1], info[2])
			end
		end
	end
	
	glLineWidth(1)
	glColor(1, 1, 1, 1)
end
