local result = {}

local DrawCircle = NATO._general.DrawCircle

local sin, cos = math.sin, math.cos
local pi = math.pi

local glPushMatrix = gl.PushMatrix
local glPopMatrix = gl.PopMatrix

local glTranslate = gl.Translate
local glScale = gl.Scale

local glShape = gl.Shape

local glPolygonMode = gl.PolygonMode

local GL_FRONT_AND_BACK = GL.FRONT_AND_BACK
local GL_FILL = GL.FILL
local GL_LINE = GL.LINE

local GL_LINE_LOOP = GL.LINE_LOOP
local GL_LINE_STRIP = GL.LINE_STRIP
local GL_POLYGON = GL.POLYGON

function result.Wheeled()
  glPushMatrix()
    glPolygonMode(GL_FRONT_AND_BACK, GL_LINE)
    glTranslate(-0.75, -0.75, 0)
    DrawCircle(0.25)
    glTranslate(0.75, 0, 0)
    DrawCircle(0.25)
    glTranslate(0.75, 0, 0)
    DrawCircle(0.25)
    glPolygonMode(GL_FRONT_AND_BACK, GL_FILL)
  glPopMatrix()
end

function result.Halftrack()
  glPushMatrix()
    glTranslate(-0.75, -0.75, 0)
    
    glPolygonMode(GL_FRONT_AND_BACK, GL_LINE)
    DrawCircle(0.25)
    glPolygonMode(GL_FRONT_AND_BACK, GL_FILL)
    
    glTranslate(1.125, 0, 0)
    
    local vertices = {}
  
    local halfCount = 12
    
    for i=0,halfCount do
      vertices[i+1] =  { v = {(1.5 + sin(i * pi / halfCount))/4, cos(i * pi / halfCount)/4, 0}}
      vertices[i+halfCount+2] = { v = {-(1.5 + sin(i * pi / halfCount))/4, -cos(i * pi / halfCount)/4, 0}}
    end
    
    glShape(GL_LINE_LOOP, vertices)
    
  glPopMatrix()
end

function result.Airborne()
  local vertices = {}

  local halfCount = 12
  
  for i=0,halfCount do
    vertices[i+1] = { v = {(-1 - cos(i * pi / halfCount)) * 0.375, -0.75 + sin(i * pi / halfCount)/4, 0}}
    vertices[i+halfCount+1] = { v = {(1 - cos(i * pi / halfCount)) * 0.375, -0.75 + sin(i * pi / halfCount)/4, 0}}
  end
  
  glShape(GL_LINE_STRIP, vertices)
end

function result.Amphibious()
  local vertices = {}
  
  local cycles = 4.5
  local samples = 54
  
  for i=0,samples do
    vertices[i+1] = { v = {-1.5 + 3 * i / samples, -0.75 + 0.125 * sin(i * cycles * 2 * pi / samples), 0 } }
  end
  
  glShape(GL_LINE_STRIP, vertices)
end

return result