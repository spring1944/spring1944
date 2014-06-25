local unitDefID = Spring.GetUnitDefID(unitID)
local teamID = Spring.GetUnitTeam(unitID)
local ud = UnitDefs[unitDefID]

local children = {"rusbka_1125_turret_76mm"}-- ud.customParams.children
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
	end
end

--[[function Script.Create()
	Spring.Echo("ALIVE!#2")
	local x,y,z = Spring.GetUnitPosition(unitID) -- strictly needed?
	for i, childDefName in ipairs(children) do
		Spring.Echo("CREATING", i, childDefName)
		local childID = Spring.CreateUnit(childDefName, x, y, z, 0, teamID)
		Spring.UnitScript.AttachUnit(childrenPieces[i], childID)
	end
end]]

Spring.Echo("ALIVE! #1")

function Script.Create()
	StartFlagThread(teamID)
end

Spring.Echo("ALIVE! #3")

-- TODO: wakes etc
-- TODO: Killed