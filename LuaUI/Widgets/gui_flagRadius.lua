function widget:GetInfo()
  return {
    name      = "1944 Flag Ranges",
    desc      = "Shows a flag's capping radius and team colour",
    author    = "FLOZi, modified from gui_teamCircle.lua by trepan",
    date      = "11th August 2008",
    license   = "GNU GPL, v2 or later",
    layer     = 5,
    enabled   = false  --  loaded by default?
  }
end

-- function localisations
local GetUnitTeam         = Spring.GetUnitTeam
local GetUnitViewPosition = Spring.GetUnitViewPosition
local GetUnitBasePosition = Spring.GetUnitBasePosition
local IsUnitVisible       = Spring.IsUnitVisible
local GetGroundNormal     = Spring.GetGroundNormal
local GetTeamUnitsByDefs 	= Spring.GetTeamUnitsByDefs
-- OpenGL
local glColor          = gl.Color
local glDrawListAtUnit = gl.DrawListAtUnit

-- constants
local GAIA_TEAM_ID					= Spring.GetGaiaTeamID()
local FLAG_DEF_ID						= UnitDefNames["flag"].id
local FLAG_RADIUS						= 230 -- current flagkiller weapon radius, we may want to open this up to modoptions
local CIRCLE_DIVS   				= 32	-- How many sides in our 'circle'
local CIRCLE_OFFSET 				= 0		-- y-offset
local CIRCLE_LINES  				= 0		-- display list containing circle

-- variables
local teamColors = {}
local flags = {}
local teams									= Spring.GetTeamList()

function widget:Initialize()
  CIRCLE_LINES = gl.CreateList(function()
		gl.LineStipple("default")
    gl.BeginEnd(GL.LINE_LOOP, function()
      local radstep = (2.0 * math.pi) / CIRCLE_DIVS
      for i = 1, CIRCLE_DIVS do
        local a = (i * radstep)
        gl.Vertex(math.sin(a), CIRCLE_OFFSET, math.cos(a))
      end
    end)
  end)
end

function widget:Shutdown()
  gl.DeleteList(CIRCLE_LINES)
end

function widget:DrawWorldPreUnit()
  gl.LineWidth(5)
  gl.DepthTest(false)
  gl.PolygonOffset(-50, 1000)

  local lastColorSet = nil

	for i = 1, #teams do
		teamID = teams[i]
		teamFlags = GetTeamUnitsByDefs (teamID, FLAG_DEF_ID)
		if teamFlags then
			for j = 1, #teamFlags do
				unitID = teamFlags[j]
				if (IsUnitVisible(unitID)) then
					local colorSet  = teamColors[teamID]
					local x, y, z = GetUnitBasePosition(unitID)
					local gx, gy, gz = GetGroundNormal(x, z)
					local degrot = math.acos(gy) * 180 / math.pi
					if (colorSet) then
						glColor(colorSet[2])
						glDrawListAtUnit(unitID, CIRCLE_LINES, false,
														FLAG_RADIUS, 1.0, FLAG_RADIUS,
														degrot, gz, 0, -gx)
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
