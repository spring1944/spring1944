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
    
    font16:Print("Buildoptions", 0.5 / tabWidth, 0, 1, "co")
  glPopMatrix()
end

local function DrawIcons()
  glPushMatrix()
    --translate to icon coords: (0, 0) to (1, 1)
    glTranslate(tabWidth, 1, 0)
    glScale(1 / iconsY, 1 / iconsY, 0)
    
    local iconY = 1
    glColor(1, 1, 1, 1)
    for _, cmdDesc in pairs(buildCommands) do
      glTranslate(0, -1, 0)
      glTexture("#" .. -cmdDesc.id)
      glTexRect(0, 0, 1, 1)
      iconY = iconY + 1
      if iconY > iconsY then
        iconY = 1
        glTranslate(1, iconsY, 0)
      end
    end
    glTexture(false)
  glPopMatrix()
end

function component:DrawScreen()
  glPushMatrix()
    --translate to component coords: (0, 0) to (1, 1)
    glTranslate(0, mainSizeY, 0)
    glScale(mainSizeY, mainSizeY, 1)
    
    DrawTab()
    DrawIcons()
    
  glPopMatrix()
end

function component:ViewResize()
  mainSizeY = vsy * 0.25
end

return component
