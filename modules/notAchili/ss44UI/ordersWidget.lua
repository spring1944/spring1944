----------------------------------------------------------------------------------------------------
--                                        Local constants                                         --
----------------------------------------------------------------------------------------------------
local posX = 0

local countLabelX = 0
local countLabelY = 0

local enabledColor	= { 1.0, 1.0, 1.0, 1 }
local disabledColor	= { 0.5, 0.5, 0.5, 1 }
local hoverColor	= { 0.5, 0.5, 1.0, 1 }
local selectedColor	= { 1.0, 0.5, 0.5, 1 }
local pressedColor	= { 0.5, 0.5, 0.5, 1 }

local markerColor	= { 1.0, 1.0, 0.7, 1 }
local outlineColor = { 0.1, 0.1, 0.1, 0.9 }

local outlineWidth = 8

local ordersGroup = {
	"states",
	"basic",
	"other"
}

----------------------------------------------------------------------------------------------------
--                                        Local variables                                         --
----------------------------------------------------------------------------------------------------
local globalSize = 2.5
local imageW, imageH = 21 * globalSize, 16 * globalSize
local imageOffset = 5
local imageInRow = 3

local labelH = 20
local labelFontSize = 14

local rowSize = imageW * imageInRow + imageOffset * ( imageInRow + 1 )
local totalW = rowSize + 21

local stateW, stateH = 24, 24
local stateImageInRow = 8

local ordersWidget

local ordersGrids = {}
local stateGrid
local basicGrid
local otherGrid

local orderButtons = {}

local currentCommands = {}

local currentStates = {}
local currentBasicOrders = {}
local currentOtherOrders = {}

----------------------------------------------------------------------------------------------------
--                                      Function declarations                                     --
----------------------------------------------------------------------------------------------------
local function CreateOrdersWidget() end

local function UpdateOrdersData( commands ) end
local function IsTableEqual( lhs, rhs ) end

local function UpdateOrdersWidget() end
local function UpdateGeometry() end
local function GetGrid() end
local function GetStateButton( cmd ) end
local function DoIconMouseClicked( self, x, y, button ) end

local function UpdateActiveCommand( id ) end

local function ReadSettings() end
----------------------------------------------------------------------------------------------------
--                          Shortcut to used global functions to speedup                          --
----------------------------------------------------------------------------------------------------
local SpGetUnitDefID			= Spring.GetUnitDefID
local SpGetSelectedUnits		= Spring.GetSelectedUnits
local SpGetSelectedUnitsSorted	= Spring.GetSelectedUnitsSorted
local SpGetSelectedUnitsCounts	= Spring.GetSelectedUnitsCounts
local SpGetUnitHealth			= Spring.GetUnitHealth
local SpGetUnitFuel				= Spring.GetUnitFuel
local SpGetUnitResources		= Spring.GetUnitResources

local SpGetModKeyState			= Spring.GetModKeyState

local table_sort				= table.sort
local table_insert				= table.insert
local string_format				= string.format

local pairs						= pairs
----------------------------------------------------------------------------------------------------
--                                            Includes                                            --
----------------------------------------------------------------------------------------------------
local SS44_UI_DIRNAME = "modules/notAchili/ss44UI/"
local includeDir = SS44_UI_DIRNAME .. 'config/'
local overrides = include( includeDir .. 'overrides_commands.lua' )
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

----------------------------------------------------------------------------------------------------
function CreateOrdersWidget()

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

	ordersWidget = Panel:New{
		--parent = screen0,
		x = 0, y = 0,
		width = totalW,
		children = {
			ScrollPanel:New{
				parent = ordersWidget,
				width = "100%", height = "100%",
				padding = { 0, 0, 0, 0 },

				hitTestAllowEmpty = true,
				NCMouseDownPostChildren = function( self, ... )
					return self
				end,

				children = {
					StackPanel:New{
						width = "100%",
						autosize = true,
						itemMargin = { 0, 0, 0, 0 },
						itemPadding = { 0, 0, 0, 0 },
						padding = { imageOffset, imageOffset, imageOffset, imageOffset },
						resizeItems = false,
						centerItems = false
					}
				}
			}
		}
	}
	
	stateGrid = GetGrid( ordersGroup[ 1 ] )
	basicGrid = GetGrid( ordersGroup[ 2 ] )
	otherGrid = GetGrid( ordersGroup[ 3 ] )
	
	SS44_UI.ordersWidget = ordersWidget
end

----------------------------------------------------------------------------------------------------
function UpdateOrdersData( commands )

	local states = commands.states
	local orders
	if SS44_UI.selectionWidget.onlyOneCategory and ( #commands.builds > 0 ) then
		orders = {}
	else
		orders = commands.orders
	end
	local others = commands.others
	
	local statesEqual = IsTableEqual( states, currentStates )
	local ordersEqual = IsTableEqual( orders, currentBasicOrders )
	local othersEqual = IsTableEqual( others, currentOtherOrders )

	if statesEqual and ordersEqual and othersEqual  then
		for i = 1, #states do
			local state = states[ i ]
			local optionIndex = state.params[ 1 ] + 1
			
			local cmdIcon = orderButtons[ state.id ]
			if cmdIcon then
				if cmdIcon.currentIndex ~= optionIndex then
					UpdateStateButton( state )
				end
			end
		end
		
		for i = 1, #others do
			local cmd = others[ i ]
			
			local button = orderButtons[ cmd.id ]
			if button then
				local label = button.children[ 1 ]
				if label.caption ~= cmd.name then
					UpdateOrderButton( cmd )
				end
			end
		end
		
		local posY = SS44_UI.selectionWidget.y + SS44_UI.selectionWidget.height
			
		if posY ~= ordersWidget.y then
			UpdateGeometry()
		end
	
	else
		currentStates		= states
		currentBasicOrders	= orders
		currentOtherOrders	= others
		UpdateOrdersWidget()
		
	end
end

----------------------------------------------------------------------------------------------------
function IsTableEqual( lhs, rhs )
	if #lhs ~= #rhs then
		return false
	end

	for i = 1, #lhs do		
		if lhs[ i ].id ~= rhs[ i ].id then
			return false
		end
	end
	
	return true
end

----------------------------------------------------------------------------------------------------
function UpdateOrdersWidget()
	
	local commandsCount = #currentStates + #currentBasicOrders + #currentOtherOrders
	
	if ( commandsCount == 0 ) then
		if ordersWidget.parent then
			screen0:RemoveChild( ordersWidget )
		end
		return
		
	elseif ordersWidget.parent == nil then
		screen0:AddChild( ordersWidget )
	end

	local ordersScroll = ordersWidget.children[ 1 ]
	local gridPanel = ordersScroll.children[ 1 ]
	if not gridPanel:IsEmpty() then
		gridPanel:ClearChildren()
	end
		
	for _, grid in pairs( ordersGrids ) do
		if not grid:IsEmpty() then
			grid:ClearChildren()
		end
	end
	
	for i = 1, #currentStates do	
		-- NotAchili dirty hax
		-- fake item, because other way notAchili make white box, instead unit texture
		if stateGrid:IsEmpty() then
			local fakeItem = Image:New{ width = stateW,	height = stateH }
			stateGrid:AddChild( fakeItem )
		end
		
		local cmd = currentStates[ i ]
		UpdateStateButton( cmd )
		
		local cmdIcon = GetStateButton( cmd )
		stateGrid:AddChild( cmdIcon )
	end
	
	for i = 1, #currentBasicOrders do	
		-- NotAchili dirty hax
		-- fake item, because other way notAchili make white box, instead unit texture
		if basicGrid:IsEmpty() then
			local fakeItem = Image:New{ width = imageW,	height = imageH }
			basicGrid:AddChild( fakeItem )
		end
		
		local cmd = currentBasicOrders[ i ]
		UpdateOrderButton( cmd )
		
		local cmdIcon = GetOrderButton( cmd )
		basicGrid:AddChild( cmdIcon )
	end
	
	for i = 1, #currentOtherOrders do	
		-- NotAchili dirty hax
		-- fake item, because other way notAchili make white box, instead unit texture
		if otherGrid:IsEmpty() then
			local fakeItem = Image:New{ width = imageW,	height = imageH }
			otherGrid:AddChild( fakeItem )
		end
		
		local cmd = currentOtherOrders[ i ]
		UpdateOrderButton( cmd )
		
		local cmdIcon = GetOrderButton( cmd )
		otherGrid:AddChild( cmdIcon )
	end
	
	for i = 1, #ordersGroup do
		local group = ordersGroup[ i ]
		local grid = ordersGrids[ group ]
		
		if grid and #grid.children > 0 then
			-- NotAchili dirty hax
			-- Remove fake item in begining
			grid:RemoveChild( grid.children[ 1 ] )
		
			--[[
			local groupButton = Button:New{ caption = group, 
				width = "100%", height = labelH 
			}
			groupButton.font.size = labelFontSize
			--groupButton.OnClick = { DoIconMouseClicked }
			
			gridPanel:AddChild( groupButton )
			--]]
			
			gridPanel:AddChild( grid )
		end
	end
	
	UpdateGeometry()
end

----------------------------------------------------------------------------------------------------
function UpdateGeometry()
	
	local totalHeight = imageOffset * 3 + 4
	
	if #stateGrid.children > 0 then
		local gridH = math.ceil( #stateGrid.children / stateImageInRow ) * ( stateH + 7 ) + 1
		totalHeight = totalHeight + gridH
	end
	
	for i = 2, #ordersGroup do
		local group = ordersGroup[ i ]
		local grid = ordersGrids[ group ]
		
		if grid and #grid.children > 0 then
			local gridH = math.ceil( #grid.children / imageInRow ) * ( imageH + 7 ) + 1
			--totalHeight = totalHeight + labelH + gridH
			totalHeight = totalHeight + gridH
		end
	end
	
	local ordersScroll = ordersWidget.children[ 1 ]
	local posY = SS44_UI.selectionWidget.y + SS44_UI.selectionWidget.height
	local orderH = screen0.height - posY
	
	if totalHeight <= orderH then
		ordersScroll:SetScrollPos( 0 )
		ordersWidget:SetPos( posX, posY, totalW, totalHeight )
	else		
		ordersWidget:SetPos( posX, posY, totalW + ordersScroll.scrollbarSize, orderH )
	end
	
	-- Spring.Echo( SS44_UI.ordersWidget.y + SS44_UI.ordersWidget.height )
end

----------------------------------------------------------------------------------------------------
function GetGrid( group )
		
	local grid = ordersGrids[ group ]
	if not grid then
		grid = Grid:New{
			itemPadding = { imageOffset, 2, 0, 5 },
			itemMargin = { 0, 0, 0, 0 },
			padding = { 0, 0, 0, 0 },
			clientWidth = rowSize,
			autosize = true,
			resizeItems = false,
			centerItems = false,
			preserveChildrenOrder = true,
		}
		
		ordersGrids[ group ] = grid
	end
	return grid
end

----------------------------------------------------------------------------------------------------
function GetStateButton( cmd )
	local button = orderButtons[ cmd.id ]

	if not button then
		button = Button:New{
			name = "command" .. cmd.id,
			caption = '',
			id = cmd.id,
			width = stateW,
			height = stateH,
			OnClick = { DoIconMouseClicked },
			disableChildrenHitTest = true,
			padding = { 4, 4, 4, 4 },
			children = { Image:New{ width = "100%", height = "100%" }, }
		}
		button.font.size = 8
		
		local override = overrides[ cmd.id ]
		if override then
			for k, v in pairs( override ) do
				button[ k ] = v
			end
		else
            overrides[cmd.id] = GetNewOverride(cmd.id)
			if (overrides[cmd.id] ~= nil) then 
				for k, v in pairs( overrides[cmd.id] ) do
					button[ k ] = v
				end
			end
		end
		
		orderButtons[ cmd.id ] = button
	end
	
	return button
end

----------------------------------------------------------------------------------------------------
function UpdateStateButton( cmd )
	local cmdIcon = GetStateButton( cmd )

	cmdIcon.isDisabled = cmd.disabled
	cmdIcon.tooltip = cmd.tooltip
	cmdIcon.currentIndex = cmd.params[ 1 ] + 1
	cmdIcon.optionsCount = #cmd.params - 1

	if type( cmdIcon.texture ) == 'table' then
		local image = cmdIcon.children[ 1 ]
		image.file = cmdIcon.texture[ cmdIcon.currentIndex ]
		image:Invalidate()
	else
		cmdIcon:SetCaption( cmd.params[ cmdIcon.currentIndex + 1 ] )
	end
end

----------------------------------------------------------------------------------------------------
function GetOrderButton( cmd )
	local button = orderButtons[ cmd.id ]

	if not button then
		button = Button:New{
			name = "command" .. cmd.id,
			caption = '',
			id = cmd.id,
			width = imageW,
			height = imageH,
			OnClick = { DoIconMouseClicked },
			disableChildrenHitTest = true,
			padding = { 4, 4, 4, 4 },
		}
		
		local override = overrides[ cmd.id ]
		if override then
			for k, v in pairs( override ) do
				button[ k ] = v
			end
		else
            overrides[cmd.id] = GetNewOverride(cmd.id)
			if (overrides[cmd.id] ~= nil) then 
				for k, v in pairs( overrides[cmd.id] ) do
					button[ k ] = v
				end
			end
		end
		
		if button.texture then
			local image = Image:New{ parent = button, width = "100%", height = "100%" }
			image.file = button.texture
		else
			local label = Label:New{
				parent = button, 
				width = "100%", height = "100%", 
				caption = cmd.name,
				y = 1 * globalSize,
				x = 1 * globalSize,
				autosize = false,
				align = "left",
				valign = "top",
				font = {
					--font = "LuaUI/Fonts/Visitor1.ttf",
					size = 3.8 * globalSize,
					color = markerColor,
					outline = true,
					outlineWidth = outlineWidth,
					outlineColor = outlineColor,
				}
			}
			
			if( cmd.texture ) then
				local image = Image:New{ parent = button, width = "100%", height = "100%" }
				image.file = cmd.texture
			end

		end
		
		orderButtons[ cmd.id ] = button
	end
	
	return button
end

function UpdateOrderButton( cmd )
	local cmdIcon = GetOrderButton( cmd )

	cmdIcon.isDisabled = cmd.disabled
	cmdIcon.tooltip = cmd.tooltip

	local label = cmdIcon.children[ 1 ]
	label:SetCaption( cmd.name )
end

----------------------------------------------------------------------------------------------------
function DoIconMouseClicked( self, x, y, button )
	
	local _, _, left, _, right = Spring.GetMouseState()
	local alt, ctrl, meta, shift = Spring.GetModKeyState()
	
	local index = Spring.GetCmdDescIndex( self.id )

	--Spring.Echo( CMD[ self.id ] )
	
	Spring.SetActiveCommand( index, button, left, right, alt, ctrl, meta, shift )
end

----------------------------------------------------------------------------------------------------
local lastButton
function UpdateActiveCommand( id )
	local button = id and orderButtons[ id ]
	
	if button ~= lastButton then
		if button then
			button.selected = true
			button.color = selectedColor
			button:Invalidate()
		end
		
		if lastButton then
			lastButton.selected = false
			lastButton.color = enabledColor
			lastButton:Invalidate()
		end
		
		lastButton = button
	end
end

----------------------------------------------------------------------------------------------------
function ResetWidget()
	if ordersWidget then
		ordersWidget:Dispose()
	end
	
	ordersGrids = {}
	orderButtons = {}
	
	CreateOrdersWidget()
	UpdateOrdersWidget()
end

----------------------------------------------------------------------------------------------------
function ReadSettings()
	globalSize = SS44_UI.globalSize

	imageW = SS44_UI.imageW 
	imageH = SS44_UI.imageH
	imageOffset = SS44_UI.imageOffset
	imageInRow = SS44_UI.imageInRow

	labelH = SS44_UI.labelH
	labelFontSize = SS44_UI.labelFontSize
	
	rowSize = SS44_UI.rowSize
	totalW = SS44_UI.totalW
	
	stateW, stateH = SS44_UI.stateW, SS44_UI.stateH
end

----------------------------------------------------------------------------------------------------
--                     Export constants and functions, used in other modules                      --
----------------------------------------------------------------------------------------------------
ORDERS_WIDGET = {
	CreateOrdersWidget	= CreateOrdersWidget,
	UpdateOrdersWidget	= UpdateOrdersWidget,
	UpdateOrdersData	= UpdateOrdersData,
	UpdateActiveCommand = UpdateActiveCommand,
	ResetWidget			= ResetWidget,
}
----------------------------------------------------------------------------------------------------

-- customCommands extension

-- get madatory module operators
VFS.Include("modules.lua") -- modules table
VFS.Include(modules.attach.data.path .. modules.attach.data.head) -- attach lib module

-- get other madatory dependencies
attach.Module(modules, "message")

-- used in init phase
function GetNewOverride(cmdID)
	local rawCustomCommandsList = Spring.GetTeamRulesParam(Spring.GetMyTeamID(), "CustomCommandsIDToOverride")
	if (rawCustomCommandsList ~= nil) then		
		local allOverrides = message.Decode(rawCustomCommandsList)
		return allOverrides[cmdID]
	end
end

-- used for updates
function CustomCommandUpdate(cmdID)
	overrides[cmdID] = GetNewOverride(cmdID)
	ORDERS_WIDGET.ResetWidget()
end
