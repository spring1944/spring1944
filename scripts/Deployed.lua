-- pieces
local flare = piece "flare"

local barrel = piece "barrel"

local tubes = piece "tubes"

local brakeleft = piece "brakeleft"
local brakeright = piece "brakeright"

local carriage = piece "carriage"

if not GG.lusHelper[unitDefID].animation then
	GG.lusHelper[unitDefID].animation = {include "DeployedLoader.lua"}
end
local poses, transitions, fireTransitions, weaponTags = unpack(GG.lusHelper[unitDefID].animation)

--Localisations
local PI = math.pi
local TAU = 2 * PI
local abs = math.abs

--Constants
local SIG_AIM = 1
local SIG_FIRE = 2
local SIG_FEAR = 32

local DEFAULT_TURN_SPEED = math.rad(300)
local REAIM_THRESHOLD = 0.15

local FEAR_LIMIT = 25
local FEAR_PINNED = 2

local FEAR_INITIAL_SLEEP = 5000
local FEAR_SLEEP = 1000

local RECOIL_DELAY = 198

local turretTraverseSpeed = math.rad(25)
local turretElevateSpeed = math.rad(17)
local recoilDistance = 2.4
local recoilReturnSpeed = 10


--CURRENT UNIT STATE
local pinned

--UNIT WANTED STATE
local wantedPinned

--POSE VARS
local inTransition
local currentPoseName

-- AIMING VARS
local currentPitch
local currentHeading

-- OTHER
local fear
local nextRocket
local weaponEnabled = {}



local function Delay(func, duration, mask, ...)
	--Spring.Echo("wait", duration)
	SetSignalMask(mask)
	Sleep(duration)
	func(...)
end

local function ChangePose(transition, nextPoseName)
	SetSignalMask(0)
	--Spring.Echo("start transition")
	for i, frame in pairs(transition) do
		local duration, turns, moves = 
			  frame.duration, frame.turns, frame.moves
		
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
			Spring.Echo("no change possible", currentPoseName, name)
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
	local headingPiece = carriage
	local pitchPiece = barrel or tubes
	Turn(headingPiece, y_axis, newHeading, turretTraverseSpeed)
	Turn(pitchPiece, x_axis, -newPitch, turretElevateSpeed)
	
	WaitForTurn(headingPiece, y_axis)
	WaitForTurn(pitchPiece, x_axis)
	
	currentHeading = newHeading
	currentPitch = newPitch
	return false
end

local function GetPoseName(newPinned)
	return newPinned and "pinned" or "ready"
end

local function UpdatePose(newPinned)
	local success = PickPose(GetPoseName(newPinned))
	--Spring.Echo(newStanding, newAiming, newMoving, newPinned, newBuilding, success)
	if success then
		Spring.SetUnitCOBValue(unitID, COB.ARMORED, newPinned and 1 or 0);
		pinned = newPinned
	end
	return success
end

local function NextPose()
	if firing then
		return UpdatePose(pinned)
	end
	return UpdatePose(wantedPinned)
end

local function IsWantedPose()
	return pinned == wantedPinned
end

local function ResolvePose(isFire)
	SetSignalMask(0)
	--Spring.Echo("trying to change")
	if inTransition then return false end
	if isFire then
		NextPose()
		return
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
			Spring.Echo("animation error")
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
	wantedPinned = pinned
	fear = 0
	wantedPitch = nil
	wantedHeading = nil
	currentPitch = nil
	currentHeading = nil
	firing = false
	UpdatePose(pinned)
	weaponEnabled[1] = true
	for i=2,GG.lusHelper[unitDefID].numWeapons do
		weaponEnabled[i] = false
	end
	if GG.lusHelper[unitDefID].numRockets > 0 then
		nextRocket = 1
	end
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


function script.QueryWeapon(num)
	if nextRocket then
		return piece("rocket" .. nextRocket) or tubes
	end
	return barrel or tubes or carriage
end

function script.AimFromWeapon(num)
	return barrel or tubes or carriage
end

local function IsLoaded()
	for i=1,GG.lusHelper[unitDefID].numWeapons do
		local _, loaded = Spring.GetUnitWeaponState(unitID, i)
		if not loaded then
			return false
		end
	end
	return true
end

local function CanFire()
	return not (inTransition or pinned)
end

local function Recoil()
	Move(barrel, z_axis, -recoilDistance)
	Sleep(RECOIL_DELAY)
	Move(barrel, z_axis, 0, recoilReturnSpeed)
end

function script.AimWeapon(num, heading, pitch)
	if not weaponEnabled[num] then
		return false
	end
	
	Signal(SIG_AIM)
	wantedHeading = heading
	wantedPitch = pitch
	if CanFire() then return ReAim(heading, pitch) end
	return false
end

function script.BlockShot(num, targetUnitID, userTarget)
	return not (CanFire() and IsLoaded() and weaponEnabled[num])
end

function script.FireWeapon(num)
	firing = true
end

function script.Shot(num)
	if barrel then
		StartThread(Recoil)
	end
	if nextRocket then
		Hide(piece("rocket" .. nextRocket))
		nextRocket = nextRocket + 1
	end
	local ceg = GG.lusHelper[unitDefID].weaponCEGs[num]
	if ceg then
		local cegPiece = GG.lusHelper[unitDefID].cegPieces[num]
		if cegPiece then
			GG.EmitSfxName(unitID, cegPiece, ceg)
		end
	end
	if brakeleft then
		GG.EmitSfxName(unitID, brakeleft, "MUZZLEBRAKESMOKE")
	end
	if brakeright then
		GG.EmitSfxName(unitID, brakeright, "MUZZLEBRAKESMOKE")
	end
	
end

function script.EndBurst(num)
	StartThread(ResolvePose, true)
	firing = false
	if nextRocket then
		nextRocket = 1
	end
	Signal(SIG_FIRE)
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
	--Spring.Echo("restoring")
	Signal(SIG_FEAR)
	fear = 0
	Spring.SetUnitRulesParam(unitID, "suppress", 0)
	StopPinned()
end

local function RecoverFear()
	Signal(SIG_FEAR)
	SetSignalMask(SIG_FEAR)
	while fear > 0 do
		--Spring.Echo("Lowered fear", fear)
		fear = fear - 1
		Spring.SetUnitRulesParam(unitID, "suppress", fear)
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
	Spring.SetUnitRulesParam(unitID, "suppress", fear)
end

function ToggleWeapon(num, isEnabled)
	weaponEnabled[num] = isEnabled
end

if GG.lusHelper[unitDefID].numRockets > 0 then
	local function ShowRockets(delay)
		Sleep(delay)
		for i = 1,GG.lusHelper[unitDefID].numRockets do
			Show(piece("rocket" .. i))
		end
	end
	function RestoreRockets(delay)
		StartThread(ShowRockets, delay)
	end
end