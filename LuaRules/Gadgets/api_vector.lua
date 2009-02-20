function gadget:GetInfo()
	return {
		name      = "Vector API",
		desc      = "Basic vector functions.",
		author    = "Evil4Zerggin",
		date      = "13 February 2008",
		license   = "GNU LGPL, v2.1 or later",
		layer     = -10000,
		enabled   = true  --  loaded by default?
	}
end

local sin, cos = math.sin, math.cos
local sqrt = math.sqrt

local mapSizeX, mapSizeZ = Game.mapSizeX, Game.mapSizeZ

local function Magnitude(x, y, z)
	return sqrt(x * x + y * y + z * z)
end

local function Normalized(x, y, z)
	local mag = Magnitude(x, y, z)
	if mag == 0 then
		return 0, 0, 0, 0
	else
		return x / mag, y / mag, z / mag, mag
	end
end

local function RotateY(x, y, z, angle)
	local cosAngle = cos(angle)
	local sinAngle = sin(angle)
	return x * cosAngle + z * sinAngle, y, z * cosAngle - x * sinAngle
end

local function ClampToMapSize(x, y, z)
	if x < 0 then
		x = 0
	elseif x > mapSizeX then
		x = mapSizeX
	end
	
	if z < 0 then
		z = 0
	elseif z > mapSizeZ then
		z = mapSizeZ
	end
	
	return x, y, z
end

--return: x, y, z, distance
local function NearestMapEdge(x, y, z, margin)
	local xEdgeNeg = margin or 0
	local xEdgePos = mapSizeX - (margin or 0)
	local zEdgeNeg = margin or 0
	local zEdgePos = mapSizeZ - (margin or 0)
	
	local xDistNeg = x - xEdgeNeg
	local zDistNeg = z - zEdgeNeg
	local xDistPos = xEdgePos - x
	local zDistPos = zEdgePos - z
	local xDist, xEdge
	local zDist, zEdge
	if xDistNeg < xDistPos then
		xDist = xDistNeg
		xEdge = xEdgeNeg
	else
		xDist = xDistPos
		xEdge = xEdgePos
	end
	
	if zDistNeg < zDistPos then
		zDist = zDistNeg
		zEdge = zEdgeNeg
	else
		zDist = zDistPos
		zEdge = zEdgePos
	end
	
	if xDist < zDist then
		return xEdge, y , z, xDist
	else
		return x, y, zEdge, zDist
	end
end

local function DistanceToMapEdge(x, y, z)
	local xDistPos = mapSizeX - x
	local zDistPos = mapSizeZ - z
	
	local result = x
	if xDistPos < result then
		result = xDistPos
	end
	if z < result then
		result = z
	end
	if zDistPos < result then
		result = zDistPos
	end
	return result
end

local function HeadingToDegrees(h)
	return h * 360 / 65536
end

local function DegreesToHeading(d)
	return d * 65536 / 360
end

local Vector = {
	Magnitude = Magnitude,
	Normalized = Normalized,
	RotateY = RotateY,
	ClampToMapSize = ClampToMapSize,
	NearestMapEdge = NearestMapEdge,
	DistanceToMapEdge = DistanceToMapEdge,
	HeadingToDegrees = HeadingToDegrees,
	DegreesToHeading = DegreesToHeading,
}

if GG then
	GG.Vector = Vector
elseif WG then
	WG.Vector = Vector
end

