local unitDefID = Spring.GetUnitDefID(unitID)
local teamID = Spring.GetUnitTeam(unitID)
local GetUnitHealth = Spring.GetUnitHealth
unitDefID = Spring.GetUnitDefID(unitID)
unitDef = UnitDefs[unitDefID]
info = GG.lusHelper[unitDefID]

local minRanges = info.minRanges
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
			-- add a condition for unnumbered child which would be the first and only
			local num = tonumber(pieceName:sub(index + string.len(name), -1)) or 1
			input[num] = piece(pieceName)
		end
	end
end

local childrenPieces = {} -- {[1] = unitname, etc}
findPieces(childrenPieces, "child")
local wakes = {}
findPieces(wakes, "wake")
local exhausts = {}
findPieces(exhausts, "exhaust")
local torps = {}
findPieces(torps, "torp")
local tpTurrets = {}
findPieces(tpTurrets, "tpturret")

local function FlagFlap()
	local flags = {}
	findPieces(flags, "flag")
	if #flags == 0 then
		return
	end
	if flags[1] then
		Turn(flags[1], y_axis, math.rad(180));
	end
	local _,_,_,_,buildProgress = GetUnitHealth(unitID)
	while (buildProgress > 0) do
		Sleep(150)
		_,_,_,_,buildProgress = GetUnitHealth(unitID)
	end
	local FLAG_FLAP_ANGLE = math.rad(30)
	local FLAG_FLAP_SPEED = math.rad(45)
	local FLAG_FLAP_PERIOD = 2000 * FLAG_FLAP_ANGLE / FLAG_FLAP_SPEED
	local direction = 1
	while true do
		direction = -1 * direction
		local direction2 = direction
		local correction_past_first = 1
		for i = 1, #flags do
			local angle = FLAG_FLAP_ANGLE * direction2
			Turn(flags[i], y_axis, angle * correction_past_first, FLAG_FLAP_SPEED * correction_past_first)
			direction2 = -1 * direction2
			if i == 1 then
				correction_past_first = 2
			end
		end
		Sleep(FLAG_FLAP_PERIOD)
	end
end

local function DamageSmoke()
	-- emit some smoke if the unit is damaged
	-- check if the unit has finished building
	_,_,_,_,buildProgress = GetUnitHealth(unitID)
	while (buildProgress > 0) do
		Sleep(150)
		_,_,_,_,buildProgress = GetUnitHealth(unitID)
	end
	-- random delay between smoke start
	timeDelay = math.random(1, 5)*30
	Sleep(timeDelay)
	while (1 == 1) do
		curHealth, maxHealth = GetUnitHealth(unitID)
		healthState = curHealth / maxHealth
		if healthState < 0.66 then
			EmitSfx(base, SFX.BLACK_SMOKE)
			-- the less HP we have left, the more often the smoke
			timeDelay = 500 * healthState
			-- no sence to make a delay shorter than a game frame
			if timeDelay < 30 then
				timeDelay = 30
			end
		else
			timeDelay = 500
		end
		Sleep(timeDelay)
	end
end

function script.Create()
	local x,y,z = Spring.GetUnitPosition(unitID) -- strictly needed?
	for i, childDefName in ipairs(children) do
		local childID = Spring.CreateUnit(childDefName, x, y, z, 0, teamID)
		Spring.UnitScript.AttachUnit(childrenPieces[i], childID)
		Hide(childrenPieces[i])
	end
	StartThread(DamageSmoke)
	StartThread(FlagFlap)
end

local function EmitWakes()
	SetSignalMask(SIG_MOVE)
	while true do
		for _, wake in pairs(wakes) do
			EmitSfx(wake, SFX.WAKE)
		end
		for _, exhaust in pairs(exhausts) do
			EmitSfx(exhaust, SFX.BLACK_SMOKE)
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
	if tpTurrets[weaponID] then
		Turn(tpTurrets[weaponID], y_axis, heading, math.rad(5))
		--Turn(sleeve, x_axis, -pitch, elevationSpeed)	
		WaitForTurn(tpTurrets[weaponID], y_axis)
		--WaitForTurn(sleeve, x_axis)
	end
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

function script.BlockShot(weaponID, targetID, userTarget)
	local minRange = minRanges[weaponID]
	if minRange then
		local distance
		if targetID then
			distance = Spring.GetUnitSeparation(unitID, targetID, true)
		elseif userTarget then -- shouldn't be the case with S44 torpedos
			local cmd = GetUnitCommands(unitID, 1)[1]
			if cmd.id == CMD.ATTACK then
				local tx,ty,tz = unpack(cmd.params)
				distance = GG.GetUnitDistanceToPoint(unitID, tx, ty, tz, false)
			end
		end
		if distance < minRange then return true end
	end
	return false
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
