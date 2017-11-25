function widget:GetInfo()
  return {
    name      = "1944 Flag Ranges",
    desc      = "Shows a flag's capping radius and team colour",
    author    = "CarRepairer and Evil4Zerggin",
    date      = "28 August 2009",
    license   = "GNU GPL v2",
    layer     = 5,
    enabled   = true  --  loaded by default?
  }
end

-- function localisations
-- Synced Read
--local GetGroundNormal     = Spring.GetGroundNormal
local GetTeamUnitsByDefs   = Spring.GetTeamUnitsByDefs
local GetUnitBasePosition = Spring.GetUnitBasePosition
local GetUnitTeam         = Spring.GetUnitTeam
local GetUnitViewPosition = Spring.GetUnitViewPosition
local GetUnitRulesParam    = Spring.GetUnitRulesParam
local GetTeamColor = Spring.GetTeamColor --cacheing not appreciably faster, if at all
-- Unsynced Read
local IsUnitInView       = Spring.IsUnitInView

-- OpenGL
local glCallList =  gl.CallList
local glShape = gl.Shape
local glPushMatrix = gl.PushMatrix
local glPopMatrix = gl.PopMatrix
local glTranslate = gl.Translate
local glScale = gl.Scale
local GL_QUAD_STRIP = GL.QUAD_STRIP

local PI = math.pi
local sin, cos = math.sin, math.cos

-- constants
local CAPTURABLE_DEF_IDS = { UnitDefNames["flag"].id, UnitDefNames["buoy"].id }
local FLAG_RADIUS          = 230 -- current flagkiller weapon radius, we may want to open this up to modoptions
local FLAG_CAP_THRESHOLD  = 10 -- number of capping points needed for a flag to switch teams, again possibilities for modoptions

local maxAlpha = 0.5
local innerSize = 0.875
local circleDivs = 64
local circleInc = 2 * PI / circleDivs

-- variables
local flags = {}
local teams = Spring.GetTeamList()

local alphavals = {}

local circleLists = {}

local function DrawTeamCircle(teamID)
  local vertices = {}
  local r, g, b = GetTeamColor(teamID)
  
  for i = 0, circleDivs do
    local angle = i * circleInc
    local ox = cos(angle)
    local oz = sin(angle)
    local ix = ox * innerSize
    local iz = oz * innerSize
    vertices[2*i+1] = { v = {ix, 0, iz}, c = {r, g, b, 0} }
    vertices[2*i+2] = { v = {ox, 0, oz}, c = {r, g, b, maxAlpha} }
  end
  
  glShape(GL_QUAD_STRIP, vertices)
end

function widget:Initialize()
  local glCreateList = gl.CreateList
  for i = 1, #teams do
    local teamID = teams[i]
    circleLists[teamID] = glCreateList(DrawTeamCircle, teamID, FLAG_RADIUS)
  end
end

function widget:Shutdown()
  local glDeleteList = gl.DeleteList
  for i = 1, #teams do
    local teamID = teams[i]
    glDeleteList(circleLists[teamID])
  end
end

function widget:DrawWorldPreUnit()

  for i = 1, #teams do
    local teamID = teams[i]
    local teamFlags = {}

    for _, flagTypeDefID in pairs(CAPTURABLE_DEF_IDS) do
      local flagTypeTeamUnits = GetTeamUnitsByDefs(teamID, flagTypeDefID)
      for index, unitID in pairs(flagTypeTeamUnits) do
        table.insert(teamFlags, unitID)
      end
    end

    if teamFlags then
      for j = 1, #teamFlags do
        unitID = teamFlags[j]
        if IsUnitInView(unitID, FLAG_RADIUS, true) then
          local x, y, z = GetUnitBasePosition(unitID)
          glPushMatrix()
            glTranslate(x, y, z)
            glScale(FLAG_RADIUS, 1, FLAG_RADIUS)
            glCallList(circleLists[teamID])
          
            for j = 1, #teams do
              local capTeamID = teams[j]
              local teamCapValue = GetUnitRulesParam(unitID, "cap" .. tostring(capTeamID))
              if (teamCapValue or 0) > 0 then
                local scale = teamCapValue / FLAG_CAP_THRESHOLD
                glPushMatrix()
                  glScale(scale, 1, scale)
                  glCallList(circleLists[capTeamID])
                glPopMatrix()
              end
            end
          
          glPopMatrix()
        end
      end
    end
  end
  
end

function widget:UnitTaken(unitID, unitDefID, unitTeam, newTeam)
	local ud = UnitDefs[unitDefID]
	if ud.name == "flag" then
		if unitTeam == Spring.GetMyPlayerID() then
			local x,y,z = Spring.GetUnitPosition(unitID)
			Spring.PlaySoundFile("sounds/Weapons/GEN_Explo_Flag.wav", 1, x, y, z)
		end
	end
end
