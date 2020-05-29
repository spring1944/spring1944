local luaType = gadget or widget

local versionNumber = "v1.0"

function luaType:GetInfo()
	return {
		name      = "Vector API",
		desc      = "Basic vector functions." .. versionNumber,
		author    = "Evil4Zerggin",
		date      = "13 February 2008",
		license   = "GNU LGPL, v2.1 or later",
		layer     = -10000,
		enabled   = true  --  loaded by default?
	}
end

local sin, cos = math.sin, math.cos
local sqrt = math.sqrt
local PI = math.pi

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
local function Elevate(x,y,z, ux,uy,uz, angle)
	local cosAngle = cos(angle)
	local sinAngle = sin(angle)
	return x*cosAngle + ux*sinAngle, y*cosAngle + uy*sinAngle, z*cosAngle + uz*sinAngle
end

local function RotateY(x, y, z, angle)
	local cosAngle = cos(angle)
	local sinAngle = sin(angle)
	return x * cosAngle + z * sinAngle, y, z * cosAngle - x * sinAngle
end

local function RotateX(x, y, z, angle)
	local cosAngle = cos(angle)
	local sinAngle = sin(angle)
	return x, y * cosAngle - z * sinAngle, z * cosAngle + y * sinAngle
end
	
local function RotateZ(x, y, z, angle)
	local cosAngle = cos(angle)
	local sinAngle = sin(angle)
	return x * cosAngle - y * sinAngle, y * cosAngle + x * sinAngle, z
end	
	
local function RotateYXZ(x, z, angle)
	local x2, _, z2 = RotateY(x, 1, z, angle)
	return x2, z2
end

local function Rotate3(x, y, z, rx, ry, rz)
	return RotateZ(RotateY(RotateX(x,y,z, rx), ry), rz)
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

local function HeadingToRadians(h)
	return h * PI / 32368
end

local function RadiansToHeading(r)
	return r * 32368 / PI
end

local function DotProduct2(x1, y1, x2, y2) 
	-- Projection(x1, y1, nx, ny) 
	return x1 * x2 + y1 * y2
end

local function DotProduct3(x1, y1, z1, x2, y2, z2)
	return DotProduct2(x1, y1, x2, y2) + z1 * z2
end

local function CosAngle3(x1, y1, z1, x2, y2, z2)
	return (DotProduct3(x1,y1,z1,x2,y2,z2)/(Magnitude(x1, y1, z1) * Magnitude(x2, y2, z2)))
end

local function EffectiveThickness(actual, x1, y1, z1, x2, y2, z2)
	return math.abs(actual / CosAngle3(x1, y1, z1, x2, y2, z2))
end

local function CounterClockNorm(x1, y1)
	return -y1, x1
end

local function Clockwise(x1, y1, x2, y2)
	-- equivalent to return DotProduct2(x2, y2, CounterClockNorm(x1, y1)) < 0
	return -x1 * y2 + y1 * x2 > 0
end

-- functions assumes you already checked the point is inside the circle, e.g. polling units returned by Spring.IsUnitInCylinder

-- Sector defined by vector
local function IsInsideSectorVector(x1, y1, cx, cy, startX, startY, endX, endY)
	local dx = cx - x1
	local dy = cy - y1
	
	return not Clockwise(startX, startY, dx, dy) and Clockwise(endX, endY, dx, dy)
end

-- Sector defined by direction vector and sector angle, in rads
local function IsInsideSectorAngle(x1, z1, cx, cz, dirx, dirz, angle)
	return IsInsideSectorAssumedVector(x1, z1, cx, cz, RotateYXZ(dirx, dirz, -angle/2), RotateYXZ(dirx, dirz, angle/2)) 
end

local function SectorVectorsFromAngle(angle, length)
	local theta = angle/2
	local x = length * math.sin(theta)
	local z = length * math.cos(theta)
	--Spring.Echo("SVFA", angle, length, x, z, -x, -z)
	return x, z, -x, z
end

local function SectorVectorsFromUnit(unitID, xLen, zLen)
	-- xlen, zlen is (cached) length of x,z vectors when facing forwards
	local front, up, right = Spring.GetUnitVectors(unitID)
	local v1x, v1z = front[1] * zLen + right[1]* xLen, front[3] * zLen + right[3] * xLen
	local v2x, v2z = front[1] * zLen - right[1]* xLen, front[3] * zLen - right[3] * xLen
	return v1x, v1z, v2x, v2z
end

local function SectorVectorsFromUnitPiece(unitID, pieceID, xLen, zLen)
	local _, _, _, x, y, z = Spring.GetUnitPiecePosDir(unitID, pieceID)
	--Spring.Echo(x,y,z,Normalized(x,y,z))
	--x, y, z = Normalized(x, y, z)
	--return x * 1000, z * 1000, z * 1000, -x * 1000
	local rx, rz = -z, x
	local v1x, v1z = x * zLen + rx * xLen, z * zLen + rz * xLen
	local v2x, v2z = x * zLen - rx * xLen, z * zLen - rz * xLen
	return v1x, v1z, v2x, v2z
end

local function MultMatrix3(m, x,y,z)
	return 	m[1]*x+m[5]*y+m[9]*z,--+m[13]*1, 
			m[2]*x+m[6]*y+m[10]*z,--+m[14]*1, 
			m[3]*x+m[7]*y+m[11]*z,--+m[15]*1, 
			m[4]*x+m[8]*y+m[12]*z--+m[16]*1
end

local function PrintMatrix(matrix)
	for i = 1, 4 do
		Spring.Echo(string.format("%.2f", matrix[i]), string.format("%.2f", matrix[i+4]), string.format("%.2f", matrix[i+8]), string.format("%.2f", matrix[i+12]))
	end
end

local Vector = {
	Magnitude = Magnitude,
	Normalized = Normalized,
	Elevate = Elevate,
	RotateY = RotateY,
	RotateX = RotateX,
	RotateZ = RotateZ,
	Rotate3 = Rotate3,
	ClampToMapSize = ClampToMapSize,
	NearestMapEdge = NearestMapEdge,
	DistanceToMapEdge = DistanceToMapEdge,
	HeadingToDegrees = HeadingToDegrees,
	DegreesToHeading = DegreesToHeading,
	HeadingToRadians = HeadingToRadians,
	RadiansToHeading = RadiansToHeading,
	DotProduct2 = DotProduct2,
	DotProduct3 = DotProduct3,
	CosAngle3 = CosAngle3,
	EffectiveThickness = EffectiveThickness,
	IsInsideSectorVector = IsInsideSectorVector,
	SectorVectorsFromAngle = SectorVectorsFromAngle,
	SectorVectorsFromUnit = SectorVectorsFromUnit,
	SectorVectorsFromUnitPiece = SectorVectorsFromUnitPiece,
	MultMatrix3 = MultMatrix3,
	PrintMatrix = PrintMatrix,
}

if GG then
	GG.Vector = Vector
elseif WG then
	WG.Vector = Vector
end

