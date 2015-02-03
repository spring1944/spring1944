local flare = piece "flare"
local turret = piece "turret"
local mantlet = piece "mantlet"

local headingPiece = turret or mantlet

local SIG_MOVE = 1
local SIG_AIM = {}

-- Aesthetics
local wheelSpeed
local currentTrack

-- Logic
local wantedDirection
local weaponPriorities
local manualTarget
local prioritisedWeapon
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
	if prioritisedWeapon == weaponNum then
		prioritisedWeapon = nil
	end
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
		if dir[1] and weaponPriorities[weaponNum] < topPriority then
			topDirection = dir
			topPriority = weaponPriorities[weaponNum]
			prioritisedWeapon = weaponNum
		end
	end
	if topDirection then
		Turn(headingPiece, y_axis, topDirection[1], math.rad(25))
		Turn(mantlet, x_axis, -topDirection[2], math.rad(14))
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
	return headingPiece
end

function script.BlockShot(weaponNum, targetUnitID, userTarget)
	return not CanFire(weaponNum)
end


function script.AimWeapon(weaponNum, heading, pitch)
	Signal(SIG_AIM[weaponNum])
	wantedDirection[weaponNum][1], wantedDirection[weaponNum][2] = heading, pitch
	StartThread(Delay, StopAiming, STOP_AIM_DELAY, SIG_AIM[weaponNum], weaponNum)
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

-- function script.Shot(weaponNum)
-- end

function WeaponPriority(targetID, attackerWeaponNum, attackerWeaponDefID, defPriority)
	local newPriority = defPriority
	-- if attackerWeaponNum == 3 then
		-- Spring.Echo("mg retarget")
	-- end
	if prioritisedWeapon and attackerWeaponNum ~= prioritisedWeapon then
		local heading = GetHeadingToTarget({targetID})
		local _, currentHeading, _ = Spring.UnitScript.GetPieceRotation(headingPiece)
		newPriority = GetHeadingDiff(heading, currentHeading)
	end
	return newPriority
end

function ManualTarget(targetParams)
	manualTarget = targetParams
end