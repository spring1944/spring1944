-- Author: Tobi Vollebregt (11 feb 2009)
-- Author: Evil4Zerggin (gui_s44_supplyradius.lua version 1.9, 5 jan 2009, SVN rev 930)
-- License: GNU LGPL, v2.1 or later

--[[
This class is implemented as a single function returning a table with public
interface methods.  Private data is stored in the function's closure.

Public interface:

local buildsiteFinder = CreateBuildsiteFinder(myTeamID)

function buildsiteFinder.UnitCreated(unitID, unitDefID, unitTeam)
	Must be called for each unit entering the team
	(e.g. from gadget:UnitCreated, gadget:UnitGiven)

function buildsiteFinder.UnitDestroyed(unitID, unitDefID, unitTeam)
	Must be called for each unit leaving the team
	(e.g. from gadget:UnitDestroyed, gadget:UnitTaken)

function buildsiteFinder.FindBuildsite(builderID, unitDefID, closest)
	Returns x, y, z, facing if it finds a suitable buildsite for unitDefID.
	builderID is currently used only to determine optimal build facing.
	Returns nil if it can not find a suitable buildsite.

Mod interface:

unitDef.customParams.buildrange defines the radius of the circle around this
building on which the AI will try to build. (default: DEFAULT_BUILD_RANGE)
--]]

local function CreateBuildsiteFinder(myTeamID)

-- keeping the original name may be easier
-- when backporting fixes from the widget
local widget = {}

------------------------------------------------
--config
------------------------------------------------
local segmentLength = 10

local DEFAULT_BUILD_RANGE = 250

------------------------------------------------
--vars
------------------------------------------------

local abs = math.abs
local sin, cos = math.sin, math.cos
local ceil, floor = math.ceil, math.floor
local min, max = math.min, math.max
local PI = math.pi

--format: unitDefID = {radius, numSegments, segmentAngle, oddX, oddZ}
local supplyDefInfos = {}

--format: unitID = {[1] = bool, [2] = bool, ... [numSegments] = bool, r = number, numSegments = number, segmentAngle = number, x = number, y = number, z = number}
local supplyInfos = {}

------------------------------------------------
--speedups and constants
------------------------------------------------
local GetUnitSeparation = Spring.GetUnitSeparation
local GetUnitPosition = Spring.GetUnitPosition
local AreTeamsAllied = Spring.AreTeamsAllied
local GetUnitDefID = Spring.GetUnitDefID
local GetUnitTeam = Spring.GetUnitTeam
local GetGroundHeight = Spring.GetGroundHeight
local GetTeamUnits = Spring.GetTeamUnits
local TestBuildOrder = Spring.TestBuildOrder

local strFind = string.find
local strSub = string.sub

local MAP_SIZE_X = Game.mapSizeX
local MAP_SIZE_Z = Game.mapSizeZ

------------------------------------------------
--util
------------------------------------------------
local function DistSq(x1, z1, x2, z2)
	local dx, dz = x2 - x1, z2 - z1
	return dx * dx + dz * dz
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
			local distSq = DistSq(x1, z1, x, z)
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
			local distSq = DistSq(x1, z1, x, z)
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
		local distSq = DistSq(x1, z1, x, z)
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

local function Reset()
	supplyInfos= {}

	local allUnits = GetTeamUnits(myTeamID)
	for i=1,#allUnits do
		local unitID = allUnits[i]
		widget.UnitCreated(unitID, GetUnitDefID(unitID), GetUnitTeam(unitID))
	end
end

------------------------------------------------
--drawing
------------------------------------------------
-- T: modified to update table of vertices
local function DrawSupplyRing(supplyInfo, vertices)
	local supplyDefInfo = supplyInfo.supplyDefInfo
	local angle = 0
	local r = supplyInfo.r
	local segmentAngle = supplyInfo.segmentAngle
	local x, y, z = supplyInfo.x, supplyInfo.y, supplyInfo.z
	local vi = vertices.vi
	for i=1, supplyInfo.numSegments do
		if (supplyInfo[i]) then
			local gx, gz = x + r * cos(angle), z + r * sin(angle)
			local gy = GetGroundHeight(gx, gz)
			if gy and gy > 0 then -- T: Underwater spots are not of interest currently
				vertices[vi] = {gx, gy, gz}
				vi = vi + 1
			end
		end
		angle = angle + segmentAngle
	end
	vertices.vi = vi
end

-- T: modified to return table of vertices
local function DrawMain()
	local vertices = {vi = 1}
	for _, supplyInfo in pairs(supplyInfos) do
		DrawSupplyRing(supplyInfo, vertices)
	end
	return vertices
end

------------------------------------------------
--callins
------------------------------------------------

function widget.UnitCreated(unitID, unitDefID, unitTeam)
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
end

function widget.UnitDestroyed(unitID, unitDefID, unitTeam)
	local supplyInfo = supplyInfos[unitID]
	if supplyInfo then
		supplyInfos[unitID] = nil
		UpdateRemove(unitID, supplyInfo)
	end
end

local function Initialize()
	for unitDefID, unitDef in pairs(UnitDefs) do
		if (not gadget.flags[unitDefID] and unitDef.speed == 0) then
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
		end
	end

	Reset()
end

------------------------------------------------
--here ends the part copied from gui_s44_supplyradius.lua
------------------------------------------------

-- The implementation of this function is copied from KP_AI_31.lua
-- (Kernel Panic AI, KDR_11k (David Becker), modified by zwzsg)
local function FindFacing(x, y, z)
	local dir
	if math.abs(MAP_SIZE_X - 2*x) > math.abs(MAP_SIZE_Z - 2*z) then
		if (2*x>MAP_SIZE_X) then
			dir=3
		else
			dir=1
		end
	else
		if (2*z>MAP_SIZE_Z) then
			dir=2
		else
			dir=0
		end
	end
	return dir
end

-- Wee, the first function in this file written by myself!
-- This is main public method; it finds good buildsites.
-- returns x,y,z,facing, or nil if it can not find any build position
function widget.FindBuildsite(builderID, unitDefID, closest)
	-- build list of points, similar to points shown by S44 supplyradius widget,
	-- but with different radii (currently fixed for all buildings)
	local vertices = DrawMain()
	local count = vertices.vi

	-- assume builder position is representative for base position
	local x,y,z = GetUnitPosition(builderID)
	local facing = FindFacing(x,y,z)

	-- only use the "advanced" algorithm for buildings,
	-- and when there is already at least one building.
	if UnitDefs[unitDefID].speed == 0 and count > 1.5 then
		if closest then
			for _,v in ipairs(vertices) do
				local dx,dz = (x-v[1]), (z-v[3])
				v.sqdist = dx*dx + dz*dz
			end
			table.sort(vertices, function (a, b) return a.sqdist < b.sqdist end)
			for _,v in ipairs(vertices) do
				if TestBuildOrder(unitDefID, v[1],v[2],v[3], facing) > 0 then
					return v[1],v[2],v[3],facing
				end
			end
		else
			-- repeatedly try a random vertex until either we found one we can build on,
			-- or we tried as many times as there are vertices
			local watchdog = 0
			repeat
				-- get random vertex from the list
				local i = math.random(0, count-1)
				local v = vertices[i]
				-- don't call TestBuildOrder multiple times for the same vertex
				vertices[i] = nil
				if v and TestBuildOrder(unitDefID, v[1],v[2],v[3], facing) > 0 then
					return v[1],v[2],v[3],facing
				end
				watchdog = watchdog + 1
			until watchdog >= count
			-- TODO: as last resort, do an exhaustive search over all vertices?
		end
	end

	-- fallback: try to pick some random build site, preferably in range of the builder
	local range = 0.5 * UnitDefs[GetUnitDefID(builderID)].buildDistance
	for _=1,10 do
		local tx = x + math.random(-range, range)
		local tz = z + math.random(-range, range)
		if TestBuildOrder(unitDefID, tx,y,tz, facing) == 2 then
			return tx,y,tz,facing
		end
		range = range * 1.5
	end

	-- we did our best, but to no avail... maybe we get lucky next time
	return nil
end

    Initialize()
    return widget
end

return {
    CreateBuildsiteFinder = CreateBuildsiteFinder
}
