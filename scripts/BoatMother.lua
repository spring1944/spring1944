local unitDefID = Spring.GetUnitDefID(unitID)
local teamID = Spring.GetUnitTeam(unitID)
unitDefID = Spring.GetUnitDefID(unitID)
unitDef = UnitDefs[unitDefID]
info = GG.lusHelper[unitDefID]

local SIG_MOVE = 1

local children = info.children

-- Pieces
local base = piece("base")

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

local childrenPieces = {} -- {[1] = unitname, etc}
findPieces(childrenPieces, "child")
local wakes = {}
findPieces(wakes, "wake")

function script.Create()
	local x,y,z = Spring.GetUnitPosition(unitID) -- strictly needed?
	for i, childDefName in ipairs(children) do
		local childID = Spring.CreateUnit(childDefName, x, y, z, 0, teamID)
		Spring.UnitScript.AttachUnit(childrenPieces[i], childID)
		Hide(childrenPieces[i])
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

function script.Killed(recentDamage, maxHealth)
	local severity = recentDamage / maxHealth * 100
	local corpseType
	
	for _, child in pairs(childrenPieces) do
		Show(child)
	end
	--signal SIG_DEATH;
	--if severity < 99 then
		local dA = info.deathAnim
		corpseType = 1;
		for axis, data in pairs(dA) do
			Turn(base, info.axes[axis] or z_axis, -math.rad(data.angle or 30), math.rad(data.speed or 10))
		end
		for axis, data in pairs(dA) do
			WaitForTurn(base, info.axes[axis] or z_axis)
		end
		--Explode(base, SFX.SHATTER)
	--[[else
		corpseType = 2
		Explode(base, SFX.SHATTER)
	end]]
	return corpseType
end
