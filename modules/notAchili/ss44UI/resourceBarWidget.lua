----------------------------------------------------------------------------------------------------
--                                        Local constants                                         --
----------------------------------------------------------------------------------------------------

local resources = { "energy", "metal", "rearm" }

local enabledColor	= { 1.0, 1.0, 1.0, 1 }
local disabledColor	= { 0.5, 0.5, 0.5, 1 }
local hoverColor	= { 0.5, 0.5, 1.0, 1 }
local selectedColor	= { 1.0, 0.5, 0.5, 1 }
local pressedColor	= { 0.5, 0.5, 0.5, 1 }

local incomeColor	= { 0, 1, 0, 1 }
local expenseColor	= { 1, 0, 0, 1 }
local progressbarColors = {
	energy = { 1, 1, 0, 0.8 },
	metal  = { 1, 1, 1, 0.5 },
	rearm = { 1, 1, 0, 0.5 },
}

local minExpenseCoverage = {
	energy = 0.9,
	metal  = 0.8,
	rearm  = 0.8,
}

local needMessage = {
	energy = "Need Supplies!",
	metal  = "Need Command!",
	rearm  = "Need Rearm!",
}

local yellowStr = "\255\255\255\1"

local commonTooltip = {
	bar =		"Show current resource amount and maximum storage\n" ..
				"Press mouse button to setup %s sharing\n\n" ..
				"Current share level " .. yellowStr,

	income =	"Total %s income\n" ..
				"Self produced and received from other players",

	expense =	"Total %s expense\n" ..
				"Consumed by factories, weapons and units"
}

local barTooltip = {
	metal  = "Command bar\n"  .. string.format( commonTooltip.bar, "metal" ),
	energy = "Supplies bar\n" .. string.format( commonTooltip.bar, "energy" ),
	rearm = "Rearm bar\n" .. string.format( commonTooltip.bar, "rearm" ),
}

local incomeTooltip = {
	metal  = string.format( commonTooltip.income, "metal"  ),
	energy = string.format( commonTooltip.income, "energy" ),
	rearm = string.format( commonTooltip.income, "rearm" ),
}

local expenseTooltip = {
	metal  = string.format( commonTooltip.expense, "metal"  ),
	energy = string.format( commonTooltip.expense, "energy" ),
	rearm = string.format( commonTooltip.expense, "rearm" ),
}
----------------------------------------------------------------------------------------------------
--                                        Local variables                                         --
----------------------------------------------------------------------------------------------------
local globalSize = 2.5
local resourceBarH = 16.4 * globalSize
local resourceW = 104 * globalSize
local imageW = 8 * globalSize
local offsetW = 8 * globalSize
local textW = 20 * globalSize

local fontSize = 4.8 * globalSize

local resourceBarWidget

local resourceWidgets = {}

local minBlink = 0.3
local maxBlink = 1
local blinkTimer = 0.0
local blinkInterval = 0.05
local blinkStep = ( maxBlink - minBlink ) / 10
local blinkWidgets = {}

----------------------------------------------------------------------------------------------------
--                                      Function declarations                                     --
----------------------------------------------------------------------------------------------------
local function CreateResourceBarWidget() end
local function CreateResourceWidget( resName ) end
local function SetResourceBarParent( parent ) end
local function UpdateResourceBarWidget( dt ) end
local function UpdateResource( resName ) end
local function UpdateResourceBarGeometry() end
local function ResetWidget() end
local function Blink( widget ) end
local function SetShareLevel( self, v, vOld ) end
local function ReadSettings() end

----------------------------------------------------------------------------------------------------
--                          Shortcut to used global functions to speedup                          --
----------------------------------------------------------------------------------------------------
local SpGetModKeyState			= Spring.GetModKeyState
local SpGetMyTeamID				= Spring.GetMyTeamID
local SpGetTeamResources		= Spring.GetTeamResources
local SpSetShareLevel			= Spring.SetShareLevel
local SpGetTeamRulesParam		= Spring.GetTeamRulesParam

local table_sort				= table.sort
local table_insert				= table.insert
local string_format				= string.format

local pairs						= pairs

local GetShortNumber = TOOLS.GetShortNumber
local myTeamID = Spring.GetMyTeamID()
local RESUPPLY_PERIOD = math.floor(Spring.GetGameRulesParam("resupplyPeriod") / 30)
----------------------------------------------------------------------------------------------------
--                                            Includes                                            --
----------------------------------------------------------------------------------------------------
-- get madatory module operators
VFS.Include("modules.lua") -- modules table
VFS.Include(modules.attach.data.path .. modules.attach.data.head) -- attach lib module

-- get other madatory dependencies
attach.Module(modules, "message")
HMSF = attach.Module(modules, "hmsf")

-- notaUI config
local includeDir = 'Widgets/notAchili/NotaUI/config/'
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
function CreateResourceBarWidget()

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

	local parent = screen0.childrenByName.epicmenubar or screen0

	resourceBarWidget = Control:New{
		parent = parent,
		x = 0, y = 0,
		padding = { 0, 0, 0, 0 },
		height = resourceBarH,
		resizable = false,
		draggable = false,
		children = {
			StackPanel:New{
				width = "100%", height = "100%",
				orientation = "horizontal",
				centerItems = false,
				resizeItems = false,
				itemPadding = {0, 0, 0, 0},
				itemMargin  = {0, 0, 0, 0},
			}
		}
	}

	resourceWidgets[ "metal"  ] = CreateResourceWidget( "metal"  )
	resourceWidgets[ "energy" ] = CreateResourceWidget( "energy" )
	resourceWidgets[ "rearm" ] = CreateResourceWidget( "rearm" )

	SS44_UI.resourceBarWidget = resourceBarWidget
	UpdateResourceBarGeometry()
end

----------------------------------------------------------------------------------------------------
function CreateResourceWidget( resName )

	local panel = resourceBarWidget.children[ 1 ]
	local imagePath = "LuaUI/Widgets/notAchili/ss44UI/images/resources/"

	resWidget = Control:New{
		parent = panel,
		width = resourceW, height = "100%",
		children = {
			Image:New{
				x = 0, width = imageW,
				y = 0, height = "100%",
				file = imagePath .. resName .. ".png"
			},
		}
	}

	local incomeLabel =	Label:New{
		parent = resWidget,
		x = imageW, width = textW,
		y = 0, height = 4 * globalSize,
		autosize = false,
		valign = "top",
		align = "center",
		caption = "9999k",
		HitTest = function( self ) return self end,
		tooltip = incomeTooltip[ resName ],
		font = {
			size = fontSize,
			color = incomeColor,
		},
	}

	local expenseLabel = Label:New{
		parent = resWidget,
		x = imageW, width = textW,
		autosize = false,
		bottom = 0, height = 4 * globalSize,
		valign = "bottom",
		align = "center",
		caption = "9999k",
		HitTest = function( self ) return self end,
		tooltip = expenseTooltip[ resName ],
		font = {
			size = fontSize,
			color = expenseColor,
		},
	}

	local shareBar = Trackbar:New{
		parent = resWidget,
		x = imageW + textW, width = resourceW - textW - imageW - offsetW,
		y = 0, height = "100%",
		value = 0, min = 0, max = 1, step = 0.01,
		thumbColor = { 1, 0, 0, 1 },
		noDrawStep	= true,
        noDrawBar	= true,
		noDrawThumb	= true,
		useValueTooltip = false,
		resName = resName,
		OnChange = {
			SetShareLevel
		},
	}

	local progressBar = Progressbar:New{
		parent = resWidget,
		padding = { 0, 0, 0, 0 },
		x = imageW + textW, width = resourceW - textW - imageW - offsetW,
		y = 0, height = "100%",
		color = progressbarColors[ resName ],
		caption = "1000M / 1000M",
		blink = 1.0, blinkStep = blinkStep,
		font = {
			size = fontSize,
		},
	}

	return {
		incomeLabel = incomeLabel,
		expenseLabel = expenseLabel,
		shareBar = shareBar,
		progressBar = progressBar
	}
end

----------------------------------------------------------------------------------------------------
function SetResourceBarParent( parent )
	parent:AddChild( resourceBarWidget )
end

----------------------------------------------------------------------------------------------------
local updateIntervalSec = 0.1
local lastTimer = 0.0
function UpdateResourceBarWidget( dt )

	-- blink
	if blinkTimer < blinkInterval then
		blinkTimer = blinkTimer + dt
	else
		blinkTimer = 0
		if blinkWidgets.metal then
			Blink( blinkWidgets.metal )
		end

		if blinkWidgets.energy then
			Blink( blinkWidgets.energy )
		end
	end

	-- update data
	if lastTimer < updateIntervalSec then
		lastTimer = lastTimer + dt
		return
	end

	lastTimer = 0.0
	
	myTeamID = SpGetMyTeamID()

	UpdateResource( "energy" )
	UpdateResource( "metal" )
	
	local seconds = Spring.GetGameSeconds()
	UpdateResource( "rearm", {storage = RESUPPLY_PERIOD - (seconds % RESUPPLY_PERIOD), storageSize = RESUPPLY_PERIOD, lastIncome = 0, lastConsumption = 0})
end
---------
-- and message handler for this

----------------------------------------------------------------------------------------------------
function UpdateResource( resName, resUpdateData )

	local current, storage,	pull, income, expense, share, sent, receive
	if (resUpdateData == nil) then -- metal, energy
		current, storage, pull, income, expense, share, sent, receive = SpGetTeamResources( myTeamID, resName )
	else -- custom resource
		current, storage, pull, income, expense, share, sent, receive = resUpdateData.storage, resUpdateData.storageSize, 0, resUpdateData.lastIncome, resUpdateData.lastConsumption, 0, 0, 0
	end
	
	local totalIncome = income + receive

	current = current + totalIncome - expense

	if current < 0 then
		current = 0
	elseif current > storage then
		current = storage
	end

	local w = resourceWidgets[ resName ]

	w.incomeLabel:SetCaption( GetShortNumber( totalIncome ) )

	w.expenseLabel:SetCaption( GetShortNumber( pull ) )

	if w.shareBar.value ~= share then
		w.shareBar.turnOffEvents = true
		w.shareBar:SetValue( share )
		w.shareBar.turnOffEvents = nil
	end

	local progressBar = w.progressBar

	local pullCoverage = totalIncome / pull
	if current < pull and pullCoverage < minExpenseCoverage[ resName ] then
		if not blinkWidgets[ resName ] then
			blinkWidgets[ resName ] = progressBar
			progressBar:SetCaption( needMessage[ resName ] )
			progressBar:SetValue( progressBar.max );
		end
	else
		if blinkWidgets[ resName ] then
			blinkWidgets[ resName ] = nil
			progressBar.color = progressbarColors[ resName ]
		end
		progressBar:SetValue( current / storage * 100 );
		
		-- special handling of rearm res
		if (resName == "rearm") then
			progressBar:SetCaption((HMSF(0,0, current, 0):Normalize()):HHMMSSFF(false, true, true, false))
		else
			progressBar:SetCaption( GetShortNumber( current ) .. " / " .. GetShortNumber( storage ) )
		end
		
	end
end

----------------------------------------------------------------------------------------------------
function UpdateResourceBarGeometry()

	local resourceBarW = ( offsetW + imageW + textW + resourceW ) * #resources
	resourceBarWidget.width = resourceBarW

	resourceBarWidget:SetPos( 0, 0 )
end

----------------------------------------------------------------------------------------------------
function ResetWidget()
	if resourceBarWidget then
		resourceBarWidget:Dispose()
	end
	blinkWidgets = {}

	CreateResourceBarWidget()
end

----------------------------------------------------------------------------------------------------
function Blink( widget )
	widget.blink = widget.blink + widget.blinkStep
	if widget.blink < minBlink then
		widget.blink = minBlink
		widget.blinkStep = -widget.blinkStep
	elseif widget.blink > maxBlink then
		widget.blink = maxBlink
		widget.blinkStep = -widget.blinkStep
	end

	local blinkColor = { 1, 0, 0, widget.blink }
	widget.color = blinkColor
	widget:Invalidate()
	--widget:SetColor( { 1, 0, 0, 1 } )
end

----------------------------------------------------------------------------------------------------
function SetShareLevel( self, v, vOld )
	if not self.turnOffEvents then
		local resName = self.resName
		if (resName == "metal" or resName == "energy") then
			SpSetShareLevel( resName, self.value )
		else
			-- TBD custom resource sharing
		end
		self.tooltip = barTooltip[ resName ]
			.. string_format( "%i %%", 100 - v * 100 )
	end
end

----------------------------------------------------------------------------------------------------
function ReadSettings()
	globalSize = SS44_UI.globalSize

	resourceBarH	= 16.4 * globalSize
	resourceW		= 104 * globalSize
	imageW			= 8 * globalSize
	offsetW			= 8 * globalSize
	textW			= 20 * globalSize

	fontSize		= 4.8 * globalSize
end

----------------------------------------------------------------------------------------------------
--                     Export constants and functions, used in other modules                      --
----------------------------------------------------------------------------------------------------
RESOURCE_BAR_WIDGET = {
	CreateResourceBarWidget		= CreateResourceBarWidget,
	SetResourceBarParent		= SetResourceBarParent,
	UpdateResourceBarGeometry	= UpdateResourceBarGeometry,
	UpdateResourceBarWidget		= UpdateResourceBarWidget,
	ResetWidget					= ResetWidget,
}
----------------------------------------------------------------------------------------------------
