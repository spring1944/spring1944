----------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------
--                                        Local constants                                         --
----------------------------------------------------------------------------------------------------
local iconPath = "LuaUI/Widgets/notAchili/ss44UI/images/buildButtons/"
local buildGroups = {
	{ name = "Units",		icon = iconPath .. "units.png" },
	{ name = "Eco",			icon = iconPath .. "eco.png" },
	{ name = "Factories",	icon = iconPath .. "factories.png" },
	{ name = "Support",		icon = iconPath .. "support.png" },
	{ name = "Defense",		icon = iconPath .. "defense.png" },
	{ name = "Navy",		icon = iconPath .. "navy.png" },
	{ name = "Tech",		icon = iconPath .. "tech.png" },
	{ name = "Others",		icon = iconPath .. "other.png" },
}

local stateIcons = {
	expanded = iconPath .. "expanded.png",
	minimized = iconPath .. "minimized.png"
}

local techUnits = {
	arm2air = true, arm2def = true, arm2kbot = true, arm2veh = true, armlvl2 = true,
	cor2air = true, cor2def = true, cor2kbot = true, cor2veh = true, corlvl2 = true,
}

local supportUnits = {
	corrad = true, -- "core radar"
	corasp = true, -- "core airpad"
	corntow = true, -- "core nanotower"
	armrad = true, -- "arm radar"
	armasp = true, -- "arm airpad"
	armnanotc = true, -- "arm nano tower"
}

local enabledColor	= { 1.0, 1.0, 1.0, 1 }
local disabledColor	= { 0.5, 0.5, 0.5, 1 }
local hoverColor	= { 0.5, 0.5, 1.0, 1 }
local selectedColor	= { 1.0, 0.5, 0.5, 1 }
local pressedColor	= { 0.5, 0.5, 0.5, 1 }

local metalColor  = { 0.8, 0.8, 0.8, 1 }
local energyColor = { 1.0, 1.0, 0.0, 1 }

----------------------------------------------------------------------------------------------------
--                                        Local variables                                         --
----------------------------------------------------------------------------------------------------
-- Layout sizes
local globalSize = 2.5
local imageW, imageH = 21 * globalSize, 16 * globalSize
local imageOffset = 5
local imageInRow = 3

local labelH = 20
local labelFontSize = 14

local rowSize = imageW * imageInRow + imageOffset * ( imageInRow + 1 )
local totalW = rowSize + 21

local buildX = 0

local countLabelX = 0
local countLabelY = 0

-- Widgets
local buildWidget

local buildGrids = {}
local buildButtons = {}

local currentCommands = {}

----------------------------------------------------------------------------------------------------
--                                      Function declarations                                     --
----------------------------------------------------------------------------------------------------
local function CreateBuildWidget() end

local function UpdateBuildsData( commands ) end
local function IsTableEqual( lhs, rhs ) end

local function UpdateBuildsWidget() end
local function UpdateGeometry() end
local function GetGrid( unitDefId ) end
local function GetBuildButton( unitDefId ) end
local function UpdateBuildButton( cmd ) end
local function DoBuildIconMouseClicked( self, x, y, button ) end
local function DoToggleGroupViewState( self ) end

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

local math_floor				= math.floor

local pairs						= pairs
----------------------------------------------------------------------------------------------------
--                                       NotAchili UI shortcuts                                       --
----------------------------------------------------------------------------------------------------
local NotAchili
local Button
local Font
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
function CreateBuildWidget()

	-- setup NotAchili
	NotAchili = WG.NotAchili
	Button = NotAchili.Button
	Font  =NotAchili.Font
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

	buildWidget = Panel:New{
		--parent = screen0,
		x = 0, y = 0,
		width = totalW,
		children = {
			ScrollPanel:New{
				parent = buildWidget,
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
	
	SS44_UI.buildWidget = buildWidget
end

----------------------------------------------------------------------------------------------------
function UpdateBuildsData( commands )

	local buildCommands = {}
	
	-- show build menu, if selected only one units category
	if SS44_UI.selectionWidget.onlyOneCategory then
		buildCommands = commands
	end

	if IsTableEqual( buildCommands, currentCommands ) then
		for i = 1, #buildCommands do
			UpdateBuildButton( buildCommands[ i ] )
		end
		currentCommands = buildCommands
		
		UpdateGeometry()
	else
		currentCommands = buildCommands
		UpdateBuildsWidget()
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
function UpdateBuildsWidget()
		
	if #currentCommands == 0 then
		if buildWidget.parent then
			screen0:RemoveChild( buildWidget )
		end
		return
		
	elseif buildWidget.parent == nil then
		screen0:AddChild( buildWidget )
	end

	local buildScroll = buildWidget.children[ 1 ]
	local gridPanel = buildScroll.children[ 1 ]
	if not gridPanel:IsEmpty() then
		gridPanel:ClearChildren()
	end
		
	for _, grid in pairs( buildGrids ) do
		if not grid:IsEmpty() then
			grid:ClearChildren()
		end
	end
	
	-- create multi unit selector
	for i = 1, #currentCommands do
		local cmd = currentCommands[ i ]
		local unitDefId = -cmd.id
		
		local grid = GetGrid( unitDefId )
		
		-- NotAchili dirty hax
		-- fake item, because other way notAchili make white box, instead unit texture
		if grid:IsEmpty() then
			local fakeItem = Image:New{ width = imageW,	height = imageH }
			grid:AddChild( fakeItem )
		end
		
		local unitIcon = GetBuildButton( unitDefId )
		UpdateBuildButton( cmd )
		
		grid:AddChild( unitIcon )
	end
	
	for i = 1, #buildGroups do
		local group = buildGroups[ i ]
		local grid = buildGrids[ group.name ]
		
		if grid and #grid.children > 0 then
			-- NotAchili dirty hax
			-- Remove fake item in begining
			grid:RemoveChild( grid.children[ 1 ] )
		
			local groupButton = Button:New{
				caption = "Build " .. group.name,
				width = "100%", height = labelH,
				padding = { 0, 0, 0, 0 },
				font = {
					size = labelFontSize
				},
				groupName = group.name,
				OnClick = {	DoToggleGroupViewState },
				children = {
					Image:New{
						x = 2, width = labelH - 4,
						y = 2, height = labelH - 4,
						file = group.icon,
					},
					Image:New{
						right = 2, width = labelH - 4,
						y = 2, height = labelH - 4,
						file = stateIcons[ grid.viewState ],
					}
				}
			}
			--groupButton.OnClick = { DoBuildIconMouseClicked }
			
			gridPanel:AddChild( groupButton )
			gridPanel:AddChild( grid )
		end
	end
	
	UpdateGeometry( 'forceUpdate' )
end

----------------------------------------------------------------------------------------------------
function UpdateGeometry( forceUpdate )
	
	local buildY = SS44_UI.ordersWidget.y + SS44_UI.ordersWidget.height
		
	if ( not forceUpdate ) and ( buildY == buildWidget.y ) then
		return
	end
	
	--Spring.Echo( "UpdateGeometry", buildY )
	
	local totalHeight = imageOffset * 3 + 4
	
	for i = 1, #buildGroups do
		local group = buildGroups[ i ]
		local grid = buildGrids[ group.name ]
		
		if grid and #grid.children > 0 then
			if grid.viewState == "expanded" then
				local gridH = math.ceil( #grid.children / imageInRow ) * ( imageH + 7 ) + 1
				totalHeight = totalHeight + labelH + gridH
			else
				totalHeight = totalHeight + labelH + 2
			end
		end
	end
	
	local buildScroll = buildWidget.children[ 1 ]

	local buildY = SS44_UI.ordersWidget.y + SS44_UI.ordersWidget.height
	--[[
	local buildX = SS44_UI.ordersWidget.x + SS44_UI.ordersWidget.width
	local buildY = 0
	--]]
	local buildH = screen0.height - buildY
	
	if totalHeight <= buildH then
		buildScroll:SetScrollPos( 0 )
		buildWidget:Resize( totalW, totalHeight )
	else		
		buildWidget:Resize( totalW + buildScroll.scrollbarSize, buildH )
	end
	
	buildWidget:SetPos( buildX, buildY )
end

----------------------------------------------------------------------------------------------------
function GetGrid( unitDefId )
	local group = "Others"
	local info = UnitDefs[ unitDefId ]
	
	local mobile	= info.speed > 1
	local armed		= #info.weapons > 0 or ( info.name == 'cordrag' ) or ( info.name  == 'armdrag' )
	local builder	= #info.buildOptions > 0
	local eco		= 
		info.totalEnergyOut > 0 or info.energyStorage > 0 or info.windGenerator > 0
		or info.extractsMetal > 0 or info.metalStorage > 0 or info.makesMetal > 0
		or info.metalMake > 0
		
	local navy		= info.waterline > 0 or info.minWaterDepth > 0
	local tech		= techUnits[ info.name ]
	local support	= supportUnits[ info.name ]
	--local air = info.canFly
	
	--[[
	--if info.name == 'corsolar' then
	if info.name == 'cormex' then
		for k, v in info:pairs() do
			Spring.Echo( k, v )
		end
	end
	--]]
	
	if mobile then
		group = "Units"
	else
		if navy then
			group = "Navy"
		elseif tech then
			group = "Tech"
		elseif support then
			group = "Factories"
		elseif armed then
			group = "Defense"
		elseif builder then
			group = "Factories"
		elseif eco then
			group = "Eco"
			--Spring.Echo( info.humanName, info.waterline, info.minWaterDepth )
		--else
		--	Spring.Echo( info.humanName, info.name )
		end
	end
	
	local grid = buildGrids[ group ]
	if not grid then
		grid = Grid:New{
			itemPadding = { imageOffset, 2, 0, 5 },
			itemMargin = { 0, 0, 0, 0 },
			padding = { 0, 0, 0, 0 },
			minHeight = 0,
			clientWidth = rowSize,
			autosize = true,
			resizeItems = false,
			centerItems = false,
			preserveChildrenOrder = true,
			viewState = "expanded"
		}
		
		buildGrids[ group ] = grid
	end
	return grid
end

----------------------------------------------------------------------------------------------------
function GetBuildButton( unitDefId )

	local image = buildButtons[ unitDefId ]

	if not image then
		local countLabel = Label:New{ 
			caption = '',
			y = 2, height = labelH,
			right = countLabelX, width = "100%",
			autosize = false,
			align = "right",
			valign = "top",
			font = {
				font = "LuaUI/Fonts/Visitor2.ttf",
				size = 7.2 * globalSize,
				color = { 1, 1, 1, 1 },
				outline = true,
			}
		}
		
		local info = UnitDefs[ unitDefId ]
		local metalCostLabel = Label:New{ 
			caption = math_floor( info.metalCost ),
			bottom = 4.8 * globalSize, height = labelH,
			x = 2, width = "100%",
			autosize = false,
			align = "left",
			valign = "bottom",
			font = {
				font = "LuaUI/Fonts/Visitor1.ttf",
				size = 4 * globalSize,
				color = metalColor,
				outline = true,
			}
		}
		
		local energyCostLabel = Label:New{ 
			caption = math_floor( info.energyCost ),
			bottom = 2, height = labelH,
			x = 2, width = "100%",
			autosize = false,
			align = "left",
			valign = "bottom",
			font = {
				font = "LuaUI/Fonts/Visitor1.ttf",
				size = 4 * globalSize,
				color = energyColor,
				outline = true,
			}
		}

		image = Image:New{
			name = "build"..unitDefId,
			unitDefId = unitDefId,
			width = imageW,
			height = imageH,
			file = "#" .. unitDefId,
			
			disableChildrenHitTest = true,
			
			OnClick = { DoBuildIconMouseClicked },			
			OnMouseEnter = DoBuildIconMouseEnter,
			OnMouseLeave = DoBuildIconMouseLeave,
			
			children = { countLabel, metalCostLabel, energyCostLabel },
		} 
		
		buildButtons[ unitDefId ] = image
	end
	
	return image
end

----------------------------------------------------------------------------------------------------
function UpdateBuildButton( command )

	local buildButton = buildButtons[ -command.id ]
	
	local countLabel = buildButton.children[ 1 ]
	local stockpile = command.params[ 1 ] or ''
	
	if countLabel.caption ~= stockpile then
		countLabel:SetCaption( stockpile )
	end
		
	if buildButton.isDisabled ~= command.disabled then
		buildButton.color = command.disabled and disabledColor or enabledColor
		buildButton.isDisabled = command.disabled
		buildButton:Invalidate()
	end
	
	buildButton.tooltip = { 
		build = true,
		isUnitBuilder = command.type == CMDTYPE.ICON,
		unitDefId = -command.id,
		text = command.tooltip 
	}
end

----------------------------------------------------------------------------------------------------
function DoBuildIconMouseEnter( self )
	if not self.isDisabled then
		self.color = hoverColor
		self:Invalidate()
	end
end

----------------------------------------------------------------------------------------------------
function DoBuildIconMouseLeave( self )
	if not self.isDisabled then
		self.color = self.selected and selectedColor or enabledColor
		self:Invalidate()
	end
end

----------------------------------------------------------------------------------------------------
function DoBuildIconMouseClicked( self, x, y, button )

	--Spring.Echo( self.unitDefId )
	local _, _, left, _, right = Spring.GetMouseState()
	local alt, ctrl, meta, shift = Spring.GetModKeyState()
	
	local index = Spring.GetCmdDescIndex( -self.unitDefId )
	--local info = Spring.GetActiveCmdDesc( index )
	--Spring.Echo( CMDTYPE[info.type] )

	Spring.SetActiveCommand( index, button, left, right, alt, ctrl, meta, shift )
end

----------------------------------------------------------------------------------------------------
function DoToggleGroupViewState( self )

	local grid = buildGrids[ self.groupName ]
	if grid then
		if grid.viewState == "expanded" then
			grid.viewState = "minimized"
			grid.autosize = false
			grid:Resize( nil, 1 )		
		else
			grid.viewState = "expanded"
			grid.autosize = true
			grid:UpdateLayout()
		end
		
		local image = self.children[ 2 ]
		image.file = stateIcons[ grid.viewState ]
		image:Invalidate()
		
		UpdateGeometry( 'forceUpdate' )
	end
end

----------------------------------------------------------------------------------------------------
local lastButton
function UpdateActiveCommand( id )
	local button = id and buildButtons[ -id ]
	
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
	if buildWidget then
		buildWidget:Dispose()
	end
	
	buildGrids = {}
	buildButtons = {}
	
	CreateBuildWidget()
	UpdateBuildsWidget()
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
end

----------------------------------------------------------------------------------------------------
--                     Export constants and functions, used in other modules                      --
----------------------------------------------------------------------------------------------------
BUILD_WIDGET = {
	CreateBuildWidget	= CreateBuildWidget,
	UpdateBuildsWidget	= UpdateBuildsWidget,
	UpdateBuildsData	= UpdateBuildsData,
	UpdateActiveCommand = UpdateActiveCommand,
	ResetWidget			= ResetWidget,
}
----------------------------------------------------------------------------------------------------