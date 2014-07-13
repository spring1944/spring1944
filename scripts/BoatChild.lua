local unitDefID = Spring.GetUnitDefID(unitID)
local teamID = Spring.GetUnitTeam(unitID)
unitDefID = Spring.GetUnitDefID(unitID)
unitDef = UnitDefs[unitDefID]
info = GG.lusHelper[unitDefID]
 
local turretTurnSpeed = info.turretTurnSpeed
local elevationSpeed = info.elevationSpeed 
local barrelRecoilDist = info.barrelRecoilDist
local barrelRecoilSpeed = info.barrelRecoilSpeed
local aaWeapon = info.aaWeapon
local facing = info.facing -- 0 = front, 1 = left, 2 = rear, 3 = right
local flareOnShots = info.flareOnShots
local numWeapons = info.numWeapons
local numBarrels = info.numBarrels
local numRockets = info.numRockets

local MIN_HEALTH = 1
local FEAR_LIMIT = info.fearLimit
local PINNED_LEVEL = 0.8 * FEAR_LIMIT

local curFear = 0
local isDisabled = false
local aaAiming = false
local curRocket = 1

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
local turret, sleeve, flare, barrel = piece("turret", "sleeve",  "flare", "barrel")
local flares = {}
if not flare then findPieces(flares, "flare") end
local barrels = {}
if not barrel and numBarrels > 0 then findPieces(barrels, "barrel") end
local backBlast = piece("backblast")
local rockets = {}
if numRockets > 0 then findPieces(rockets, "r_rocket") end

function Disabled(state)
	isDisabled = state
end


function script.Create()
	--Spring.Echo("OH HAI", rearFacing)
	Turn(turret, y_axis, math.rad(90 * facing))
	if flare then
		Hide(flare)
	else
		for _, flarePiece in pairs(flares) do
			Hide(flarePiece)
		end
	end
end

function script.AimWeapon(weaponID, heading, pitch)
	if isDisabled then return false end -- don't even animate if we are disabled
	Signal(2 ^ weaponID) -- 2 'to the power of' weapon ID
	SetSignalMask(2 ^ weaponID)
	if aaWeapon and aaWeapon == weaponID then
		aaAiming = true
	elseif aaAiming and weaponID > numBarrels then -- HE weapons
		return false
	end
	Turn(turret, y_axis, heading, turretTurnSpeed)
	Turn(sleeve, x_axis, -pitch, elevationSpeed)
	WaitForTurn(turret, y_axis)
	WaitForTurn(sleeve, x_axis)
	--StartThread(RestoreAfterDelay)
	aaAiming = false
	if weaponID % 5 > 1 then Sleep(100) end -- make flakvierling fire in diagonal pairs
	return true
end

local function ShowRockets()
	Sleep((info.reloadTimes[1] - 1) * 1000) -- show 1 second before ready to fire
	for _, rocket in pairs(rockets) do
		Show(rocket)
		Sleep(info.burstRates * 1000)
	end
end

function script.FireWeapon(weaponID)
	if not flareOnShots[weaponID] then
		-- TODO: Autoloader feed anim for Fairmile D
		EmitSfx(flare or flares[weaponID], SFX.CEG + weaponID)
		if barrel then
			Move(barrel, z_axis, -barrelRecoilDist)
			WaitForMove(barrel, z_axis)
			Move(barrel, z_axis, 0, barrelRecoilSpeed)
		end
	elseif numRockets > 0 then
		StartThread(ShowRockets)
	end
end

function script.Shot(weaponID)
	if aaWeapon and weaponID > numBarrels then
		weaponID = weaponID - numBarrels
	end
	if flareOnShots[weaponID] then
		if numRockets > 0 then
			EmitSfx(backBlast, SFX.CEG + weaponID)
			Hide(rockets[curRocket])
			curRocket = curRocket + 1
			if curRocket > numRockets then curRocket = 1 end
		else
			EmitSfx(flare or flares[weaponID], SFX.CEG + weaponID)
			local barrelToMove = barrel or barrels[weaponID] 
			if barrelToMove then
				Move(barrelToMove, z_axis, -barrelRecoilDist)
				WaitForMove(barrelToMove, z_axis)
				Move(barrelToMove, z_axis, 0, barrelRecoilSpeed)
			end
		end
	end
end

function script.AimFromWeapon(weaponID) 
	return sleeve
end

function script.QueryWeapon(weaponID) 
	if aaWeapon and weaponID > numBarrels then
		weaponID = weaponID - numBarrels
	end
	return flare or flares[weaponID] or rockets[curRocket]
end


local function FearRecovery()
	Signal(1) -- we _really_ only want one copy of this running at any time
	SetSignalMask(1)
	while curFear > 0 do
		Sleep(1000)
		curFear = curFear - 1
		Spring.SetUnitRulesParam(unitID, "suppress", curFear)
		if curFear > PINNED_LEVEL then
			-- TODO: crew hiding anim
			Disabled(true)
		else
			-- TODO: reduce fire rate when suppressed but not pinned?
			Disabled(false)
		end
	end
end

function AddFear(amount)
	curFear = curFear + amount
	if curFear > FEAR_LIMIT then curFear = FEAR_LIMIT end
	Spring.Echo(amount, curFear)
	Spring.SetUnitRulesParam(unitID, "suppress", curFear)
	StartThread(FearRecovery)
end