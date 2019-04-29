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
local AttachUnit = Spring.UnitScript.AttachUnit
local DropUnit = Spring.UnitScript.DropUnit


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

local GAIA_TEAM_ID = Spring.GetGaiaTeamID()

-- STATUS
local passengers = 0
local weaponEnabled = {}


local function Delay(func, duration, mask, ...)
    --Spring.Echo("wait", duration)
    SetSignalMask(mask)
    Sleep(duration)
    func(...)
end


local function UpdateCrew()
    while true do
        local h, mh, p, cap, b = Spring.GetUnitHealth(unitID)
        if passengers > 0 then
            -- Assist restoring the capture state
            local h, mh, p, cap, b = Spring.GetUnitHealth(unitID)
            Spring.SetUnitHealth(unitID, {capture = cap - 0.01 * passengers})
        end
        if UnitDef.transportCapacity > passengers then
            SetUnitRulesParam(unitID, "immobilized", 1)
            for i=1,info.numWeapons do
                weaponEnabled[i] = false
            end
        else
            SetUnitRulesParam(unitID, "immobilized", 0)
            for i=1,info.numWeapons do
                weaponEnabled[i] = true
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
    return UnitDef.transportCapacity == passengers
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
    local mass = UnitDefs[Spring.GetUnitDefID(passengerID)].mass
    AttachUnit(-1, passengerID)
    passengers = passengers + 1
end

-- note x, y z is in worldspace
function script.TransportDrop(passengerID, x, y, z)
    DropUnit(passengerID)
    passengers = passengers - 1
end
