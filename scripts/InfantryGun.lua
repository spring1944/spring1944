local info = GG.lusHelper[unitDefID]

if not info.animation then
	include "DeployedLoader.lua"
	info.wheelSpeeds = {}
	local pieceMap = Spring.GetUnitPieceMap(unitID)
	for pieceName, pieceNum in pairs(pieceMap) do
		-- Find Wheel Speeds
		if pieceName:find("wheel") then
			local wheelInfo = Spring.GetUnitPieceInfo(unitID, pieceNum)
			local wheelHeight = math.abs(wheelInfo.max[2] - wheelInfo.min[2])
			info.wheelSpeeds[pieceNum] = (UnitDefs[unitDefID].speed / wheelHeight)
		end
	end
end
local poses, transitions, fireTransitions, weaponTags = unpack(info.animation)

--Localisations
local PI = math.pi
local TAU = 2 * PI
local abs = math.abs
local random = math.random
local SetUnitRulesParam = Spring.SetUnitRulesParam
local GetGameFrame = Spring.GetGameFrame

--Constants
local SIG_AIM = 1
local SIG_FIRE = 2
local SIG_MOVE = 4
local SIG_ANIM = 16
local SIG_FEAR = 32

local DEFAULT_TURN_SPEED = math.rad(300)
local REAIM_THRESHOLD = 0.15

local FEAR_LIMIT = 25
local FEAR_PINNED = 2
local FEAR_MAX = 15

local FEAR_INITIAL_SLEEP = 5000
local FEAR_SLEEP = 1000

local RECOIL_DELAY = 198

local WHEEL_CHECK_DELAY = 990
local WHEEL_ACCELERATION_FACTOR = 3

--CURRENT UNIT STATE
local moving
local pinned
local firing

--UNIT WANTED STATE
local wantedMoving
local wantedPinned

--POSE VARS
local inTransition
local currentPoseName
local currentAnim

-- AIMING VARS
local currentPitch
local currentHeading
local wantedPitch
local wantedHeading

-- OTHER
local usesAmmo = info.usesAmmo

local turretTraverseSpeed
local turretElevateSpeed
local recoilDistance = 2.4
local recoilReturnSpeed = 10

local fear
local weaponEnabled = {}



local function Delay(func, duration, mask, ...)
	--Spring.Echo("wait", duration)
	SetSignalMask(mask)
	Sleep(duration)
	func(...)
end

local function SpinWheels()
	Signal(SIG_MOVE)
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

local function StopWheels()
	Signal(SIG_MOVE)
	for wheelPiece, speed in pairs(info.wheelSpeeds) do
		StopSpin(wheelPiece, x_axis, speed / WHEEL_ACCELERATION_FACTOR)
	end
end

local function PlayAnim()
	Signal(SIG_ANIM)
	SetSignalMask(SIG_ANIM)
	while true do
		local anim = currentAnim
		local wait = random(unpack(currentAnim.wait)) * 33
		for i = 1, #anim do
			local frame = anim[i]
			local turns, moves = frame.turns, frame.moves
			if turns then
				for _, params in pairs(turns) do
					Turn(unpack(params))
				end
			end
			if moves then
				for _, params in pairs(moves) do
					Move(unpack(params))
				end
			end
			Sleep(wait)
		end
	end
end


local function UpdateSpeed()
	local speedMult = 1.0
	if pinned then
		speedMult = 0
	end
	SetUnitRulesParam(unitID, "fear_movement", speedMult)
	GG.ApplySpeedChanges(unitID)
end


local function ChangePose(transition, nextPoseName)
	SetSignalMask(0)
	--Spring.Echo("start transition")
	for i, frame in pairs(transition) do
		local duration, turns, moves, anim  =
			  frame.duration, frame.turns, frame.moves, frame.anim

		--Spring.Echo("frame", i, #turns, #moves, duration, headingTurn, pitchTurn)
		if turns then
			for _, params in pairs(turns) do
				Turn(unpack(params))
			end
		end
		if moves then
			for _, params in pairs(moves) do
				Move(unpack(params))
			end
		end
		if anim and not currentAnim then
			currentAnim = anim
			StartThread(PlayAnim)
		elseif not anim then
			currentAnim = nil
			Signal(SIG_ANIM)
		else
			currentAnim = anim
		end
		Sleep(duration)
	end
	--Spring.Echo("done transition")
	currentPoseName = nextPoseName
end

local function PickPose(name)
	if not currentPoseName then
		--Spring.Echo("warp")
		currentPoseName = name
		local pose = poses[currentPoseName]
		local turns, moves = pose.turns, pose.moves
		if turns then
			for _, params in pairs(turns) do
				Turn(unpack(params))
			end
		end
		if moves then
			for _, params in pairs(moves) do
				Move(unpack(params))
			end
		end
	else

		local transition
		if firing then
			transition = fireTransitions[currentPoseName][name]
		end
		if not transition then
			transition = transitions[currentPoseName][name]
		end
		if not transition then
			Spring.Log("infantrygun script", "error", "no change possible " .. currentPoseName .. " " .. name)
			return false
		end

		ChangePose(transition, name)
	end
	return true
end


local function ReAim(newHeading, newPitch)
	--Spring.Echo("reaiming")
	if currentHeading and currentPitch then
		local hDiff = currentHeading - newHeading
		if hDiff > PI then
			hDiff = TAU - hDiff
		elseif hDiff < -PI then
			hDiff = hDiff + TAU
		end
		local pDiff = abs(currentPitch - newPitch)
		local hDiff = abs(hDiff)
		if hDiff < REAIM_THRESHOLD and pDiff < REAIM_THRESHOLD then
			return true
		end
	end

	SetSignalMask(SIG_AIM)
	Turn(weaponTags.headingPiece, y_axis, newHeading, info.turretTurnSpeed)
	Turn(weaponTags.pitchPiece, x_axis, -newPitch, info.elevationSpeed)

	WaitForTurn(weaponTags.headingPiece, y_axis)
	WaitForTurn(weaponTags.pitchPiece, x_axis)

	currentHeading = newHeading
	currentPitch = newPitch
	return false
end

local function GetPoseName(newMoving, newPinned)
	if newPinned then
		return "pinned"
	end
	if newMoving then
		return "run"
	end
	return "ready"
end

local function UpdatePose(newMoving, newPinned)
	local success = PickPose(GetPoseName(newMoving, newPinned))
	--Spring.Echo(newStanding, newAiming, newMoving, newPinned, newBuilding, success)
	if success then
		Spring.SetUnitCOBValue(unitID, COB.ARMORED, newPinned and 1 or 0)
		if newMoving then
			StartThread(SpinWheels)
		else
			StartThread(StopWheels)
		end
		moving = newMoving
		pinned = newPinned
		UpdateSpeed()
	end
	return success
end

local function NextPose()
	if firing then
		return UpdatePose(moving, pinned)
	end
	return UpdatePose(wantedMoving and not wantedPinned and not pinned, wantedPinned and not moving)
end

local function IsWantedPose()
	return moving == (wantedMoving and not wantedPinned) and pinned == wantedPinned
end

local function ResolvePose(isFire)
	SetSignalMask(0)
	--Spring.Echo("trying to change")
	if inTransition then return false end
	if isFire then
		inTransition = true
		NextPose()
	elseif firing then
		return false
	end
	inTransition = true
	while true do
		if IsWantedPose() then
			--Spring.Echo("reached wanted")
			break
		end
		if not NextPose() then
			Sleep(33)
			Spring.Log("infantrygun script", "error", "animation error")
		end
	end
	--Spring.Echo("ending transition")
	inTransition = false
	return true
end


function script.Create()
	if flare then
		Hide(flare)
	end
	if brakeleft then
		Hide(brakeleft)
	end
	if brakeright then
		Hide(brakeright)
	end

	pinned = false
	moving = false
	wantedPinned = pinned
	wantedMoving = moving
	fear = 0
	firing = false
	UpdatePose(pinned, moving)

	for i=1,info.numWeapons do
		weaponEnabled[i] = true
	end
	if UnitDef.stealth then
		Spring.SetUnitStealth(unitID, true)
	end

	turretTraverseSpeed = UnitDef.customParams.turretTraverseSpeed or weaponTags.defaultTraverseSpeed
	turretElevateSpeed = UnitDef.customParams.turretElevateSpeed or weaponTags.defaultElevateSpeed
end

local function StopPinned()
	--Spring.Echo("stoppinned")
	wantedPinned = false
	StartThread(ResolvePose)
end

local function StartPinned()
	--Spring.Echo("startpinned")
	wantedPinned = true
	StartThread(ResolvePose)
end

local function StopWalk()
	--Spring.Echo("stopwalk")
	wantedMoving = false
	StartThread(ResolvePose)
end

local function Walk()
	--Spring.Echo("walk")
	wantedMoving = true
	StartThread(ResolvePose)
end

function script.StartMoving()
	Walk()
end

function script.StopMoving()
	StopWalk()
end


function script.QueryWeapon(weaponNum)
	local cegPiece = info.cegPieces[weaponNum]
	if cegPiece then
		return cegPiece
	end

	return weaponTags.pitchPiece
end

function script.AimFromWeapon(weaponNum)
	return weaponTags.pitchPiece
end

local function IsLoaded()
	for i=1,info.numWeapons do
		local _, loaded = Spring.GetUnitWeaponState(unitID, i)
		if not loaded then
			return false
		end
	end
	return true
end

local function CanAim()
	return not (moving or inTransition or pinned)
end

local function Recoil()
	Move(barrel, z_axis, -recoilDistance)
	Sleep(RECOIL_DELAY)
	Move(barrel, z_axis, 0, recoilReturnSpeed)
end

function script.AimWeapon(weaponNum, heading, pitch)
	--Spring.Echo("aiming", weaponNum, weaponEnabled[weaponNum])
	if not weaponEnabled[weaponNum] then
		return false
	end

	Signal(SIG_AIM)
	wantedHeading = heading
	wantedPitch = pitch
	if CanAim() and ReAim(heading, pitch) then
		local explodeRange = info.explodeRanges[weaponNum]
		if explodeRange then
			GG.LimitRange(unitID, weaponNum, explodeRange)
		end
		return true
	end
	return false
end

function script.BlockShot(weaponNum, targetUnitID, userTarget)
	if usesAmmo then
		local ammo = Spring.GetUnitRulesParam(unitID, 'ammo')
		if ammo <= 0 then
			return true
		end
	end

	return not (CanAim() and IsLoaded() and weaponEnabled[weaponNum])
end

function script.FireWeapon(weaponNum)
	firing = true

	-- tell the cloak gadget we fired so we should not be cloaked
	local f, _ = GetGameFrame() -- this is not a single number...
	SetUnitRulesParam(unitID, 'decloak_activity_frame', f)
	
	if UnitDef.stealth then
		Spring.SetUnitStealth(unitID, false)
	end
	local explodeRange = info.explodeRanges[weaponNum]
	if explodeRange then
		Spring.SetUnitWeaponState(unitID, weaponNum, "range", explodeRange)
	end
	if usesAmmo then
		local currentAmmo = Spring.GetUnitRulesParam(unitID, 'ammo')
		SetUnitRulesParam(unitID, 'ammo', currentAmmo - 1)
	end
end

function script.Shot(weaponNum)
	if barrel then
		StartThread(Recoil)
	end
	local ceg = info.weaponCEGs[weaponNum]
	if ceg then
		local cegPiece = info.cegPieces[weaponNum]
		if cegPiece then
			GG.EmitSfxName(unitID, cegPiece, ceg)
		end
	end
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

function script.EndBurst(weaponNum)
	Signal(SIG_FIRE)
	StartThread(ResolvePose, true)
	firing = false
end


function script.Killed(recentDamage, maxHealth)
	local corpse = 1
	-- for wheelPiece, _ in pairs(GG.lusHelper[unitDefID].wheelSpeeds) do
		-- Explode(wheelPiece, SFX.SHATTER + SFX.EXPLODE_ON_HIT)
	-- end
	if flare then
		Explode(flare, SFX.FIRE + SFX.FALL + SFX.EXPLODE_ON_HIT + SFX.SMOKE)
	end
	if recentDamage > maxHealth then -- Overkill
		if carriage then
			Explode(carriage, SFX.FIRE + SFX.FALL + SFX.EXPLODE_ON_HIT + SFX.SMOKE)
		end
		corpse = 2
	end
	-- if recentDamage > 10 * maxHealth then -- Hyperkill

	-- end

	return math.min(GG.lusHelper[unitDefID].numCorpses - 1, corpse)
end

function RestoreAfterCover()
	Signal(SIG_FEAR)
	fear = 0
	SetUnitRulesParam(unitID, "fear", 0)
	StopPinned()
end

local function RecoverFear()
	Signal(SIG_FEAR)
	SetSignalMask(SIG_FEAR)
	while fear > 0 do
		--Spring.Echo("Lowered fear", fear)
		fear = fear - 1
		SetUnitRulesParam(unitID, "fear", fear)
		if pinned and fear < FEAR_PINNED then
			StopPinned()
		end
		Sleep(FEAR_SLEEP)
	end
	RestoreAfterCover()
end

function AddFear(amount)
	Signal(SIG_FEAR)
	StartThread(Delay, RecoverFear, FEAR_INITIAL_SLEEP, SIG_FEAR)
	fear = fear + amount
	if fear > FEAR_LIMIT then
		fear = FEAR_LIMIT
	end
	if fear > FEAR_PINNED and not pinned then
		StartThread(StartPinned)
	end
	SetUnitRulesParam(unitID, "fear", fear)
end

function ToggleWeapon(num, isEnabled)
	weaponEnabled[num] = isEnabled
end