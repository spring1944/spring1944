function gadget:GetInfo()
  return {
    name      = "Spring 1944 Armor",
    desc      = "Calculates damage against armor.",
    author    = "Evil4Zerggin",
    date      = "11 July 2008",
    license   = "GNU LGPL, v2.1 or later",
    layer     = 0,
    enabled   = true  --  loaded by default?
  }
end

--[[
DOCUMENTATION

Units:

customParams:
  armor_front: front armor of the unit (in mm)
  armor_side: side armor
  armor_rear: rear armor
  armor_top: top armor

Each of these defaults to the previous if not explicitly given.

Weapon customParams:
armor_penetration: penetration of the weapon at point-blank (in mm)
ao_penetration_100m: penetration of the weapon at 100 m (in mm); you may use this instead of armor_penetration
armor_penetration_1000m: penetration of the weapon at 1000 m (in mm); default equal to penetration (i.e. no dropoff). Penetration drops off exponentially
armor_hit_side: forces the weapon to hit a certain side of the armor ("front", "side", "rear", or "top")

the damage actually dealt is proportional to the unmodified damage 
(the ap system multiplies the basic damage depending on penetration vs. armor)

Estimate the cost of a unit as proportional to sqrt(hp * dps * exp((armor + penetration) / ARMOR_BANDWIDTH / 2).

]]

if (not gadgetHandler:IsSyncedCode()) then
  return false
end

----------------------------------------------------------------
--constants
----------------------------------------------------------------

--how quickly penetration and armor effectiveness increase with thickness
--higher = less quickly
--along with cost, controls how hard counters are; higher = softer counters
--recommend somewhere around 15-25
local AP_SCALE = 20

--he weapons get an exponential decay curve
--effective penetration = HE_MULT * damage^HE_POWER
local HE_SCALE = AP_SCALE * 2
--local HE_POWER = 1/2
local HE_MULT = 2

----------------------------------------------------------------
--locals
----------------------------------------------------------------

--format: unitDefID = { armor_front, armor_side, armor_rear, armor_top, opentopped }
local unitInfos = {}

--format: weaponDefID = { armor_penetration, armor_dropoff, armor_hit_side }
local weaponInfos = {}

----------------------------------------------------------------
--speedups
----------------------------------------------------------------

local GetUnitPosition = Spring.GetUnitPosition
local GetUnitVectors = Spring.GetUnitVectors
local ValidUnitID = Spring.ValidUnitID

local vNormalized = GG.Vector.Normalized

local sqrt = math.sqrt
local exp = math.exp
local log = math.log

local SQRT_HALF = sqrt(0.5)

----------------------------------------------------------------
--callins
----------------------------------------------------------------

function gadget:Initialize()
  local armorTypes = Game.armorTypes

  for i = 1, #UnitDefs do
    local unitDef = UnitDefs[i]
    local customParams = unitDef.customParams
    if customParams.armor_front then
      local armor_front = customParams.armor_front
      local armor_side = customParams.armor_side or armor_front
      local armor_rear = customParams.armor_rear or armor_side
      local armor_top = customParams.armor_top or armor_rear
      
      local openTopped = armorTypes[unitDef.armorType] == "armouredvehicles"
      
      unitInfos[i] = {
        armor_front,
        armor_side,
        armor_rear,
        armor_top,
        openTopped,
      }
    end
  end
  
  for i = 1, #WeaponDefs do
    local weaponDef = WeaponDefs[i]
    local customParams = weaponDef.customParams
    if customParams.armor_penetration then
      local armor_penetration = customParams.armor_penetration
      local armor_penetration_1000m = customParams.armor_penetration_1000m or armor_penetration
      local armor_hit_side = customParams.armor_hit_side
      weaponInfos[i] = {
        armor_penetration,
        log(armor_penetration_1000m / armor_penetration) / 1000,
        armor_hit_side,
      }
    elseif customParams.armor_penetration_100m then
      local armor_penetration_100m = customParams.armor_penetration_100m
      local armor_penetration_1000m = customParams.armor_penetration_1000m or armor_penetration_100m
      local armor_hit_side = customParams.armor_hit_side
      weaponInfos[i] = {
        (armor_penetration_100m / armor_penetration_1000m) ^ (1/9) * armor_penetration_100m,
        log(armor_penetration_1000m / armor_penetration_100m) / 900,
        armor_hit_side,
      }
    elseif customParams.damagetype == "explosive" then
      local armor_hit_side = customParams.armor_hit_side
      weaponInfos[i] = {
        "explosive",
        0,
        armor_hit_side,
      }
    end
  end
end

function gadget:UnitPreDamaged(unitID, unitDefID, unitTeam, damage, paralyzer, weaponDefID, attackerID, attackerDefID, attackerTeam)
  if not weaponDefID or not ValidUnitID(unitID) or not ValidUnitID(attackerID) then return damage end
  
  local unitInfo = unitInfos[unitDefID]
  local weaponInfo = weaponInfos[weaponDefID]
  
  if not unitInfo or not weaponInfo then return damage end

  local armor
  
  local armor_hit_side = weaponInfo[3]
  
  local frontDir, upDir = GetUnitVectors(unitID)
  local ux, uy, uz = GetUnitPosition(unitID)
  local ax, ay, az = GetUnitPosition(attackerID)
  local dx, dy, dz, d
  local dotFront, dotUp
  
  dx, dy, dz = ax - ux, ay - uy, az - uz
  dx, dy, dz, d = vNormalized(dx, dy, dz)
  
  if ax and ux then
    dotUp = dx * upDir[1] + dy * upDir[2] + dz * upDir[3]
    dotFront = dx * frontDir[1] + dy * frontDir[2] + dz * frontDir[3]
  else
    --finagle something
    dotFront = 1
    dotUp = 0
    d = 500
  end
  
  --discrete arcs
  if armor_hit_side then
    if armor_hit_side == "top" then armor = unitInfo[4]
    elseif armor_hit_side == "rear" then armor = unitInfo[3]
    elseif armor_hit_side == "side" then armor = unitInfo[2]
    else armor = unitInfo[1]
    end
  else
    if dotUp > SQRT_HALF or dotUp < -SQRT_HALF then
      armor = unitInfo[4]
    else
      if dotFront > SQRT_HALF then
        armor = unitInfo[1]
      elseif dotFront > -SQRT_HALF then
        armor = unitInfo[2]
      else
        armor = unitInfo[3]
      end
    end
  end
  
  if weaponInfo[1] == "explosive" then
    local netPenetration = HE_MULT * sqrt(damage) - armor
    local mult
    if netPenetration >= 0 then
      mult = 1
    else
      mult = exp(netPenetration / HE_SCALE)
    end
    
    if unitInfo[5] then
      mult = mult + 1
    end
    
    return damage * mult
  else
    local penetration = weaponInfo[1] * exp(d * weaponInfo[2])
    penetration = exp(penetration / AP_SCALE)
    armor = exp(armor / AP_SCALE)
    
    return damage * penetration / (penetration + armor)
  end
end
