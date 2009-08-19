local result = {}

local glRect = gl.Rect
local glShape = gl.Shape

local GL_LINES = GL.LINES
local GL_TRIANGLES = GL.TRIANGLES

function result.SpecialOps()
  local vertices = {
    {v = {-1.5, 1, 0}},
    {v = {-0.5, 1/3, 0}},
    {v = {-0.5, 1, 0}},
    
    {v = {1.5, 1, 0}},
    {v = {0.5, 1, 0}},
    {v = {0.5, 1/3, 0}},
  }
  
  glShape(GL_TRIANGLES, vertices)
end

function result.Rocket()
  local vertices = {
    {v = {-0.25, 0.25, 0}},
    {v = {0, 0.5, 0}},
    {v = {0, 0.5, 0}},
    {v = {0.25, 0.25, 0}},
    
    {v = {-0.25, 0.5, 0}},
    {v = {0, 0.75, 0}},
    {v = {0, 0.75, 0}},
    {v = {0.25, 0.5, 0}},
  }

  glShape(GL_LINES, vertices)
end

function result.HQ()
  glRect(-1.5, 0.75, 1.5, 1)
end

return result