--related thread: http://springrts.com/phpbb/viewtopic.php?f=13&t=26732&start=22
function widget:GetInfo()
  return {
    name = "External VR Grid",
    desc = "VR grid around map",
    author = "knorke, tweaked by KR",
    date = "Sep 2011",
    license = "PD",
    layer = -3,
    enabled = true,
    detailsDefault = 3
  }
end

local DspLst=nil
local localAllyID = Spring.GetLocalAllyTeamID ()
local gridTex = "LuaUI/Images/vr_grid.png"
local mirror = true

-- speedups
local math = math
local random = math.random
local spGetGroundHeight = Spring.GetGroundHeight
local glVertex = gl.Vertex
local glTexCoord = gl.TexCoord
local glColor = gl.Color
local glCreateList = gl.CreateList
local glTexRect = gl.TexRect
----------------------

local heights = {}
local island = false

options_path = 'Settings/View/Map/Configure VR Grid'
options_order = {"mirrorHeightMap","drawForIslands","res","range"}
options = {
	mirrorHeightMap = {
		name = "Mirror heightmap",
		type = 'bool',
		value = true,
		desc = 'Mirrors heightmap on the grid',
		OnChange = function(self)
			gl.DeleteList(DspLst)
			widget:Initialize()
		end,            
	},
	drawForIslands = {
		name = "Draw for islands",
		type = 'bool',
		value = Spring.GetConfigInt("ReflectiveWater", 0) ~= 4,
		desc = "Draws grid for islands",                
	},      
	res = {
		name = "Resolution (32-512)",
		advanced = true,
		type = 'number',
		min = 64, 
		max = 512, 
		step = 64,
		value = 128,
		desc = 'Sets resolution (lower = more detail)',
		OnChange = function(self)
			gl.DeleteList(DspLst)
			widget:Initialize()
		end, 
	},
	range = {
		name = "Range (1024-8192)",
		advanced = true,
		type = 'number',
		min = 1024, 
		max = 8192, 
		step = 256,
		value = 8192,
		desc = 'How far outside the map to draw',
		OnChange = function(self)
			gl.DeleteList(DspLst)
			widget:Initialize()
		end, 
	},              
}

local function GetGroundHeight(x, z)
	return heights[x] and heights[x][z] or spGetGroundHeight(x,z)
end

local function IsIsland()
	local sampleDist = 640
	for i=1,Game.mapSizeX,sampleDist do
		-- top edge
		if GetGroundHeight(i, 0) > 0 then
			return false
		end
		-- bottom edge
		if GetGroundHeight(i, Game.mapSizeZ) > 0 then
			return false
		end
	end
	for i=1,Game.mapSizeZ,sampleDist do
		-- left edge
		if GetGroundHeight(0, i) > 0 then
			return false
		end
		-- right edge
		if GetGroundHeight(Game.mapSizeX, i) > 0 then
			return false
		end     
	end
	return true
end

local function InitGroundHeights()
	local res = options.res.value or 128
	local range = (options.range.value or 8192)/res
	local TileMaxX = Game.mapSizeX/res +1
	local TileMaxZ = Game.mapSizeZ/res +1
	
	for x = (-range)*res,Game.mapSizeX+range*res, res do
		heights[x] = {}
		for z = (-range)*res,Game.mapSizeZ+range*res, res do
			local px, pz
			if mirror then
				if (x < 0 or x > Game.mapSizeX) then -- outside X map bounds; mirror true heightmap
					local xAbs = math.abs(x)
					local xFrac = (Game.mapSizeX ~= xAbs) and x%(Game.mapSizeX) or Game.mapSizeX
					local xFlip = -1^math.floor(x/Game.mapSizeX)
					if xFlip == -1 then
						px = Game.mapSizeX - xFrac
					else
						px = xFrac
					end
				end
				if (z < 0 or z > Game.mapSizeZ) and mirror  then -- outside Z map bounds; mirror true heightmap
					local zAbs = math.abs(z)
					local zFrac = (Game.mapSizeZ ~= zAbs) and z%(Game.mapSizeZ) or Game.mapSizeZ
					local zFlip = -1^math.floor(z/Game.mapSizeZ)
					if zFlip == -1 then
						pz = Game.mapSizeZ - zFrac
					else
						pz = zFrac
					end                             
				end
			end
			heights[x][z] = GetGroundHeight(px or x, pz or z) -- 20, 0
		end
	end
end

local function TilesVerticesOutside()
	local res = options.res.value or 128
	local range = (options.range.value or 8192)/res
	local TileMaxX = Game.mapSizeX/res +1
	local TileMaxZ = Game.mapSizeZ/res +1   
	for x=-range,TileMaxX+range,1 do
		for z=-range,TileMaxZ+range,1 do
			if (x > 0 and z > 0 and x < TileMaxX and z < TileMaxZ) then 
			else
				glTexCoord(0,0)
				glVertex(res*(x-1), GetGroundHeight(res*(x-1),res*z), res*z)
				glTexCoord(0,1)
				glVertex(res*x, GetGroundHeight(res*x,res*z), res*z)
				glTexCoord(1,1)                         
				glVertex(res*x, GetGroundHeight(res*x,res*(z-1)), res*(z-1))
				glTexCoord(1,0)
				glVertex(res*(x-1), GetGroundHeight(res*(x-1),res*(z-1)), res*(z-1))
			end
		end
	end
end

local function DrawTiles()
	gl.PushAttrib(GL.ALL_ATTRIB_BITS)
	gl.DepthTest(true)
	gl.DepthMask(true)
	gl.Texture(gridTex)
	gl.BeginEnd(GL.QUADS,TilesVerticesOutside)
	gl.Texture(false)
	gl.DepthMask(false)
	gl.DepthTest(false)
	glColor(1,1,1,1)
	gl.PopAttrib()
end

function widget:DrawWorld()
	if (not island) or options.drawForIslands.value then
		gl.CallList(DspLst)-- Or maybe you want to keep it cached but not draw it everytime.
		-- Maybe you want Spring.SetDrawGround(false) somewhere
	end     
end

function widget:Initialize()
	island = IsIsland()
	InitGroundHeights()
	DspLst = glCreateList(DrawTiles)
end

function widget:Shutdown()
	gl.DeleteList(DspList)
end