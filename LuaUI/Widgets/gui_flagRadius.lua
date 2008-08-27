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
-- Synced Read
local GetGroundNormal     = Spring.GetGroundNormal
local GetTeamUnitsByDefs 	= Spring.GetTeamUnitsByDefs
local GetUnitBasePosition = Spring.GetUnitBasePosition
local GetUnitTeam         = Spring.GetUnitTeam
local GetUnitViewPosition = Spring.GetUnitViewPosition
local GetUnitRulesParam		= Spring.GetUnitRulesParam
-- Unsynced Read
local IsUnitVisible       = Spring.IsUnitVisible
-- OpenGL
local glColor          		= gl.Color
local glDrawListAtUnit 		= gl.DrawListAtUnit

-- constants
local GAIA_TEAM_ID				= Spring.GetGaiaTeamID()
local FLAG_DEF_ID					= UnitDefNames["flag"].id
local FLAG_RADIUS					= 230 -- current flagkiller weapon radius, we may want to open this up to modoptions
local FLAG_CAP_THRESHOLD	= 10 -- number of capping points needed for a flag to switch teams, again possibilities for modoptions
local CIRCLE_DIVS   			= 32	-- How many sides in our 'circle'
local CIRCLE_OFFSET 			= 0		-- y-offset
local CIRCLE_LINES  			= 0		-- display list containing circle
local LINE_ALPHA_CAP			= 0.9	-- alpha value of capping indicator line
local LINE_ALPHA_RADIUS		= 0.5	-- alpha value of radius line
local LINE_WIDTH_CAP			= 10	-- width of capping indicator line (this is limited either by hardware or the lua opengl implementation)
local LINE_WIDTH_RADIUS		= 5		-- width of radius line

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
		gl.LineStipple(false)
  end)
	-- pre-cache team colours
	for i = 1, #teams do
		local teamID = teams[i]
		local r,g,b = Spring.GetTeamColor(teamID)
		teamColors[teamID] = {{ r, g, b, LINE_ALPHA_RADIUS },
													{ r, g, b, LINE_ALPHA_CAP }}
	end
end


function widget:Shutdown()
  gl.DeleteList(CIRCLE_LINES)
end


function widget:DrawWorldPreUnit()
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
					glColor(colorSet[1])
					gl.LineWidth(LINE_WIDTH_RADIUS)
					glDrawListAtUnit(unitID, CIRCLE_LINES, false,
													FLAG_RADIUS, 1.0, FLAG_RADIUS,
													degrot, gz, 0, -gx)
					for j = 1, #teams do
						capTeamID = teams[j]
						teamCapValue = GetUnitRulesParam(unitID, "cap" .. tostring(capTeamID))
						--Spring.Echo(teamCapValue)
						if (teamCapValue or 0) > 0 then
							colorSet = teamColors[capTeamID]
							glColor(colorSet[2])
							gl.LineWidth(LINE_WIDTH_CAP)
							local capVisualRadius = (FLAG_RADIUS - 5)/ FLAG_CAP_THRESHOLD * teamCapValue
							glDrawListAtUnit(unitID, CIRCLE_LINES, false,
															capVisualRadius, 1.0, capVisualRadius,
															degrot, gz, 0, -gx)
						end
					end
        end
      end
    end
  end
end
