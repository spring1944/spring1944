-- DEPENDENCIES --

-- get madatory module operators
VFS.Include("modules.lua") -- modules table
VFS.Include(modules.attach.data.path .. modules.attach.data.head) -- attach lib module

-- get other madatory dependencies
attach.Module(modules, "tableExt")

----------------------------------------------------------------------------------------------------
--                                        Local constants                                         --
----------------------------------------------------------------------------------------------------
local SS44_UI_DIRNAME = "modules/notAchili/ss44UI/"
local unitStatsIconPrefix = ":a:" .. SS44_UI_DIRNAME .. "images/unitStats/"

----------------------------------------------------------------------------------------------------
--                                        Local variables                                         --
----------------------------------------------------------------------------------------------------
local globalSize = 2.5
local imageW, imageH = 21 * globalSize, 16 * globalSize
local imageOffset = 5
local imageInRow = 3

local labelH = 20
local labelFontSize = 8 * globalSize

local rowSize = imageW * imageInRow + imageOffset * ( imageInRow + 1 )
local totalW = rowSize + 21

local selectionX = 0

local countLabelX = 0
local countLabelY = 0

local selectionWidget
local singleSelectionWidget

local unitGroups = {
	"Air",
	"Soldiers",
	"Vehicles",
	"Navy",
	"Hover",
	"Unarmed",
	"Factories",
	"Defense",
	"Others"
}

local selectionGrids = {}
local currentSelection = {}

----------------------------------------------------------------------------------------------------
--                                      Function declarations                                     --
----------------------------------------------------------------------------------------------------
local function CreateSelectionWidget() end
local function CreateStatLine( items ) end

local function UpdateSelectionData() end
local function IsTableEqual( lhs, rhs ) end
local function UpdateSelectionWidget() end
local function CreateUnitIcon( unitDefId, unitsCount ) end
local function GetGrid( unitDefId ) end

local function DoSelectionIconMouseUp( self, x, y, button ) end
local function DoSelectionGroupMouseUp( self, x, y, button ) end
local function SelectUnitFromSelection( selectDefId, singleSelection ) end
local function RemoveUnitFromSelection( removeDefId, singleRemove ) end
local function GotoUnitFromSelection( selectDefId ) end

local function ResetWidget() end
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

local CalculateDPS = TOOLS.CalculateDPS
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
function CreateSelectionWidget()

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

	selectionWidget = Panel:New{
		--parent = screen0,
		x = 0, y = 0,
		width = totalW,
		children = {
			ScrollPanel:New{
				--parent = selectionWidget,
				width = "100%", height = "100%",
				padding = { 0, 0, 0, 0 },
			}
		}
	}
		
	singleSelectionWidget = Control:New{
		x = 0, clientWidth = rowSize,
		y = 0,
		autosize = true,
		padding = { 0, 0, 0, 0 },
		children = {
			Button:New{
				x = 0, y = 0, width = "100%", height = labelH,
				caption = "Unit Name",
				font = { size = labelFontSize },
				styleKey = "buttonResizable",
			},
			Image:New{
				x = imageOffset, y = labelH + 2,
				width = imageW, height = imageH,
				children = {
					Label:New{
						right = 2, y = 2,
						width = "100%", height = "100%",
						caption = "",
						font = {
							outline = true,
							size = 8 * globalSize,
							font = "LuaUI/Fonts/Visitor1.ttf",
							outline = true,
							outlineWidth = 7,
							outlineColor = { 0.1, 0.1, 0.1, 0.9 },
						},
						autosize = false,
						align = "right", valign = "top"
					},
				}
			},
			Grid:New{
				x = imageOffset * 2 + imageW, width = rowSize - (imageW + imageOffset * 2),
				y = labelH + imageOffset, height = labelH,
				centerItems = false,
				padding = { 0, 0, 0, 0 },
				itemMargin = { 0, 0, 4, 4 },
				resizeItems = false,
				children = CreateStatLine{ "dps", "range"}
			},
			Grid:New{
				x = imageOffset * 2 + imageW, width = rowSize - (imageW + imageOffset * 2),
				y = 2*labelH + imageOffset, height = labelH,
				centerItems = false,
				padding = { 0, 0, 0, 0 },
				itemMargin = { 0, 0, 4, 4 },
				resizeItems = false,
				children = CreateStatLine{ "speed", "health" }
			}
				
			--[[
			Progressbar:New{
				x = imageOffset, y = row4,
				minHeight = 0, height = imageOffset * 2,
				width = rowSize - imageOffset * 2,
				tooltip = "Unit health",
				color = { 0, 1, 0, 0.5 },
			}
			--]]
		}
	}
	
	SS44_UI.selectionWidget = selectionWidget
end

----------------------------------------------------------------------------------------------------
function CreateStatLine( items )
	local result = {}

	for i = 1, #items do
	
		local item = items[ i ]
		result[ #result + 1 ] = Image:New{ 
			width = 8 * globalSize, height = 7 * globalSize,
			file = unitStatsIconPrefix .. item .. ".png"
		}
		result[ #result + 1 ] = Label:New{
			width = 16 * globalSize, height = 7 * globalSize,
			autosize = false,
			caption = '',
			font = {
				size = labelFontSize,
			}
		}
	end
	
	return result
end

----------------------------------------------------------------------------------------------------
function UpdateSelectionData()

	local selectedUnits = SpGetSelectedUnits()

	if not IsTableEqual( selectedUnits, currentSelection ) then
	
		currentSelection = selectedUnits
		UpdateSelectionWidget()
		
	end
end

----------------------------------------------------------------------------------------------------
function IsTableEqual( lhs, rhs )
	if #lhs ~= #rhs then
		return false
	end

	for i = 1, #lhs do
		if lhs[ i ] ~= rhs[ i ] then
			return false
		end
	end
	
	return true
end

----------------------------------------------------------------------------------------------------
function UpdateSelectionWidget()
	
	local units = {}
	local sortedUnits = SpGetSelectedUnitsCounts()
	
	if sortedUnits.n == 0 then
		if selectionWidget.parent then
			screen0:RemoveChild( selectionWidget )
		end
		selectionWidget.onlyOneCategory = false
		
		return
		
	elseif selectionWidget.parent == nil then
		screen0:AddChild( selectionWidget )
	end

	for defId, count in pairs( sortedUnits ) do
		if defId ~= 'n' then
			units[ #units + 1 ] = {	defId = defId, count = count }
		end
	end
	
	local function SortByUnitDefID( lhs, rhs )
		return lhs.defId < rhs.defId
	end
	table_sort( units, SortByUnitDefID )
	
	local selectionScroll = selectionWidget.children[ 1 ]
	if not selectionScroll:IsEmpty() then
		selectionScroll:ClearChildren()
	end
	
	local gridPanel = StackPanel:New{
		width = "100%",
		height = imageH + imageOffset,
		autosize = true,
		itemMargin = { 0, 0, 0, 0 },
		itemPadding = { 0, 0, 0, 0 },
		padding = { imageOffset, imageOffset, imageOffset, imageOffset },
		resizeItems = false,
		centerItems = false
	}
	selectionScroll:AddChild( gridPanel )
		
	selectionGrids = {}
	
	local totalHeight = 0
	
	if #units > 1 then
		-- create multi unit selector
		for i = 1, #units do
			local unit = units[ i ]
			local grid = GetGrid( unit.defId )
			grid.unitDefIdList[ unit.defId ] = true
			grid:AddChild( CreateUnitIcon( unit.defId, unit.count ) )
		end
		
		totalHeight = imageOffset * 3 + 4
		for i = 1, #unitGroups do
			local group = unitGroups[ i ]
			local grid = selectionGrids[ group ]
			if grid then
			
				local gridH = math.ceil( #grid.children / imageInRow ) * ( imageH + 7 ) + 1
				totalHeight = totalHeight + labelH + gridH
			
				local groupButton = Button:New{ 
					caption = group, 
					width = "100%", height = labelH,
					font = { size = labelFontSize },
					styleKey = "buttonResizable",
				}
				
				groupButton.OnClick = { DoSelectionGroupMouseUp }
				groupButton.unitDefIdList = grid.unitDefIdList
				
				gridPanel:AddChild( groupButton )
				gridPanel:AddChild( grid )
			end
		end
	elseif units[ 1 ] then
		-- create single unit info panel
		local unit = units[ 1 ]
		local unitDefId = units[ 1 ].defId
		local info = UnitDefs[ unitDefId ]
		
		local button = singleSelectionWidget.children[ 1 ]
		button:SetCaption( info.humanName )
		
		local image = singleSelectionWidget.children[ 2 ]
		image.file = "#" .. unitDefId
		image:Invalidate()
		
		local countLabel = image.children[ 1 ]
		countLabel:SetCaption( unit.count == 1 and '' or unit.count )
		
		local statGridOne = singleSelectionWidget.children[ 3 ]
		
		local attack = statGridOne.children[ 2 ]
		attack:SetCaption( CalculateDPS( info ) )
		
		local rangeText = ( info.maxWeaponRange > 0 ) and math.floor(info.maxWeaponRange) or "-"
		local range = statGridOne.children[ 4 ]
		range:SetCaption( rangeText )
		
		local statGridTwo = singleSelectionWidget.children[ 4 ]
		
		local speedText = ( info.speed > 0 ) and string_format( "%i", info.speed ) or "-"
		local speed = statGridTwo.children[ 2 ]
		speed:SetCaption( speedText )
		
		local health = statGridTwo.children[ 4 ]
		health:SetCaption( math.floor(info.health) )
		
		totalHeight = imageH + labelH + 8*globalSize
		--totalHeight = singleSelectionWidget.height
		gridPanel:AddChild( singleSelectionWidget )
	end
	
	selectionWidget.onlyOneCategory = ( #gridPanel.children < 3 )
	
	local selectionY = SS44_UI.minimapOffset or 0
	local selectionH = screen0.height - selectionY
	
	if totalHeight <= selectionH then
		selectionScroll:SetScrollPos( 0 )
		selectionWidget:Resize( totalW, totalHeight )
	else		
		selectionWidget:Resize( totalW + selectionScroll.scrollbarSize, selectionH )
	end
	
	selectionWidget:SetPos( selectionX, selectionY )
end

----------------------------------------------------------------------------------------------------
function GetGrid( unitDefId )
	local group = "Others"
	local info = UnitDefs[ unitDefId ]
	
	local mobile = info.speed > 0.1
	local armed = #info.weapons > 0
	local builder = #info.buildOptions > 0
	local air = info.canFly
	local kbot = info.moveDef.family == "kbot"
	
	if mobile then
		if info.canFly then
			group = "Air"
		elseif kbot then
			group = armed and "Soldiers" or "Unarmed"
		else
			group = armed and "Vehicles" or "Unarmed"
		end
	else
		if armed then
			group = builder and "Factories" or "Defense"
		else
			group = "Factories"	
		end
	end
	
	local grid = selectionGrids[ group ]
	if not grid then
		grid = Grid:New{
			itemPadding = { imageOffset, 2, 0, 5 },
			itemMargin = { 0, 0, 0, 0 },
			padding = { 0, 0, 0, 0 },
			clientWidth = rowSize,
			autosize = true,
			resizeItems = false,
			centerItems = false,
		}
		
		grid.unitDefIdList = {}
		
		selectionGrids[ group ] = grid
	end
	return grid
end

----------------------------------------------------------------------------------------------------
function CreateUnitIcon( unitDefId, unitsCount )

	local label = Label:New{ 
		caption = unitsCount,
		y = 2, height = labelH,
		right = countLabelX, width = "100%",
		autosize = false,
		align = "right",
		valign = "top",
		font = {
			outline = true,
			size = 8 * globalSize,
			font = "LuaUI/Fonts/Visitor1.ttf",
			outline = true,
			outlineWidth = 7,
			outlineColor = { 0.1, 0.1, 0.1, 0.9 },
		},
	}

	return Image:New{
		unitDefId = unitDefId,
		width = imageW,
		height = imageH,
		file = "#" .. unitDefId,
		
		disableChildrenHitTest = true,
		tooltip = {
			selection = true,
			unitDefId = unitDefId
		},
		
		OnClick = { DoSelectionIconMouseUp },
		children = { label }
	} 
end

----------------------------------------------------------------------------------------------------
local LEFT_BUTTON = 1
local RIGHT_BUTTON = 3

function DoSelectionIconMouseUp( self, x, y, button )
			
	local alt, ctrl, meta, shift = SpGetModKeyState()
	
	local unitDefId = { [ self.unitDefId ] = true }
	
	if button == LEFT_BUTTON then
	
		SelectUnitFromSelection( unitDefId, ctrl )	
	elseif button == RIGHT_BUTTON then
		--// deselect a whole or one unit ( ctrl ) unitdef block		
		RemoveUnitFromSelection( unitDefId, ctrl )
	else --button2 (middle)

		GotoUnitFromSelection( unitDefId )
	end
end

function DoSelectionGroupMouseUp( self, x, y, button )
			
	local alt, ctrl, meta, shift = SpGetModKeyState()
	
	if button == LEFT_BUTTON then
	
		SelectUnitFromSelection( self.unitDefIdList, ctrl )	
	elseif button == RIGHT_BUTTON then
		--// deselect a whole or one unit ( ctrl ) unitdef block		
		RemoveUnitFromSelection( self.unitDefIdList, ctrl )
	else --button2 (middle)

		GotoUnitFromSelection( self.unitDefIdList )
	end
end

----------------------------------------------------------------------------------------------------
function RemoveUnitFromSelection( removeDefId, singleRemove )
	local result = {}

	for i = 1, #currentSelection do
		local unitId = currentSelection[ i ]
		local unitDefId = Spring.GetUnitDefID( unitId )
		
		if removeDefId[ unitDefId ]  then
			if singleRemove then
				-- remove only one unit from result
				removeDefId = {}
			end
		elseif unitDefId then
			result[ #result + 1 ] = unitId
		end
	end
	
	Spring.SelectUnitArray( result )
end

----------------------------------------------------------------------------------------------------
function SelectUnitFromSelection( selectDefId, singleSelection )
	local result = {}

	for i = 1, #currentSelection do
		local unitId = currentSelection[ i ]
		
		if selectDefId[ Spring.GetUnitDefID( unitId ) ] then
			result[ #result + 1 ] = unitId
			if singleSelection then
				break
			end
		end
	end
	
	Spring.SelectUnitArray( result )
end

----------------------------------------------------------------------------------------------------
function GotoUnitFromSelection( selectDefId )
	for i = 1, #currentSelection do
		local unitId = currentSelection[ i ]
		
		if selectDefId[ Spring.GetUnitDefID( unitId ) ] then
			local x, y, z = Spring.GetUnitPosition( unitId )
			Spring.SetCameraTarget( x, y, z, 1 )
			return
		end
	end
end

----------------------------------------------------------------------------------------------------
function ResetWidget()
	if selectionWidget then
		selectionWidget:Dispose()
	end
	
	selectionGrids = {}
	
	CreateSelectionWidget()
	UpdateSelectionWidget()
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
SELECTION_WIDGET = {
	CreateSelectionWidget	= CreateSelectionWidget,
	UpdateSelectionWidget	= UpdateSelectionWidget,
	UpdateSelectionData		= UpdateSelectionData,
	ResetWidget				= ResetWidget,
}
----------------------------------------------------------------------------------------------------