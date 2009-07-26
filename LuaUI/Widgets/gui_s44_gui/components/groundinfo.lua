local component = {}

local GetMapDrawMode = Spring.GetMapDrawMode
local TraceScreenRay = Spring.TraceScreenRay
local GetGroundInfo = Spring.GetGroundInfo

local strFormat = string.format

function component:DrawTooltip(mx, my)
  if GetMapDrawMode() == "height" then
    local _, pos = TraceScreenRay(mx, my, true)
    if pos then
      local tx, ty, tz = string.format("%.0f", pos[1]), string.format("%.0f", pos[2]), string.format("%.0f", pos[3])
      local terrainType, metal, hardness, vehSpeed, infSpeed, amphSpeed, navSpeed = GetGroundInfo(tx, tz)
      local text = "Pos (" .. tx .. ", " .. tz .. "), Elevation " .. ty .. "\n"
        .. "Speed: " .. string.format("%.2f", vehSpeed) .. " (Vehicle), " .. string.format("%.2f", infSpeed) .. " (Infantry)\n"
        .. string.format("%.2f", amphSpeed) .. " (Amphibious), " .. string.format("%.2f", navSpeed) .. " (Naval)\n"
        .. "Command: " .. string.format("%.2f", metal) .. ", Hardness:" .. string.format("%.2f", hardness) .. "\n"
        .. "Terrain Type: " .. terrainType
      DrawStandardTooltip(text, mx, my, false)
      return true
    end
  end
  return false
end

return component
