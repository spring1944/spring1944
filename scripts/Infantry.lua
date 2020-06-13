-- pieces
local torso = piece "torso"

local flare = piece "flare"

local info = GG.lusHelper[unitDefID]
local customAnims = info.customAnims

local SetUnitRulesParam = Spring.SetUnitRulesParam
local GetGameFrame = Spring.GetGameFrame

if not info.animation then
	include "InfantryLoader.lua"
end
local poses, poseVariants, anims, transitions, fireTransitions, weaponsTags, weaponsMap, weaponsPriorities = unpack(info.animation)

-- Just in case we have wheels
local WHEEL_CHECK_DELAY = 990
local WHEEL_ACCELERATION_FACTOR = 3

local hasWheels = false
info.wheelSpeeds = {}
local pieceMap = Spring.GetUnitPieceMap(unitID)
for pieceName, pieceNum in pairs(pieceMap) do
	-- Find Wheel Speeds
	if pieceName:find("wheel") then
		hasWheels = true
		local wheelInfo = Spring.GetUnitPieceInfo(unitID, pieceNum)
		local wheelHeight = math.abs(wheelInfo.max[2] - wheelInfo.min[2])
		info.wheelSpeeds[pieceNum] = (UnitDefs[unitDefID].speed / wheelHeight)
	end
end


--Constants
local SIG_STATE = 1
local SIG_AIM = 2
local SIG_PINNED = 4
local SIG_FIRE = 8
local SIG_RESTORE = 14
local SIG_MOVE = 16
local SIG_FEAR = 32
local SIG_ANIM = 128

local STOP_AIM_DELAY = 2000
local STAND_DELAY    = 5000
local DEFAULT_TURN_SPEED = math.rad(300)
local REAIM_THRESHOLD = 0.15

local CRAWL_SLOWDOWN_FACTOR = 5

local FEAR_LIMIT = 25
local FEAR_PINNED = 20

local FEAR_INITIAL_SLEEP = 5000
local FEAR_SLEEP = 1000

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
local lastShot

-- OTHER
local fear
local weaponEnabled = {}
local usesAmmo = info.usesAmmo

--localisations
local random = math.random
local push = table.insert
local abs = math.abs
local min = math.min
local PI = math.pi
local TAU = 2 * PI

-- if no weaponswithammo then do not check - solves commando problem
if UnitDef.customParams.weaponswithammo and UnitDef.customParams.weaponswithammo == '0' then
	usesAmmo = false
end

local function GetNewPoseID(poseName)
	--Spring.Echo("looking for " .. poseName)
	if poseName == currentPoseName then
		return currentPoseID
	end
	local variants = poseVariants[poseName]
	if not variants then
		Spring.Log("infantry script", "error", "no variants for pose: " .. poseName .. " " .. UnitDef.name, unitID)
	end
	return variants[random(#variants)]
end

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

local function ChangePose(transition, nextPoseID, nextPoseName)
	--Spring.Echo("start transition")
	SetSignalMask(0)
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
			local ceg = info.weaponCEGs[lastShot]
			if ceg then
				local cegPiece = info.cegPieces[lastShot]
				if cegPiece then
					GG.EmitSfxName(unitID, cegPiece, ceg)
				end
			end
		end
	end
	--Spring.Echo("done transition")
	currentPoseID = nextPoseID
	currentPoseName = nextPoseName
end

function PickPose(name)

	local nextPoseID = GetNewPoseID(name)
	if not currentPoseID or force then
		--Spring.Echo("warp", name)
		currentPoseID = nextPoseID
		currentPoseName = name
		local pose = poses[currentPoseID]
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
		--Spring.Echo("PickPose else", name)
		local transition
		
		-- do not attempt to change for morphing units
		if firing and Spring.GetUnitRulesParam(unitID, 'movectrl') ~= 1 then
			if fireTransitions[currentPoseID] and fireTransitions[currentPoseID][nextPoseID] then
				transition = fireTransitions[currentPoseID][nextPoseID]
			else
				Spring.Log("infantry script", "error", "no fire transition change possible: " .. currentPoseName .. " " .. name .. " " .. UnitDef.name, unitID)
				return false
			end
		end
		if not transition then
			transition = transitions[currentPoseID][nextPoseID]
		end
		if not transition then
			-- prevent error spam for transitions to the same pose
			if currentPoseName ~= name then
				Spring.Log("infantry script", "error", "no change possible: " .. currentPoseName .. " " .. name .. " " .. UnitDef.name, unitID)
			end
			return false
		end

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
	local headingPiece, headingAxis, pitchPiece, pitchAxis
	if headingTurn then
		local p, axis, target, mul = unpack(headingTurn)
		Turn(p, axis, target + mul * newHeading, DEFAULT_TURN_SPEED)
		headingPiece, headingAxis = p, axis
	end
	if pitchTurn then
		local p, axis, target, mul = unpack(pitchTurn)
		Turn(p, axis, target + mul * newPitch, DEFAULT_TURN_SPEED)
		pitchPiece, pitchAxis = p, axis
	end
	if headingTurn then
		WaitForTurn(headingPiece, headingAxis)
	end
	if pitchTurn then
		WaitForTurn(pitchPiece, pitchAxis)
	end
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
	local speedMult = 1.0
	if pinned or (firing and not (standing and moving and weaponsTags[aiming].canRunFire)) then
		speedMult = 0
	elseif not standing then
		speedMult = 1 / CRAWL_SLOWDOWN_FACTOR
	end
	-- change for unified speed adjustement
	SetUnitRulesParam(unitID, "fear_movement", speedMult)
	GG.ApplySpeedChanges(unitID)

	if UnitDef.isBuilder then
		local origBuildSpeed = UnitDef.buildSpeed
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
		Signal(SIG_STATE)
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
		Spring.SetUnitCOBValue(unitID, COB.ARMORED, newStanding and 0 or 1)
		if newBuilding then
			Spring.SetUnitCOBValue(unitID, COB.INBUILDSTANCE, 1)
		elseif not wantedBuilding then
			-- Fix https://github.com/spring1944/spring1944/issues/200
			comm = Spring.GetUnitCommands(unitID, 1)[1]
			if not comm or comm.id ~= CMD.RECLAIM then
				Spring.SetUnitCOBValue(unitID, COB.INBUILDSTANCE, 0)
			end
		end
		standing = newStanding
		aiming = newAiming

		-- for wheeled models - heavy inf weapons can have wheels
		if hasWheels then
			if newMoving then
				StartThread(SpinWheels)
			else
				StartThread(StopWheels)
			end
		end

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

local function NextPose()
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

	Spring.Log("infantry script", "error", "shouldn't reach here")
	Sleep(33)
end

local function ResolvePose(isFire)
	SetSignalMask(0)
	--Spring.Echo("trying to change")
	if inTransition then return false end
	if isFire then
		UpdateTargetState()
		inTransition = true
		NextPose()
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
			-- just comment this out
			--Spring.Log("infantry script", "error", "animation error")
		end
	end
	--Spring.Echo("ending transition")
	inTransition = false
end

local function StopAiming()
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

local function StartAiming(weaponNum)
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
	-- Spring.Echo("started building")
	wantedBuilding = true
	StartThread(ResolvePose)
end

local function StopBuilding()
	-- Spring.Echo("stopped building")
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
	UpdatePose(standing, aiming, moving, pinned, building)
	for i=1,#weaponsMap do
		weaponEnabled[i] = true
	end
	UpdateSpeed()
	-- Fix https://github.com/spring1944/spring1944/issues/200
	if UnitDef.isBuilder then
		StartThread(fixReclaim)
	end
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
	local weaponClass = weaponsMap[num]
	local tags = weaponsTags[weaponClass]
	return tags.flare or flare
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

local function CanAim(weaponClass)
	return aiming == weaponClass and not inTransition
end

function script.AimWeapon(num, heading, pitch)
	if wantedAiming and weaponsPriorities[wantedAiming] > num then
		return false
	end
	if not weaponEnabled[num] then
		return false
	end
	if firing then
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
	if CanAim(weaponClass) then return ReAim(heading, pitch) end
	StartAiming(weaponClass)
	return false
end

function script.BlockShot(num, targetUnitID, userTarget)
	local weaponClass = weaponsMap[num]
	if usesAmmo then
		local ammo = Spring.GetUnitRulesParam(unitID, 'ammo')
		if ammo <= 0 then
			return true
		end
	end

	return not (CanAim(weaponClass) and IsLoaded(weaponClass) and weaponEnabled[num])
end

function script.FireWeapon(num)
	firing = true

	-- tell the cloak gadget we fired so we should not be cloaked
	local f, _ = GetGameFrame() -- this is not a single number...
	SetUnitRulesParam(unitID, 'decloak_activity_frame', f)

	if usesAmmo then
		local currentAmmo = Spring.GetUnitRulesParam(unitID, 'ammo')
		SetUnitRulesParam(unitID, 'ammo', currentAmmo - 1)
	end
	UpdateSpeed()
end

function script.Shot(num)
	local weaponClass = weaponsMap[num]
	local tags = weaponsTags[weaponClass]
	lastShot = num
	if not tags.aimOnLoaded then
		StartThread(ResolvePose, true)
	end
	if customAnims and customAnims.postShot then
		customAnims.postShot(num)
	end
end

function script.EndBurst(num)
	Signal(SIG_FIRE)
	local weaponClass = weaponsMap[num]
	local tags = weaponsTags[weaponClass]
	if tags.aimOnLoaded and wantedAiming == aiming then
		StopAiming()
		StartThread(ResolvePose, true)
	else
		StartThread(Delay, StopAiming, STOP_AIM_DELAY, SIG_RESTORE)
	end
	firing = false
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
	SetUnitRulesParam(unitID, "fear", 0)
	StopPinned()
	Stand()
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
	Drop()
	SetUnitRulesParam(unitID, "fear", fear)
end

function ToggleWeapon(num, isEnabled)
	weaponEnabled[num] = isEnabled
end

if UnitDef.isBuilder then
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

	function fixReclaim()
		while true do
			local comm = Spring.GetUnitCommands(unitID, 1)[1]
			if not comm or comm.id ~= CMD.RECLAIM then
				-- We already finished reclaiming things
				if not wantedBuilding then
					Spring.SetUnitCOBValue(unitID, COB.INBUILDSTANCE, 0)
				end
			else
				Spring.SetUnitCOBValue(unitID, COB.INBUILDSTANCE, 1)
			end
			Sleep(150)
		end
	end
end

if UnitDef.customParams.canclearmines then

	function StartClearMines(blowFunc, blowDelay)
		if CanAim("engineer") then
			StartThread(Delay, blowFunc, blowDelay, SIG_STATE, unitID)
			StartThread(Delay, StopAiming, blowDelay, 0)
			return true
		end
		StartAiming("engineer")
		return false
	end

	function IsClearing()
		return CanAim("engineer")
	end

	function StopClearMines()
		if CanAim("engineer") then
			StopAiming()
		end
	end
end

