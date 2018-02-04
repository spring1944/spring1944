-- MISSION GOALS WIDGET
-- derived from resources widget by PepeAmpere 2018-02-03

-- Function declarations
local function CreateMissionGoalsWidget() end
local function CreateMissionGoalAlly( goalData ) end
local function SetMissionGoalsParent( parent ) end
local function UpdateMissionGoalsWidget( dt ) end
local function UpdateMissionGoal( goalName ) end
local function UpdateMissionGoalsGeometry() end
local function ResetMissionGoalsWidget() end
local function Blink( widget ) end
local function ReadSettings() end

-- Shortcut to used global functions to speedup
local SpGetModKeyState = Spring.GetModKeyState
local SpGetMyTeamID	= Spring.GetMyTeamID
local SpGetTeamRulesParam = Spring.GetTeamRulesParam
local pairs	= pairs
local GetShortNumber = TOOLS.GetShortNumber
local myTeamID = SpGetMyTeamID()

-- Includes
-- get madatory module operators
VFS.Include("modules.lua") -- modules table
VFS.Include(modules.attach.data.path .. modules.attach.data.head) -- attach lib module

-- get other madatory dependencies
attach.Module(modules, "message")
HMSF = attach.Module(modules, "hmsf")

-- notaUI config
local includeDir = 'Widgets/notAchili/NotaUI/config/'

-- NotAchili UI shortcuts --
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

local HEIGHT = 100

local globalSize = SS44_UI.globalSize
local missionGoalsH = HEIGHT * globalSize

-- temp
local visualsPerType = {
	["Strongpoints_Capture"] = {
		strongpointImg = "flag.png",
	}
}

local allyGoals = {
	[1] = {
		key = "g1",
		ownerAllyID = 0,
		logic = {
			name = "Strongpoints_CaptureAmount",
			currentAmount = 10,
			amountToWin = 20,				
		},
		visual = {
			name = "Strongpoints_Capture",
		}
	},
	[2] = {
		key = "g2",
		ownerAllyID = 0,
		logic = {
			name = "Strongpoints_PreventCapturingAmount",
			ownerAllyID = 1,
			currentAmount = 5,
			amountToWin = 20,
		},
		visual = {
			name = "Strongpoints_Capture",
		}
	}
}

function CreateMissionGoalsWidget()

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

	missionGoalsWidget = Control:New{
		parent = parent,
		x = 0, y = 0,
		padding = { 0, 0, 0, 0 },
		height = missionGoalsH,
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
	
	for i, goalData in pairs (allyGoals) do
		goalsWidgets[goalData.key] = CreateMissionGoal(goalData)
	end

	SS44_UI.missionGoalsWidget = missionGoalsWidget
	UpdateMissionGoalsGeometry()
end

----------------------------------------------------------------------------------------------------
function CreateMissionGoal(goalData)

	local panel = missionGoalsWidget.children[1]

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
	parent:AddChild( missionGoalsWidget )
end

----------------------------------------------------------------------------------------------------
local updateIntervalSec = 0.1
local lastTimer = 0.0
function UpdatemissionGoalsWidget( dt )

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
function UpdateMissionGoalsGeometry()

	local resourceBarW = ( offsetW + imageW + textW + resourceW ) * #resources
	missionGoalsWidget.width = resourceBarW

	missionGoalsWidget:SetPos( 0, 0 )
end

----------------------------------------------------------------------------------------------------
function ResetWidget()
	if missionGoalsWidget then
		missionGoalsWidget:Dispose()
	end
	blinkWidgets = {}

	CreateMissionGoalsWidget()
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
	missionGoalsH = HEIGHT * globalSize
	resourceW = 104 * globalSize
	imageW = 8 * globalSize
	offsetW = 8 * globalSize
	textW = 20 * globalSize
	fontSize = 4.8 * globalSize
end

-- Export constants and functions, used in other modules
RESOURCE_BAR_WIDGET = {
	CreatemissionGoalsWidget = CreatemissionGoalsWidget,
	SetMissionGoalsParent = SetMissionGoalsParent,
	UpdateMissionGoalsGeometry = UpdateMissionGoalsGeometry,
	UpdatemissionGoalsWidget = UpdatemissionGoalsWidget,
	ResetWidget = ResetWidget,
}
