local component = {}

local tabWidth = 1/16
local iconsY = 4

local GetCmdDescIndex = Spring.GetCmdDescIndex

local glColor = gl.Color
local glRect = gl.Rect
local glTexRect = gl.TexRect

local glTexture = gl.Texture

local glPushMatrix = gl.PushMatrix
local glPopMatrix = gl.PopMatrix

local glTranslate = gl.Translate
local glScale = gl.Scale
local glRotate = gl.Rotate

local mainSizeY = 256

local function DrawTab()
  glPushMatrix()
    glScale(tabWidth, tabWidth, 1)
    glTranslate(1, 0, 0)
    glRotate(90, 0, 0, 1)
    
    glColor(0, 0, 0, guiOpacity)
    glRect(0, 0, 1 / tabWidth, 1)
    glColor(1, 1, 1, 1)
    
    font16:Print("Commands", 0.5 / tabWidth, 0, 1, "co")
  glPopMatrix()
end

local function DrawIcons()
  glPushMatrix()
    --translate to icon coords: (0, 0) to (1, 1)
    glTranslate(tabWidth, 1, 0)
    glScale(1 / iconsY, 1 / iconsY, 0)
    
    local iconY = 1
    
    for _, cmdDesc in pairs(orderCommands) do
      glTranslate(0, -1, 0)
      if (cmdDesc.texture or "") ~= "" then
        glColor(1, 1, 1, 1)
        glTexture(cmdDesc.texture)
        glTexRect(0, 0, 1, 1)
        glTexture(false)
      else
        glColor(0, 0, 0, 1)
        glRect(0, 0, 1, 1)
      end
      local text = font16:WrapText(cmdDesc.name, 1, 1, 1/4)
      glColor(1, 1, 1, 1)
      font16:Print(text, 0.5, 0.5, 1/4, "cvo")
      
      iconY = iconY + 1
      if iconY > iconsY then
        iconY = 1
        glTranslate(1, iconsY, 0)
      end
    end
  glPopMatrix()
end

function component:DrawScreen()
  glPushMatrix()
    glTranslate(0, mainSizeY * 2, 0)
    glScale(mainSizeY, mainSizeY, 1)
    
    DrawTab()
    DrawIcons()
    
  glPopMatrix()
end

function component:ViewResize()
  mainSizeY = vsy * 0.25
end

return component
