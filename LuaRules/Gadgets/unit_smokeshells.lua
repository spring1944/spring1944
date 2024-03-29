function gadget:GetInfo()
  return {
    name      = "Smoke shells and generators",
    desc      = "Implements smoke screens from artillery strikes",
    author    = "yuritch",
    date      = "14 September 2009",
    license   = "GNU LGPL, v2.1 or later",
    layer     = 100,
    enabled   = true  --  loaded by default?
  }
end
-- Mindecloakdistance under smoke
-- default sniper has 220, let's make this a bit worse
local Mindecloakdist = 250
local CLOAK_TIMEOUT = 128
-- how often to check units
local UPDATE_PERIOD = 32
local UPDATE_OFFSET = 5
local VFX_SMOKE_PERIOD = 16
local VFX_SMOKE_OFFSET = 1

-- how long a smoke generator takes to recharge
local DEFAULT_SMOKEGEN_COOLDOWN = 15

--windspeed is divided by this number before affecting smoke
local WIND_SPEED_MULT = 1.0 / 64.0

-- effect on accuracy of smoked units
local ACCURACY_MULT = 10

-- localize functions
local GetUnitSensorRadius = Spring.GetUnitSensorRadius
local SetUnitSensorRadius = Spring.SetUnitSensorRadius
local SetUnitCloak = Spring.SetUnitCloak
local GetUnitDefID = Spring.GetUnitDefID
local GetUnitsInSphere = Spring.GetUnitsInSphere
local GetWind = Spring.GetWind
local SetUnitWeaponState = Spring.SetUnitWeaponState
local SetUnitRulesParam = Spring.SetUnitRulesParam
local InsertUnitCmdDesc = Spring.InsertUnitCmdDesc
local FindUnitCmdDesc = Spring.FindUnitCmdDesc
local EditUnitCmdDesc = Spring.EditUnitCmdDesc

if gadgetHandler:IsSyncedCode() then
--------------------------------------------------------------------------------
--- SYNCED
--------------------------------------------------------------------------------

local SMOKE_WEAPON = 2 -- WARNING! Assume all smoke weapons will be in this slot
local CMD_SMOKEGEN = GG.CustomCommands.GetCmdID("CMD_SMOKEGEN")

local smokeGenCmdDesc = {
    id       = CMD_SMOKEGEN,
    type     = CMDTYPE.ICON,
    name     = "Smoke Screen",
    action   = "smokegen",
    tooltip  = 'Activate Smoke generator',
    hidden   = false,
    disabled = false,
}

local SmokeSources={}
local SmokedUnits={}

local SmokeGenCooldowns = {}

local DURATION_MULT = 1
local modOptions = Spring.GetModOptions()
if modOptions and modOptions.smoke_mult then
    DURATION_MULT = modOptions.smoke_mult
end

function gadget:Initialize()
    for weaponId, weaponDef in pairs (WeaponDefs) do
        if weaponDef.customParams.smokeradius then
            Script.SetWatchWeapon(weaponId, true)
        end
    end
    
    local allUnits = Spring.GetAllUnits()
    for i=1,#allUnits do
        local unitID = allUnits[i]
        gadget:UnitCreated(unitID, Spring.GetUnitDefID(unitID))
    end
end

function gadget:UnitCreated(unitID, unitDefID, teamID)
    -- smoke generator
    local params = UnitDefs[unitDefID].customParams
    if params then
        if params.smokegenerator then
            InsertUnitCmdDesc(unitID, smokeGenCmdDesc)
        end
    end
end

function gadget:UnitDestroyed(unitID, unitDefID, teamID)
    -- remove units from tracking if they die
    SmokedUnits[unitID] = nil
    SmokeGenCooldowns[unitID] = nil
end

function ChangeSmokeGenStatus(unitID, smokeGenEnabled)
    local cmdDescID = FindUnitCmdDesc(unitID, CMD_SMOKEGEN)
    if cmdDescID then
        local disabledSmokeCmd = {}
        for k,v in pairs(smokeGenCmdDesc) do
            disabledSmokeCmd[k] = v
        end
        disabledSmokeCmd.disabled = not smokeGenEnabled
        EditUnitCmdDesc(unitID, cmdDescID, disabledSmokeCmd)
    end
end

function ApplySmoke(unitID)
    local oldSight = GetUnitSensorRadius(unitID, "los")
    local oldRadar = GetUnitSensorRadius(unitID, "radar")
    local oldAirLos = GetUnitSensorRadius(unitID, "airLos")
    local oldSeismic = GetUnitSensorRadius(unitID, "seismic")

    -- On first round oldLos = 0, check that to avoid overwriting it in later rounds
    if oldSight > 0 and SmokedUnits[unitID].oldLos == 0 then
        SmokedUnits[unitID].oldLos = oldSight
    end
    if oldRadar > 0 then
        SmokedUnits[unitID].oldRadar = oldRadar
    end
    if oldAirLos and oldAirLos > 0 then
        SmokedUnits[unitID].oldAirLos = oldAirLos
    end
    if oldSeismic and oldSeismic > 0 then
        SmokedUnits[unitID].oldSeismic = oldSeismic
    end

    SetUnitRulesParam(unitID, "smoked", 1)
    -- make the unit blind
    SetUnitSensorRadius(unitID, "los", 180)
    SetUnitSensorRadius(unitID, "radar", 0)
    SetUnitSensorRadius(unitID, "airLos", 0)
    SetUnitSensorRadius(unitID, "seismic", 0)

    -- hide the unit
    local tmpUDID = GetUnitDefID(unitID)
    if tmpUDID then
        if UnitDefs[tmpUDID].canCloak then
            SetUnitCloak(unitID, 2)
            else
            SetUnitCloak(unitID, 2, Mindecloakdist)
            Spring.SetUnitRulesParam(unitID, 'mindecloakdist', Mindecloakdist)
        end
        Spring.SetUnitRulesParam(unitID, 'decloak_activity_frame', Spring.GetGameFrame())
    end
    --SetUnitCloak(unitID, true) this is redundant, I'm pretty sure.
    Spring.SetUnitStealth(unitID, true)
    -- affect the weapons
    local tmpUDID = GetUnitDefID(unitID)
    if tmpUDID then
        local tmpWeapons = UnitDefs[tmpUDID].weapons
        for i, tmpWeapon in pairs(tmpWeapons) do
            if (tmpWeapon) and (type(tmpWeapon) == "table") then
                local tmpAccuracy = WeaponDefs[tmpWeapon.weaponDef].accuracy
                tmpAccuracy = tmpAccuracy * ACCURACY_MULT
                SetUnitWeaponState(unitID, i, {accuracy = tmpAccuracy})
            end
        end
    end
    SmokedUnits[unitID].smokeApplied = true
end

function RemoveSmoke(unitID)
    -- find out the 'default' los value for that unittype
    local defaultLos = SmokedUnits[unitID].oldLos
    local defaultRadar = SmokedUnits[unitID].oldRadar
    local defaultAirLos = SmokedUnits[unitID].oldAirLos
    local defaultSeismic = SmokedUnits[unitID].oldSeismic
    local defaultMincloak = SmokedUnits[unitID].oldMincloak

    SetUnitRulesParam(unitID, "smoked", 0)
    -- Set sensor values back to unit defaults
    -- airLos seems to also set los in current engine (104.0.1). That's why airLos has to be set first.
    SetUnitSensorRadius(unitID, "airLos", defaultAirLos)
    SetUnitSensorRadius(unitID, "los", defaultLos)
    SetUnitSensorRadius(unitID, "radar", defaultRadar)
    SetUnitSensorRadius(unitID, "seismic", defaultSeismic)

    -- unhide the unit
    --SetUnitCloak(unitID, 1)
    -- and make it cloak/stealth by its own if it can
    local tmpUDID = GetUnitDefID(unitID)
    if tmpUDID then
        if UnitDefs[tmpUDID].canCloak then
            SetUnitCloak(unitID, true)
        else
            SetUnitCloak(unitID, false)
        end
        if UnitDefs[tmpUDID].stealth then
            Spring.SetUnitStealth(unitID, true)
        else
            Spring.SetUnitStealth(unitID, false)
        end
        
        -- also restore it's weapon accuracy
        local tmpWeapons = UnitDefs[tmpUDID].weapons
        for i, tmpWeapon in pairs(tmpWeapons) do
            if (tmpWeapon) and (type(tmpWeapon) == "table") then
                local tmpAccuracy = WeaponDefs[tmpWeapon.weaponDef].accuracy
                SetUnitWeaponState(unitID, i, {accuracy = tmpAccuracy})
            end
        end
    end
    SmokedUnits[unitID].smokeApplied = false
end

local lastCloaked = {}
local lastDecloaked = {}
-- AllowUnitCloak(unitID, enemyID) -> return cloakStatus
-- enemyID is nil if there is no unit within minCloakDistance
-- called every SlowUpdate to check if you want to stay cloaked
function gadget:AllowUnitCloak(unitID, enemyID)
    --Spring.Echo("AllowUnitCloak", enemyID)
    if SmokedUnits[unitID] then
        local checkID = Spring.GetUnitNearestEnemy(unitID, 5000, false)
        local separation = checkID and Spring.GetUnitSeparation(unitID, checkID) or "no enemy"
        local name = UnitDefs[Spring.GetUnitDefID(unitID)].name
        --Spring.Echo("SmokedUnit", name, unitID, enemyID, checkID, separation, SmokedUnits[unitID].underSmoke, Spring.GetUnitRulesParam(unitID, 'mindecloakdist'))
    end
    local n = Spring.GetGameFrame()
    local canCloak = (enemyID == nil) and (((lastDecloaked[unitID] or 0) + CLOAK_TIMEOUT) < n)
    if canCloak then 
        lastCloaked[unitID] = n 
    end
    --Spring.Echo(unitID, enemyID, "I last cloaked in frame", lastCloaked[unitID], lastDecloaked[unitID], canCloak)
    return canCloak
end

-- AllowUnitDecloak(unitID, objectID, weaponID) -> return allowToDecloak
-- called when building or firing
-- also every SlowUpdate if already cloaked?
function gadget:AllowUnitDecloak(unitID, objectID, weaponID)
    --Spring.Echo("AllowUnitDecloak", unitID, objectID, weaponID)
    lastDecloaked[unitID] = Spring.GetGameFrame()
    return true
end

local function AddSmoke(x, y, z, params)
    local size = tonumber(params.smokeradius) or 0
    local duration = tonumber(params.smokeduration) or 0
    if size == 0 or duration == 0 then
        return
    end

    duration = duration * DURATION_MULT * 32

    local tmpSmoke =
    {
        radius = size,
        remainingTimer = duration,
        x = x,
        y = y,
        z = z,
    }
    table.insert(SmokeSources, tmpSmoke)

    SendToUnsynced("lups_smoke", x, y, z, size, duration * DURATION_MULT * 32)
end

function gadget:AllowCommand(unitID, unitDefID, teamID, cmdID, cmdParams, cmdOptions)
    if cmdID == CMD_SMOKEGEN then
        -- has our generator recharged?
        if (SmokeGenCooldowns[unitID] or 0) == 0 then
            -- start smoke generator!
            local params = UnitDefs[unitDefID].customParams
            local x, y, z = Spring.GetUnitPosition(unitID)
            AddSmoke(x, y, z, params)
            SmokeGenCooldowns[unitID] = tonumber(params.smokegencooldown or DEFAULT_SMOKEGEN_COOLDOWN)
            ChangeSmokeGenStatus(unitID, false)
        end
    end
    return true
end

function gadget:Explosion(weaponID, px, py, pz, ownerID)
    local params = WeaponDefs[weaponID].customParams
    if not params then
        return false
    end
    AddSmoke(px, py, pz, params)

    return false
end

function gadget:GameFrame(n)
    -- implement smoke decay - each frame
    for i, tmpSource in pairs(SmokeSources) do
        if tmpSource then
            tmpSource.remainingTimer = tmpSource.remainingTimer - 1
            if tmpSource.remainingTimer <= 0 then
                table.remove(SmokeSources, i)
            else
                -- wind blowing the smoke away
                local dx, dy, dz = GetWind()
                tmpSource.x = tmpSource.x + dx * WIND_SPEED_MULT
                tmpSource.z = tmpSource.z + dz * WIND_SPEED_MULT
            end
        end
    end
    -- check units in smoke - NOT each frame
    if n % UPDATE_PERIOD == UPDATE_OFFSET then
        -- mark smoked units as not smoked first (to keep track of units leaving smoked area)
        for i, tmpUnit in pairs(SmokedUnits) do
            if tmpUnit.underSmoke then
                SmokedUnits[i].underSmoke = false
            end
        end
        -- loop through all the smokes, search for units
        if #SmokeSources > 0 then
            for _, tmpSmoke in pairs(SmokeSources) do
                if tmpSmoke then
                    local unitsInSmoke = GetUnitsInSphere(tmpSmoke.x, tmpSmoke.y, tmpSmoke.z, tmpSmoke.radius)
                    if (unitsInSmoke) and (#unitsInSmoke > 0) then
                        for _, unitID in ipairs(unitsInSmoke) do
                            -- mark units for smoke effect
                            if (SmokedUnits[unitID]) then
                                SmokedUnits[unitID].underSmoke = true
                            else
                                SmokedUnits[unitID] = {underSmoke = true, oldLos = 0, oldRadar = 0,
                                    oldAirLos = 0, oldSeismic = 0}
                            end
                        end
                    end
                end
            end
        end
        -- now loop trough units again, and apply/unapply smoke effects based on marks
        for UnitID, tmpUnit in pairs(SmokedUnits) do
            if not tmpUnit.underSmoke then
                -- remove effect from unit
                RemoveSmoke(UnitID)
                -- remove unit from tracking
                SmokedUnits[UnitID] = nil
                Spring.SetUnitRulesParam(UnitID, 'decloak_activity_frame', n)
            elseif ((Spring.GetUnitRulesParam(UnitID, 'decloak_activity_frame') or 0) + CLOAK_TIMEOUT) < n then
                if not SmokedUnits[UnitID].smokeApplied then
                    -- apply effect to unit
                    GG.cloakedUnits[UnitID] = Spring.GetUnitDefID(UnitID)
                    ApplySmoke(UnitID)
                end
            end
        end
        -- process smoke generator cooldown
        for id, duration in pairs(SmokeGenCooldowns) do
            if (SmokeGenCooldowns[id] or 0) > 0 then
                SmokeGenCooldowns[id] = SmokeGenCooldowns[id] - 1
                -- enable/disable command
                local smokegenReady = true
                if SmokeGenCooldowns[id] > 0 then
                    smokegenReady = false
                end
                ChangeSmokeGenStatus(id, smokegenReady)
            end
        end
    end
end

else
--------------------------------------------------------------------------------
--- UNSYNCED
--------------------------------------------------------------------------------
local smokeFX = {
    alwaysVisible  = true,
    layer          = 1,
    speed          = 0.65,
    count          = 100,
    life           = 50,
    lifeSpread     = 20,
    delaySpread    = 900,
    rotSpeed       = 1,
    rotSpeedSpread = -2,
    rotSpread      = 360,
    size           = 30,
    sizeSpread     = 5,
    sizeGrowth     = 0.9,
    emitVector     = {0, 1, 0},
    emitRotSpread  = 60,
    partpos        = "r*sin(alpha),0,r*cos(alpha) | alpha=rand()*2*pi, r=rand()*delay/32",

    force          = {0, 0, 0},
    pos            = {0, 0, 0},
    colormap       = {
        {0.00, 0.00, 0.00, 0.00},
        {0.20, 0.20, 0.20, 0.01},
        {0.50, 0.50, 0.50, 0.10},
        {0.00, 0.00, 0.00, 0.00}
    },
    texture        = 'bitmaps/smoke/smoke01.tga',
}

local function AddSmoke(cmd, x, y, z, size, duration)
    smokeFX.pos[1], smokeFX.pos[2], smokeFX.pos[3] = x, y + 0.25 * size, z
    local wx, wy, wz = Spring.GetWind()
    smokeFX.force[1] = wx * WIND_SPEED_MULT
    smokeFX.force[2] = wy * WIND_SPEED_MULT
    smokeFX.force[3] = wz * WIND_SPEED_MULT
    smokeFX.size = 0.5 * size
    smokeFX.sizeGrowth = size / smokeFX.life
    smokeFX.partpos = "r*sin(alpha),0,r*cos(alpha) | alpha=rand()*2*pi, r=" .. tostring(0.25*size)
    smokeFX.delaySpread = duration / 32
    smokeFX.texture = "bitmaps/smoke/smoke0" .. math.random(1,9) .. ".tga"

    GG.Lups.AddParticles('SimpleParticles2', smokeFX)
end

function gadget:Initialize()
    gadgetHandler:AddSyncAction("lups_smoke", AddSmoke)
end

function gadget:Shutdown()
    gadgetHandler:RemoveSyncAction("lups_smoke")
end

end
