----------------------------------------------------------------------------------------------------
--                                        Local constants                                         --
----------------------------------------------------------------------------------------------------
local mapRatio = Game.mapX / Game.mapY

----------------------------------------------------------------------------------------------------
--                                        Local variables                                         --
----------------------------------------------------------------------------------------------------
local globalSize = 2.5
local imageW, imageH = 21 * globalSize, 16 * globalSize
local imageOffset = 5
local imageInRow = 3

local labelH = 20

local rowSize = imageW * imageInRow + imageOffset * ( imageInRow + 1 )
local totalW = rowSize + 21

local mainX, mainY = 0, 0
local minimapX, minimapY = 0, 0
local minimapW, minimapH = rowSize, 0
local minimapOffset = 2

local minimapWidget

----------------------------------------------------------------------------------------------------
--                                      Function declarations                                     --
----------------------------------------------------------------------------------------------------
local function CreateMinimapWidget() end

local function UpdateMinimapGeometry() end
local function RenderMinimap() end
local function ResetWidget() end

local function ReadSettings() end
----------------------------------------------------------------------------------------------------
--                          Shortcut to used global functions to speedup                          --
----------------------------------------------------------------------------------------------------
local glDrawMiniMap		= gl.DrawMiniMap
local glResetState		= gl.ResetState
local glResetMatrices	= gl.ResetMatrices

local glPushAttrib	= gl.PushAttrib
local glMatrixMode	= gl.MatrixMode
local glPushMatrix	= gl.PushMatrix
local glTranslate	= gl.Translate
local glScale		= gl.Scale
local glPopMatrix	= gl.PopMatrix
local glPopAttrib	= gl.PopAttrib

local GL_ALL_ATTRIB_BITS = GL.ALL_ATTRIB_BITS
local GL_PROJECTION = GL.PROJECTION
local GL_MODELVIEW = GL.MODELVIEW

local glColor 		= gl.Color
local glRect		= gl.Rect

local SpSendCommands	= Spring.SendCommands
local SpGetCameraState	= Spring.GetCameraState

local math_floor	= math.floor
local string_format	= string.format
----------------------------------------------------------------------------------------------------
--                                       NotAchili UI shortcuts                                       --
----------------------------------------------------------------------------------------------------
local NotAchili
local Button
local Label
local Colorbars
local Checkbox
local Window
local ScrollPanel
local StackPanel
local LayoutPanel
local Panel
local Grid
local Trackbar
local TextBox
local Image
local Progressbar
local Colorbars
local Control
local screen0

----------------------------------------------------------------------------------------------------
--                                         Implementation                                         --
----------------------------------------------------------------------------------------------------
function CreateMinimapWidget()
	
	-- setup NotAchili
	NotAchili = WG.NotAchili
	Button = NotAchili.Button
	Label = NotAchili.Label
	Colorbars = NotAchili.Colorbars
	Checkbox = NotAchili.Checkbox
	Window = NotAchili.Window
	ScrollPanel = NotAchili.ScrollPanel
	StackPanel = NotAchili.StackPanel
	LayoutPanel = NotAchili.LayoutPanel
	Panel = NotAchili.Panel
	Grid = NotAchili.Grid
	Trackbar = NotAchili.Trackbar
	TextBox = NotAchili.TextBox
	Image = NotAchili.Image
	Progressbar = NotAchili.Progressbar
	Colorbars = NotAchili.Colorbars
	Control = NotAchili.Control
	screen0 = NotAchili.Screen0
	
	ReadSettings()
	
	minimapWidget = Panel:New{
		parent = screen0,
		x = mainX, y = mainY,
		width = totalW, height = minimapH,
	}
	
	SS44_UI.minimapWidget = minimapWidget
	
	UpdateMinimapGeometry()
end

----------------------------------------------------------------------------------------------------
function UpdateMinimapGeometry()
	
	local minimapW, minimapH = minimapW - minimapOffset * 2, minimapH - minimapOffset * 2
			
	local minimapRatio = minimapW / minimapH
	
	local mapX, mapY, mapH, mapW
	--Spring.Echo( minimapRatio, mapRatio )
	if( minimapRatio < mapRatio ) then
		mapW = minimapW
		mapH = math_floor( minimapH * minimapRatio / mapRatio + .5 )
		mapX = minimapX + minimapOffset
		mapY = math_floor( minimapY + ( minimapH - mapH ) / 2 + .5 ) + minimapOffset
	else
		mapW = math_floor( minimapW * mapRatio / minimapRatio + .5 )
		mapH = minimapH
		mapX = math_floor( minimapX + ( minimapW - mapW ) / 2 + .5 ) + minimapOffset
		mapY = minimapY + minimapOffset
	end
	
	SpSendCommands( { string_format( "minimap geometry %i %i %i %i", 
		mapX, mapY, mapW, mapH ) } )
end

----------------------------------------------------------------------------------------------------

function RenderMinimap()
	
	glDrawMiniMap()
	glResetState()
	glResetMatrices()
	
	--[[
	glPushAttrib(GL_ALL_ATTRIB_BITS)
	glMatrixMode(GL_PROJECTION)
	glPushMatrix()
	glMatrixMode(GL_MODELVIEW)
	glPushMatrix()
	glTranslate( 0, screen0.height, 0 )
	glScale( 1, -1, 1 )

	glDrawMiniMap()

	glMatrixMode(GL_PROJECTION)
	glPopMatrix()
	glMatrixMode(GL_MODELVIEW)
	glPopMatrix()
	glPopAttrib()
	--]]
end

----------------------------------------------------------------------------------------------------
function ResetWidget()
	if minimapWidget then
		minimapWidget:Dispose()
	end
	
	CreateMinimapWidget()
end

----------------------------------------------------------------------------------------------------
function ReadSettings()
	globalSize = SS44_UI.globalSize

	imageW = SS44_UI.imageW 
	imageH = SS44_UI.imageH
	imageOffset = SS44_UI.imageOffset
	imageInRow = SS44_UI.imageInRow

	labelH = SS44_UI.labelH
	
	rowSize = SS44_UI.rowSize
	totalW = SS44_UI.totalW
	
	minimapW = totalW
	minimapH = SS44_UI.minimapH
	
	minimapOffset = SS44_UI.skinMargin
end

----------------------------------------------------------------------------------------------------
--                     Export constants and functions, used in other modules                      --
----------------------------------------------------------------------------------------------------
MINIMAP_WIDGET = {
	CreateMinimapWidget		= CreateMinimapWidget,
	RenderMinimap			= RenderMinimap,
	UpdateMinimapGeometry	= UpdateMinimapGeometry,
	ResetWidget				= ResetWidget,
}
----------------------------------------------------------------------------------------------------