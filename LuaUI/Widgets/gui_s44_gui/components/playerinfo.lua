local component = {}

local glColor = gl.Color
local glRect = gl.Rect

local glPushMatrix = gl.PushMatrix
local glPopMatrix = gl.PopMatrix

local glTranslate = gl.Translate

function component:Initialize()
  Spring.SendCommands("info 0", "clock 0", "fps 0")
end

function component:Shutdown()
  Spring.SendCommands("info 1", "clock 1", "fps 1")
end

function component:DrawScreen()
  glPushMatrix()
    glTranslate(vsx - mainSizeX, vsy - mainSizeY, 0)
    glColor(0, 0, 0, guiOpacity)
    glRect(0, 0, mainSizeX, mainSizeY)
    glColor(1, 1, 1, 1)
    
    font32:Print("Player Info", 0, mainSizeY, 32, "to")
  glPopMatrix()
end

function component:ViewResize()
  mainSizeX = vsx * 0.2
  mainSizeY = vsy * 0.25
end

return component
