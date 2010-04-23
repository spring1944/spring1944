local result = {}

local glPolygonMode = gl.PolygonMode
local glRect = gl.Rect
local GL_FRONT_AND_BACK = GL.FRONT_AND_BACK
local GL_FILL = GL.FILL
local GL_LINE = GL.LINE

function result.Medium()
  glPolygonMode(GL_FRONT_AND_BACK, GL_LINE)
  glRect(-1.5, -1, -1.25, 1)
  glPolygonMode(GL_FRONT_AND_BACK, GL_FILL)
end

function result.Heavy()
  glRect(-1.5, -1, -1.25, 1)
end

return result
