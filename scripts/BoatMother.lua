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
local torps = {}
findPieces(torps, "torp")

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

function script.AimWeapon(weaponID, heading, pitch)
	Signal(2 ^ weaponID) -- 2 'to the power of' weapon ID
	SetSignalMask(2 ^ weaponID)
	-- TODO: support torpedo turrets e.g. Gabi
	--[[Turn(turret, y_axis, heading, turretTurnSpeed)
	--Turn(sleeve, x_axis, -pitch, elevationSpeed)
	WaitForTurn(turret, y_axis)
	WaitForTurn(sleeve, x_axis)
	--StartThread(RestoreAfterDelay)]]
	return true
end

function script.FireWeapon(weaponID)
	EmitSfx(torps[weaponID] or base, SFX.CEG + weaponID)
end

function script.AimFromWeapon(weaponID) 
	return torps[weaponID] or base
end

function script.QueryWeapon(weaponID) 
	return torps[weaponID] or base
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
		for _, child in pairs(childrenPieces) do
			GG.EmitSfxName(unitID, child, "klara") -- FIXME: Explosion is rather OTT
		end
		--Explode(base, SFX.SHATTER)
	--[[else
		corpseType = 2
		Explode(base, SFX.SHATTER)
	end]]
	return corpseType
end
