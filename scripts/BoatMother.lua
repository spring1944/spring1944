local unitDefID = Spring.GetUnitDefID(unitID)
local teamID = Spring.GetUnitTeam(unitID)
local ud = UnitDefs[unitDefID]

local children = {"rusbka-1125_turret_76mm"}-- ud.customParams.children
-- Pieces
local base = piece("base")

local childrenPieces = {} -- {[1] = unitname, etc}
-- Auto-Detect Child Pieces
local pieceMap = Spring.GetUnitPieceMap(unitID)
--{ "piecename1" = pieceNum1, ... , "piecenameN" = pieceNumN }
for pieceName, pieceNum in pairs(pieceMap) do
	local childIndex = pieceName:find("child")
	if childIndex then
		local childNum = tonumber(pieceName:sub(childIndex+5, -1))
		childrenPieces[childNum] = piece(pieceName)
		--Spring.Echo(childNum, pieceName)
	end
end

function script.Create()
	local x,y,z = Spring.GetUnitPosition(unitID) -- strictly needed?
	for i, childDefName in ipairs(children) do
		Spring.Echo("CREATING", i, childDefName)
		local childID = Spring.CreateUnit(childDefName, x, y, z, 0, teamID)
		Spring.UnitScript.AttachUnit(childrenPieces[i], childID)
	end
	
end


-- TODO: wakes etc
-- TODO: Killed
