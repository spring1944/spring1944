local component = {}

local GetMapDrawMode = Spring.GetMapDrawMode
local GetGroundInfo = Spring.GetGroundInfo

local strFormat = string.format

function component:DrawRolloverScreen(mx, my, targetType, targetID)
  if targetType == "ground" and GetMapDrawMode() == "height" then
    local tx, ty, tz = string.format("%.0f", targetID[1]), string.format("%.0f", targetID[2]), string.format("%.0f", targetID[3])
    local terrainType, metal, hardness, vehSpeed, infSpeed, amphSpeed, navSpeed = GetGroundInfo(tx, tz)
    local text = "Position (" .. tx .. ", " .. tz .. "), Elevation " .. ty .. "\n"
      .. "Speed: " .. string.format("%.2f", vehSpeed) .. " (Vehicle), " .. string.format("%.2f", infSpeed) .. " (Infantry)\n"
      .. string.format("%.2f", amphSpeed) .. " (Amphibious), " .. string.format("%.2f", navSpeed) .. " (Naval)\n"
      .. "Command: " .. string.format("%.2f", metal) .. ", Hardness:" .. string.format("%.2f", hardness) .. "\n"
      .. "Terrain Type: " .. terrainType
    DrawStandardTooltip(text, mx, my, false)
    return true
  end
  return false
end

return component
