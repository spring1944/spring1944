local unitDefID = Spring.GetUnitDefID(unitID)
local teamID = Spring.GetUnitTeam(unitID)
local ud = UnitDefs[unitDefID]

local SIG_MOVE = 1

local children = {
		"rusbka-1125_turret_76mm", 
		"RUS_BKA_1125_Turret_DshK_Front", 
		"RUS_BKA_1125_Turret_DshK_Top", 
		"RUS_BKA_1125_Turret_DshK_Rear"
	}-- ud.customParams.children

-- Pieces
local function findPieces(input, name)
	local pieceMap = Spring.GetUnitPieceMap(unitID)
	--{ "piecename1" = pieceNum1, ... , "piecenameN" = pieceNumN }
	for pieceName, pieceNum in pairs(pieceMap) do
		local index = pieceName:find(name)
		if index then
			local num = tonumber(pieceName:sub(index + string.len(name), -1))
			input[num] = piece(pieceName)
		end
	end
end

local base = piece("base")

local childrenPieces = {} -- {[1] = unitname, etc}
findPieces(childrenPieces, "child")
local wakes = {}
findPieces(wakes, "wake")

function script.Create()
	local x,y,z = Spring.GetUnitPosition(unitID) -- strictly needed?
	for i, childDefName in ipairs(children) do
		Spring.Echo("CREATING", i, childDefName)
		local childID = Spring.CreateUnit(childDefName, x, y, z, 0, teamID)
		Spring.UnitScript.AttachUnit(childrenPieces[i], childID)
	end
	
end

local function EmitWakes()
	SetSignalMask(SIG_MOVE)
	while true do
		for wake in pairs(wakes) do
			EmitSfx(wake, 2)
		end
		Sleep(300)
	end
end

function script.StartMoving()
	Signal(SIG_MOVE)
	StartThread(EmitWakes)
end

function script.StopMoving()
	Signal(SIG_MOVE)
end
-- TODO: wakes etc
-- TODO: Killed
