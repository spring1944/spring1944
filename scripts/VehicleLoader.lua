do

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


	local info = GG.lusHelper[unitDefID]

	local wheelSpeeds = {}
	local tracks = {}
	local smokePieces = {}
	local cegPieces = {}
	local aimPieces = {}
	local reversedWeapons = {}


	local pieceMap = Spring.GetUnitPieceMap(unitID)
	for pieceName, pieceNum in pairs(pieceMap) do
		-- Find Wheel Speeds
		if pieceName:find("wheel") then
			local wheelInfo = Spring.GetUnitPieceInfo(unitID, pieceNum)
			local wheelHeight = math.abs(wheelInfo.max[2] - wheelInfo.min[2])
			wheelSpeeds[pieceNum] = (UnitDefs[unitDefID].speed / wheelHeight)
		elseif pieceName:find("tracks") then
			tracks[#tracks + 1] = pieceNum
		elseif pieceName:find("base") or pieceName:find("sleeve") or pieceName:find("turret") or pieceName:find("exhaust") then
			smokePieces[#smokePieces + 1] = pieceNum
		end
	end

	local lastflare = pieceMap["flare"] and "flare"
	for weaponNum = 1,info.numWeapons do
		if info.reloadTimes[weaponNum] then -- don't want any shields etc.
			lastflare = pieceMap["flare_" .. weaponNum] and ("flare_" .. weaponNum) or lastflare
			Spring.Echo(UnitDefs[unitDefID].name, weaponNum, lastflare)
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
	end

	info.wheelSpeeds = wheelSpeeds
	info.tracks = tracks
	info.smokePieces = smokePieces
	info.cegPieces = cegPieces
	info.aimPieces = aimPieces
	info.reversedWeapons = reversedWeapons
end