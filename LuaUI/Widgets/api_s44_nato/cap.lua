local result = {}

local DrawCircle = NATO._general.DrawCircle

local glPolygonMode = gl.PolygonMode
local glRect = gl.Rect
local glShape = gl.Shape

local glPushMatrix = gl.PushMatrix
local glPopMatrix = gl.PopMatrix

local glTranslate = gl.Translate

local GL_LINES = GL.LINES

local GL_FRONT_AND_BACK = GL.FRONT_AND_BACK
local GL_FILL = GL.FILL
local GL_LINE = GL.LINE

function result.Building()
  glRect(-0.5, 1, 0.5, 1.5)
end

function result.FireTeam()
  glPushMatrix()
    glTranslate(0, 1.25, 0)
    DrawCircle(0.125)
  glPopMatrix()
end

function result.Section()
  glPushMatrix()
    glTranslate(-0.25, 1.25, 0)
    DrawCircle(0.125)
    glTranslate(0.5, 0, 0)
    DrawCircle(0.125)
  glPopMatrix()
end

function result.Platoon()
  glPushMatrix()
    glTranslate(-0.5, 1.25, 0)
    DrawCircle(0.125)
    glTranslate(0.5, 0, 0)
    DrawCircle(0.125)
    glTranslate(0.5, 0, 0)
    DrawCircle(0.125)
  glPopMatrix()
end

function result.Company()
  local vertices = {
    { v = {0, 1.375, 0} },
    { v = {0, 1.125, 0} },
  }
  
  glShape(GL_LINES, vertices)
end

function result.Battalion()
  local vertices = {
    { v = {-0.125, 1.375, 0} },
    { v = {-0.125, 1.125, 0} },
    
    { v = {0.125, 1.375, 0} },
    { v = {0.125, 1.125, 0} },
  }
  
  glShape(GL_LINES, vertices)
end

function result.Regiment()
  local vertices = {
    { v = {-0.25, 1.375, 0} },
    { v = {-0.25, 1.125, 0} },
  
    { v = {0, 1.375, 0} },
    { v = {0, 1.125, 0} },
    
    { v = {0.25, 1.375, 0} },
    { v = {0.25, 1.125, 0} },
  }
  
  glShape(GL_LINES, vertices)
end

return result
