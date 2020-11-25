local info = GG.lusHelper[unitDefID]

if not info.animation then
    include "GunLoader.lua"
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
local GetCrewPosition = include "crew/crew_transporter.lua"

--Localisations
local PI = math.pi
local TAU = 2 * PI
local abs = math.abs
local random = math.random
local SetUnitRulesParam = Spring.SetUnitRulesParam
local AttachUnit = Spring.UnitScript.AttachUnit
local DropUnit = Spring.UnitScript.DropUnit
local SetUnitNoDraw = Spring.SetUnitNoDraw
local GetUnitRulesParam = Spring.GetUnitRulesParam

--Constants
local SIG_AIM = 1
local SIG_FIRE = 2
local SIG_MOVE = 4
local SIG_ANIM = 16

local DEFAULT_TURN_SPEED = math.rad(300)
local REAIM_THRESHOLD = 0.15

local FEAR_PINNED = 20  -- Copy from Infantry.lua

local RECOIL_DELAY = 198

local WHEEL_CHECK_DELAY = 990
local WHEEL_ACCELERATION_FACTOR = 3

local GAIA_TEAM_ID = Spring.GetGaiaTeamID()
local usesAmmo = info.usesAmmo

-- STATUS
local passengers = 0
local passengersIDs = {}
local weaponEnabled = {}
local moving = false
local pinned = false


local function Delay(func, duration, mask, ...)
    --Spring.Echo("wait", duration)
    SetSignalMask(mask)
    Sleep(duration)
    func(...)
end


local function UpdateSpeed()
    local speedMult = 1.0
    if pinned then
        speedMult = 0
    end
    SetUnitRulesParam(unitID, "fear_movement", speedMult)
    -- GG.ApplySpeedChanges(unitID)  -- UpdateCrew is doing that
end


local function UpdateCrew()
    while true do
        if passengers == 0 then
            Spring.SetUnitNeutral(unitID, true)
        else
            Spring.SetUnitNeutral(unitID, false)
            -- Make the unit non-capturable until the crew has not been killed
            Spring.SetUnitHealth(unitID, {capture = 0})
        end
        if UnitDef.transportCapacity > passengers then
            SetUnitRulesParam(unitID, "immobilized", 1)
            for i=1,info.numWeapons do
                weaponEnabled[i] = false
            end
        else
            SetUnitRulesParam(unitID, "immobilized", 0)
            -- The gun is functional, but depending on whether the crew members
            -- are pinned or not, it might be unable to move or fire
            pinned = false
            for _,paxID in pairs(passengersIDs) do
                if GetUnitRulesParam(paxID, "fear") >= FEAR_PINNED then
                    pinned = true
                    break
                end
            end
            UpdateSpeed()
            for i=1,info.numWeapons do
                weaponEnabled[i] = not pinned
            end
        end

        GG.ApplySpeedChanges(unitID)
        Sleep(33)
    end
end


local function ReAim(newHeading, newPitch)
    -- Check we have crew enough to handle the Gun
    if UnitDef.transportCapacity > passengers then
        return false
    end

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

    if UnitDef.stealth then
        Spring.SetUnitStealth(unitID, true)
    end

    turretTraverseSpeed = UnitDef.customParams.turretTraverseSpeed or weaponTags.defaultTraverseSpeed
    turretElevateSpeed = UnitDef.customParams.turretElevateSpeed or weaponTags.defaultElevateSpeed

    for i=1,info.numWeapons do
        weaponEnabled[i] = true
    end
    StartThread(UpdateCrew)
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

local function StopWheels()
    for wheelPiece, speed in pairs(info.wheelSpeeds) do
        StopSpin(wheelPiece, x_axis, speed / WHEEL_ACCELERATION_FACTOR)
    end
end

function script.StartMoving()
    Signal(SIG_MOVE)
    moving = true

    -- Wheels
    StartThread(SpinWheels)
    -- Crew
    for _, crewID in pairs(passengersIDs) do
        local env = Spring.UnitScript.GetScriptEnv(crewID)
        Spring.UnitScript.CallAsUnit(crewID, env.script.StartMoving)
    end
end

function script.StopMoving()
    Signal(SIG_MOVE)
    moving = false

    -- Wheels
    StopWheels()
    -- Crew
    for _, crewID in pairs(passengersIDs) do
        local env = Spring.UnitScript.GetScriptEnv(crewID)
        Spring.UnitScript.CallAsUnit(crewID, env.script.StopMoving)
    end
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
    return UnitDef.transportCapacity == passengers and not (moving or pinned)
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

function ToggleWeapon(num, isEnabled)
    weaponEnabled[num] = isEnabled
end

function script.TransportPickup(passengerID)
    -- Add the pax to the first available slot
    passengers = passengers + 1
    local i = 0
    while true do
        i = i + 1
        if passengersIDs[i] == nil then
            passengersIDs[i] = passengerID
            break
        end
    end
    -- Attach the unit to the found slot
    local p = GetCrewPosition(i)
    AttachUnit(p, passengerID)
    Spring.SetUnitNoMinimap(passengerID, true)
    if p == -1 then
        SetUnitNoDraw(passengerID, true)
    end
end

-- note x, y z is in worldspace
function script.TransportDrop(passengerID, x, y, z)
    -- Remove the pax from the stored list
    passengers = passengers - 1
    local i, pax
    for i,pax in pairs(passengersIDs) do
        if pax == passengerID then
            passengersIDs[i] = nil
            break
        end
    end
    -- Drop the unit
    Spring.UnitScript.DropUnit(passengerID)
    Spring.GiveOrderToUnit(passengerID, CMD.MOVE, {x,y,z}, {})
    -- Ensure the unit is visible again
    SetUnitNoDraw(passengerID, false)
    Spring.SetUnitNoMinimap(passengerID, false)
end
