local info = GG.lusHelper[unitDefID]

info.cegPieces = {}
info.bombPieces = {}

local pieceMap = Spring.GetUnitPieceMap(unitID)
local lastflare = pieceMap["flare"] and "flare"
for weaponNum = 1,info.numWeapons do
	if info.reloadTimes[weaponNum] then -- don't want any shields etc.
		if WeaponDefs[UnitDef.weapons[weaponNum].weaponDef].bomb then
			bombPieces[weaponNum] = piece "bomb_" .. weaponNum
		end
		lastflare = pieceMap["flare_" .. weaponNum] and ("flare_" .. weaponNum) or lastflare
		info.cegPieces[weaponNum] = pieceMap[lastflare]
	end
end