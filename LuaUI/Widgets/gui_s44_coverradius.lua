local versionNumber = "v0.0"

function widget:GetInfo()
  return {
    name = "1944 Cover",
    desc = versionNumber .. " Cover indicator for Spring 1944",
    author = "Evil4Zerggin",
    date = "5 January 2009",
    license = "GNU LGPL, v2.1 or later",
    layer = 1,
    enabled = false
  }
end

--[[
DOCUMENTATION

Always on for now.
]]

local CIRCLE_DIVS = 32
local MAX_ALPHA = 0.75

------------------------------------------------
--speedups and constants
------------------------------------------------
local GetAllFeatures = Spring.GetAllFeatures
local GetFeatureDefID = Spring.GetFeatureDefID
local GetFeaturePosition = Spring.GetFeaturePosition

local sin, cos = math.sin, math.cos
local PI = math.pi

local glPushMatrix = gl.PushMatrix
local glPopMatrix = gl.PopMatrix

local glTranslate = gl.Translate
local glScale = gl.Scale

local glCreateList = gl.CreateList
local glCallList = gl.CallList
local glDeleteList = gl.DeleteList

local glShape = gl.Shape

local glColor = gl.Color
local glBlending = gl.Blending

local GL_POLYGON = GL.POLYGON

local GL_SRC_ALPHA = GL.SRC_ALPHA
local GL_ONE_MINUS_SRC_ALPHA = GL.ONE_MINUS_SRC_ALPHA
local GL_ONE_MINUS_SRC_COLOR = GL.ONE_MINUS_SRC_COLOR
local GL_ONE_MINUS_DST_COLOR = GL.ONE_MINUS_DST_COLOR

------------------------------------------------
--helpers
------------------------------------------------

local function DrawUnitCircle()
  local vertices = {}
  for i = 1, CIRCLE_DIVS + 1 do
    local theta = 2 * PI * i / CIRCLE_DIVS
    vertices[i] = { v = { cos(theta), 0, sin(theta) } }
  end
  glShape(GL_POLYGON, vertices)
end

local function DrawCircle(x, y, z, radius)
  glPushMatrix()
  glTranslate(x, y, z)
  glScale(radius, radius, radius)
  
  glCallList(circleList)
  
  glPopMatrix()
end

local function SetupDisplayLists()
  circleList = glCreateList(DrawUnitCircle)
end

local function DeleteDisplayLists()
  glDeleteList(circleList)
end

------------------------------------------------
--callins
------------------------------------------------

function widget:Initialize()
  SetupDisplayLists()
end

function widget:Shutdown()
  DeleteDisplayLists()
end

function widget:DrawWorldPreUnit()
  --slow implementation for now (are features always visibile in FeatureCreated?)
  
  glBlending(GL_ONE_MINUS_DST_COLOR, GL_ONE_MINUS_SRC_COLOR)
  
  local allFeatures = GetAllFeatures()
  
  for i = 1, #allFeatures do
    local featureID = allFeatures[i]
    local featureDefID = GetFeatureDefID(featureID)
    local customParams = FeatureDefs[featureDefID].customParams
    local coverStrength, coverRadius = customParams.cover_strength, customParams.cover_radius
    if coverStrength and coverRadius then
      local fx, fy, fz = GetFeaturePosition(featureID)
      glColor(0, MAX_ALPHA - MAX_ALPHA / coverStrength, 0)
      DrawCircle(fx, fy, fz, coverRadius)
    end
  end
  
  glBlending(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA)
  
end
