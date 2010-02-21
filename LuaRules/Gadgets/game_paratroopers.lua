function gadget:GetInfo()
  return {
    name      = "Spring: 1944 Paratroopers",
    desc      = "Spawns paratroopers.",
    author    = "Evil4Zerggin",
    date      = "31 July 2008",
    license   = "GNU LGPL, v2.1 or later",
    layer     = -5,
    enabled   = true  --  loaded by default?
  }
end

if not gadgetHandler:IsSyncedCode() then return end

local windFactor = 0.1
local drag = 0.06
local relVelHoriz = 0.25
local relVelVert = 1
local INF_WATER_LEVEL = -5

local paratrooperWeaponDefIDs = {}

--transportID = paratrooper number
local transports = {}

local paratroopers = {}

--transportDefID = list of paratroopers
local transportInfos = {}

local random = math.random

local mcEnable = Spring.MoveCtrl.Enable
local mcDisable = Spring.MoveCtrl.Disable
local mcSetPosition = Spring.MoveCtrl.SetPosition
local mcSetGravity = Spring.MoveCtrl.SetGravity
local mcSetWindFactor = Spring.MoveCtrl.SetWindFactor
local mcSetDrag = Spring.MoveCtrl.SetDrag
local mcSetTrackGround = Spring.MoveCtrl.SetTrackGround
local mcSetCollideStop = Spring.MoveCtrl.SetCollideStop
local mcSetVelocity = Spring.MoveCtrl.SetVelocity
local mcSetRelativeVelocity = Spring.MoveCtrl.SetRelativeVelocity

local uReplaceUnit = GG.Util.ReplaceUnit

local CreateUnit = Spring.CreateUnit
local DestroyUnit = Spring.DestroyUnit
local ValidUnitID = Spring.ValidUnitID
local GetUnitDefID = Spring.GetUnitDefID

local GetUnitTeam = Spring.GetUnitTeam
local CallCOBScript = Spring.CallCOBScript

local GetUnitVelocity = Spring.GetUnitVelocity
local GetUnitPosition = Spring.GetUnitPosition

do
  local paratrooperInclude = VFS.Include("LuaRules/Configs/paratrooper_defs.lua")
  for transportname, info in pairs(paratrooperInclude) do
    local transportDefID = UnitDefNames[transportname].id
    transportInfos[transportDefID] = info
  end
end

function gadget:Initialize()
  local SetWatchWeapon = Script.SetWatchWeapon

  for WeaponDefID = 1, #WeaponDefs do
    local weaponDef = WeaponDefs[WeaponDefID]
    if weaponDef.customParams.paratrooper then
      SetWatchWeapon(WeaponDefID, true)
      paratrooperWeaponDefIDs[WeaponDefID] = true
    end
  end
end

function gadget:Explosion(weaponDefID, px, py, pz, ownerID)
  if paratrooperWeaponDefIDs[weaponDefID] and ValidUnitID(ownerID) then
    local transportDefID = GetUnitDefID(ownerID)
    local transportInfo = transportInfos[transportDefID]
    
    local paratrooperNumber = (transports[ownerID] or 0) + 1
    if paratrooperNumber > #transportInfo then
      paratrooperNumber = 1
    end
    
    transports[ownerID] = paratrooperNumber
    local paratrooperInfo = transportInfo[paratrooperNumber]
    
    local ux, uy, uz = GetUnitPosition(ownerID)
    local vx, vy, vz = GetUnitVelocity(ownerID)
    local teamID = GetUnitTeam(ownerID)
    local unitID = CreateUnit(paratrooperInfo[1], ux, uy, uz, 0, teamID)
    mcEnable(unitID)
    mcSetPosition(unitID, ux, uy - 16, uz)
    mcSetVelocity(unitID, vx, vy, vz)
    mcSetGravity(unitID, 1)
    mcSetWindFactor(unitID, windFactor)
    mcSetDrag(unitID, drag)
    mcSetTrackGround(unitID, true)
    mcSetCollideStop(unitID, true)
    --CallCOBScript(unitID, "Falling", 0, 0)
    
    local vx = (random() - 0.5) * relVelHoriz
    local vy = (random() - 0.5) * relVelVert
    local vz = (random() - 0.5) * relVelHoriz
    mcSetRelativeVelocity(unitID, vx, vy, vz)
    
    paratroopers[unitID] = paratrooperInfo
  end
  
  return false
end

function gadget:UnitDestroyed(unitID, unitDefID, teamID)
  --CallCOBScript(unitID, "Landed", 0, 0)
  transports[unitID] = nil
  paratroopers[unitID] = nil
end

function gadget:MoveCtrlNotify(unitID, unitDefID, unitTeam, data)
  local paratrooperInfo = paratroopers[unitID]
  if not paratrooperInfo then return false end
  local x, y, z = GetUnitPosition(unitID)
  if y > INF_WATER_LEVEL then
	uReplaceUnit(unitID, paratrooperInfo[2], unitTeam)
  else
	DestroyUnit(unitID)
  end
  return true
end
