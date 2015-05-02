local info = GG.lusHelper[unitDefID]

info.cegPieces = {}
info.bombPieces = {}

local pieceMap = Spring.GetUnitPieceMap(unitID)
local lastflare = pieceMap["flare"] and "flare"
for weaponNum = 1,info.numWeapons do
	if info.reloadTimes[weaponNum] then -- don't want any shields etc.
		if WeaponDefs[UnitDef.weapons[weaponNum].weaponDef].bomb then
			info.bombPieces[weaponNum] = piece("bomb_" .. weaponNum)
			info.cegPieces[weaponNum] = piece("flare_" .. weaponNum) or info.bombPieces[weaponNum]
		else
			lastflare = pieceMap["flare_" .. weaponNum] and ("flare_" .. weaponNum) or lastflare
			info.cegPieces[weaponNum] = pieceMap[lastflare]		
		end
	end
end