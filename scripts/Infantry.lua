

-- pieces
local head = piece "head"
local torso = piece "torso"
local pelvis = piece "pelvis"
local gun = piece "gun"
local ground = piece "ground"
local flare = piece "flare"

local luparm = piece "luparm"
local lloarm = piece "lloarm"

local ruparm = piece "ruparm"
local rloarm = piece "rloarm"

local lthigh = piece "lthigh"
local lleg = piece "lleg"
local lfoot = piece "lfoot"

local rthigh = piece "rthigh"
local rleg = piece "rleg"
local rfoot = piece "rfoot"
local pieces = Spring.GetUnitPieceMap(unitID)
local rPieces = {}
for k,v in pairs(pieces) do
	rPieces[v] = k
end
local poses, poseVariants, anims, transitions = include "InfantryStances.lua"


--Constants
local SIG_STATE = 1
local SIG_AIM = 2
local SIG_PINNED = 4
local SIG_FIRE = 8
local SIG_RESTORE = 15
local SIG_MOVE = 16
local SIG_FEAR = 32
local SIG_PINNED = 64
local SIG_ANIM = 128

local STATE_STAND = 1
local STATE_KNEEL = 2
local STATE_PRONE = 3


local MUZZLEFLASH = 1024 + 7
local STOP_AIM_DELAY = 2000
local STAND_DELAY    = 5000
local DEFAULT_TURN_SPEED = math.rad(300)
local DEFAULT_MOVE_SPEED = 100
local PRONE_TURN_SPEED = math.rad(900)
local PRONE_MOVE_SPEED = 80
local REAIM_THRESHOLD = 0.02

local CRAWL_SLOWDOWN_FACTOR = 5

local FEAR_LITTLE = 2  -- small arms or very small calibre cannon: MGs, snipers, LMGs, 20mm
local FEAR_MEDIUM = 4 -- small/med explosions: mortars, 88mm guns and under
local FEAR_BIG = 8 -- large explosions: small bombs, 155mm - 105mm guns
local FEAR_MORTAL = 16 -- omgwtfbbq explosions: medium/large bombs, 170+mm guns, rocket arty
local FEAR_LIMIT = 25
local FEAR_PINNED = 20

local FEAR_INITIAL_SLEEP = 5000
local FEAR_SLEEP = 1000

local IS_PRONE_FIRE = false
local CAN_RUN_FIRE = true

--UNIT STATE
local state
local aiming
local moving
local pinned

--POSE VARS
local inTransition
local currentPoseID
local currentAnim

-- AIMING VARS
local lastPitch
local lastHeading
local aimed

--STORED VARS
local origSpeed
local currentSpeed

--localisations
local random = math.random
local push = table.insert
local abs = math.abs
local min = math.min
local PI = math.pi
local TAU = 2 * PI

local nonWaitedStances = {}

local function MySignal(sig)
	Spring.Echo("signal", sig)
	Signal(sig)
end

local function GetNewPoseID(poseName)
	Spring.Echo("looking for " .. poseName)
	local variants = poseVariants[poseName]
	return variants[random(#variants)]
end

local function Delay(func, duration, mask, params)
	Spring.Echo("wait", duration)
	SetSignalMask(mask)
	Sleep(duration)
	if params then
		func(unpack(params))
	else
		func()
	end
end

local function WaitForStances()
	Spring.Echo("waiting")
	for _, stance in pairs(nonWaitedStances) do
		local turns, moves, headingTurn, pitchTurn = unpack(stance)
		Spring.Echo(#turns, #moves)
		for _, params in pairs(turns) do
			WaitForTurn(params[1], params[2])
		end
		if moves then
			for _, params in pairs(moves) do
				WaitForMove(params[1], params[2])
			end	
		end
		if headingTurn then
			WaitForTurn(headingTurn[1], headingTurn[2])
		end
		if pitchTurn then
			WaitForTurn(pitchTurn[1], pitchTurn[2])
		end
	end
	Sleep(33)
	nonWaitedStances = {}
	Spring.Echo("done")
end

local function PlayAnim()
	MySignal(SIG_ANIM)
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

local function ChangePose(transition, nextPoseID)
	SetSignalMask(0)
	Spring.Echo("start transition")
	for i, frame in pairs(transition) do
		local duration, turns, moves, headingTurn, pitchTurn, anim = 
			  frame.duration, frame.turns, frame.moves, frame.headingTurn, frame.pitchTurn, frame.anim
		
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
		if headingTurn and lastHeading then
			local p, axis, target, mul = unpack(headingTurn)
			Turn(p, axis, target + mul * lastHeading, DEFAULT_TURN_SPEED)
		end
		if pitchTurn and lastPitch then
			local p, axis, target, mul = unpack(pitchTurn)
			Turn(p, axis, target + mul * lastPitch, DEFAULT_TURN_SPEED)
		end
		if anim and not currentAnim then
			currentAnim = anim
			StartThread(PlayAnim)
		elseif not anim then
			currentAnim = nil
			MySignal(SIG_ANIM)
		end
		Sleep(duration)
	end
	Spring.Echo("done transition")
	currentPoseID = nextPoseID
	inTransition = false
end

local function PickPose(name)
	Spring.Echo(name)
	local nextPoseID = GetNewPoseID(name)
	if not currentPoseID then
		Spring.Echo("warp")
		currentPoseID = nextPoseID
		local pose = poses[currentPoseID]
		local turns, moves, headingTurn, pitchTurn, anim = 
			  pose.turns, pose.moves, pose.headingTurn, pose.pitchTurn, pose.anim
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
		if headingTurn then
			local p, axis, target, mul = unpack(headingTurn)
			Turn(p, axis, target + mul * lastHeading)
		end
		if pitchTurn then
			local p, axis, target, mul = unpack(pitchTurn)
			Turn(p, axis, target + mul * lastPitch)
		end
		if anim and not currentAnim then
			currentAnim = anim
			StartThread(PlayAnim)
		elseif not anim then
			currentAnim = nil
			MySignal(SIG_ANIM)
		end
	else
		if inTransition then
			Spring.Echo("in transition")
			return false
		end
		if nextPoseID == currentPoseID then
			Spring.Echo("no change req")
			return true
		end
		local transition = transitions[currentPoseID][nextPoseID]
		if not transition then
			Spring.Echo("no change possible")
			return false
		end
		inTransition = true
		StartThread(ChangePose, transition, nextPoseID)
		return true
	end
	
end

local function ReAim(newHeading, newPitch)
	Spring.Echo("reaiming")
	local pose = poses[currentPoseID]
	local headingTurn, pitchTurn = pose.headingTurn, pose.pitchTurn
	if headingTurn then
		local p, axis, target, mul = unpack(headingTurn)
		Turn(p, axis, target + mul * newHeading, DEFAULT_TURN_SPEED)
	end
	if pitchTurn then
		local p, axis, target, mul = unpack(pitchTurn)
		Turn(p, axis, target + mul * newPitch, DEFAULT_TURN_SPEED)
	end
	nonWaitedStances[#nonWaitedStances + 1] = {{}, {}, headingTurn, pitchTurn}
	WaitForStances() 
	lastHeading = newHeading
	lastPitch = newPitch
	aimed = true
end


local function GetPoseName(newState, newAiming, newMoving, newPinned)
	if newPinned then
		return "pinned"
	end
	if newState == STATE_STAND then
		if newMoving then
			if newAiming then
				return "run_aim"
			else
				return "run_ready"
			end
		else
			if newAiming then
				return "stand_aim"
			else
				return "stand_ready"
			end
		end
	elseif newState == STATE_PRONE then
		if newMoving then
			return "crawl"
		else
			if not newAiming then
				return "prone_ready"
			else
				return "prone_aim"
			end
		end
	end
end

local function UpdatePose(newState, newAiming, newMoving, newPinned)
	return PickPose(GetPoseName(newState, newAiming, newMoving, newPinned))
end

local function ChangeSpeed(newSpeed)
	Spring.MoveCtrl.SetGroundMoveTypeData(unitID, {maxSpeed = newSpeed})
	if currentSpeed < newSpeed then
		local params = {1, CMD.SET_WANTED_MAX_SPEED, 0, 1}
		Spring.MoveCtrl.SetGroundMoveTypeData(unitID, {maxSpeed = newSpeed})
		Spring.GiveOrderToUnit(unitID, CMD.INSERT, params, {"alt"})
	end
	currentSpeed = newSpeed
end

local function ChangeState(newState)
	if state == newState then
		return true
	end
	local oldState = state
	state = newState
	if not UpdatePose() then
		state = oldState
		return false
	end
	if state == STATE_PRONE then
		SetUnitValue(COB.UPRIGHT, 0)
		ChangeSpeed(origSpeed / CRAWL_SLOWDOWN_FACTOR)
	elseif state == STATE_STAND then
		SetUnitValue(COB.UPRIGHT, 1)
		ChangeSpeed(origSpeed)
	end
	return true
end

local function RequestChange(newState, newAiming, newMoving, newPinned)
	Spring.Echo(newState, newAiming, newMoving, newPinned)
	if inTransition then
		return false
	end
	if newState ~= state then
		if not UpdatePose(newState, aiming, moving, pinned) then
			return false
		else
			state = newState
		end
	end
	while inTransition do
		Sleep(33)
	end
	if newAiming ~= aiming then
		if not UpdatePose(state, newAiming, moving, pinned) then
			return false
		else
			aiming = newAiming
		end
	end
	while inTransition do
		Sleep(33)
	end
	if newMoving ~= moving then
		if not UpdatePose(state, aiming, newMoving, pinned) then
			return false
		else
			moving = newMoving
		end
	end
	while inTransition do
		Sleep(33)
	end
	if newPinned ~= pinned then
		if not UpdatePose(state, aiming, moving, newPinned) then
			return false
		else
			pinned = newPinned
		end
	end
	return true
end

local function StopAiming()
	if not RequestChange(state, false, moving, pinned) then
		StartThread(Delay, StopAiming, STOP_AIM_DELAY, SIG_RESTORE)
		Spring.Echo("can't stop aiming")
	else
		aimed = false
		lastPitch = nil
		lastHeading = nil
		
		Spring.Echo("stopped aiming")
	end
end

local function StopWalk()
	Spring.Echo("stoppppp")
	MySignal(SIG_MOVE)
	SetSignalMask(SIG_MOVE)	
	while (not RequestChange(state, aiming, false, pinned)) do
		Sleep(33)
	end
	Spring.Echo("stopped")
end

local Walk

local function Stand()
	SetSignalMask(0)
	if fear > 0 then
		return
	end
	local wasMoving = moving
	if moving then
		StopWalk()
	end
	if IS_PRONE_FIRE and aiming then
		StopAiming()
	end
	if not RequestChange(STATE_STAND, aiming, moving, pinned) then
		StartThread(Delay, Stand, STAND_DELAY, SIG_RESTORE)
		Spring.Echo("can't stand")
	else
		SetUnitValue(COB.UPRIGHT, 1)
		SetUnitValue(COB.ARMORED, 0)
		ChangeSpeed(origSpeed)
		Spring.Echo("stood up")
	end
	if wasMoving then
		Walk()
	end
end

Walk = function()
	Spring.Echo("runnnnn")
	MySignal(SIG_MOVE)
	SetSignalMask(SIG_MOVE)
	if fear == 0 then
		Stand()
	end
	SetSignalMask(SIG_MOVE)
	if state == STATE_PRONE or not CAN_RUN_FIRE then
		StopAiming()
	end
	while (not RequestChange(state, aiming, true, pinned)) do
		Sleep(33)
	end
	-- while (true) do
		-- if state == STATE_STAND then
			-- local wait = random(5, 6) * 33
			-- PlayAnim("run", wait)
		-- elseif state == STATE_PRONE then
			-- local wait = random(395, 465)
			-- PlayAnim("crawl", wait)
		-- else
			-- Sleep(200)
		-- end
	-- end
end



local function Drop()
	SetSignalMask(0)
	local wasMoving = moving
	if moving then
		StopWalk()
	end
	while (not RequestChange(STATE_PRONE, aiming, moving, pinned)) do
		Sleep(33)
	end
	SetUnitValue(COB.UPRIGHT, 0)
	SetUnitValue(COB.ARMORED, 1)
	ChangeSpeed(origSpeed / CRAWL_SLOWDOWN_FACTOR)
	Spring.Echo("changed speed")
	StartThread(Delay, Stand, STAND_DELAY, SIG_RESTORE)
	if wasMoving then
		Walk()
	end
end

local function StartAiming()
	SetSignalMask(0)
	local newState, newMoving
	if IS_PRONE_FIRE and state ~= STATE_PRONE and not moving then
		Drop()
	end

	if not RequestChange(state, true, moving, pinned) then
		Spring.Echo("can't start aiming")
	else
		Spring.Echo("started aiming")
		StartThread(Delay, StopAiming, STOP_AIM_DELAY, SIG_RESTORE)
	end
end


function script.Create()
	Hide(flare)
	state = STATE_STAND
	aiming = false
	moving = false
	pinned = false
	fear = 0
	lastPitch = nil
	lastHeading = nil
	origSpeed = UnitDefs[unitDefID].speed
	currentSpeed = origSpeed
	UpdatePose(STATE_STAND, false, false, false)
end

function script.StartMoving()
	StartThread(Walk)
end

function script.StopMoving()
	StartThread(StopWalk)
end


function script.QueryWeapon(num)
	return flare 
end

function script.AimFromWeapon(num)
	return torso 
end

local function CanAim()
	if pinned or inTransition then
		return false
	end
	if moving then
		return state == STATE_STAND and CAN_RUN_FIRE and not IS_PRONE_FIRE
	end
	
	return true
end

function script.AimWeapon(num, heading, pitch)
	MySignal(SIG_AIM)
	SetSignalMask(SIG_AIM)
	StartThread(Delay, StopAiming, STOP_AIM_DELAY, SIG_RESTORE)
	StartThread(Delay, Stand, STAND_DELAY, SIG_RESTORE)
	if num == 2 then return false end
	if not CanAim() then
		return false
	end
	if not aiming then
		lastHeading = heading
		lastPitch = pitch
		StartThread(StartAiming)
		return false
	end
	
	-- local aimed
	
	if lastHeading then
		local hDiff = lastHeading - heading
		if hDiff > PI then
			hDiff = TAU - hDiff
		elseif hDiff < -PI then
			hDiff = hDiff + TAU
		end
		local pDiff = abs(lastPitch - pitch)
		local hDiff = abs(hDiff)
		if hDiff > REAIM_THRESHOLD or pDiff > REAIM_THRESHOLD then
			aimed = false
		end
	end
	
	if not aimed then
		ReAim(heading, pitch)
	end
	return true
end

function script.FireWeapon(num)
	MySignal(SIG_FIRE)
	EmitSfx(flare, MUZZLEFLASH)
	StartThread(Delay, StopAiming, STOP_AIM_DELAY, SIG_RESTORE)
	StartThread(Delay, Stand, STAND_DELAY, SIG_RESTORE)
end

function script.Killed(recentDamage, maxHealth)

end

local function RestoreAfterCover()
	MySignal(SIG_FEAR)
	Stand()
end

local function StopPinned()
	MySignal(SIG_PINNED)
	SetSignalMask(SIG_PINNED)
	while not RequestChange(state, aiming, moving, false) do
		Sleep(33)
	end
	ChangeSpeed(origSpeed / CRAWL_SLOWDOWN_FACTOR)
end

local function StartPinned()
	MySignal(SIG_PINNED)
	SetSignalMask(SIG_PINNED)
	
	if moving then
		StopWalk()
	end
	if state ~= STATE_PRONE then
		Drop()
	end
	if aiming then
		StopAiming()
	end
	ChangeSpeed(0)
	while not RequestChange(state, aiming, moving, true) do
		Sleep(33)
	end
end

local function RecoverFear()
	MySignal(SIG_FEAR)
	SetSignalMask(SIG_FEAR)
	while fear > 0 do
		Spring.Echo("Lowered fear", fear)
		fear = fear - 1
		Spring.SetUnitRulesParam(unitID, "suppress", fear)
		if pinned and fear < FEAR_PINNED then
			StartThread(StopPinned)
		end
		Sleep(FEAR_SLEEP)
	end
	RestoreAfterCover()
end

function AddFear(amount)
	MySignal(SIG_FEAR)
	StartThread(Delay, RecoverFear, FEAR_INITIAL_SLEEP, SIG_FEAR)
	fear = fear + amount
	if fear > FEAR_LIMIT then
		fear = FEAR_LIMIT
	end
	if fear > FEAR_PINNED and not pinned then
		StartThread(StartPinned)
	end
	if state ~= STATE_PRONE then
		StartThread(Drop)
	end
	Spring.SetUnitRulesParam(unitID, "suppress", fear)
end
