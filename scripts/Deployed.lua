-- pieces
local flare = piece "flare"

local barrel = piece "barrel"

local tubes = piece "tubes"

local brakeleft = piece "brakeleft"
local brakeright = piece "brakeright"

local carriage = piece "carriage"

local turret = piece "turret"
local sleeve = piece "sleeve"

-- for some guns there are hydraulic cylinders, usually 2
local cylinder1 = piece "cylinder1"
local cylinder2 = piece "cylinder2"

local cylinder1inverse = 1
local cylinder2inverse = 1

if UnitDef.customparams then
	if UnitDef.customparams.guncylinderinverse1 then
		cylinder1inverse = -1
	end
	if UnitDef.customparams.guncylinderinverse2 then
		cylinder2inverse = -1
	end
end

local info = GG.lusHelper[unitDefID]

if not info.animation then
	include "DeployedLoader.lua"
end
local customAnims = info.customAnims
local poses, transitions, fireTransitions, weaponTags = unpack(info.animation)

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

local FEAR_LIMIT = weaponTags.fearLimit or 25
local FEAR_PINNED = weaponTags.fearPinned or 2

local FEAR_INITIAL_SLEEP = 5000
local FEAR_SLEEP = 1000

local RECOIL_DELAY = 198

local VISIBLE_PERIOD = 5000


--CURRENT UNIT STATE
local pinned
local firing

--UNIT WANTED STATE
local wantedPinned

--POSE VARS
local inTransition
local currentPoseName

-- AIMING VARS
local currentPitch
local currentHeading
local wantedPitch
local wantedHeading

-- OTHER

local turretTurnSpeed
local turretElevateSpeed
local recoilDistance = 2.4
local recoilReturnSpeed = 10

local fear
local lastRocket
local weaponEnabled = {}
local usesAmmo = info.usesAmmo


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
	Turn(weaponTags.headingPiece, y_axis, newHeading, info.turretTurnSpeed)
	Turn(weaponTags.pitchPiece, x_axis, -newPitch, info.elevationSpeed)

	if cylinder2 then
		Turn(cylinder2, x_axis, newPitch * cylinder2inverse, info.elevationSpeed)
	end

	WaitForTurn(weaponTags.headingPiece, y_axis)
	WaitForTurn(weaponTags.pitchPiece, x_axis)

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
		Spring.SetUnitCOBValue(unitID, COB.ARMORED, newPinned and 1 or 0)
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
			Spring.Log("deployed script", "error", "animation error")
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
	firing = false
	UpdatePose(pinned)
	--weaponEnabled[1] = true
	for i=1,info.numWeapons do
		weaponEnabled[i] = true
	end
	if info.numRockets > 0 then
		lastRocket = info.numRockets
	end
	if UnitDef.stealth then
		Spring.SetUnitStealth(unitID, true)
	end
	-- turn AA barrel up
	if UnitDef.customParams.scriptanimation == "aa" then
		Turn(weaponTags.headingPiece, y_axis, 0, info.turretTurnSpeed)
		Turn(weaponTags.pitchPiece, x_axis, -70, info.elevationSpeed)
		WaitForTurn(weaponTags.headingPiece, y_axis)
		WaitForTurn(weaponTags.pitchPiece, x_axis)
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


function script.QueryWeapon(weaponNum)
	if lastRocket then
		return piece("rocket" .. lastRocket) or tubes
	end

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
	return not (inTransition or pinned)
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
	if usesAmmo then
		local currentAmmo = Spring.GetUnitRulesParam(unitID, 'ammo')
		Spring.SetUnitRulesParam(unitID, 'ammo', currentAmmo - 1)
	end
	if UnitDef.stealth then
		Spring.SetUnitStealth(unitID, false)
	end
	local explodeRange = info.explodeRanges[weaponNum]
	if explodeRange then
		Spring.SetUnitWeaponState(unitID, weaponNum, "range", explodeRange)
	end
end

function script.Shot(weaponNum)
	if barrel then
		StartThread(Recoil)
	end
	if lastRocket then
		lastRocket = lastRocket % info.numRockets + 1
		Hide(piece("rocket" .. lastRocket))
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
	if customAnims and customAnims.postShot then
		customAnims.postShot(weaponNum)
	end
end

function script.EndBurst(weaponNum)
	Signal(SIG_FIRE)
	StartThread(ResolvePose, true)
	firing = false
	if UnitDef.stealth then
		StartThread(Delay, Spring.SetUnitStealth, VISIBLE_PERIOD, 0, unitID, true)
	end
end

function script.TargetWeight(weaponNum, targetUnitID)
	return GG.lusHelper.standardTargetWeight(unitID, unitDefID, weaponNum, targetUnitID)
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
	Spring.SetUnitRulesParam(unitID, "fear", 0)
	StopPinned()
end

local function RecoverFear()
	Signal(SIG_FEAR)
	SetSignalMask(SIG_FEAR)
	while fear > 0 do
		--Spring.Echo("Lowered fear", fear)
		fear = fear - 1
		Spring.SetUnitRulesParam(unitID, "fear", fear)
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
	Spring.SetUnitRulesParam(unitID, "fear", fear)
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
