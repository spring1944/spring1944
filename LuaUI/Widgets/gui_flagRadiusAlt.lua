function widget:GetInfo()
  return {
    name      = "1944 Flag Ranges",
    desc      = "Shows a flag's capping radius and team colour",
    author    = "CarRepairer",
    date      = "2009-08-08",
    license   = "GNU GPL v2",
    layer     = 5,
    enabled   = true  --  loaded by default?
  }
end

-- function localisations
-- Synced Read
--local GetGroundNormal     = Spring.GetGroundNormal
local GetTeamUnitsByDefs 	= Spring.GetTeamUnitsByDefs
local GetUnitBasePosition = Spring.GetUnitBasePosition
local GetUnitTeam         = Spring.GetUnitTeam
local GetUnitViewPosition = Spring.GetUnitViewPosition
local GetUnitRulesParam		= Spring.GetUnitRulesParam
-- Unsynced Read
local IsUnitVisible       = Spring.IsUnitVisible
-- OpenGL
local glColor          		= gl.Color
local glDrawGroundCircle          		= gl.DrawGroundCircle

-- constants
local FLAG_DEF_ID					= UnitDefNames["flag"].id
local FLAG_RADIUS					= 230 -- current flagkiller weapon radius, we may want to open this up to modoptions
local FLAG_CAP_THRESHOLD	= 10 -- number of capping points needed for a flag to switch teams, again possibilities for modoptions

local loop = 20
local alphamax = 0.8


-- variables
local teamColors = {}
local flags = {}
local teams									= Spring.GetTeamList()

local alphavals = {}

function widget:Initialize()
	-- pre-cache team colours
	for i = 1, #teams do
		local teamID = teams[i]
		local r,g,b = Spring.GetTeamColor(teamID)
		teamColors[teamID] = {{ r, g, b, alphamax },{ r, g, b, alphamax }}
	end
	
	for i=0,loop do
		alphavals[i] = alphamax - math.log(i) / math.log(loop) * alphamax 
	end
end


function widget:Shutdown()
end


function widget:DrawWorldPreUnit()
  gl.DepthTest(false)
	for i = 1, #teams do
		teamID = teams[i]
		teamFlags = GetTeamUnitsByDefs (teamID, FLAG_DEF_ID)
		if teamFlags then
			for j = 1, #teamFlags do
				unitID = teamFlags[j]
				if (IsUnitVisible(unitID, FLAG_RADIUS, true) ) then
					local colorSet  = teamColors[teamID]
					local x, y, z = GetUnitBasePosition(unitID)
					gl.LineWidth(1)
					
					local coltemp = colorSet[1]
					for i=0,loop do
						glColor({coltemp[1], coltemp[2], coltemp[3], alphavals[i]})
						glDrawGroundCircle(x,y,z, FLAG_RADIUS-i, 48)
					end
					
					for j = 1, #teams do
						capTeamID = teams[j]
						teamCapValue = GetUnitRulesParam(unitID, "cap" .. tostring(capTeamID))
						if (teamCapValue or 0) > 0 then
							colorSet = teamColors[capTeamID]
							local capVisualRadius = (FLAG_RADIUS - 5)/ FLAG_CAP_THRESHOLD * teamCapValue
							local coltemp = colorSet[2]
							for i=0,loop do
								glColor({coltemp[1], coltemp[2], coltemp[3], alphavals[i], })
								glDrawGroundCircle(x,y,z, capVisualRadius-i, 48)		
							end
							
							
						end
					end
				end
			end
		end
	end
end
