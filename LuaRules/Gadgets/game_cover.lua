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

local coverFeatures = {}

----------------------------------------------------------------
--speedups
----------------------------------------------------------------
local GetFeatureDefID = Spring.GetFeatureDefID
local GetFeaturePosition = Spring.GetFeaturePosition
local GetUnitDefID = Spring.GetUnitDefID
local GetUnitsInCylinder = Spring.GetUnitsInCylinder
local GetUnitRulesParam = Spring.GetUnitRulesParam
local SetUnitRulesParam = Spring.SetUnitRulesParam
local GetAllUnits = Spring.GetAllUnits

----------------------------------------------------------------
--callins
----------------------------------------------------------------

function gadget:Initialize()
  local allFeatures = Spring.GetAllFeatures()
  for i = 1, #allFeatures do
    gadget:FeatureCreated(allFeatures[i])
  end
  local allUnits = GetAllUnits()
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
  if unitDef.customParams.feartarget and not(unitDef.canFly) and unitDef.speed ~= 0 then  
	SetUnitRulesParam(unitID, "cover", 1)
  else
  end
end

function gadget:GameFrame(n)
  if n % UPDATE_PERIOD ~= UPDATE_OFFSET then return end
  
  local allUnits = GetAllUnits()
  for i=1, #allUnits do
    local unitID = allUnits[i]
    if GetUnitRulesParam(unitID, "cover") then
      SetUnitRulesParam(unitID, "cover", 1)
    end
  end
  
  for featureID, featureInfo in pairs(coverFeatures) do
    local fx, fy, fz = GetFeaturePosition(featureID)
    if fx then
      local coverStrength = featureInfo[1]
      local coveredUnits = GetUnitsInCylinder(fx, fz, featureInfo[2])
      for i = 1, #coveredUnits do
        local unitID = coveredUnits[i]
        local currCover = GetUnitRulesParam(unitID, "cover")
        if currCover and currCover < coverStrength then
          SetUnitRulesParam(unitID, "cover", coverStrength)
        end
      end
    end
  end
end

function gadget:UnitPreDamaged(unitID, unitDefID, unitTeam, damage, paralyzer, weaponDefID, attackerID, attackerDefID, attackerTeam)
  return damage / (GetUnitRulesParam(unitID, "cover") or 1)
end
