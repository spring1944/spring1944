local result = {}

local DrawCircle = NATO._general.DrawCircle

local sin, cos = math.sin, math.cos
local pi = math.pi

local glPolygonMode = gl.PolygonMode
local glRect = gl.Rect
local glShape = gl.Shape

local glPushMatrix = gl.PushMatrix
local glPopMatrix = gl.PopMatrix

local glTranslate = gl.Translate

local GL_FRONT_AND_BACK = GL.FRONT_AND_BACK
local GL_FILL = GL.FILL
local GL_LINE = GL.LINE

local GL_LINES = GL.LINES
local GL_LINE_STRIP = GL.LINE_STRIP
local GL_LINE_LOOP = GL.LINE_LOOP

function result.Artillery()
  DrawCircle(0.125)
end

function result.AntiAir()
  local vertices = {
    {v = {-1.5, -1, 0}},
    {v = {0, 1, 0}},
    
    {v = {0, 1, 0}},
    {v = {1.5, -1, 0}},
    
    {v = {-0.75, 0, 0}},
    {v = {0.75, 0, 0}},
  }

  glShape(GL_LINES, vertices)
end

function result.AntiTank()
  local vertices = {
    {v = {-1.5, 1, 0}},
    {v = {0, -1, 0}},
    {v = {1.5, 1, 0}},
  }

  glShape(GL_LINE_STRIP, vertices)
end

function result.Assault()
  local vertices = {
    {v = {-1, 0, 0}},
    {v = {1, 0, 0}},
  }

  glShape(GL_LINES, vertices)
end

function result.Mortar()
  result.Artillery()
  
  local vertices = {
    {v = {-0.25, 0.375, 0}},
    {v = {0, 0.625, 0}},
    {v = {0, 0.625, 0}},
    {v = {0.25, 0.375, 0}},
    
    {v = {0, 0.625, 0}},
    {v = {0, 0, 0}},
  }
  
  glShape(GL_LINES, vertices)
end

function result.Engineer()
  
  local vertices = {
    {v = {-1, -0.5, 0}},
    {v = {-1, 0.5, 0}},
    
    {v = {-1, 0.5, 0}},
    {v = {1, 0.5, 0}},
    
    {v = {1, 0.5, 0}},
    {v = {1, -0.5, 0}},
    
    {v = {0, 0.5, 0}},
    {v = {0, 0, 0}},
  }
  
  glShape(GL_LINES, vertices)
end

function result.Naval()
  glPolygonMode(GL_FRONT_AND_BACK, GL_LINE)
  glPushMatrix()
    glTranslate(0, 0.625, 0)
    DrawCircle(0.125)
  glPopMatrix()
  glPolygonMode(GL_FRONT_AND_BACK, GL_FILL)

  local vertices = {
    {v = {0, 0.5, 0}},
    {v = {0, -0.75, 0}},
    
    {v = {-0.25, 0.25, 0}},
    {v = {0.25, 0.25, 0}},
  }
  
  glShape(GL_LINES, vertices)
  
  vertices = {}
  
  local halfCount = 12
  
  for i=0,halfCount do
    vertices[i+1] = { v = {cos(i * pi / halfCount) * 0.75, -0.5 - sin(i * pi / halfCount) * 0.25, 0}}
  end

  glShape(GL_LINE_STRIP, vertices)
end

function result.Signals()
  local vertices = {
    {v = {-1.5, 1, 0}},
    {v = {0, -0.5, 0}},
    {v = {0, 0.5, 0}},
    {v = {1.5, -1, 0}},
  }

  glShape(GL_LINE_STRIP, vertices)
end

return result