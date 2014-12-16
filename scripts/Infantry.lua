

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

local SIG_STATE = 1
local SIG_AIM = 2
local SIG_PINNED = 4
local SIG_FIRE = 8
local SIG_RESTORE = 15
local SIG_MOVE = 16

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

local IS_PRONE_FIRE = false


local state
local aiming
local moving
local pinned
local fear
local lastPitch
local lastHeading

local origSpeed
local aimed

local inTransition

local currentPoseID

local random = math.random
local push = table.insert
local abs = math.abs
local PI = math.pi
local TAU = 2 * PI

local nonWaitedStances = {}

local function MySignal(sig)
	Spring.Echo("signal", sig)
	Signal(sig)
end

local function GetPoseID(poseName)
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

local function PickPose(name)
	Spring.Echo(name)
	local nextPoseID = GetPoseID(name)
	if not currentPoseID then
		currentPoseID = nextPoseID --GetPoseID(name)
		local pose = poses[currentPoseID]
		local delay, turns, moves, headingTurn, pitchTurn = unpack(pose)--, headingTurn, pitchTurn = unpack(stance)
		for _, params in pairs(turns) do
			Turn(unpack(params))
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
		SetSignalMask(0)
		Spring.Echo("no mask!!!")
		inTransition = true
		for i, frame in pairs(transition) do
			local delay, turns, moves, headingTurn, pitchTurn = unpack(frame)
			Spring.Echo("frame", i, #turns, #moves, delay, headingTurn, pitchTurn)			
			for _, params in pairs(turns) do
				Turn(unpack(params))
			end
			if moves then
				for _, params in pairs(moves) do
					Move(unpack(params))
				end
			end
			Sleep(delay)
		end
		Spring.Echo("done transition")
		currentPoseID = nextPoseID
		inTransition = false
		return true
	end
	
end

local function ReAim()
	local pose = poses[currentPoseID]
	local turns, moves, headingTurn, pitchTurn = unpack(pose)--, headingTurn, pitchTurn = unpack(stance)
	if headingTurn then
		Spring.Echo(unpack(headingTurn))
		local p, axis, target, mul = unpack(headingTurn)
		Turn(p, axis, target + mul * lastHeading, DEFAULT_TURN_SPEED)
	end
	if pitchTurn then
		Spring.Echo(unpack(pitchTurn))
		local p, axis, target, mul = unpack(pitchTurn)
		Turn(p, axis, target + mul * lastPitch, DEFAULT_TURN_SPEED)
	end
	nonWaitedStances[#nonWaitedStances + 1] = {{}, {}, headingTurn, pitchTurn}
	WaitForStances() 
end

local function PlayAnim(name, wait)
	Spring.Echo("playing " .. name)
	local animTable = anims[name]
	for _, frame in pairs(animTable) do
		local turns, moves = unpack(frame)
		if moves then
			for _, params in pairs(moves) do
				Move(unpack(params))
			end
		end
		
		for _, params in pairs(turns) do
			Turn(unpack(params))
		end
		if wait then
			Sleep(wait)
		else
			push(nonWaitedStances, frame)
			WaitForStances()
		end
	end
end

local function UpdatePose()
	if state == STATE_STAND then
		if not moving then
			if aiming then
				return PickPose("stand_aim")
			else
				return PickPose("stand_ready")
			end
		else
			if aiming then
				return PickPose("run_aim")
			else
				return PickPose("run_ready")
			end
		end
	elseif state == STATE_PRONE then
		if not aiming then
			return PickPose("prone_ready")
		else
			return PickPose("prone_aim")
		end
	end
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
		--SetUnitValue(COB.MAX_SPEED, origSpeed / CRAWL_SLOWDOWN_FACTOR)
		Spring.MoveCtrl.SetGroundMoveTypeData(unitID, {maxSpeed = origSpeed / CRAWL_SLOWDOWN_FACTOR})
	elseif oldState == STATE_PRONE then
		SetUnitValue(COB.UPRIGHT, 1)
		--SetUnitValue(COB.MAX_SPEED, origSpeed)
		Spring.MoveCtrl.SetGroundMoveTypeData(unitID, {maxSpeed = origSpeed})
	end
	return true
end

local function StopAiming()
	aiming = false
	aimed = false
	lastPitch = nil
	lastHeading = nil
	if UpdatePose() then
		Spring.Echo("stopped aiming")
	else
		Spring.Echo("not yet")
	end
end

local function Walk()
	Spring.Echo("runnnnn")
	MySignal(SIG_MOVE)
	SetSignalMask(SIG_MOVE)
	moving = true
	while (not UpdatePose()) do
		Sleep(33)
	end
	SetSignalMask(SIG_MOVE)
	while (true) do
		if state == STATE_STAND then
			local pelvisWait = random(5, 6) * 33
			PlayAnim("run", pelvisWait)
		else
			Sleep(200)
			Spring.Echo(state, moving)
		end
	end
end

local function StopWalk()
	Spring.Echo("stoppppp")
	MySignal(SIG_MOVE)
	SetSignalMask(SIG_MOVE)	
	moving = false
	while (not UpdatePose()) do
		Sleep(33)
	end
	Spring.Echo("stopped")
end

local function Stand()
	Spring.Echo("please")
	if ChangeState(STATE_STAND) then
		Spring.Echo("easy")
		return
	end
	Spring.Echo("hard")
	if moving then
		Spring.Echo("harder")
		StopWalk()
		local success = ChangeState(STATE_STAND)
		Walk()
		if success then
			return
		end
	end
	Spring.Echo("super hard")
	StartThread(Delay, ChangeState, STAND_DELAY, SIG_RESTORE, {STATE_STAND})
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
	UpdatePose()
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

function script.AimWeapon(num, heading, pitch)
	MySignal(SIG_AIM)
	SetSignalMask(SIG_AIM)
	if num == 2 then return false end
	if IS_PRONE_FIRE and state ~= STATE_PRONE then
		StartThread(Delay, Stand, STAND_DELAY, SIG_RESTORE)
		if not ChangeState(STATE_PRONE) then
			return false
		end
	end
	
	-- local aimed
	
	aiming = true
	StartThread(Delay, Stand, STAND_DELAY, SIG_RESTORE)
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
		lastPitch = pitch
		lastHeading = heading
		if UpdatePose() then
			ReAim()
			aiming = true
			aimed = true
		else
			aiming = false
			return false
		end
	end
	if aiming then
		StartThread(Delay, StopAiming, STOP_AIM_DELAY, SIG_RESTORE)
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
