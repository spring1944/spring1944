local barrel = piece "barrel"
local base = piece "base"

local brakeleft = piece "brakeleft"
local brakeright = piece "brakeright"

local info = GG.lusHelper[unitDefID]

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
do
	local sig = SIG_MOVE
	for i = 1,info.numWeapons do
		sig = sig * 2
		SIG_AIM[i] = sig
	end
end



local wantedDirection
local weaponEnabled
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
	local flare = piece "flare"
	local coaxflare = piece "coaxflare"
	if flare then 
		Hide(flare)
	end
	if coaxflare then
		Hide(coaxflare)
	end
	if brakeleft then
		Hide(brakeleft)
	end
	if brakeright then
		Hide(brakeright)
	end

	if #info.tracks > 1 then
		currentTrack = 1
		Show(info.tracks[1])
		for i = 2,#info.tracks do
			Hide(info.tracks[i])
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
			if headingPiece then
				Turn(headingPiece, y_axis, 0)
			end
			if pitchPiece then
				Turn(pitchPiece, x_axis, 0)
			end
		end
	end
	if info.smokePieces then
		StartThread(DamageSmoke, info.smokePieces)
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

local function RestoreTurret(weaponNum)
	if info.aimPieces[weaponNum] then
		local headingPiece, pitchPiece = info.aimPieces[weaponNum][1], info.aimPieces[weaponNum][2]
		if headingPiece then
			Turn(headingPiece, y_axis, 0, info.turretTurnSpeed)
		end
		if pitchPiece then
			Turn(pitchPiece, x_axis, 0, info.elevationSpeed)
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
	return math.abs(diff)
end

local function ResolveDirection(headingPiece, pitchPiece)
	local topDirection
	local topPriority = #wantedDirection + 1
	local manualHeading
	if manualTarget then
		manualHeading = GetHeadingToTarget(headingPiece, manualTarget)
	end
	
	for weaponNum, dir in pairs(wantedDirection) do
		if info.aimPieces[weaponNum] and info.aimPieces[weaponNum][1] == headingPiece then -- Make sure the weapon is using same headingPiece
			if manualHeading and dir[1] then
				if GetAngleDiff(manualHeading, dir[1]) < REAIM_THRESHOLD then
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
	local cegPiece = info.cegPieces[weaponNum]
	if cegPiece then 
		return cegPiece
	end
	-- Shields etc.
	return base
end

function script.AimFromWeapon(weaponNum)
	local headingPiece = info.aimPieces[weaponNum] and info.aimPieces[weaponNum][1] or base
	return headingPiece
end

function script.BlockShot(weaponNum, targetUnitID, userTarget)
	return not (CanFire(weaponNum) and weaponEnabled[weaponNum])
end


function script.AimWeapon(weaponNum, heading, pitch)
	Signal(SIG_AIM[weaponNum])
	
	if not weaponEnabled[weaponNum] then
		return false
	end
	
	if not info.aimPieces[weaponNum] then -- it's a shield or w/e
		return true
	end
	
	if info.reversedWeapons[weaponNum] then
		heading = heading + PI
		pitch = -pitch
	end
	wantedDirection[weaponNum][1], wantedDirection[weaponNum][2] = heading, pitch
	
	local headingPiece, pitchPiece = info.aimPieces[weaponNum][1], info.aimPieces[weaponNum][2]
	
	if headingPiece then
		StartThread(Delay, StopAiming, STOP_AIM_DELAY, SIG_AIM[weaponNum], weaponNum)
		StartThread(ResolveDirection, headingPiece, pitchPiece)
	end
	
	return IsAimed(weaponNum)
end


function script.Killed(recentDamage, maxHealth)
	local corpse = 1
	local turret = piece "turret"
	local mantlet = piece "mantlet"
	
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
	
	local ceg = info.weaponCEGs[weaponNum]
	if ceg then
		local cegPiece = info.cegPieces[weaponNum]
		if cegPiece then
			GG.EmitSfxName(unitID, cegPiece, ceg)
		end
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
	--Spring.Echo("priority", targetID, newPriority)
	return newPriority * 100
end

function ManualTarget(targetParams)
	manualTarget = targetParams
end

function TogglePriority(weaponNum, newPriority)
	weaponPriorities[weaponNum] = newPriority
end

function ToggleWeapon(weaponNum, isEnabled)
	weaponEnabled[weaponNum] = isEnabled
end

if UnitDef.isBuilder then
	local SIG_BUILD
	if #SIG_AIM > 0 then
		SIG_BUILD = SIG_AIM[#SIG_AIM] * 2
	else
		SIG_BUILD = SIG_MOVE * 2
	end
	
	local turret = piece "turret"
	local DEFAULT_CRANE_TURN_SPEED = math.rad(50)
	
	function script.StartBuilding(buildHeading, pitch)
		if turret then
			Signal(SIG_BUILD)
			SetSignalMask(SIG_BUILD)
			Turn(turret, y_axis, buildHeading, DEFAULT_CRANE_TURN_SPEED)
			WaitForTurn(turret, y_axis)
		end
		Spring.SetUnitCOBValue(unitID, COB.INBUILDSTANCE, 1)
	end
	
	function script.StopBuilding()
		Spring.SetUnitCOBValue(unitID, COB.INBUILDSTANCE, 0)
		if turret then
			Signal(SIG_BUILD)
			Turn(turret, y_axis, 0, DEFAULT_CRANE_TURN_SPEED)
		end		
	end
end

if UnitDef.transportCapacity > 0 then
	local tow_point = piece "tow_point"
	local canTow = not not tow_point
	
	function script.TransportPickup(passengerID)
		local mass = UnitDefs[Spring.GetUnitDefID(passengerID)].mass
		if mass < 100 then --ugly check for inf gun vs. infantry.
			Spring.UnitScript.AttachUnit(-1, passengerID)
		elseif canTow then
			Spring.UnitScript.AttachUnit(tow_point, passengerID)
			canTow = false
		end
	end
	
	-- note x, y z is in worldspace
	function script.TransportDrop(passengerID, x, y, z)
		local mass = UnitDefs[Spring.GetUnitDefID(passengerID)].mass
		if mass >= 100 then
			canTow = true
		end
		Spring.UnitScript.DropUnit(passengerID)
	end
end