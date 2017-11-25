local function GetAimingPieces(unitID, pieceName, pieceMap)
	local headingPiece
	local pitchPiece
	local currentPiece = pieceName
	local i = 0
	while pieceMap[currentPiece] do
		if i > 20 then
			break
		end
		i = i + 1
		
		if currentPiece:find("turret") then
			headingPiece = pieceMap[currentPiece]
		end
		if currentPiece:find("sleeve") then
			pitchPiece = pieceMap[currentPiece]
		end
		if headingPiece and pitchPiece then
			break
		end
		
		local pieceInfo = Spring.GetUnitPieceInfo(unitID, pieceMap[currentPiece])
		currentPiece = pieceInfo.parent
	end
	return headingPiece, pitchPiece
end

local function GetTurretDefaultPositions(weaponNum)
	local cp = UnitDefs[unitDefID].customParams
	if cp then
		return cp['defaultheading' .. weaponNum] or 0, cp['defaultpitch' .. weaponNum] or 0
	end
	return 0, 0
end

local info = GG.lusHelper[unitDefID]

local numWheels = 0
local wheelSpeeds = {}
local tracks = {}
local trailerTracks = {}
local smokePieces = {}
local cegPieces = {}
local aimPieces = {}
local reversedWeapons = {}
local exhausts = {}
local dusttrails = {}

-- default position of the turret
local turretDefaultPositions = {}

-- Compositing
local childrenPieces = {}

local pieceMap = Spring.GetUnitPieceMap(unitID)
for pieceName, pieceNum in pairs(pieceMap) do
	-- Find Wheel Speeds
	if pieceName:find("wheel") then
		local wheelInfo = Spring.GetUnitPieceInfo(unitID, pieceNum)
		local wheelHeight = math.abs(wheelInfo.max[2] - wheelInfo.min[2])
		wheelSpeeds[pieceNum] = (UnitDefs[unitDefID].speed / wheelHeight)
		numWheels = numWheels + 1
	elseif pieceName:find("trailer_tracks") then
		trailerTracks[#trailerTracks + 1] = pieceNum
	elseif pieceName:find("tracks") then
		tracks[#tracks + 1] = pieceNum
	elseif pieceName:find("exhaust") then
		exhausts[#exhausts + 1] = pieceNum
	elseif pieceName:find("dusttrail") then
		dusttrails[#dusttrails + 1] = pieceNum
	elseif pieceName:find("base") or pieceName:find("sleeve") or pieceName:find("turret") or pieceName:find("exhaust") then
		smokePieces[#smokePieces + 1] = pieceNum
	elseif pieceName:find("child") then
		-- can't just put them all in array as is, order matters here!
		local _, endPos = pieceName:find("child")
		local childNum = tonumber(pieceName:sub(endPos + 1))
		childrenPieces[childNum] = pieceNum
	end
end

local lastflare = pieceMap["flare"] and "flare"
for weaponNum = 1,info.numWeapons do
	if info.reloadTimes[weaponNum] then -- don't want any shields etc.
		-- Modified this to support boat turrets
		lastflare = (pieceMap["flare_" .. weaponNum] and ("flare_" .. weaponNum)) or (pieceMap["flare" .. weaponNum] and ("flare" .. weaponNum)) or (pieceMap["r_rocket" .. weaponNum] and ("r_rocket" .. weaponNum)) or lastflare

		cegPieces[weaponNum] = pieceMap[lastflare]
		local headingPiece, pitchPiece = GetAimingPieces(unitID, lastflare, pieceMap)
		aimPieces[weaponNum] = {headingPiece, pitchPiece}
		
		local _, _, _, dx, dy, dz = Spring.GetUnitPiecePosDir(unitID, pieceMap[lastflare])
		local frontDir = Spring.GetUnitVectors(unitID)
		local dotFront = dx * frontDir[1] + dy * frontDir[2] + dz * frontDir[3]
		if dotFront < 0 then
			reversedWeapons[weaponNum] = true
		end
	end
	local defaultHeading, defaultPitch = GetTurretDefaultPositions(weaponNum)
	turretDefaultPositions[weaponNum] = {heading = defaultHeading, pitch = defaultPitch,}
end

info.numWheels = numWheels
info.wheelSpeeds = wheelSpeeds
info.tracks = tracks
info.trailerTracks = trailerTracks
info.smokePieces = smokePieces
info.cegPieces = cegPieces
info.aimPieces = aimPieces
info.reversedWeapons = reversedWeapons
info.dustTrails = dusttrails
info.exhausts = exhausts
info.childrenPieces = childrenPieces
info.turretDefaultPositions = turretDefaultPositions

if info.customAnimsName then
	info.customAnims = include("anims/vehicles/" .. info.customAnimsName .. ".lua")
end

