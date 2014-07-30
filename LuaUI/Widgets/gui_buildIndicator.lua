function widget:GetInfo()
  return {
    name      = "1944 Build Indicators",
    desc      = "Indicates when engineers are building",
    author    = "FLOZi, modified from gui_teamCircle.lua by trepan",
    date      = "22nd December 2008",
    license   = "GNU GPL v2",
    layer     = 5,
    enabled   = true  --  loaded by default?
  }
end

-- function localisations
-- Synced Read
local GetGroundNormal     	= Spring.GetGroundNormal
local GetUnitBasePosition 	= Spring.GetUnitBasePosition
local GetGameSeconds				=	Spring.GetGameSeconds
local GetUnitTeam						= Spring.GetUnitTeam
local GetUnitIsBuilding			= Spring.GetUnitIsBuilding
-- Unsynced Read
local IsUnitVisible      	 	= Spring.IsUnitVisible
-- OpenGL
local glColor          			= gl.Color

-- constants
local LINE_OFFSET 					= 0		-- y-offset
local DEFAULT_SUPPLY_RANGE	=	300 -- This should never have to be used, but just in case
local LINE_ALPHA						= 0.9	-- alpha value of supply range line
local LINE_WIDTH						= 2		-- width of supply range line

-- variables
local builders = {}
local teamColors = {}
local teams									= Spring.GetTeamList()

function widget:Initialize()
	-- pre-cache team colours
	for i = 1, #teams do
		local teamID = teams[i]
		local r,g,b = Spring.GetTeamColor(teamID)
		teamColors[teamID] = { r, g, b, LINE_ALPHA }
	end
end

function widget:UnitCreated(unitID, unitDefID, unitTeam, builderID)
	local ud = UnitDefs[unitDefID]
	if ud.buildDistance then
		--table.insert(builders, unitID)
		builders[unitID] = true
	end
end

function widget:UnitDestroyed(unitID)
	builders[unitID] = nil
end


function widget:DrawWorldPreUnit()
  gl.DepthTest(false)
  --gl.PolygonOffset(-50, 1000)
	gl.LineWidth(LINE_WIDTH)
	
  local lastColorSet = nil

	--for i = 1, #builders  do
		--builderID = builders[i]
	for builderID, yes in pairs(builders) do
		if yes then
			beingBuiltID = GetUnitIsBuilding(builderID)
			if beingBuiltID then
				local x, y, z = GetUnitBasePosition(builderID)
				local x1, y1, z1 = GetUnitBasePosition(beingBuiltID)
				--Spring.Echo(x, y, z)
				--Spring.Echo(x1, y1, z1)
				local colorSet = teamColors[GetUnitTeam(builderID)]
				glColor(colorSet)
				gl.LineStipple("default")
				gl.BeginEnd(GL.LINES, function()
					gl.Vertex(x, y, z)
					gl.Vertex(x1, y1, z1)
				end)
				gl.LineStipple(false)
			end
		end
  end
end
