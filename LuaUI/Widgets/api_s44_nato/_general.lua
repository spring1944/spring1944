local result = {}

local sin, cos = math.sin, math.cos
local pi = math.pi

local glShape = gl.Shape

local glPushMatrix = gl.PushMatrix
local glPopMatrix = gl.PopMatrix

local glTranslate = gl.Translate
local glScale = gl.Scale

local GL_POLYGON = GL.POLYGON

function result.DrawCircle(size)

  local vertices = {}
  for i = 1, 24 do
    local angle = i * pi / 12
    vertices[i] = { v = {cos(angle), sin(angle), 0} }
  end
  
  glPushMatrix()
    glScale(size, size, 1)
    glShape(GL_POLYGON, vertices)
  glPopMatrix()
end

return result
