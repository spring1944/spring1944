local teamID = Spring.GetUnitTeam(unitID)
local currentSide -- intentionally nil
-- Pieces
local base = piece("base")

local flags = {} -- {nationcode = piecenum}
-- Auto-Detect Flag Pieces
local pieceMap = Spring.GetUnitPieceMap(unitID)
--{ "piecename1" = pieceNum1, ... , "piecenameN" = pieceNumN }
for pieceName, pieceNum in pairs(pieceMap) do
	local flagIndex = pieceName:find("flag")
	if flagIndex then
		local nation = pieceName:sub(1, flagIndex - 1)
		flags[nation] = piece(pieceName)
	end
end

function StartFlagThread(teamID)
	StartThread(SetFlag, teamID)
end
	
function SetFlag(teamID)
	if currentSide then
		Move(flags[currentSide], y_axis, 0, 20)
		WaitForMove(flags[currentSide], y_axis)
	end
	local side = GG.teamSide[teamID]
	if side ~= "" then
		Move(flags[side], y_axis, 65, 10)
		WaitForMove(flags[side], y_axis)
		currentSide = side
	end
end

function script.Create()
--	StartFlagThread(teamID)
end

function script.WindChanged (heading, strength)
	if currentSide then
		Turn(flags[currentSide], y_axis, heading, math.rad(20))
	end
end