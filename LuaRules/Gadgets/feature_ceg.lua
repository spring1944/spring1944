function gadget:GetInfo()
  return {
    name      = "Feature CEG",
    desc      = "Spawns CEGs for features.",
    author    = "Evil4Zerggin",
    date      = "18 June 2009",
    license   = "GNU LGPL, v2.1 or later",
    layer     = 0,
    enabled   = true  --  loaded by default?
  }
end

if (not gadgetHandler:IsSyncedCode()) then
  return false
end

local GetFeaturePosition = Spring.GetFeaturePosition
local GetFeatureDefID = Spring.GetFeatureDefID
local SpawnCEG = Spring.SpawnCEG

function gadget:FeatureCreated(featureID)
  local featureDef = FeatureDefs[GetFeatureDefID(featureID)]
  local customParams = featureDef.customParams
  local ceg = customParams.ceg_created
  if ceg then
    local fx, fy, fz = GetFeaturePosition(featureID)
    SpawnCEG(ceg, fx, fy, fz)
  end
end

function gadget:FeatureDestroyed(featureID)
  local featureDef = FeatureDefs[GetFeatureDefID(featureID)]
  local ceg = featureDef.customParams.ceg_destroyed
  if ceg then
    local fx, fy, fz = GetFeaturePosition(featureID)
    SpawnCEG(ceg, fx, fy, fz)
  end
end
