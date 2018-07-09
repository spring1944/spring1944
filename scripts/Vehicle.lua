local barrel = piece "barrel"
local base = piece "base"

local brakeleft = piece "brakeleft"
local brakeright = piece "brakeright"

local info = GG.lusHelper[unitDefID]

if not info.aimPieces then
	include "VehicleLoader.lua"
end

local customAnims = info.customAnims

--Localisations
local PI = math.pi
local TAU = 2 * PI
local abs = math.abs
local rad = math.rad
local atan2 = math.atan2
local SetUnitRulesParam = Spring.SetUnitRulesParam
local SetUnitCOBValue = Spring.SetUnitCOBValue

local SetUnitNoSelect = Spring.SetUnitNoSelect

local CreateUnit = Spring.CreateUnit
local AttachUnit = Spring.UnitScript.AttachUnit
local GiveOrderToUnit	= Spring.GiveOrderToUnit

-- Should be fetched from OO defs when time comes
local rockSpeedFactor = rad(50)
local rockRestoreSpeed = rad(20)

-- Aesthetics
local wheelSpeed
local currentTrack
local lastShot

local hasTrailerTracks = false

-- Logic
local usesAmmo = info.usesAmmo

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
local prioritisedWeapon
local moving
local deploying


-- Constants
local WHEEL_CHECK_DELAY = 990
local TRACK_SWAP_DELAY = 99
local STOP_AIM_DELAY = 2000

local RECOIL_DELAY = 198

local WHEEL_ACCELERATION_FACTOR = 3

local REAIM_THRESHOLD = 0.15

local exhaust_fx_name = "petrol_exhaust"
if UnitDef.customParams then
	exhaust_fx_name = UnitDef.customParams.exhaust_fx_name or exhaust_fx_name
end

-- Optional composite units stuff
local childrenPieces = info.childrenPieces
local children = info.children

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


local function RestoreTurret(weaponNum) -- called by Create so must be prior
	if info.aimPieces[weaponNum] then
		local headingPiece, pitchPiece = info.aimPieces[weaponNum][1], info.aimPieces[weaponNum][2]
		local defaultHeading = info.turretDefaultPositions[weaponNum].heading or 0
		local defaultPitch = info.turretDefaultPositions[weaponNum].pitch or 0
		if headingPiece then
			Turn(headingPiece, y_axis, defaultHeading, info.turretTurnSpeed)
		end
		if pitchPiece then
			if UnitDef.customParams.spaa then
				Turn(pitchPiece, x_axis, -70, info.elevationSpeed)
			else
				Turn(pitchPiece, x_axis, defaultPitch, info.elevationSpeed)
			end
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

local function SpawnChildren()
	local x,y,z = Spring.GetUnitPosition(unitID) -- strictly needed?
	local teamID = Spring.GetUnitTeam(unitID)
	Sleep(50)
	for i, childDefName in ipairs(children) do
		local childID = CreateUnit(childDefName, x, y, z, 0, teamID)
		if (childID ~= nil) then
			AttachUnit(childrenPieces[i], childID)
			Hide(childrenPieces[i])
			SetUnitNoSelect(childID, true)
		end
	end
end

function script.Create()
	if customAnims and customAnims.preCreate then
		customAnims.preCreate()
	end
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

	-- reliably hide all the flares
	local pieceMap = Spring.GetUnitPieceMap(unitID)
	for pieceName, pieceNum in pairs(pieceMap) do
		if pieceName:find("flare") then
			Hide(pieceNum)
		end
	end
	
	if #info.tracks > 1 then
		currentTrack = 1
		Show(info.tracks[1])
		for i = 2, #info.tracks do
			Hide(info.tracks[i])
		end
	end

	if #info.trailerTracks > 1 then
		hasTrailerTracks = true
		Show(info.trailerTracks[1])
		for i = 2, #info.trailerTracks do
			Hide(info.trailerTracks[i])
		end
	end
	
	moving = false
	deploying = false
	weaponEnabled = {}
	weaponPriorities = {}
	wantedDirection = {}

	for i = 1,info.numWeapons do
		weaponPriorities[i] = i
		weaponEnabled[i] = true
		wantedDirection[i] = {}
		if info.aimPieces[weaponNum] then
			local headingPiece, pitchPiece = info.aimPieces[weaponNum][1], info.aimPieces[weaponNum][2]

			local defaultHeading = info.turretDefaultPositions[weaponNum].heading or 0
			local defaultPitch = info.turretDefaultPositions[weaponNum].pitch or 0

			if headingPiece then
				Turn(headingPiece, y_axis, defaultHeading)
			end
			if pitchPiece then
				Turn(pitchPiece, x_axis, defaultPitch)
			end

		end
	end

	-- composite units
	if #children > 0 then
		StartThread(SpawnChildren)
	end
	
	if info.smokePieces then
		StartThread(DamageSmoke, info.smokePieces)
	end
	-- Randomly pre-position wheels
	if info.wheelSpeeds then
		local wheelSpeeds = info.wheelSpeeds
		for wheelPiece, _ in pairs(wheelSpeeds) do
			Turn(wheelPiece, x_axis, math.rad(math.random(0, 359)))
		end
	end
	if customAnims and customAnims.postCreate then
		customAnims.postCreate()
	end
	StartThread(RestoreTurret, 1) -- force elevation of guns for SPAA
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
	local trailerTracks = info.trailerTracks
	while true do
		Hide(tracks[currentTrack])
		if hasTrailerTracks then
			Hide(trailerTracks[currentTrack])
		end
		currentTrack = (currentTrack % #tracks) + 1
		Show(tracks[currentTrack])
		if hasTrailerTracks then
			Show(trailerTracks[currentTrack])
		end
		Sleep(TRACK_SWAP_DELAY)
	end
end

local function EmitDust()
	SetSignalMask(SIG_MOVE)
	local dustEmitters = info.dustTrails
	while true do
		local i
		for i = 1, #dustEmitters do
			GG.EmitSfxName(unitID, dustEmitters[i], "dustcloud_medium")
		end
		Sleep(TRACK_SWAP_DELAY * 4)
	end
end

local function StopWheels()
	for wheelPiece, speed in pairs(info.wheelSpeeds) do
		StopSpin(wheelPiece, x_axis, speed / WHEEL_ACCELERATION_FACTOR)
	end
end

function Undeploy()
	customAnims.undeploy()
	deploying = true
end

function Deploy()
	customAnims.deploy()
	deploying = true
end

function script.StartMoving()
	Signal(SIG_MOVE)
	-- Undeploy anim
	if customAnims and customAnims.undeploy then
		StartThread(Undeploy)
	end
	moving = true
	deploying = false

	if info.numWheels > 0 then
		StartThread(SpinWheels)
	end
	if #info.tracks > 1 then
		StartThread(SwapTracks)
	end
	if #info.dustTrails > 0 then
		StartThread(EmitDust)
	end
	if #info.exhausts > 0 then
		local i
		for i = 1, #info.exhausts do
			GG.EmitSfxName(unitID, info.exhausts[i], exhaust_fx_name)
		end
	end
end

function script.StopMoving()
	Signal(SIG_MOVE)
	moving = false

	StopWheels()
	-- Deploy anim
	if customAnims and customAnims.deploy then
		StartThread(Deploy)
	end
	deploying = false
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

	for weaponNum, dir in pairs(wantedDirection) do
		if info.aimPieces[weaponNum] and info.aimPieces[weaponNum][1] == headingPiece and
				(not IsMainGun(weaponNum) or Spring.GetUnitRulesParam(unitID, "ammo") > 0) and dir[1] then
			local _, isUserTarget = Spring.GetUnitWeaponTarget(unitID, weaponNum)
			if isUserTarget then --is manual target
				topDirection = dir
				prioritisedWeapon = weaponNum
				break
			end
			if weaponPriorities[weaponNum] ~= topPriority then
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



local function CanAim(weaponNum)

	--Spring.Echo("Move,Deploy,canIaim",moving,deploying,info.nomoveandfire)

	if moving == true and info.nomoveandfire == true then
		return false
	end
	if deploying == true and info.nomoveandfire == true then
		return false
	end
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
	if IsMainGun(weaponNum) then
		if usesAmmo then
			local ammo = Spring.GetUnitRulesParam(unitID, 'ammo')
			if ammo <= 0 then
				return true
			end
		end

	end

	return not (CanAim(weaponNum) and weaponEnabled[weaponNum])
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

	StartThread(Delay, StopAiming, STOP_AIM_DELAY, SIG_AIM[weaponNum], weaponNum)
	if headingPiece then
		StartThread(ResolveDirection, headingPiece, pitchPiece)
	end

	return IsAimed(weaponNum)
end

function script.FireWeapon(weaponNum)
	if IsMainGun(weaponNum) and usesAmmo then
		local currentAmmo = Spring.GetUnitRulesParam(unitID, 'ammo')
		SetUnitRulesParam(unitID, 'ammo', currentAmmo - 1)
	end
end

function script.Killed(recentDamage, maxHealth)
	local corpse = 1
	local turret = piece "turret"
	local sleeve = piece "sleeve"

	-- for composite units
	for _, child in pairs(childrenPieces) do
		Show(child)
	end
	
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
		if sleeve then
			Explode(sleeve, SFX.SHATTER)
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
	end
end

function script.EndBurst(weaponNum)
	if IsMainGun(weaponNum) then
		GG.EmitSfxName(unitID, base, "fire_dust")
	end
end

function WeaponPriority(targetID, attackerWeaponNum, attackerWeaponDefID, defPriority)
	local newPriority = defPriority
	--if prioritisedWeapon and attackerWeaponNum > prioritisedWeapon then
		local headingPiece = info.aimPieces[attackerWeaponNum] and info.aimPieces[attackerWeaponNum][1] or base
		local heading = GetHeadingToTarget(headingPiece, {targetID})
		local _, currentHeading, _ = Spring.UnitScript.GetPieceRotation(headingPiece)
		newPriority = GetAngleDiff(heading, currentHeading)
	--end
	--Spring.Echo("priority", targetID, newPriority)
	return newPriority * 100
end

function TogglePriority(weaponNum, newPriority)
	weaponPriorities[weaponNum] = newPriority
end

function ToggleWeapon(weaponNum, isEnabled)
	weaponEnabled[weaponNum] = isEnabled
end

--Builders
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
		if customAnims and customAnims.deploy then
			StartThread(Deploy)
		end
		if turret then
			Signal(SIG_BUILD)
			SetSignalMask(SIG_BUILD)
			Turn(turret, y_axis, buildHeading, DEFAULT_CRANE_TURN_SPEED)
			WaitForTurn(turret, y_axis)
		end
		SetUnitCOBValue(unitID, COB.INBUILDSTANCE, 1)
	end

	function script.StopBuilding()
		SetUnitCOBValue(unitID, COB.INBUILDSTANCE, 0)
		if customAnims and customAnims.undeploy then
			StartThread(Undeploy)
		end
		if turret then
			Signal(SIG_BUILD)
			Turn(turret, y_axis, 0, DEFAULT_CRANE_TURN_SPEED)
		end
	end
end


--Transports
if UnitDef.transportCapacity > 0 then
	local tow_point = piece "tow_point"
	local canTow = not not tow_point

	function script.TransportPickup(passengerID)
		local mass = UnitDefs[Spring.GetUnitDefID(passengerID)].mass
		if mass < 100 then --ugly check for inf gun vs. infantry.
			AttachUnit(-1, passengerID)
		elseif canTow then
			AttachUnit(tow_point, passengerID)
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

--Amphibs
if UnitDef.waterline > 0 then
	local SIG_WATER = 512 -- should be high enough
	local WATER_SPEED_DIVISOR = 3

	local wake = piece "wake"
	local inWater = false

	local function Wakes()
		Signal(SIG_WATER)
		SetSignalMask(SIG_WATER)
		while true do
			if moving then
				EmitSfx(wake, SFX.WAKE)
			end
			Sleep(165)
		end
	end

	local function UpdateSpeed()
		local speedMult = 1.0
		if inWater then
			speedMult = 1 / WATER_SPEED_DIVISOR
		end
		SetUnitRulesParam(unitID, "amphib_movement", speedMult)
		GG.ApplySpeedChanges(unitID)

	end

	function script.setSFXoccupy(curTerrainType)
		Signal(SIG_WATER)
		inWater = curTerrainType ~= 4
		if inWater then
			Spring.SetUnitLeaveTracks(unitID, false)
			SetUnitCOBValue(unitID, COB.UPRIGHT, 1)
			StartThread(Wakes)
			UpdateSpeed()
		else
			Spring.SetUnitLeaveTracks(unitID, true)
			SetUnitCOBValue(unitID, COB.UPRIGHT, 0)
			UpdateSpeed()
		end
	end
end

