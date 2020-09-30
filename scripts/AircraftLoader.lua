local info = GG.lusHelper[unitDefID]

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

info.cegPieces = {}
info.bombPieces = {}
info.rocketWeapons = {}
info.aimPieces = {}
info.reversedWeapons = {}
info.smokePieces = {}
info.blades = {}

local pieceMap = Spring.GetUnitPieceMap(unitID)

for pieceName, pieceNum in pairs(pieceMap) do
	-- Find Wheel Speeds
	if pieceName:find("base") or pieceName:find("propeller") or pieceName:find("wing") or pieceName:find("fuselage") then
		info.smokePieces[#info.smokePieces + 1] = pieceNum
	end
	if pieceName:find("blades") then
		info.blades[#info.blades + 1] = pieceNum
	end
end


local lastflare = pieceMap["flare"] and "flare"
for weaponNum = 1,info.numWeapons do
	if info.reloadTimes[weaponNum] then -- don't want any shields etc.
		if WeaponDefs[UnitDef.weapons[weaponNum].weaponDef].customParams.bomb then
			info.bombPieces[weaponNum] = piece("bomb_" .. weaponNum)
			info.cegPieces[weaponNum] = piece("flare_" .. weaponNum) or info.bombPieces[weaponNum]
		elseif WeaponDefs[UnitDef.weapons[weaponNum].weaponDef].customParams.rocket then
			info.rocketWeapons[weaponNum] = true
		else
			lastflare = pieceMap["flare_" .. weaponNum] and ("flare_" .. weaponNum) or lastflare
			info.cegPieces[weaponNum] = pieceMap[lastflare]
			local headingPiece, pitchPiece = GetAimingPieces(unitID, lastflare, pieceMap)
			if headingPiece then
				info.aimPieces[weaponNum] = {headingPiece, pitchPiece}

				local reversed = WeaponDefs[UnitDef.weapons[weaponNum].weaponDef].customParams.reversed
				if reversed == nil then
					local _, _, _, dx, dy, dz = Spring.GetUnitPiecePosDir(unitID, pieceMap[lastflare])
					local frontDir = Spring.GetUnitVectors(unitID)
					local dotFront = dx * frontDir[1] + dy * frontDir[2] + dz * frontDir[3]
					if dotFront < 0 then
						info.reversedWeapons[weaponNum] = true
					end
				else
					info.reversedWeapons[weaponNum] = reversed
				end
			end
		end
	end
end
