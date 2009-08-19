local result = {}

local DrawCircle = NATO._general.DrawCircle

local pi = math.pi
local sin, cos = math.sin, math.cos
local sqrt = math.sqrt

local glPolygonMode = gl.PolygonMode
local glRect = gl.Rect
local glShape = gl.Shape

local GL_FRONT_AND_BACK = GL.FRONT_AND_BACK
local GL_FILL = GL.FILL
local GL_LINE = GL.LINE

local GL_LINES = GL.LINES
local GL_LINE_STRIP = GL.LINE_STRIP
local GL_LINE_LOOP = GL.LINE_LOOP
local GL_POLYGON = GL.POLYGON

function result.Infantry()
  glPolygonMode(GL_FRONT_AND_BACK, GL_LINE)
  glRect(-1.5, -1, 1.5, 1)
  glPolygonMode(GL_FRONT_AND_BACK, GL_FILL)
  
  local vertices = {
    {v = {-1.5, -1, 0}},
    {v = {1.5, 1, 0}},
    
    {v = {1.5, -1, 0}},
    {v = {-1.5, 1, 0}},
  }
  
  glShape(GL_LINES, vertices)
end

function result.Armored()
  local vertices = {}
  
  local halfCount = 12
  
  for i=0,halfCount do
    vertices[i+1] =  { v = {(2 + sin(i * pi / halfCount))/3, -cos(i * pi / halfCount)/3, 0}}
    vertices[i+halfCount+2] = { v = {-(2 + sin(i * pi / halfCount))/3, cos(i * pi / halfCount)/3, 0}}
  end
  
  glShape(GL_LINE_LOOP, vertices)
end

function result.Artillery()
  DrawCircle(0.125)
end

function result.FixedWing()
  local vertices = {}
  
  local halfCount = 8
  
  vertices[1] = { v = {0, 0, 0} }
  
  for i=0,halfCount do
    vertices[i+2] =  { v = {(2 + sin(i * pi / halfCount))/3, -cos(i * pi / halfCount)/3, 0}}
  end
  
  glShape(GL_POLYGON, vertices)
  
  vertices[1] = { v = {0, 0, 0} }
  
  for i=0,halfCount do
    vertices[i+2] =  { v = {-(2 + sin(i * pi / halfCount))/3, cos(i * pi / halfCount)/3, 0}}
  end
  
  glShape(GL_POLYGON, vertices)
end

return result