-- pieces
-- local head = piece "head"
local torso = piece "torso"
-- local pelvis = piece "pelvis"
-- local gun = piece "gun"
local ground = piece "ground"
local flare = piece "flare"

-- local luparm = piece "luparm"
-- local lloarm = piece "lloarm"

-- local ruparm = piece "ruparm"
-- local rloarm = piece "rloarm"

-- local lthigh = piece "lthigh"
-- local lleg = piece "lleg"
-- local lfoot = piece "lfoot"

-- local rthigh = piece "rthigh"
-- local rleg = piece "rleg"
-- local rfoot = piece "rfoot"

if not GG.lusHelper[unitDefID].animation then
	GG.lusHelper[unitDefID].animation = {include "InfantryStances.lua"}
end
local poses, poseVariants, anims, transitions, fireTransitions, weaponsTags, weaponsMap, weaponsPriorities, customFunctions = unpack(GG.lusHelper[unitDefID].animation)


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

local STOP_AIM_DELAY = 2000
local STAND_DELAY    = 5000
local DEFAULT_TURN_SPEED = math.rad(300)
local REAIM_THRESHOLD = 0.15

local CRAWL_SLOWDOWN_FACTOR = 5

local FEAR_LITTLE = 2  -- small arms or very small calibre cannon: MGs, snipers, LMGs, 20mm
local FEAR_MEDIUM = 4 -- small/med explosions: mortars, 88mm guns and under
local FEAR_BIG = 8 -- large explosions: small bombs, 155mm - 105mm guns
local FEAR_MORTAL = 16 -- omgwtfbbq explosions: medium/large bombs, 170+mm guns, rocket arty
local FEAR_LIMIT = 25
local FEAR_PINNED = 20

local FEAR_INITIAL_SLEEP = 5000
local FEAR_SLEEP = 1000

local isBuilder = UnitDefs[unitDefID].isBuilder

--CURRENT UNIT STATE
local standing
local aiming
local moving
local pinned
local building

--UNIT WANTED STATE
local wantedStanding
local wantedAiming
local wantedMoving
local wantedPinned
local wantedBuilding

--UNIT TARGET STATE
local targetStanding
local targetAiming
local targetMoving
local targetPinned
local targetBuilding

--POSE VARS
local inTransition
local currentPoseID
local currentPoseName
local currentAnim

-- AIMING VARS
local currentPitch
local currentHeading
local wantedHeading
local wantedPitch
local firing

--STORED VARS
local currentSpeed

local weaponEnabled = {}

--localisations
local random = math.random
local push = table.insert
local abs = math.abs
local min = math.min
local PI = math.pi
local TAU = 2 * PI

local nonWaitedStances = {}


local function GetNewPoseID(poseName)
	--Spring.Echo("looking for " .. poseName)
	if poseName == currentPoseName then
		return currentPoseID
	end
	local variants = poseVariants[poseName]
	return variants[random(#variants)]
end

local function Delay(func, duration, mask, params)
	--Spring.Echo("wait", duration)
	SetSignalMask(mask)
	Sleep(duration)
	if params then
		func(unpack(params))
	else
		func()
	end
end

local function WaitForStances()
	--Spring.Echo("waiting")
	for _, stance in pairs(nonWaitedStances) do
		local turns, moves, headingTurn, pitchTurn = unpack(stance)
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
	--Spring.Echo("done")
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

local function ChangePose(transition, nextPoseID, nextPoseName)
	SetSignalMask(0)
	--Spring.Echo("start transition")
	for i, frame in pairs(transition) do
		local duration, turns, moves, headingTurn, pitchTurn, anim, emit = 
			  frame.duration, frame.turns, frame.moves, frame.headingTurn, frame.pitchTurn, frame.anim, frame.emit
		
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
		if headingTurn and wantedHeading then
			local p, axis, target, mul = unpack(headingTurn)
			Turn(p, axis, target + mul * wantedHeading, DEFAULT_TURN_SPEED)
		end
		if pitchTurn and wantedPitch then
			local p, axis, target, mul = unpack(pitchTurn)
			Turn(p, axis, target + mul * wantedPitch, DEFAULT_TURN_SPEED)
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
		if emit then
			for _, params in pairs(emit) do
				local emitPiece, effect = params[1], params[2]
				if emitPiece then
					EmitSfx(emitPiece, effect)
				end
			end
		end
	end
	--Spring.Echo("done transition")
	currentPoseID = nextPoseID
	currentPoseName = nextPoseName
end

local function PickPose(name)
	
	-- if not firing then
		-- Spring.Echo(name)
	-- end
	
	local nextPoseID = GetNewPoseID(name)
	if not currentPoseID then
		--Spring.Echo("warp")
		currentPoseID = nextPoseID
		currentPoseName = name
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
			Turn(p, axis, target + mul * wantedHeading)
		end
		if pitchTurn then
			local p, axis, target, mul = unpack(pitchTurn)
			Turn(p, axis, target + mul * wantedPitch)
		end
		if anim and not currentAnim then
			currentAnim = anim
			StartThread(PlayAnim)
		elseif not anim then
			currentAnim = nil
			Signal(SIG_ANIM)
		end
	else
		-- if inTransition then
			-- Spring.Echo("in transition")
			-- return false
		-- end
		-- if nextPoseID == currentPoseID then
			-- Spring.Echo("no change req")
			-- return true
		-- end
		local transition
		if firing then
			transition = fireTransitions[currentPoseID][nextPoseID]
		end
		if not transition then
			transition = transitions[currentPoseID][nextPoseID]
		end
		if not transition then
			Spring.Echo("no change possible", currentPoseName, name)
			return false
		end
		-- inTransition = true
		ChangePose(transition, nextPoseID, name)
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
	currentHeading = newHeading
	currentPitch = newPitch
	return false
end


local function GetPoseName(newStanding, newAiming, newMoving, newPinned, newBuilding)
	if newPinned then
		return "pinned"
	end
	if newBuilding then
		return "build"
	end
	if newStanding then
		if newMoving then
			if newAiming then
				return "run_aim_" .. newAiming
			else
				return "run"
			end
		else
			if newAiming then
				return "stand_aim_" .. newAiming
			else
				return "stand"
			end
		end
	else
		if newMoving then
			return "crawl"
		else
			if newAiming then
				return "prone_aim_" .. newAiming
			else
				return "prone"
			end
		end
	end
end


local function UpdateSpeed()
	local origSpeed = UnitDefs[unitDefID].speed
	local newSpeed = origSpeed
	if pinned or (firing and not (standing and moving and weaponsTags[aiming].canRunFire)) then
		newSpeed = 0
	elseif not standing then
		newSpeed = origSpeed / CRAWL_SLOWDOWN_FACTOR
	end
	if newSpeed == currentSpeed then
		return
	end
	
	Spring.MoveCtrl.SetGroundMoveTypeData(unitID, {maxSpeed = newSpeed})
	if currentSpeed < newSpeed then
		local cmds = Spring.GetCommandQueue(unitID, 2)
		if cmds[2] and cmds[2].id == CMD.SET_WANTED_MAX_SPEED then
			Spring.GiveOrderToUnit(unitID,CMD.REMOVE,{cmds[2].tag},{})
		end
		local params = {1, CMD.SET_WANTED_MAX_SPEED, 0, 1}
		Spring.MoveCtrl.SetGroundMoveTypeData(unitID, {maxSpeed = newSpeed})
		Spring.GiveOrderToUnit(unitID, CMD.INSERT, params, {"alt"})
	end
	currentSpeed = newSpeed
	
	if UnitDefs[unitDefID].isBuilder then
		local origBuildSpeed = UnitDefs[unitDefID].buildSpeed
		if fear > 0 then
			newBuildSpeed = 0.000001
		else
			newBuildSpeed = origBuildSpeed
		end
		Spring.SetUnitBuildSpeed(unitID, newBuildSpeed)
	end
end

local function UpdatePose(newStanding, newAiming, newMoving, newPinned, newBuilding)
	local success = PickPose(GetPoseName(newStanding, newAiming, newMoving, newPinned, newBuilding))
	--Spring.Echo(newStanding, newAiming, newMoving, newPinned, newBuilding, success)
	if success then
		if not newAiming then
			for _, tags in pairs(weaponsTags) do
				if tags.weaponPiece then
					if tags.showOnReady then
						Show(tags.weaponPiece)
					else
						Hide(tags.weaponPiece)
					end
				end
			end
		else
			for weap, tags in pairs(weaponsTags) do
				if tags.weaponPiece then
					if weap == newAiming then
						Show(tags.weaponPiece)
					else
						Hide(tags.weaponPiece)
					end
				end
			end
		end
		if building ~= newBuilding then
			Spring.SetUnitCOBValue(unitID, COB.INBUILDSTANCE, newBuilding and 1 or 0);
		end
		standing = newStanding
		aiming = newAiming
		moving = newMoving
		pinned = newPinned
		building = newBuilding
		UpdateSpeed()
	end
	return success
end


local function UpdateTargetState()
	if wantedPinned then
		targetStanding = false
		targetAiming = false
		targetMoving = false
		targetPinned = true
		targetBuilding = false
		return
	end
	if firing then
		targetStanding = standing
		targetAiming = aiming and (not weaponsTags[aiming].aimOnLoaded) and aiming --on purpose
		targetMoving = moving
		targetPinned = pinned
		targetBuilding = building
	end
	targetStanding = wantedStanding and fear == 0
	targetAiming = wantedAiming
	targetMoving = wantedMoving
	targetPinned = wantedPinned
	targetBuilding = wantedBuilding and (not wantedPinned and not wantedMoving and not wantedAiming and fear == 0)
	
	if wantedAiming then
		local tags = weaponsTags[wantedAiming]
		if wantedMoving then
			-- solves both crawling and aiming while running
			targetAiming = targetStanding and tags.canRunFire and targetAiming
		else
			-- stand/drop if needed to fire
			targetStanding = targetStanding and tags.canStandFire
			targetAiming = (targetStanding or tags.canProneFire) and targetAiming
		end
	end
	
	if targetBuilding then
		targetStanding = true
	end
	
end


local function IsWantedPose()
	local wanted = standing == targetStanding and
		 aiming == targetAiming and
		 moving == targetMoving and
		 pinned == targetPinned and
		 building == targetBuilding and
		 not firing
		 
	-- Spring.Echo("wanted", wanted)
	return wanted
end

local function NextPose(isFire)
	-- Spring.Echo("current", standing, aiming, moving, pinned, building)
	-- Spring.Echo("wanted", wantedStanding, wantedAiming, wantedMoving, wantedPinned, wantedBuilding)
	-- Spring.Echo("target", targetStanding, targetAiming, targetMoving, targetPinned, targetBuilding)
		
	if firing then
		return UpdatePose(standing, aiming == wantedAiming and aiming, moving, pinned, building)
	end
	
	if targetPinned and not pinned then
		if aiming then
			return UpdatePose(standing, false, moving, pinned, building)
		end
		if moving then
			return UpdatePose(standing, aiming, false, pinned, building)
		end
		if standing then
			return UpdatePose(false, aiming, moving, pinned, building)
		end
		return UpdatePose(false, false, false, true, false)
	elseif pinned and not targetPinned then
		return UpdatePose(false, false, false, false, false)
	end
	
	if standing ~= targetStanding  then
		if building then
			return UpdatePose(standing, aiming, moving, pinned, false)
		end
		if aiming then
			return UpdatePose(standing, false, moving, pinned, building)
		end
		if moving then
			return UpdatePose(standing, aiming, false, pinned, building)
		end
		return UpdatePose(targetStanding and fear == 0, aiming, moving, pinned, building)
	end
	
	if moving ~= targetMoving then
		if building then
			return UpdatePose(standing, aiming, moving, pinned, false)
		end
		if aiming then
			return UpdatePose(standing, false, moving, pinned, building)
		end
		return UpdatePose(standing, aiming, targetMoving, pinned, building)
	end
	
	if aiming ~= targetAiming then
		if building then
			return UpdatePose(standing, aiming, moving, pinned, false)
		end
		if aiming then
			return UpdatePose(standing, false, moving, pinned, building)
		end
		return UpdatePose(standing, targetAiming, moving, pinned, building)
	end
	
	if building ~= targetBuilding then
		return UpdatePose(standing, aiming, moving, pinned, targetBuilding)
	end
	
	Spring.Echo("shouldn't reach here")
	Sleep(33)
end

local function ResolvePose(isFire)
	SetSignalMask(0)
	--Spring.Echo("trying to change")
	if inTransition then return false end
	if isFire then
		UpdateTargetState()
		NextPose()
		return
	elseif firing then
		return false
	end
	inTransition = true
	while true do
		UpdateTargetState()
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
end

function StopAiming()
	--Spring.Echo("stopaiming")
	wantedAiming = false
	StartThread(ResolvePose)
end

local function StopWalk()
	--Spring.Echo("stopwalk")
	wantedMoving = false
	StartThread(ResolvePose)
end

local function Stand()
	--Spring.Echo("stand")
	wantedStanding = true
	StartThread(ResolvePose)
end

local function Walk()
	--Spring.Echo("walk")
	wantedMoving = true
	wantedStanding = true
	StartThread(ResolvePose)
end

local function Drop()
	--Spring.Echo("drop")
	wantedStanding = false
	StartThread(ResolvePose)
end

function StartAiming(weaponNum)
	--Spring.Echo("startaiming")
	wantedAiming = weaponNum
	StartThread(ResolvePose)
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

local function StartBuilding()
	wantedBuilding = true
	StartThread(ResolvePose)
end

local function StopBuilding()
	wantedBuilding = false
	StartThread(ResolvePose)
end


function script.Create()
	if flare then 
		Hide(flare)
	end
	standing = true
	wantedStanding = standing
	aiming = false
	wantedAiming = aiming
	moving = false
	wantedMoving = moving
	pinned = false
	wantedPinned = pinned
	building = false
	wantedBuilding = building
	fear = 0
	wantedPitch = nil
	wantedHeading = nil
	currentPitch = nil
	currentHeading = nil
	firing = false
	currentSpeed = UnitDefs[unitDefID].speed
	UpdatePose(standing, aiming, moving, pinned, building)
	for i=1,#weaponsMap do
		weaponEnabled[i] = true
	end
	UpdateSpeed()
end

function script.StartMoving()
	Walk()
end

function script.StopMoving()
	StopWalk()
end

local function CanBuild()
	return standing and not aiming and not moving and fear == 0 and not inTransition
end


function script.QueryWeapon(num)
	return flare
end

function script.AimFromWeapon(num)
	return torso
end

local function IsLoaded(weaponClass)
	for i, wc in pairs(weaponsMap) do
		local _, loaded = Spring.GetUnitWeaponState(unitID, i)
		if weaponClass == wc and not loaded then
			return false
		end
	end
	return true
end

local function CanFire(weaponClass)
	return aiming == weaponClass and not inTransition
end

function script.AimWeapon(num, heading, pitch)
	if wantedAiming and weaponsPriorities[wantedAiming] > num then
		return false
	end
	if not weaponEnabled[num] then
		return false
	end
	
	local weaponClass = weaponsMap[num]
	local tags = weaponsTags[weaponClass]
	if not tags then return false end
	
	if tags.aimOnLoaded and not IsLoaded(weaponClass) then
		return false
	end
	
	Signal(SIG_AIM)
	StartThread(Delay, StopAiming, STOP_AIM_DELAY, SIG_RESTORE)
	StartThread(Delay, Stand, STAND_DELAY, SIG_RESTORE)
	wantedHeading = heading
	wantedPitch = pitch
	if CanFire(weaponClass) then return ReAim(heading, pitch) end
	StartAiming(weaponClass)
	return false
end

function script.BlockShot(num, targetUnitID, userTarget)
	local weaponClass = weaponsMap[num]
	return not (CanFire(weaponClass) and IsLoaded(weaponClass) and weaponEnabled[num])
end

function script.FireWeapon(num)
	firing = true
	UpdateSpeed()
end

function script.Shot(num)
	local weaponClass = weaponsMap[num]
	local tags = weaponsTags[weaponClass]
	if not tags.aimOnLoaded then
		StartThread(ResolvePose, true)
	end
end

function script.EndBurst(num)
	firing = false
	Signal(SIG_FIRE)
	local weaponClass = weaponsMap[num]
	local tags = weaponsTags[weaponClass]
	if tags.aimOnLoaded and wantedAiming == aiming then
		StopAiming()
	else
		StartThread(Delay, StopAiming, STOP_AIM_DELAY, SIG_RESTORE)
	end
	UpdateSpeed()
	StartThread(ResolvePose)
	StartThread(Delay, Stand, STAND_DELAY, SIG_RESTORE)
end


function script.Killed(recentDamage, maxHealth)
	return 1
end

function RestoreAfterCover()
	--Spring.Echo("restoring")
	Signal(SIG_FEAR)
	fear = 0
	StopPinned()
	Stand()
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
	Drop()
	Spring.SetUnitRulesParam(unitID, "suppress", fear)
end

function ToggleWeapon(num, isEnabled)
	weaponEnabled[num] = isEnabled
end

function script.StartBuilding(buildheading, pitch)
	if CanBuild() then
		wantedHeading = buildheading
		wantedPitch = pitch
		StartBuilding()
	end
end

function script.StopBuilding()
	StopBuilding()
end


for name, func in pairs(customFunctions) do
	_G[name] = func
end
