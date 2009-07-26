local glSmoothing = gl.Smoothing
local glPolygonMode = gl.PolygonMode

local glRect = gl.Rect
local glShape = gl.Shape

local GL_FRONT_AND_BACK = GL.FRONT_AND_BACK

local GL_LINE = GL.LINE
local GL_FILL = GL.FILL

local GL_POINTS = GL.POINTS
local GL_LINES = GL.LINES
local GL_LINE_STRIP = GL.LINE_STRIP
local GL_LINE_LOOP = GL.LINE_LOOP
local GL_TRIANGLES = GL.TRIANGLES

local function Rectangle()
  glPolygonMode(GL_FRONT_AND_BACK, GL_LINE)
  glRect(-1, -1, 1, 1)
  glPolygonMode(GL_FRONT_AND_BACK, GL_FILL)
end

local function Infantry()
  local vertices = {
    {v = {-1, -1, 0}},
    {v = {1, 1, 0}},
    {v = {-1, 1, 0}},
    {v = {1, -1, 0}},
  }
  
  glShape(GL_LINES, vertices)
end

local function SpecialOps()
  Infantry()
  
  local vertices = {
    {v = {-1, 1, 0}},
    {v = {-0.5, 0.5, 0}},
    {v = {-0.5, 1, 0}},
    
    {v = {1, 1, 0}},
    {v = {0.5, 1, 0}},
    {v = {0.5, -0.5, 0}},
  }
  
  glShape(GL_TRIANGLES, vertices)
end

local function Recon()
  local vertices = {
    {v = {-1, -1, 0}},
    {v = {1, 1, 0}},
  }
  
  glShape(GL_LINES, vertices)
end

local function Mortar()

end

local function Artillery()
  glSmoothing(true, false, false)
  
  local vertices = {
    {v = {0, 0, 0}},
  }
  
  glShape(GL_POINTS, vertices)
  
  glSmoothing(false, false, false)
end

local function AntiTank()
  local vertices = {
    {v = {-1, -1, 0}},
    {v = {0, 1, 0}},
    {v = {1, -1, 0}},
  }
  
  glShape(GL_LINE_STRIP, vertices)
end

local function AntiAircraft()
  local vertices = {
    {v = {-1, -1, 0}},
    {v = {0, 1, 0}},
    {v = {0, 1, 0}},
    {v = {1, -1, 0}},
    {v = {-0.5, 0, 0}},
    {v = {0.5, 0, 0}},
  }
  
  glShape(GL_LINES, vertices)
end

local function Wheeled()

end

local function Armor()

end

local function FixedWing()

end

local function Rocket()

end

local function HQ()
  local vertices = {
    {v = {-1, 0.25, 0}},
    {v = {1, 0.25, 0}},
  }
  
  glShape(GL_LINES, vertices)
end

local function Engineer()
  local vertices = {
    {v = {-0.5, -0.25, 0}},
    {v = {-0.5, 0.25, 0}},
    {v = {0, -0.25, 0}},
    {v = {0, 0.25, 0}},
    {v = {0.5, -0.25, 0}},
    {v = {0.5, 0.25, 0}},
    {v = {-0.5, 0.25, 0}},
    {v = {0.5, 0.25, 0}},
  }
  
  glShape(GL_LINES, vertices)
end

local function Supply()
  local vertices = {
    {v = {-1, -1/3, 0}},
    {v = {1, -1/3, 0}},
  }
  
  glShape(GL_LINES, vertices)
end

local function Radar()

end

return {
  Rectangle = Rectangle,
  Infantry = Infantry,
  SpecialOps = SpecialOps,
  Mortar = Mortar,
  Artillery = Artillery,
  AntiTank = AntiTank,
  AntiAircraft = AntiAircraft,
  Wheeled = Wheeled,
  Armor = Armor,
  FixedWing = FixedWing,
  Rocket = Rocket,
  HQ = HQ,
  Engineer = Engineer,
  Supply = Supply,
  Radar = Radar,
}