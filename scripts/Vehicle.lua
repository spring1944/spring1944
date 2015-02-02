local flare = piece "flare"
local turret = piece "turret"
local mantlet = piece "mantlet"

local SIG_MOVE = 1
local SIG_AIM = 2

-- Aesthetics
local wheelSpeed
local currentTrack

-- Logic
local wantedDirection
local weaponPriorities
local manualTarget

-- Constants
local WHEEL_CHECK_DELAY = 990
local TRACK_SWAP_DELAY = 99
local STOP_AIM_DELAY = 2000

local WHEEL_ACCELERATION_FACTOR = 3

local REAIM_THRESHOLD = 0.15

local PI = math.pi
local TAU = 2 * PI
local abs = math.abs
local atan2 = math.atan2

local function Delay(func, duration, mask, ...)
	--Spring.Echo("wait", duration)
	SetSignalMask(mask)
	Sleep(duration)
	func(...)
end


function script.Create()
	local info = GG.lusHelper[unitDefID]
	
	if #info.tracks > 1 then
		currentTrack = 1
		Show(info.tracks[1])
		for i = 2,#info.tracks do
			Hide(info.tracks[i])
		end
	end
	
	weaponPriorities = {}
	for i = 1,info.numWeapons do
		weaponPriorities[i] = i
	end
	if turret then
		Turn(turret, y_axis, 0)
	end
	
	wantedDirection = {}
	for i = 1,info.numWeapons do
		wantedDirection[i] = {}
	end
	
end

local function SpinWheels()
	SetSignalMask(SIG_MOVE)
	local wheelSpeeds = GG.lusHelper[unitDefID].wheelSpeeds
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
	local tracks = GG.lusHelper[unitDefID].tracks
	while true do
		Hide(tracks[currentTrack])
		currentTrack = (currentTrack % #tracks) + 1
		Show(tracks[currentTrack])
		Sleep(TRACK_SWAP_DELAY)
	end
end

local function StopWheels()
	for wheelPiece, speed in pairs(GG.lusHelper[unitDefID].wheelSpeeds) do
		StopSpin(wheelPiece, x_axis, speed / WHEEL_ACCELERATION_FACTOR)
	end
end

function script.StartMoving()
	Signal(SIG_MOVE)
	if GG.lusHelper[unitDefID].numWheels > 0 then
		StartThread(SpinWheels)
	end
	if #(GG.lusHelper[unitDefID].tracks) > 1 then
		StartThread(SwapTracks)
	end
end

function script.StopMoving()
	Signal(SIG_MOVE)
	StopWheels()
end

local function StopAiming(weaponNum)
	wantedDirection[weaponNum][1], wantedDirection[weaponNum][2] = nil, nil
end

local function ResolveDirection()
	local topDirection
	local topPriority = #wantedDirection + 1
	local manualHeading
	if manualTarget then
		local tx, ty, tz
		if #manualTarget == 1 then
			if Spring.ValidUnitID(manualTarget[1]) then
				tx, ty, tz = Spring.GetUnitPosition(manualTarget[1])
			elseif Spring.ValidFeatureID(manualTarget[1]) then
				tx, ty, tz = Spring.GetFeaturePosition(manualTarget[1])
			else
				manualTarget = nil
			end
		else
			tx, ty, tz = manualTarget[1], manualTarget[2], manualTarget[3]
		end
		if tx then
			local ux, uy, uz = Spring.GetUnitPiecePosDir(unitID, turret or mantlet)
			local frontDir = Spring.GetUnitVectors(unitID)
			manualHeading = atan2(tx - ux, tz - uz) - atan2(frontDir[1], frontDir[3])
			if manualHeading < 0 then
				manualHeading = manualHeading + TAU
			end
		end
	end
	
	for weaponNum, dir in pairs(wantedDirection) do
		if manualHeading and dir[1] then
			local hDiff = manualHeading - dir[1]
			if hDiff > PI then
				hDiff = TAU - hDiff
			elseif hDiff < -PI then
				hDiff = hDiff + TAU
			end
			if abs(hDiff) < REAIM_THRESHOLD then
				topDirection = dir
				break
			end
		end
		if dir[1] and weaponPriorities[weaponNum] < topPriority then
			topDirection = dir
			topPriority = weaponPriorities[weaponNum]
		end
	end
	if topDirection then
		-- Signal(SIG_AIM)
		-- SetSignalMask(SIG_AIM)
		local headingPiece = turret or mantlet
		Turn(headingPiece, y_axis, topDirection[1], math.rad(25))
		Turn(mantlet, x_axis, -topDirection[2], math.rad(14))
	end
end

function IsAimedAt(heading, pitch)
	local headingPiece = turret or mantlet
	
	local _, currentHeading, _ = Spring.UnitScript.GetPieceRotation(headingPiece)
	local _, currentPitch, _ = Spring.UnitScript.GetPieceRotation(mantlet)

	if currentHeading and currentPitch then
		local hDiff = currentHeading - heading
		if hDiff > PI then
			hDiff = TAU - hDiff
		elseif hDiff < -PI then
			hDiff = hDiff + TAU
		end
		local pDiff = abs(currentPitch - pitch)
		local hDiff = abs(hDiff)
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
	if weaponNum <= GG.lusHelper[unitDefID].weaponsWithAmmo then
		for i = 1,GG.lusHelper[unitDefID].weaponsWithAmmo do
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
	return flare
end

function script.AimFromWeapon(weaponNum)
	return turret or mantlet
end

function script.BlockShot(weaponNum, targetUnitID, userTarget)
	return not CanFire(weaponNum)
end


function script.AimWeapon(weaponNum, heading, pitch)
	Signal(SIG_AIM)
	wantedDirection[weaponNum][1], wantedDirection[weaponNum][2] = heading, pitch
	StartThread(Delay, StopAiming, STOP_AIM_DELAY, 0, weaponNum)
	StartThread(ResolveDirection)
	return IsAimedAt(heading, pitch)
end


function script.Killed(recentDamage, maxHealth)

	if recentDamage <= maxHealth then
		--normal kill
	else
		--overkill
	end
	
	return 1
end

function WeaponPriority(targetID, attackerWeaponNum, attackerWeaponDefID, defPriority)
	return defPriority
end

function ManualTarget(targetParams)
	manualTarget = targetParams
end