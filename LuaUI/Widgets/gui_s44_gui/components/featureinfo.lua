local component = {}

local GetFeatureDefID = Spring.GetFeatureDefID
local GetFeatureHealth = Spring.GetFeatureHealth
local strFormat = string.format

function component:DrawRolloverScreen(mx, my, targetType, targetID)
  if targetType == "feature" then
    local featureDef = FeatureDefs[GetFeatureDefID(targetID)]
    local tooltip = featureDef.tooltip
    
    local health, maxHealth = GetFeatureHealth(targetID)
    local healthProportion = health / maxHealth
    local healthColorString = GetColorString(GetHealthColor(healthProportion))
    
    local text = tooltip .. "\n"
      .. healthColorString .. "Health: " .. strFormat("%u", health) .. "/" .. strFormat("%u", maxHealth)
    DrawStandardTooltip(text, mx, my, false)
    return true
  end
  return false
end

return component
