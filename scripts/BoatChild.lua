local unitDefID = Spring.GetUnitDefID(unitID)
local teamID = Spring.GetUnitTeam(unitID)
local GetUnitHealth = Spring.GetUnitHealth
unitDefID = Spring.GetUnitDefID(unitID)
unitDef = UnitDefs[unitDefID]
info = GG.lusHelper[unitDefID]

-- this shares quite a lot with vehicles
if not info.aimPieces then
	include "VehicleLoader.lua"
end

local customAnims = info.customAnims

local turretTurnSpeed = info.turretTurnSpeed
local elevationSpeed = info.elevationSpeed
local barrelRecoilDist = info.barrelRecoilDist
local barrelRecoilSpeed = info.barrelRecoilSpeed
local aaWeapon = info.aaWeapon
local facing = info.facing -- 0 = front, 1 = left, 2 = rear, 3 = right

local reloadTimes = info.reloadTimes
local flareOnShots = info.flareOnShots
local numWeapons = info.numWeapons
local numBarrels = info.numBarrels
local numRockets = info.numRockets

local MIN_HEALTH = 1
local FEAR_LIMIT = info.fearLimit or 25
local PINNED_LEVEL = 0.8 * FEAR_LIMIT
local SUPPRESSED_FIRE_RATE_PENALTY = 2

local curFear = 0
local isDisabled = false
local isPinned = false
local aaAiming = false
local curRocket = 1

local usesAmmo = info.usesAmmo

local PI = math.pi
local TAU = 2 * PI
local abs = math.abs
local rad = math.rad
local atan2 = math.atan2
local SetUnitRulesParam = Spring.SetUnitRulesParam

local SIG_MOVE = 1
local SIG_AIM = {}
do
	local sig = SIG_MOVE
	for i = 1,info.numWeapons do
		sig = sig * 2
		SIG_AIM[i] = sig
	end
end

local STOP_AIM_DELAY = 2000
local RECOIL_DELAY = 198

local REAIM_THRESHOLD = 0.15

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

local function Delay(func, duration, mask, ...)
	SetSignalMask(mask)
	Sleep(duration)
	func(...)
end

local function DisabledSmoke()
	while (1 == 1) do
		if isDisabled then
			EmitSfx(base, SFX.BLACK_SMOKE)
		end
		Sleep(500)
	end
end

function Disabled(state)
	isDisabled = state
end

local function RestoreTurret(weaponNum) -- called by Create so must be prior
	if info.aimPieces[weaponNum] then
		local headingPiece, pitchPiece = info.aimPieces[weaponNum][1], info.aimPieces[weaponNum][2]
		local defaultHeading = info.turretDefaultPositions[weaponNum].heading or 0

		local defaultPitch = info.turretDefaultPositions[weaponNum].pitch or 0
		if headingPiece then
			Turn(headingPiece, y_axis, defaultHeading, info.turretTurnSpeed)
		end
		if pitchPiece then
			if UnitDef.customParams.spaa then
				Turn(pitchPiece, x_axis, -70, info.elevationSpeed)
			else
				Turn(pitchPiece, x_axis, defaultPitch, info.elevationSpeed)
			end
		end
	end
end

local function StopAiming(weaponNum)
	wantedDirection[weaponNum][1], wantedDirection[weaponNum][2] = nil, nil
	if prioritisedWeapon == weaponNum then
		prioritisedWeapon = nil
	end

	for i = 1,info.numWeapons do
		-- If we're still aiming at anything, we don't want to restore the turret
		if info.aimPieces[weaponNum] and info.aimPieces[i] and info.aimPieces[weaponNum][1] == info.aimPieces[i][1] and -- make sure it's a relevant weapon
			wantedDirection[i][1] then
			return
		end
	end
	RestoreTurret(weaponNum)
end

function script.Create()
	if customAnims and customAnims.preCreate then
		customAnims.preCreate()
	end

	StartThread(DisabledSmoke)

	Turn(turret, y_axis, rad(90 * facing))

	if flare then
		Hide(flare)
	else
		for _, flarePiece in pairs(flares) do
			Hide(flarePiece)
		end
	end

	weaponEnabled = {}
	weaponPriorities = {}
	wantedDirection = {}

	for i = 1,info.numWeapons do
		weaponPriorities[i] = i
		weaponEnabled[i] = true
		wantedDirection[i] = {}
		if info.aimPieces[weaponNum] then
			local headingPiece, pitchPiece = info.aimPieces[weaponNum][1], info.aimPieces[weaponNum][2]

			local defaultHeading = info.turretDefaultPositions[weaponNum].heading or 0
			local defaultPitch = info.turretDefaultPositions[weaponNum].pitch or 0

			if headingPiece then
				Turn(headingPiece, y_axis, defaultHeading)
			end
			if pitchPiece then
				Turn(pitchPiece, x_axis, defaultPitch)
			end

		end
	end

	if customAnims and customAnims.postCreate then
		customAnims.postCreate()
	end
end

local function ShowRockets()
	Sleep((info.reloadTimes[1] - 1) * 1000) -- show 1 second before ready to fire
	for _, rocket in pairs(rockets) do
		Show(rocket)
		Sleep(info.burstRates[1] * 1000)
	end
end

local function SetWeaponReload(multiplier)
	for weaponID = 1, numWeapons do
		Spring.SetUnitWeaponState(unitID, weaponID, {reloadTime = reloadTimes[weaponID] * multiplier})
	end
end

local currFearState = "none"
local fearChanged = false

local function FearRecovery()
	Signal(1) -- we _really_ only want one copy of this running at any time
	SetSignalMask(1)
	currFearState = "suppressed"
	while curFear > 0 do
		Sleep(1000)
		curFear = curFear - 1
		SetUnitRulesParam(unitID, "fear", curFear)
		if curFear >= PINNED_LEVEL then
			isPinned = true
			fearChanged = currFearState == "pinned"
			currFearState = "pinned"
			if fearChanged then
				-- TODO: crew hiding anim
			end
		else
			isPinned = false
			fearChanged = currFearState == "suppressed"
			currFearState = "suppressed"
			if fearChanged then
				-- reduce fire rate when suppressed but not pinned
				SetWeaponReload(SUPPRESSED_FIRE_RATE_PENALTY)
			end
		end
	end
	currFearState = "none"
	SetWeaponReload(1.0)
end

function AddFear(amount)
	curFear = curFear + amount
	if curFear > FEAR_LIMIT then curFear = FEAR_LIMIT end
	SetUnitRulesParam(unitID, "fear", curFear)
	StartThread(FearRecovery)
end

function script.Killed(recentDamage, maxHealth)
	return 1
end

local function IsMainGun(weaponNum)
	return weaponNum <= info.weaponsWithAmmo
end

local function GetHeadingToTarget(headingPiece, target)
	local tx, ty, tz
	local heading
	if #target == 1 then
		if Spring.ValidUnitID(target[1]) then
			tx, ty, tz = Spring.GetUnitPosition(target[1])
		elseif Spring.ValidFeatureID(target[1]) then
			tx, ty, tz = Spring.GetFeaturePosition(target[1])
		else
			target = nil
		end
	else
		tx, ty, tz = target[1], target[2], target[3]
	end
	if tx then
		local ux, uy, uz = Spring.GetUnitPiecePosDir(unitID, headingPiece)
		local frontDir = Spring.GetUnitVectors(unitID)
		heading = atan2(tx - ux, tz - uz) - atan2(frontDir[1], frontDir[3])
		if heading < 0 then
			heading = heading + TAU
		end
		return heading
	end
	return nil
end

local function GetAngleDiff(a, b)
	local diff = a - b
	if diff > PI then
		diff = TAU - diff
	elseif diff < -PI then
		diff = diff + TAU
	end
	return abs(diff)
end

local function ResolveDirection(headingPiece, pitchPiece)
	local topDirection
	local topPriority = #wantedDirection + 1

	for weaponNum, dir in pairs(wantedDirection) do
		if info.aimPieces[weaponNum] and info.aimPieces[weaponNum][1] == headingPiece and
				(not IsMainGun(weaponNum) or Spring.GetUnitRulesParam(unitID, "ammo") > 0) and dir[1] then
			local _, isUserTarget = Spring.GetUnitWeaponTarget(unitID, weaponNum)
			if isUserTarget then --is manual target
				topDirection = dir
				prioritisedWeapon = weaponNum
				break
			end
			if weaponPriorities[weaponNum] < topPriority then
				topDirection = dir
				topPriority = weaponPriorities[weaponNum]
				prioritisedWeapon = weaponNum
			end
		end
	end
	if topDirection then
		Turn(headingPiece, y_axis, topDirection[1], info.turretTurnSpeed)
		if pitchPiece then
			Turn(pitchPiece, x_axis, -topDirection[2], info.elevationSpeed)
		end
	end
end

function IsAimedAt(headingPiece, pitchPiece, heading, pitch)

	local _, currentHeading = Spring.UnitScript.GetPieceRotation(headingPiece)
	-- If you can't change pitch, assume you're aimed for now.
	local currentPitch = pitchPiece and -Spring.UnitScript.GetPieceRotation(pitchPiece) or pitch

	local pDiff = GetAngleDiff(currentPitch, pitch)
	local hDiff = GetAngleDiff(currentHeading, heading)

	if hDiff < REAIM_THRESHOLD and pDiff < REAIM_THRESHOLD then
		return true
	end

	return false
end

local function IsAimed(weaponNum)
	if not info.aimPieces[weaponNum] then -- it's a shield or w/e
		return true
	end
	if wantedDirection[weaponNum][1] then
		local headingPiece, pitchPiece = info.aimPieces[weaponNum][1] or base, info.aimPieces[weaponNum][2]
		return IsAimedAt(headingPiece, pitchPiece, wantedDirection[weaponNum][1], wantedDirection[weaponNum][2])
	end
	return false
end

local function CanAim(weaponNum)
	if not IsAimed(weaponNum) then
		return false
	end

	if IsMainGun(weaponNum) then
		for i = 1,info.weaponsWithAmmo do
			if i ~= weaponNum then
				local _, loaded = Spring.GetUnitWeaponState(unitID, i)
				if not loaded then
					return false
				end
				if IsAimed(i) and weaponPriorities[i] < weaponPriorities[weaponNum] then
					return false
				end
			end
		end
	end
	return true
end

function script.QueryWeapon(weaponNum)
	local cegPiece = info.cegPieces[weaponNum]
	return cegPiece or flares[weaponNum] or rockets[curRocket] or base
end

function script.AimFromWeapon(weaponNum)
	local headingPiece = info.aimPieces[weaponNum] and info.aimPieces[weaponNum][1] or base
	return headingPiece
end

function script.BlockShot(weaponNum, targetUnitID, userTarget)
	if IsMainGun(weaponNum) then
		if usesAmmo then
			local ammo = Spring.GetUnitRulesParam(unitID, 'ammo')
			if ammo <= 0 then
				return true
			end
		end
	end

	return not (CanAim(weaponNum) and weaponEnabled[weaponNum])
end

function script.AimWeapon(weaponNum, heading, pitch)
	if isDisabled or isPinned then return false end -- don't even animate if we are pinned/disabled

	Signal(SIG_AIM[weaponNum])

	if not weaponEnabled[weaponNum] then
		return false
	end

	if not info.aimPieces[weaponNum] then -- it's a shield or w/e
		return true
	end

	-- Rocket turrets always have reversed flares, because those are backblasts. So do not apply reversed flare logic for rocket weapons
	if ((numRockets or 0) == 0) and info.reversedWeapons[weaponNum] then
		heading = heading + PI
		pitch = -pitch
	end
	wantedDirection[weaponNum][1], wantedDirection[weaponNum][2] = heading, pitch

	local headingPiece, pitchPiece = info.aimPieces[weaponNum][1], info.aimPieces[weaponNum][2]

	StartThread(Delay, StopAiming, STOP_AIM_DELAY, SIG_AIM[weaponNum], weaponNum)
	if headingPiece then
		StartThread(ResolveDirection, headingPiece, pitchPiece)
	end

	-- Since in this logic there is not a way to stop aiming running threads,
	-- we shall check another time that the gun is not pinned or disabled before
	-- allowing it to fire
	return IsAimed(weaponNum) and (not (isDisabled or isPinned))
end

function script.FireWeapon(weaponNum)
	if numRockets > 0 then
		StartThread(ShowRockets)
	end
	if IsMainGun(weaponNum) and usesAmmo then
		local currentAmmo = Spring.GetUnitRulesParam(unitID, 'ammo')
		SetUnitRulesParam(unitID, 'ammo', currentAmmo - 1)
	end
end

local function Recoil()
	Move(barrel, z_axis, -info.barrelRecoilDist)
	Sleep(RECOIL_DELAY)
	Move(barrel, z_axis, 0, info.barrelRecoilSpeed)
end

function script.Shot(weaponNum)
	lastShot = weaponNum

	local ceg = info.weaponCEGs[weaponNum]
	if ceg then
		local cegPiece = info.cegPieces[weaponNum]
		if cegPiece then
			GG.EmitSfxName(unitID, cegPiece, ceg)
		end
	end

	if numRockets > 0 then
		EmitSfx(backBlast, SFX.CEG + weaponNum)
		Hide(rockets[curRocket])
		curRocket = curRocket + 1
		if curRocket > numRockets then curRocket = 1 end
	end

	if IsMainGun(weaponNum) and barrel then
		StartThread(Recoil)
		local ping = info.seismicPings[weaponNum]
		if ping then
			Spring.AddUnitSeismicPing(unitID, ping)
		end
		if brakeleft then
			GG.EmitSfxName(unitID, brakeleft, "MUZZLEBRAKESMOKE")
		end
		if brakeright then
			GG.EmitSfxName(unitID, brakeright, "MUZZLEBRAKESMOKE")
		end
	end
end

function script.EndBurst(weaponNum)
	if IsMainGun(weaponNum) then
		GG.EmitSfxName(unitID, base, "fire_dust")
	end
end

function WeaponPriority(targetID, attackerWeaponNum, attackerWeaponDefID, defPriority)
	local newPriority = defPriority
	--if prioritisedWeapon and attackerWeaponNum ~= prioritisedWeapon then
		local headingPiece = info.aimPieces[attackerWeaponNum] and info.aimPieces[attackerWeaponNum][1] or base
		local heading = GetHeadingToTarget(headingPiece, {targetID})
		local _, currentHeading, _ = Spring.UnitScript.GetPieceRotation(headingPiece)
		newPriority = GetAngleDiff(heading, currentHeading)
	--end

	return newPriority * 100
end

function TogglePriority(weaponNum, newPriority)
	weaponPriorities[weaponNum] = newPriority
end

function ToggleWeapon(weaponNum, isEnabled)
	weaponEnabled[weaponNum] = isEnabled
end
