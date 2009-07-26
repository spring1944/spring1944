local component = {}

local mainSizeX = 256
local mainSizeY = 256
local fontSize = 16

local GetSelectedUnits = Spring.GetSelectedUnits
local GetUnitDefID = Spring.GetUnitDefID
local GetUnitHealth = Spring.GetUnitHealth
local strFormat = string.format
local glColor = gl.Color
local glRect = gl.Rect

function component:Initialize()
  Spring.SendCommands("tooltip 0")
  Spring.SetDrawSelectionInfo(false)
end

function component:CommandsChanged()
  
end

function component:DrawScreen()
  glColor(0, 0, 0, 0.5)
  glRect(0, 0, mainSizeX, mainSizeY)
  glColor(1, 1, 1, 1)

  local selectedUnits = GetSelectedUnits()
  
  if #selectedUnits == 0 then
    -- ?
  elseif #selectedUnits == 1 then
    local unitID = selectedUnits[1]
    local unitDef = UnitDefs[GetUnitDefID(unitID)]
    local humanName = unitDef.humanName
    local tooltip = unitDef.tooltip
    
    local health, maxHealth = GetUnitHealth(unitID)
    local healthProportion = health / maxHealth
    local healthColorString = GetColorString(GetHealthColor(healthProportion))
    
    local text = humanName .. ":" .. tooltip .. "\n"
      .. healthColorString .. "Health: " .. strFormat("%u", health) .. "/" .. strFormat("%u", maxHealth)
      
    text = font16:WrapText(text, mainSizeX - 8, mainSizeY, fontSize)
    
    font16:Print(text, 0, mainSizeY, fontSize, "t")
  else
    local text = #selectedUnits .. " selected units"
    font16:Print(text, 0, mainSizeY, fontSize, "t")
  end
  
  
  
end

function component:ViewResize()
  mainSizeX = vsx * 0.2
  mainSizeY = vsy * 0.25
end

return component
