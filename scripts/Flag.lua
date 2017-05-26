local currentSide -- intentionally nil
-- Pieces
local base = piece("base")
local flag, teamFlag = piece("flag", "teamflag")
local buoy = flag ~= nil
local flags = {} -- {nationcode = piecenum}

-- Auto-Detect Flag Pieces
if not buoy then
	local pieceMap = Spring.GetUnitPieceMap(unitID)
	--{ "piecename1" = pieceNum1, ... , "piecenameN" = pieceNumN }
	for pieceName, pieceNum in pairs(pieceMap) do
		local flagIndex = pieceName:find("flag")
		if flagIndex then
			local nation = pieceName:sub(1, flagIndex - 1)
			flags[nation] = piece(pieceName)
		end
	end
end

-- for flags
function SetFlag(teamID)
	if currentSide and flags[currentSide] then
		Move(flags[currentSide], y_axis, 0, 20)
		WaitForMove(flags[currentSide], y_axis)
	else
		-- it is very possible for this to be nil, at the first frame of the game. So only print error if it is not nil, but there is no data to move the flag
		if currentSide then
			Spring.Log("flag script", "error", "currentSide contains: " .. (currentSide or 'nil') .. ' for teamID: ' .. teamID)
		end
	end
	while not GG.teamSide do -- for /luarules reload
		Sleep(33)
	end
	local side = GG.teamSide[teamID]
	if side and side ~= "" then
		if not flags[side] then
			Spring.Log("flag script", "error", "teamSide contains: " .. (side or 'nil') .. ' for teamID: ' .. teamID)
		else
			Move(flags[side], y_axis, 65, 10)
			WaitForMove(flags[side], y_axis)
		end 
		currentSide = side
	end
end

-- for buoys
function RockBuoy()
	local angleX, angleZ
	local ROCK_ANGLE = 10
	local ROCK_SPEED = math.rad(2)
	while true do
		angleX = math.rad(math.random(-ROCK_ANGLE, ROCK_ANGLE))
		angleZ = math.rad(math.random(-ROCK_ANGLE, ROCK_ANGLE))
		
    	Turn(base, x_axis, angleX, ROCK_SPEED)
    	Turn(base, z_axis, angleZ, ROCK_SPEED)
    	WaitForTurn(base, x_axis)
    	WaitForTurn(base, z_axis)
    	Turn(base, x_axis, 0, ROCK_SPEED / 2)
    	Turn(base, z_axis, 0, ROCK_SPEED / 2)
		
    	Sleep(50)
    end
end

function script.Create()
	local teamID = Spring.GetUnitTeam(unitID)
	if buoy then
		StartThread(RockBuoy)
	else
		StartThread(SetFlag, teamID)
	end
end

function script.WindChanged (heading, strength)
	if currentSide then
		Turn(flags[currentSide], y_axis, heading, math.rad(20))
	elseif buoy then
		Turn(flag, y_axis, heading, math.rad(20))
		Turn(teamFlag, y_axis, heading, math.rad(20))
	end
end
