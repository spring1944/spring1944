local component = {}

local mainSizeY = 256
local fontSize = 1/16

local tabWidth = 1/16

local GetSelectedUnits = Spring.GetSelectedUnits

local GetUnitDefID = Spring.GetUnitDefID
local GetUnitHealth = Spring.GetUnitHealth
local GetUnitExperience = Spring.GetUnitExperience
local GetUnitRulesParam  = Spring.GetUnitRulesParam

local glPushMatrix = gl.PushMatrix
local glPopMatrix = gl.PopMatrix

local glTranslate = gl.Translate
local glScale = gl.Scale
local glRotate = gl.Rotate

local strFormat = string.format
local glColor = gl.Color
local glRect = gl.Rect

local function DrawTab()
  glPushMatrix()
    glScale(tabWidth, tabWidth, 1)
    glTranslate(1, 0, 0)
    glRotate(90, 0, 0, 1)
    
    glColor(0, 0, 0, guiOpacity)
    glRect(0, 0, 1 / tabWidth, 1)
    glColor(1, 1, 1, 1)
    
    font16:Print("Selection", 0.5 / tabWidth, 0, 1, "co")
  glPopMatrix()
end

local function DrawMain()
  glPushMatrix()
  glTranslate(tabWidth, 0, 0)
    local selectedUnits = GetSelectedUnits()
    
    if #selectedUnits == 0 then return end
    
    glColor(0, 0, 0, guiOpacity)
    glRect(0, 0, 1, 1)
    glColor(1, 1, 1, 1)
    
    if #selectedUnits == 1 then
      local unitID = selectedUnits[1]
      local unitDef = UnitDefs[GetUnitDefID(unitID)]
      local humanName = unitDef.humanName
      local tooltip = unitDef.tooltip
      
      local health, maxHealth = GetUnitHealth(unitID)
      local healthProportion = health / maxHealth
      local healthColorString = GetColorString(GetHealthColor(healthProportion))
      
      local text = humanName .. ": " .. tooltip .. "\n"
        .. healthColorString .. "Health: " .. strFormat("%u", health) .. "/" .. strFormat("%u", maxHealth) .. "\n"
        
      local ammo = GetUnitRulesParam(unitID, "ammo")
      local maxAmmo = unitDef.customParams.maxammo
      
      if ammo and maxAmmo then
        local ammoProportion = ammo / maxAmmo
        local ammoColorString = GetColorString(GetHealthColor(ammoProportion))
        text = text .. ammoColorString .. "Ammunition: " .. strFormat("%u", ammo) .. "/" .. strFormat("%u", maxAmmo) .. "\n"
      end
      
      if #unitDef.weapons > 0 then
        local xp = GetUnitExperience(unitID)
        text = text .. "\255\255\255\255Experience: " .. strFormat("%.2f", xp)
      end
        
      text = font16:WrapText(text, 1, 1, fontSize)
      
      font16:Print(text, 0, 1, fontSize, "to")
    else
      local text = #selectedUnits .. " selected units"
      font16:Print(text, 0, 1, fontSize, "to")
    end
  glPopMatrix()
end

function component:Initialize()
  Spring.SendCommands("tooltip 0")
  Spring.SetDrawSelectionInfo(false)
end

function component:Shutdown()
  Spring.SendCommands("tooltip 1")
  Spring.SetDrawSelectionInfo(true)
end

function component:CommandsChanged()
  
end

function component:DrawScreen()
  glPushMatrix()
    --transform to component coords: (0, 0) to (1, 1)
    glScale(mainSizeY, mainSizeY, 1)
    
    DrawTab()
    DrawMain()
    
  glPopMatrix()
end

function component:ViewResize()
  mainSizeY = vsy * 0.25
end

return component
