local versionNumber = "v1.1"

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
local startDistDeployable = 24
local startDistSandbagable = 16
local lineWidth = 1

------------------------------------------------
--vars
------------------------------------------------
--format: unitDefID = range
local deployables = {} --90 degree
local sandbagables = {} --120 degree
------------------------------------------------
--speedups
------------------------------------------------
local GetSelectedUnitsSorted = Spring.GetSelectedUnitsSorted
local GetUnitDirection = Spring.GetUnitDirection
local GetUnitPosition = Spring.GetUnitPosition
local GetUnitRadius = Spring.GetUnitRadius

local glLineWidth = gl.LineWidth
local glColor = gl.Color
local glShape = gl.Shape
local glTranslate = gl.Translate
local glPopMatrix = gl.PopMatrix
local glPushMatrix = gl.PushMatrix

local floor = math.floor
local sqrt = math.sqrt

local strFind = string.find
local strSub = string.sub

local GL_LINES = GL.LINES

local SQRT_HALF = sqrt(0.5)
local SQRT_THREE_QUARTERS = sqrt(0.75)

------------------------------------------------
--helper functions
------------------------------------------------
local function HashColor(x)
	local hue = x * SQRT_HALF * 42
	hue = hue - floor(hue)
	hue = hue * 6
	
	local huePart = hue - floor(hue)
	
	if (hue < 1) then
		glColor(1, huePart, 0, alpha)
	elseif (hue < 2) then
		glColor(1, 0, huePart, alpha)
	elseif (hue < 3) then
		glColor(huePart, 1, 0, alpha)
	elseif (hue < 4) then
		glColor(0, 1, huePart, alpha)
	elseif (hue < 5) then
		glColor(huePart, 0, 1, alpha)
	else
		glColor(0, huePart, 1, alpha)
	end
end

local function DrawDeployableFieldOfFire(unitID, range)
	local x, y, z = GetUnitPosition(unitID)
	local dx, _, dz = GetUnitDirection(unitID)
	
	if (dx == 0 and dz == 0) then return end
	
	--normalize and multiply by sqrt(0.5)
	local dg = sqrt(dx * dx + dz * dz)
	dx, dz = SQRT_HALF * dx / dg, SQRT_HALF * dz / dg
	
	local sum = dx + dz
	local diff = dx - dz
	
	local vertices = {
		{v = {startDistDeployable * diff, 0, startDistDeployable * sum}},
		{v = {range * diff, 0, range * sum}},
		{v = {startDistDeployable * sum, 0, startDistDeployable * -diff}},
		{v = {range * sum, 0, range * -diff}},
	}
	
	glPushMatrix()
		if (not color) then
			HashColor(unitID)
		end
		glTranslate(x, y, z)
		glShape(GL_LINES, vertices)
	glPopMatrix()
end

local function DrawSandbagableFieldOfFire(unitID, range)
	local x, y, z = GetUnitPosition(unitID)
	local dx, _, dz = GetUnitDirection(unitID)
	
	if (dx == 0 and dz == 0) then return end
	
	local dg = sqrt(dx * dx + dz * dz)
	dx, dz = dx / dg, dz / dg
	local half_dx, half_dz = 0.5 * dx, 0.5 * dz
	local root_dx, root_dz = SQRT_THREE_QUARTERS * dx, SQRT_THREE_QUARTERS * dz
	
	local sum = dx + dz
	local diff = dx - dz
	
	local vertices = {
		{v = {startDistSandbagable * (half_dx - root_dz), 0, startDistSandbagable * (half_dz + root_dx)}},
		{v = {range *                (half_dx - root_dz), 0, range *                (half_dz + root_dx)}},
		{v = {startDistSandbagable * (half_dx + root_dz), 0, startDistSandbagable * (half_dz - root_dx)}},
		{v = {range *                (half_dx + root_dz), 0, range *                (half_dz - root_dx)}},
	}
	
	glPushMatrix()
		if (not color) then
			HashColor(unitID)
		end
		glTranslate(x, y, z)
		glShape(GL_LINES, vertices)
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
			
			--debug
			--Spring.Echo(mobileName)
			
			local mobileDef = UnitDefNames[mobileName]
			if (mobileDef) then
				local mobileDefID = mobileDef.id
				if (mobileDefID) then
					deployables[mobileDefID] = unitDef.maxWeaponRange
					deployables[unitDefID] = unitDef.maxWeaponRange
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
						deployables[unitDefID] = unitDef.maxWeaponRange
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
					sandbagables[unitDefID] = unitDef.maxWeaponRange
					inUse = true
				end
			end
		end
	end
	
	--remove self if unused
	if (not inUse) then
		widgetHandler:RemoveWidget()
	end
end

function widget:DrawWorld()
	if (color) then
		glColor(color)
	end
	glLineWidth(lineWidth)
	
	local selectedUnitsSorted = GetSelectedUnitsSorted()
	
	for unitDefID, range in pairs(deployables) do
		local units = selectedUnitsSorted[unitDefID]
		if (units) then
			for i=1,#units do
				local unitID = units[i]
				DrawDeployableFieldOfFire(unitID, range)
			end
		end
	end
	
	for unitDefID, range in pairs(sandbagables) do
		local units = selectedUnitsSorted[unitDefID]
		if (units) then
			for i=1,#units do
				local unitID = units[i]
				DrawSandbagableFieldOfFire(unitID, range)
			end
		end
	end
	
	glLineWidth(1)
	glColor(1, 1, 1, 1)
end
