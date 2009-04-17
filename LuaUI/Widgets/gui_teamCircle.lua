--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--
--  file:    gui_S44TeamCircleOptimized.lua
--  brief:   team colored circle around selected units
--  author:  Dave Rodgers, tweaked by Nemo, tweaked by Neddiedrow
--
--  Copyright (C) 2007.
--  Licensed under the terms of the GNU GPL, v2 or later.
--
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

function widget:GetInfo()
  return {
    name      = "1944 Team Circles",
    desc      = "Shows a team color circle around selected units",
    author    = "trepan",
    date      = "Apr 16, 2007",
    license   = "GNU GPL, v2 or later",
    layer     = 5,
    enabled   = false  --  loaded by default?
  }
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

local function SetupCommandColors(state)
  local alpha = state and 1 or 0
  local f = io.open('cmdcolors.tmp', 'w+')
  if (f) then
    f:write('unitBox  0 1 0 ' .. alpha)
    f:close()
    Spring.SendCommands({'cmdcolors cmdcolors.tmp'})
  end
  --Spring newer then 0.78.2.1 doesn't have os.remove anymore
  if (os.remove) then
    os.remove('cmdcolors.tmp')
  end
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

local teamColors = {}

local trackSlope = true

local circleLines  = 0
local circleDivs   = 32
local circleOffset = 0

local startTimer = Spring.GetTimer()

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

function widget:Initialize()

  circleLines = gl.CreateList(function()
    gl.BeginEnd(GL.LINE_LOOP, function()
      local radstep = (2.0 * math.pi) / circleDivs
      for i = 1, circleDivs do
        local a = (i * radstep)
        gl.Vertex(math.sin(a), circleOffset, math.cos(a))
      end
    end)
  end)

  SetupCommandColors(false)
end


function widget:Shutdown()
  gl.DeleteList(circleLines)

  SetupCommandColors(true)
end


--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

--
-- Speed-ups
--

local GetUnitTeam         = Spring.GetUnitTeam
local GetUnitRadius       = Spring.GetUnitRadius
local GetUnitViewPosition = Spring.GetUnitViewPosition
local GetUnitBasePosition = Spring.GetUnitBasePosition
local IsUnitVisible       = Spring.IsUnitVisible
local IsUnitSelected      = Spring.IsUnitSelected
local GetGroundNormal     = Spring.GetGroundNormal

local glColor          = gl.Color
local glDrawListAtUnit = gl.DrawListAtUnit

function widget:DrawWorldPreUnit()
    local selUnits = Spring.GetSelectedUnits()  --  FIXME -- Use UnitsInPlanes()?

  gl.LineWidth(2.5)
  gl.DepthTest(false)

--  gl.Texture(false)
--  gl.AlphaTest(false)

  gl.PolygonOffset(-50, 1000)

  local lastColorSet = nil
  for _,unitID in ipairs(selUnits) do
    if (IsUnitVisible(unitID)) then
      local teamID = GetUnitTeam(unitID)
      if (teamID) then
        local radius = 1.2*GetUnitRadius(unitID)
        if (radius) then
          local colorSet  = teamColors[teamID]
          if (trackSlope) then
            local x, y, z = GetUnitBasePosition(unitID)
            local gx, gy, gz = GetGroundNormal(x, z)
            local degrot = math.acos(gy) * 180 / math.pi
            if (colorSet) then
              glColor(colorSet[2])
              glDrawListAtUnit(unitID, circleLines, false,
                               radius, 1.0, radius,
                               degrot, gz, 0, -gx)
            else
              local r,g,b = Spring.GetTeamColor(teamID)
              teamColors[teamID] = {{ r, g, b, 0.4 },
                                    { r, g, b, 0.5 }}
            end
          end
        else
          if (colorSet) then
            glColor(colorSet[2])
            glDrawListAtUnit(unitID, circleLines, false,
                             radius, 1.0, radius)
          else
            local r,g,b = Spring.GetTeamColor(teamID)
            teamColors[teamID] = {{ r, g, b, 0.4 },
                                  { r, g, b, 0.5 }}
          end
        end
      end
    end
  end
end
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------