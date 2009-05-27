function gadget:GetInfo()
  return {
    name      = "Cover",
    desc      = "Reduces damage to units in cover.",
    author    = "Evil4Zerggin",
    date      = "27 May 2008",
    license   = "GNU LGPL, v2.1 or later",
    layer     = 10000,
    enabled   = false  --  loaded by default?
  }
end

--[[
DOCUMENTATION

Usage:
* Give features customParams cover_strength > 1 and cover_radius to make it give cover.

Optimization:
* Assumes number of cover-giving features is less than the number of units.

]]

if (not gadgetHandler:IsSyncedCode()) then
  return false
end

----------------------------------------------------------------
--locals
----------------------------------------------------------------

local UPDATE_PERIOD = 32
local UPDATE_OFFSET = 19

local cover = {}
local coverFeatures = {}

local updateLists = {}
for i = 0, UPDATE_PERIOD - 1 do
  updateLists[i] = {}
end

----------------------------------------------------------------
--speedups
----------------------------------------------------------------
local GetFeatureDefID = Spring.GetFeatureDefID
local GetFeaturePosition = Spring.GetFeaturePosition
local GetUnitDefID = Spring.GetUnitDefID
local GetUnitsInCylinder = Spring.GetUnitsInCylinder

----------------------------------------------------------------
--callins
----------------------------------------------------------------

function gadget:Initialize()
  local allFeatures = Spring.GetAllFeatures()
  for i = 1, #allFeatures do
    gadget:FeatureCreated(allFeatures[i])
  end
  local allUnits = Spring.GetAllUnits()
  for i = 1, #allUnits do
    local unitID = allUnits[i]
    gadget:UnitCreated(unitID, GetUnitDefID(unitID))
  end
end

function gadget:FeatureCreated(featureID, allyTeam)
  local featureDefID = GetFeatureDefID(featureID)
  local customParams = FeatureDefs[featureDefID].customParams
  if not customParams.cover_strength or not customParams.cover_radius then return end

  coverFeatures[featureID] = { tonumber(customParams.cover_strength), tonumber(customParams.cover_radius) }
end

function gadget:FeatureDestroyed(featureID, allyTeam)
  coverFeatures[featureID] = nil
end

function gadget:UnitCreated(unitID, unitDefID, unitTeam, builderID)
  local unitDef = UnitDefs[unitDefID]
  if unitDef.canFly or unitDef.speed == 0 then return end
  
  cover[unitID] = 1
end

function gadget:UnitDestroyed(unitID, unitDefID, unitTeam)
  cover[unitID] = nil
end

function gadget:GameFrame(n)
  if n % UPDATE_PERIOD ~= UPDATE_OFFSET then return end
  
  for unitID, _ in pairs(cover) do
    cover[unitID] = 1
  end
  
  for featureID, featureInfo in pairs(coverFeatures) do
    local fx, fy, fz = GetFeaturePosition(featureID)
    if fx then
      local coverStrength = featureInfo[1]
      local coveredUnits = GetUnitsInCylinder(fx, fz, featureInfo[2])
      for i = 1, #coveredUnits do
        local unitID = coveredUnits[i]
        if cover[unitID] and cover[unitID] < coverStrength then
          cover[unitID] = coverStrength
        end
      end
    end
  end
end

function gadget:UnitPreDamaged(unitID, unitDefID, unitTeam, damage, paralyzer, weaponDefID, attackerID, attackerDefID, attackerTeam)
  if cover[unitID] and cover[unitID] > 1 then
    Spring.Echo("Cover", cover[unitID])
  end
  return damage / (cover[unitID] or 1)
end
