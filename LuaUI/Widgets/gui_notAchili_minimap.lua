----------------------------------------------------------------------------------------------------
--                                            Nota UI                                             --
----------------------------------------------------------------------------------------------------
function widget:GetInfo()
	return {
		name	= "Nota Minimap",
		desc	= "Cool minimap",
		author	= "a1983",
		date	= "01 08 2013",
		license	= "GPL",
		layer	= math.huge,
		handler	= true, -- used widget handlers
		enabled	= true  -- loaded by default
	}
end

----------------------------------------------------------------------------------------------------
--                                        Local constants                                         --
----------------------------------------------------------------------------------------------------
local mapRatio = Game.mapX / Game.mapY

local imagesPath = "LuaUI/Widgets/notAchili/ss44UI/images/minimap/"
local panelTexture = imagesPath .. "panel_carbon.png"
local buttonTextures = {
	["normal"]				= imagesPath .. "normal.png",
	["normal_hovered"]		= imagesPath .. "normal_hovered.png",
	["disabled"]			= imagesPath .. "disabled.png",
	["disabled_hovered"]	= imagesPath .. "disabled_hovered.png",
	["clicked"]				= imagesPath .. "clicked.png"
}

local minUpdateInterval = 0.02

----------------------------------------------------------------------------------------------------
--                                        Local variables                                         --
----------------------------------------------------------------------------------------------------
local oldMinimapGeometry
local screenWidth, screenHeight = 0, 0

local lastUpdateInterval = 0.0
local animations = {}

local globalSize = 2.5

local minimapLeft, minimapTop = 0, 0
local minimapWidth, minimapHeight = 260, 220

local offsetLeft, offsetTop = 17, 10
local offsetRight, offsetBottom = 60, 10

local boxLeft, boxTop = 210, 0
local boxRight, boxBottom = 250, 220
local buttonWidth, buttonHeight = 32, 32
local buttonOffset = 6

local function CreateButton( name, icon, ClickFunction )
	return {
		name	= name,
		icon	= imagesPath .. icon,
		state	= "normal",
		drawBox = { 0, 0, 0, 0 },
		texture = buttonTextures[ "normal" ],
		OnClick = ClickFunction,
		animation = nil,
	}
end

local minimapPanel = {
	needRedraw	= true,
	drawList	= nil,
	drawBox		= {
		minimapLeft,
		minimapTop,
		minimapLeft + minimapWidth,
		minimapTop + minimapHeight
	},
	texture		= panelTexture,
	buttonBox = {
		drawBox = { boxLeft, boxTop, boxRight, boxBottom },
		buttons = {
			CreateButton( "LosView", "map_los.png", function()
				Spring.SendCommands( "togglelos" )
			end ),
			CreateButton( "RadarView", "map_radar.png", function()
				if Spring.GetMapDrawMode() ~= "los" then
					Spring.SendCommands( "togglelos" )
				end
				Spring.SendCommands( "toggleradarandjammer" )
			end ),
			CreateButton( "Elevation", "map_elevation.png", function()
				Spring.SendCommands( "showelevation" )
			end ),
			CreateButton( "TraverseAbility", "map_traversability.png", function()
				Spring.SendCommands( "showpathtraversability" )
			end ),
			CreateButton( "Resource", "map_resource.png", function()
				Spring.SendCommands( "showmetalmap" )
			end ),
		},
	},
}
----------------------------------------------------------------------------------------------------
--                                            Includes                                            --
----------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------
--                                        Local functions                                         --
----------------------------------------------------------------------------------------------------
local UpdateMinimapGeometry
local UpdateButtonBoxGeometry
local RenderMinimap
local RenderUI
local ClearUI
local CreateUI
local RenderBox
local RenderButtonBox
local ProcessAnimation
local CoordInBox
local EnterButton
local LeaveButton
local ReadSettings

----------------------------------------------------------------------------------------------------
--                                        Global variables                                        --
----------------------------------------------------------------------------------------------------
if not WG.SS44_UI then
	WG.SS44_UI = {}
end

WG.SS44_UI.minimapOffset = minimapHeight

WG.SS44_UI.ResetMinimapWidget = function()
	globalSize = WG.SS44_UI.globalSize or 2.5

	ReadSettings()
	UpdateMinimapGeometry()
	UpdateButtonBoxGeometry()
end

----------------------------------------------------------------------------------------------------
--                          Shortcut to used global functions to speedup                          --
----------------------------------------------------------------------------------------------------
local glDrawMiniMap		= gl.DrawMiniMap
local glResetState		= gl.ResetState
local glResetMatrices	= gl.ResetMatrices

local glCreateList		= gl.CreateList
local glCallList		= gl.CallList
local glDeleteList		= gl.DeleteList

local glPushMatrix		= gl.PushMatrix
local glPopMatrix		= gl.PopMatrix
local glTranslate		= gl.Translate
local glScale			= gl.Scale

local glColor			= gl.Color
local glTexture			= gl.Texture
local glTexRect			= gl.TexRect

local SpSendCommands	= Spring.SendCommands
local SpGetCameraState	= Spring.GetCameraState

local SpGetMapDrawMode	= Spring.GetMapDrawMode

local math_floor	= math.floor
local string_format	= string.format


----------------------------------------------------------------------------------------------------
--                                         WIDGET CALLINS                                         --
----------------------------------------------------------------------------------------------------
function widget:Initialize()
	-- set minimap handler
	oldMinimapGeometry = Spring.GetConfigString( "MiniMapGeometry", "2 2 200 200" )
	gl.SlaveMiniMap( true )

	widget:ViewResize( Spring.GetWindowGeometry() )
end

----------------------------------------------------------------------------------------------------
function widget:ViewResize( w, h )

	screenWidth = w
	screenHeight = h

	UpdateMinimapGeometry()
	UpdateButtonBoxGeometry()
end

----------------------------------------------------------------------------------------------------
local aboveButton

function widget:IsAbove( x, y )

	y = screenHeight - y
	local buttonBox = minimapPanel.buttonBox

	if CoordInBox( x, y, buttonBox.drawBox ) then
		local buttons = buttonBox.buttons
		for i = 1, #buttons do
			local button = buttons[ i ]
			if CoordInBox( x, y, button.drawBox ) then
				if aboveButton ~= button then
					if aboveButton then
						LeaveButton( aboveButton )
					end

					aboveButton = button
					EnterButton( button )
				end

				return
			end
		end
	end

	if aboveButton then
		LeaveButton( aboveButton )
	end

	aboveButton = nil
end

----------------------------------------------------------------------------------------------------
local clickedButton

function widget:MousePress( x, y, button )
	if aboveButton then
		if clickedButton ~= aboveButton then
			clickedButton = aboveButton
			clickedButton.OnClick()
			clickedButton.clicked = true
			aboveButton.texture = buttonTextures[ "clicked" ]
			minimapPanel.needRedraw = true
		end
		return true
	end
end

----------------------------------------------------------------------------------------------------
function widget:MouseRelease( x, y, button )
	if clickedButton then
		clickedButton.texture = buttonTextures[ "normal_hovered" ]
		clickedButton.clicked = nil
		clickedButton = nil
		minimapPanel.needRedraw = true
	end
end

----------------------------------------------------------------------------------------------------
function widget:Update( dt )
	if lastUpdateInterval < minUpdateInterval then
		lastUpdateInterval = lastUpdateInterval + dt
		return
	end

	lastUpdateInterval = dt

	if SpGetCameraState().name == "ov" then
		if minimapPanel.state ~= "hide" then
			CreateHideMinimapAnimation()
		end
	elseif minimapPanel.state == "hide" then

		minimapPanel.state = nil
		minimapLeft = 0

		boxLeft = 84 * globalSize
		boxRight = 100 * globalSize
		minimapPanel.buttonBox.drawBox = { boxLeft, boxTop, boxRight, boxBottom }

		UpdateMinimapGeometry()
		UpdateButtonBoxGeometry()
	end

	if #animations == 0 then
		return
	end

	minimapPanel.needRedraw = true

	local unfinishedAnimations = {}

	for i = 1, #animations do
		local button = animations[ i ]
		local animation = button.animation
		ProcessAnimation( animation, dt )

		if animation.finished then
			button.animation = nil
		else
			unfinishedAnimations[ #unfinishedAnimations + 1 ] = button
		end
	end

	animations = unfinishedAnimations
end

----------------------------------------------------------------------------------------------------
function widget:DrawScreen()
	glPushMatrix()
	glScale( 1, -1, 1 )
	glTranslate( 0, -screenHeight, 0 )

	RenderUI()

	glPopMatrix()

	RenderMinimap()
end

----------------------------------------------------------------------------------------------------
function widget:Shutdown()

	-- restore minimap
	Spring.SendCommands( "minimap geometry " .. oldMinimapGeometry )
	gl.SlaveMiniMap( false )

	ClearUI()
end

----------------------------------------------------------------------------------------------------
--                                         Implementation                                         --
----------------------------------------------------------------------------------------------------
function UpdateMinimapGeometry()

	minimapPanel.drawBox = {
		minimapLeft,
		minimapTop,
		minimapLeft + minimapWidth,
		minimapTop + minimapHeight
	}
	minimapPanel.needRedraw = true

	local minimapW = minimapWidth - offsetLeft - offsetRight
	local minimapH = minimapHeight - offsetTop - offsetBottom

	local minimapRatio = minimapW / minimapH

	local mapX, mapY, mapH, mapW

	if minimapRatio < mapRatio then
		mapW = minimapW
		mapH = math_floor( minimapH * minimapRatio / mapRatio + .5 )
		mapX = minimapLeft + offsetLeft
		mapY = math_floor( minimapTop + ( minimapH - mapH ) / 2 + .5 ) + offsetTop
	else
		mapW = math_floor( minimapW * mapRatio / minimapRatio + .5 )
		mapH = minimapH
		mapX = math_floor( minimapLeft + ( minimapW - mapW ) / 2 + .5 ) + offsetLeft
		mapY = minimapTop + offsetTop
	end

	SpSendCommands( { string_format( "minimap geometry %i %i %i %i",
		mapX, mapY, mapW, mapH ) } )
end

----------------------------------------------------------------------------------------------------
function UpdateButtonBoxGeometry()

	local w = boxRight - boxLeft
	local h = boxBottom - boxTop

	local buttonBox = minimapPanel.buttonBox
	local buttons = buttonBox.buttons
	local buttonsCount = #buttons

	local buttonsH = buttonHeight * buttonsCount + buttonOffset * ( buttonsCount - 1 )

	local y = boxTop + ( h - buttonsH ) / 2
	local x = boxLeft + ( w - buttonWidth ) / 2

	for i = 1, buttonsCount do
		local button = buttons[ i ]
		button.drawBox[ 1 ] = x
		button.drawBox[ 2 ] = y
		button.drawBox[ 3 ] = x + buttonWidth
		button.drawBox[ 4 ] = y + buttonHeight
		-- Step for next button
		y = y + buttonHeight + buttonOffset
	end
end

----------------------------------------------------------------------------------------------------
function RenderMinimap()

	glDrawMiniMap()
	glResetState()
	glResetMatrices()

end

----------------------------------------------------------------------------------------------------
function RenderUI()

	if minimapPanel.needRedraw then
		ClearUI()
		minimapPanel.drawList = glCreateList( CreateUI )
		minimapPanel.needRedraw = false
	end

	glCallList( minimapPanel.drawList )

end

----------------------------------------------------------------------------------------------------
function ClearUI()
	if minimapPanel.drawList then
		glDeleteList( minimapPanel.drawList )
	end
end

----------------------------------------------------------------------------------------------------
function CreateUI()
	RenderBox( minimapPanel )
	RenderButtonBox()
end

----------------------------------------------------------------------------------------------------
function RenderBox( box )

	glColor( 1, 1, 1, 1 )
	glTexture( box.texture )
	local drawBox = box.drawBox
	glTexRect( drawBox[ 1 ], drawBox[ 2 ], drawBox[ 3 ], drawBox[ 4 ], false, true )
	if box.icon then
		glTexture( box.icon )
		if box.clicked then
			glTexRect( drawBox[ 1 ] + 1, drawBox[ 2 ] + 1,
						drawBox[ 3 ] - 1, drawBox[ 4 ] - 1, false, true )
		else
			glTexRect( drawBox[ 1 ], drawBox[ 2 ], drawBox[ 3 ], drawBox[ 4 ], false, true )
		end
	end
	glTexture( false )
end

----------------------------------------------------------------------------------------------------
function RenderButtonBox()
	local buttonBox = minimapPanel.buttonBox
	local buttons = buttonBox.buttons

	for i = 1, #buttons do
		RenderBox( buttons[ i ] )
	end

end

----------------------------------------------------------------------------------------------------
function ProcessAnimation( animation, dt )
	animation.state = animation.state + dt / animation.duration
	if animation.state > animation.maxState then
		animation.state = animation.maxState
	end

	if animation.state == animation.maxState then
		animation.finished = true
	end

	animation:OnProcess()
end

----------------------------------------------------------------------------------------------------
function CoordInBox( x, y, box )
	local outsideBox = x < box[ 1 ] or x > box[ 3 ] or y < box[ 2 ] or y > box[ 4 ]
	return not outsideBox
end

----------------------------------------------------------------------------------------------------
function EnterButton( button )
	button.texture = buttonTextures[ "normal_hovered" ]
	minimapPanel.needRedraw = true
end

----------------------------------------------------------------------------------------------------
function LeaveButton( button )
	button.texture = buttonTextures[ "normal" ]
	minimapPanel.needRedraw = true
end

----------------------------------------------------------------------------------------------------
function ReadSettings()
	minimapLeft,	minimapTop		= 0,					0
	minimapWidth,	minimapHeight	= 104 * globalSize,		88 * globalSize
	--minimapWidth,	minimapHeight	= WG.SS44_UI.totalW,	88 * globalSize

	offsetLeft,		offsetTop		= 6.7 * globalSize,		4.4 * globalSize
	offsetRight,	offsetBottom	= 23.0 * globalSize,	4 * globalSize

	boxLeft,		boxTop			= 84 * globalSize,		0
	boxRight,		boxBottom		= 100 * globalSize,		88 * globalSize
	buttonWidth,	buttonHeight	= 12.8 * globalSize,	12.8 * globalSize

	buttonOffset					= 2.4 * globalSize

	WG.SS44_UI.minimapOffset = minimapHeight
end

----------------------------------------------------------------------------------------------------
function CreateHideMinimapAnimation()

	minimapPanel.state = "hide"
	minimapPanel.animation = {
		state		= 0,
		maxState	= 1,
		duration	= 0.1,
		OnProcess = function( self )
			local hideWidth = 80 * globalSize * self.state
			minimapLeft = 0 - hideWidth
			boxLeft = 84 * globalSize - hideWidth
			boxRight = 100 * globalSize - hideWidth

			minimapPanel.buttonBox.drawBox = { boxLeft, boxTop, boxRight, boxBottom }

			UpdateMinimapGeometry()
			UpdateButtonBoxGeometry()
		end
	}

	animations[ #animations + 1 ] = minimapPanel
end

----------------------------------------------------------------------------------------------------

