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

local paratrooperWeaponDefIDs = {}

--transportID = paratrooper number
local transports = {}

local paratroopers = {}

--transportDefID = list of paratroopers
local transportInfos = {}

local mcEnable = Spring.MoveCtrl.Enable
local mcDisable = Spring.MoveCtrl.Disable
local mcSetPosition = Spring.MoveCtrl.SetPosition
local mcSetGravity = Spring.MoveCtrl.SetGravity
local mcSetWindFactor = Spring.MoveCtrl.SetWindFactor
local mcSetDrag = Spring.MoveCtrl.SetDrag
local mcSetTrackGround = Spring.MoveCtrl.SetTrackGround
local mcSetCollideStop = Spring.MoveCtrl.SetCollideStop

local CreateUnit = Spring.CreateUnit
local SetUnitPosition = Spring.SetUnitPosition
local ValidUnitID = Spring.ValidUnitID
local GetUnitDefID = Spring.GetUnitDefID
local GetUnitPosition = Spring.GetUnitPosition
local GetUnitTeam = Spring.GetUnitTeam
local CallCOBScript = Spring.CallCOBScript

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
    local paratrooperUnitname = transportInfo[paratrooperNumber]
    
    local ux, uy, uz = GetUnitPosition(ownerID)
    local teamID = GetUnitTeam(ownerID)
    local unitID = CreateUnit(paratrooperUnitname, ux, uy, uz, 0, teamID)
    mcEnable(unitID)
    mcSetPosition(unitID, ux, uy, uz)
    mcSetGravity(unitID, 1)
    mcSetWindFactor(unitID, 0.1)
    mcSetDrag(unitID, 0.03)
    mcSetTrackGround(unitID, true)
    mcSetCollideStop(unitID, true)
    --CallCOBScript(unitID, "Falling", 0, 0)
    
    paratroopers[unitID] = true
  end
  
  return false
end

function gadget:UnitDestroyed(unitID, unitDefID, teamID)
  --CallCOBScript(unitID, "Landed", 0, 0)
  transports[unitID] = nil
  paratroopers[unitID] = nil
end

function gadget:MoveCtrlNotify(unitID, unitDefID, unitTeam, data)
  if not paratroopers[unitID] then return false end
  
  paratroopers[unitID] = nil
  return true
end
