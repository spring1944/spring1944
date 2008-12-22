function widget:GetInfo()
  return {
    name      = "1944 Supply Ranges",
    desc      = "Shows a ammo suppliers radius",
    author    = "FLOZi, modified from gui_teamCircle.lua by trepan",
    date      = "11th August 2008",
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
-- Unsynced Read
local IsUnitVisible      	 	= Spring.IsUnitVisible
-- OpenGL
local glColor          			= gl.Color
local glDrawListAtUnit 			= gl.DrawListAtUnit

-- constants
local CIRCLE_DIVS   				= 64	-- How many sides in our 'circle'
local CIRCLE_OFFSET 				= 0		-- y-offset
local CIRCLE_LINES  				= 0		-- display list containing circle
local DEFAULT_SUPPLY_RANGE	=	300 -- This should never have to be used, but just in case
local LINE_ALPHA_SUPPLY			= 0.1	-- alpha value of supply range line
local LINE_WIDTH_SUPPLY			= 10	-- width of supply range line
local ROTATION_SPEED_MULT		= 4

-- variables
local color  = { 1.0, 1.0, 0.25, LINE_ALPHA_SUPPLY }
local ammoSuppliers = {}

function widget:Initialize()
  CIRCLE_LINES = gl.CreateList(function()
		gl.LineStipple(5,0xFF)
    gl.BeginEnd(GL.LINE_LOOP, function()
      local radstep = (2.0 * math.pi) / CIRCLE_DIVS
      for i = 1, CIRCLE_DIVS do
					local a = (i * radstep)
					gl.Vertex(math.sin(a), CIRCLE_OFFSET, math.cos(a))
      end
    end)
		gl.LineStipple(false)
  end)
end


function widget:Shutdown()
  gl.DeleteList(CIRCLE_LINES)
end

function widget:UnitCreated(unitID, unitDefID, unitTeam, builderID)
	local ud = UnitDefs[unitDefID]
	if ud.customParams.ammosupplier == '1' then
		ammoSuppliers[unitID] = ud.customParams.supplyrange or DEFAULT_SUPPLY_RANGE
		--Spring.Echo(ammoSuppliers[unitID])
	end
end

function widget:UnitDestroyed(unitID)
	ammoSuppliers[unitID] = nil
end


function widget:DrawWorldPreUnit()
  gl.DepthTest(false)
  gl.PolygonOffset(-50, 1000)
	glColor(color)
	gl.LineWidth(LINE_WIDTH_SUPPLY)
	
  local lastColorSet = nil

	for unitID, supplyRange in pairs(ammoSuppliers) do
		if IsUnitVisible(unitID) then
			local x, y, z = GetUnitBasePosition(unitID)
			--local gx, gy, gz = GetGroundNormal(x, z)
			--local degrot = math.acos(gy) * 180 / math.pi
			local rotation = (GetGameSeconds() * ROTATION_SPEED_MULT) % 360
			glDrawListAtUnit(unitID, CIRCLE_LINES, false,
											supplyRange, 1.0, supplyRange,
											--degrot, gz, 0, -gx)
											rotation, 0, 1, 0)
    end
  end
end
