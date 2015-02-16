local flare = piece "flare"
local coaxflare = piece "coaxflare"
local turret = piece "turret"
local mantlet = piece "mantlet"
local barrel = piece "barrel"
local base = piece "base"


local info = GG.lusHelper[unitDefID]

local headingPiece = turret or mantlet

--Localisations
local PI = math.pi
local TAU = 2 * PI
local abs = math.abs
local rad = math.rad
local atan2 = math.atan2

-- Should be fetched from OO defs when time comes
local rockSpeedFactor = rad(50)
local rockRestoreSpeed = rad(20)

-- Aesthetics
local wheelSpeed
local currentTrack
local lastShot

-- Logic
local SIG_MOVE = 1
local SIG_AIM = {}

local wantedDirection
local weaponPriorities
local manualTarget
local prioritisedWeapon

-- Constants
local WHEEL_CHECK_DELAY = 990
local TRACK_SWAP_DELAY = 99
local STOP_AIM_DELAY = 2000

local RECOIL_DELAY = 198

local WHEEL_ACCELERATION_FACTOR = 3

local REAIM_THRESHOLD = 0.15


local function Delay(func, duration, mask, ...)
	--Spring.Echo("wait", duration)
	SetSignalMask(mask)
	Sleep(duration)
	func(...)
end

local function DamageSmoke(smokePieces)
	-- emit some smoke if the unit is damaged
	-- check if the unit has finished building
	local n = #smokePieces
	_,_,_,_,buildProgress = Spring.GetUnitHealth(unitID)
	while (buildProgress < 1) do
		Sleep(150)
		_,_,_,_,buildProgress = Spring.GetUnitHealth(unitID)
	end
	-- random delay between smoke start
	timeDelay = math.random(1, 5)*33
	Sleep(timeDelay)
	while true do
		curHealth, maxHealth = Spring.GetUnitHealth(unitID)
		healthState = curHealth / maxHealth
		if healthState < 0.66 then
			EmitSfx(smokePieces[math.random(1,n)], SFX.WHITE_SMOKE)
			-- the less HP we have left, the more often the smoke
			timeDelay = 2000 * healthState
			-- no sence to make a delay shorter than a game frame
			if timeDelay < 33 then
				timeDelay = 33
			end
		else
			timeDelay = 2000
		end
		Sleep(timeDelay)
	end
end

function script.Create()
	if #info.tracks > 1 then
		currentTrack = 1
		Show(info.tracks[1])
		for i = 2,#info.tracks do
			Hide(info.tracks[i])
		end
	end
	
	weaponPriorities = {}
	wantedDirection = {}
	local sig = SIG_MOVE
	
	for i = 1,info.numWeapons do
		sig = sig * 2
		weaponPriorities[i] = i
		wantedDirection[i] = {}
		SIG_AIM[i] = sig
	end
	if turret then
		Turn(turret, y_axis, 0)
	end
	if info.smokePieces then
		StartThread(DamageSmoke, info.smokePieces)
	end
	if headingPiece then
		Turn(headingPiece, y_axis, 0)
	end
	if mantlet then
		Turn(mantlet, x_axis, 0)
	end
end

local function SpinWheels()
	SetSignalMask(SIG_MOVE)
	local wheelSpeeds = info.wheelSpeeds
	while true do
		local frontDir = Spring.GetUnitVectors(unitID)
		local vx, vy, vz = Spring.GetUnitVelocity(unitID)
		local dotFront = vx * frontDir[1] + vy * frontDir[2] + vz * frontDir[3]
		local direction = dotFront > 0 and 1 or -1
		for wheelPiece, speed in pairs(wheelSpeeds) do
			Spin(wheelPiece, x_axis, speed * direction, speed / WHEEL_ACCELERATION_FACTOR)
		end
		Sleep(WHEEL_CHECK_DELAY)
	end
end

local function SwapTracks()
	SetSignalMask(SIG_MOVE)
	local tracks = info.tracks
	while true do
		Hide(tracks[currentTrack])
		currentTrack = (currentTrack % #tracks) + 1
		Show(tracks[currentTrack])
		Sleep(TRACK_SWAP_DELAY)
	end
end

local function StopWheels()
	for wheelPiece, speed in pairs(info.wheelSpeeds) do
		StopSpin(wheelPiece, x_axis, speed / WHEEL_ACCELERATION_FACTOR)
	end
end

function script.StartMoving()
	Signal(SIG_MOVE)
	if info.numWheels > 0 then
		StartThread(SpinWheels)
	end
	if #info.tracks > 1 then
		StartThread(SwapTracks)
	end
end

function script.StopMoving()
	Signal(SIG_MOVE)
	StopWheels()
end

local function RestoreTurret()
	Turn(headingPiece, y_axis, 0, info.turretTurnSpeed)
	Turn(mantlet, x_axis, 0, info.elevationSpeed)	
end

local function StopAiming(weaponNum)
	wantedDirection[weaponNum][1], wantedDirection[weaponNum][2] = nil, nil
	if prioritisedWeapon == weaponNum then
		prioritisedWeapon = nil
	end
	
	for i = 1,info.numWeapons do
		-- If we're still aiming at anything, we don't want to restore the turret
		if wantedDirection[i][1] then
			return
		end
	end
	RestoreTurret()
end

local function IsMainGun(weaponNum)
	return weaponNum <= info.weaponsWithAmmo
end

local function GetHeadingToTarget(target)
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

local function GetHeadingDiff(a, b)
	local hDiff = a - b
	if hDiff > PI then
		hDiff = TAU - hDiff
	elseif hDiff < -PI then
		hDiff = hDiff + TAU
	end
	return math.abs(hDiff)
end

local function ResolveDirection()
	local topDirection
	local topPriority = #wantedDirection + 1
	local manualHeading
	if manualTarget then
		manualHeading = GetHeadingToTarget(manualTarget)
	end
	
	for weaponNum, dir in pairs(wantedDirection) do
		if manualHeading and dir[1] then
			if GetHeadingDiff(manualHeading, dir[1]) < REAIM_THRESHOLD then
				topDirection = dir
				prioritisedWeapon = weaponNum
				break
			end
		end
		if (not IsMainGun(weaponNum) or Spring.GetUnitRulesParam(unitID, "ammo") > 0) and dir[1] and
				weaponPriorities[weaponNum] < topPriority then
			topDirection = dir
			topPriority = weaponPriorities[weaponNum]
			prioritisedWeapon = weaponNum
		end
	end
	if topDirection then
		Turn(headingPiece, y_axis, topDirection[1], info.turretTurnSpeed)
		Turn(mantlet, x_axis, -topDirection[2], info.elevationSpeed)
	end
end

function IsAimedAt(heading, pitch)	
	local _, currentHeading, _ = Spring.UnitScript.GetPieceRotation(headingPiece)
	local _, currentPitch, _ = Spring.UnitScript.GetPieceRotation(mantlet)

	if currentHeading and currentPitch then
		local pDiff = abs(currentPitch - pitch)
		local hDiff = GetHeadingDiff(currentHeading, heading)
		
		if hDiff < REAIM_THRESHOLD and pDiff < REAIM_THRESHOLD then
			return true
		end
	end
	
	return false
end

local function IsAimed(weaponNum)
	if wantedDirection[weaponNum][1] then
		return IsAimedAt(wantedDirection[weaponNum][1], wantedDirection[weaponNum][2])
	end
	return false
end



local function CanFire(weaponNum)
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
	if IsMainGun(weaponNum) then
		return flare
	else
		return coaxflare or flare
	end
end

function script.AimFromWeapon(weaponNum)
	return headingPiece
end

function script.BlockShot(weaponNum, targetUnitID, userTarget)
	return not CanFire(weaponNum)
end


function script.AimWeapon(weaponNum, heading, pitch)
	Signal(SIG_AIM[weaponNum])
	if weaponNum > 3 then
		return false
	end
	-- if IsMainGun(weaponNum) and Spring.GetUnitRulesParam(unitID, "ammo") == 0 then
		-- return false
	-- end
	
	wantedDirection[weaponNum][1], wantedDirection[weaponNum][2] = heading, pitch
	StartThread(Delay, StopAiming, STOP_AIM_DELAY, SIG_AIM[weaponNum], weaponNum)
	StartThread(ResolveDirection)
	return IsAimedAt(heading, pitch)
end


function script.Killed(recentDamage, maxHealth)
	local corpse = 1
	for wheelPiece, _ in pairs(info.wheelSpeeds) do
		Explode(wheelPiece, SFX.SHATTER + SFX.EXPLODE_ON_HIT)
	end
	if recentDamage > maxHealth then -- Overkill
		Explode(base, SFX.SHATTER)
		if turret then
			Explode(turret, SFX.FIRE + SFX.FALL + SFX.EXPLODE_ON_HIT + SFX.SMOKE)
		end
		corpse = 2
	end
	if recentDamage > 10 * maxHealth then -- Hyperkill
		if barrel then
			Explode(barrel, SFX.SHATTER)
		end
		if mantlet then
			Explode(mantlet, SFX.SHATTER)
		end
		corpse = 3
	end
	
	return math.min(info.numCorpses - 1, corpse)
end

local function Recoil()
	Move(barrel, z_axis, -info.barrelRecoilDist)
	Sleep(RECOIL_DELAY)
	Move(barrel, z_axis, 0, info.barrelRecoilSpeed)
end

local function Rock(anglex, anglez)
	-- For some reaosn they are switched
	anglex, anglez = anglez, anglex

	local rockx = rad(anglex) * 2
	local rockz = -rad(anglez) * 2
	local speedx = abs(rockx) * 20
	local speedz = abs(rockz) * 20
	Turn(base, z_axis, rockz, speedz)
	Turn(base, x_axis, rockx, speedx)

	WaitForTurn(base, x_axis)
	WaitForTurn(base, z_axis)
	
	Turn(base, z_axis, 0, speedz / 2)
	Turn(base, x_axis, 0, speedx / 2)
end

function script.RockUnit(anglex, anglez)
	if IsMainGun(lastShot) then
		StartThread(Rock, anglex, anglez)
	end
end

function script.Shot(weaponNum)
	lastShot = weaponNum
	if IsMainGun(weaponNum) and barrel then
		StartThread(Recoil)
	end
	local ceg = info.weaponCEGs[weaponNum]
	if ceg then
		local cegPiece = IsMainGun(weaponNum) and flare or coaxflare or flare
		Spring.SpawnCEG(ceg, Spring.GetUnitPiecePosDir(unitID, cegPiece))
	end
end

function WeaponPriority(targetID, attackerWeaponNum, attackerWeaponDefID, defPriority)
	local newPriority = defPriority
	--if prioritisedWeapon and attackerWeaponNum ~= prioritisedWeapon then
		local heading = GetHeadingToTarget({targetID})
		local _, currentHeading, _ = Spring.UnitScript.GetPieceRotation(headingPiece)
		newPriority = GetHeadingDiff(heading, currentHeading)
	--end
	--Spring.Echo("priority", targetID, newPriority)
	return newPriority * 100
end

function ManualTarget(targetParams)
	manualTarget = targetParams
end