-- MISSION GOALS WIDGET
-- derived from resources widget by PepeAmpere 2018-02-03

-- Function declarations
local function CreateMissionGoalsWidget() end
local function CreateMissionGoalAlly(goalData) end
local function SetMissionGoalsParent(parent) end
local function UpdateMissionGoalsWidget(dt) end
local function UpdateMissionGoal(goalName) end
local function UpdateMissionGoalsGeometry() end
local function ResetallGoalsWidget() end
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
hmsf = attach.Module(modules, "hmsf")
local goalTypes = attach.Module(modules, "goals")

-- notaUI config
local includeDir = 'Widgets/notAchili/NotaUI/config/'

local SS44_UI_DIRNAME = "modules/notAchili/ss44UI/"
local confdata = VFS.Include( SS44_UI_DIRNAME .. "config/epicmenu_conf.lua" , nil, VFSMODE )
local epic_options = confdata.eopt
local epic_colors = confdata.color

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

local DEBUG = true

local CHECKBOX_WIDTH = 10
local COUNTER_WIDTH = 20
local DESCRIPTION_WIDTH = 90

local WIDGET_DEFAULT_HEIGHT = 50
local WIDGET_DEFAULT_WIDTH = CHECKBOX_WIDTH + COUNTER_WIDTH + DESCRIPTION_WIDTH
local FROM_TOP = 26

local ONE_GOAL_LINE_HEIGHT = CHECKBOX_WIDTH
local ONE_GOAL_MARGIN = 2
local ONE_GOAL_LABLE_MARGIN = 2
local DEFAULT_FONT_SIZE = 4
local HIGHLIGHT_FONT_SIZE = 5

local GOALS_BUTTON_WIDTH = 40
local GOALS_BUTTON_HEIGHT = 10
local GOALS_BUTTON_RIGHT = 2
local GOALS_BUTTON_TOP = 16

local myAllianceID = Spring.GetMyAllyTeamID()
local myTeamID = Spring.GetMyTeamID()

local globalSize = SS44_UI.globalSize

local allGoalsW
local allGoalsH
local fromTop

local oneGoalH
local oneGoalMarginLeft
local oneGoalMarginTop
local oneGoalMarginRight
local oneGoalMarginBottom
local oneGoalHFull

local oneGoalCheckboxSize
local oneGoalCheckboxMargin
local oneGoalIconSize

local oneGoalCounterW
local oneGoalCounterMarginLeft
local oneGoalCaptionW

local counterFontSize
local descriptionFontSize

local goalsButtonW
local goalsButtonH
local goalsButtonRight
local goalsButtonTop
local goalsButtonLableFontSize

local completedColor
local notCompletedColor

local goalsWidgets = {}
local missionGoals = {}

local showingGoals = true

function ReadSettings()
	globalSize = SS44_UI.globalSize

	allGoalsW = WIDGET_DEFAULT_WIDTH * globalSize
	allGoalsH = WIDGET_DEFAULT_HEIGHT * globalSize -- future: auto
	fromTop = FROM_TOP * globalSize

	oneGoalH = ONE_GOAL_LINE_HEIGHT * globalSize
	oneGoalMarginLeft = ONE_GOAL_MARGIN * globalSize
	oneGoalMarginTop = ONE_GOAL_MARGIN * globalSize
	oneGoalMarginRight = ONE_GOAL_MARGIN * globalSize * 4
	oneGoalMarginBottom = ONE_GOAL_MARGIN * globalSize
	oneGoalHFull = oneGoalH + oneGoalMarginTop + oneGoalMarginBottom

	oneGoalCheckboxSize = CHECKBOX_WIDTH * globalSize
	oneGoalCheckboxMargin = ONE_GOAL_LABLE_MARGIN * globalSize
	oneGoalIconSize = oneGoalH

	oneGoalCounterW = COUNTER_WIDTH * globalSize
	oneGoalCounterMarginLeft = oneGoalCheckboxMargin
	oneGoalCaptionW = allGoalsW - oneGoalMarginLeft - oneGoalMarginRight - oneGoalCheckboxSize - oneGoalCheckboxMargin - oneGoalCounterW

	counterFontSize = HIGHLIGHT_FONT_SIZE * globalSize
	descriptionFontSize =  DEFAULT_FONT_SIZE * globalSize

	goalsButtonW = GOALS_BUTTON_WIDTH * globalSize
	goalsButtonH = GOALS_BUTTON_HEIGHT * globalSize
	goalsButtonRight = GOALS_BUTTON_RIGHT * globalSize
	goalsButtonTop = GOALS_BUTTON_TOP * globalSize
	goalsButtonLableFontSize = HIGHLIGHT_FONT_SIZE * globalSize

	completedColor = {0.4, 1, 0.4, 1}
	notCompletedColor = {1, 1, 1, 1}
end

-- local inputGoals = {
	-- {
		-- key = "w1",
		-- goalType = "captureFlags",
	-- },
	-- {
		-- key = "w2",
		-- goalType = "holdFlags",
	-- },
	-- {
		-- key = "w3",
		-- goalType = "preventCapturingFlags",
	-- },
	-- {
		-- key = "w4",
		-- goalType = "preventHoldingFlags",
	-- }
-- }


-- for i=1, #inputGoals do
	-- local key = inputGoals[i].key
	-- local goalType = inputGoals[i].goalType
	-- local newIndex = #missionGoals + 1
	-- missionGoals[newIndex] = {
		-- key = key,
		-- goalType = goalType,
	-- }
	-- for k,v in pairs(goalTypes[goalType]) do
		-- missionGoals[newIndex][k] = v
	-- end
-- end

local function GetGoalIndexPerKey(goals, key)
	for i=1, #goals do
		if key == goals[i].key then
			return i
		end
	end
end

local function GetGoalLinesCount(goalData)
	--Spring.Echo(tableExt.Dump(goalData),4)
	return math.ceil(string.len(goalData.Description(goalData)) / (DESCRIPTION_WIDTH/2))
end

local function GetOneGoalHeight(goalData)
	return (GetGoalLinesCount(goalData) * oneGoalH + oneGoalMarginTop + oneGoalMarginBottom)
end

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
	Control = NotAchili.Control
	screen0 = NotAchili.Screen0

	ReadSettings()
	
	goalsButton = Button:New{
		right = goalsButtonRight,  
		y = goalsButtonTop,
		width = goalsButtonW, height = goalsButtonH,
		caption = "Mission Goals",
		parent = screen0,
		font = { size = goalsButtonLableFontSize },
		styleKey = "buttonResizable",
		OnMouseUp = { function() 
			if (showingGoals) then
				HideGoals()
			else
				ShowGoals()
			end
			showingGoals = not showingGoals
		end }, 
	}
	
	CreateGoals()
	UpdateMissionGoalsGeometry()
end

function CreateGoals()
	allGoalsWidget = Control:New{
		parent = screen0,
		right = 0,
		y = fromTop,
		padding = { 0, 0, 0, 0 },
		width = allGoalsW,
		--autosize = true,
		resizable = false,
		draggable = false,
		tweakDraggable = true,
		backgroundColor = epic_colors.main_bg,
		children = {
			StackPanel:New{
				width = "100%", height = "100%",
				orientation = "vertical",
				centerItems = false,
				resizeItems = true,
				itemPadding = {0, 0, 0, 0},
				itemMargin  = {0, 0, 0, 0},
				weightedResize = true,
			}
		},
	}
	
	-- if not development, this will be empty
	for i, goalData in pairs (missionGoals) do
		--Spring.Echo(tableExt.Dump(goalData))
		goalsWidgets[goalData.key] = CreateMissionGoal(goalData)
	end

	SS44_UI.allGoalsWidget = allGoalsWidget
end

function ShowGoals()
	CreateGoals()
end

function HideGoals()
	screen0:RemoveChild(allGoalsWidget)
end


function CreateMissionGoal(goalData)
	local height = GetOneGoalHeight(goalData)
	local panel = allGoalsWidget.children[1]
		
	oneGoalWidget = Control:New{
		parent = panel,
		width = allGoalsW,
		autosize = true,
		weight = height,
		backgroundColor = epic_colors.main_bg,
		children = {
			-- all added below
		},	
	}
	
	local checkbox = Checkbox:New{
		parent = oneGoalWidget,
		x = 0, y = 2,
		padding = {oneGoalMarginLeft, oneGoalMarginTop, oneGoalMarginRight, oneGoalMarginBottom},
		width = oneGoalCheckboxSize,
		caption = "", 
		checked = goalData.Value(goalData), 
		textColor = epic_colors.sub_fg, 
		tooltip = goalData.Tooltip(goalData),
		boxsize = oneGoalCheckboxSize - 1*globalSize,
		inputAllowed = false,
	}
	local counter = Label:New{
		parent = oneGoalWidget,
		x = oneGoalCheckboxSize + oneGoalCheckboxMargin + oneGoalCounterMarginLeft,
		y = 2, 
		height = height,
		width = oneGoalCounterW,
		autosize = false,
		valign = "top",
		align = "left",
		caption = goalData.Counter(goalData),
		HitTest = function( self ) return self end,
		font = {
			size = counterFontSize,
			outline = true,
			outlineWidth = 5,
			outlineColor = { 0.1, 0.1, 0.1, 0.9 },
		},
	}
	local description = Label:New{
		parent = oneGoalWidget,
		x = oneGoalCheckboxSize + oneGoalCheckboxMargin + oneGoalCounterW, 
		y = 2,
		height = height,
		width = oneGoalCaptionW,
		autosize = false,
		valign = "top",
		align = "left",
		caption = goalData.Description(goalData),
		HitTest = function( self ) return self end,
		font = {
			size = descriptionFontSize,
			outline = true,
			outlineWidth = 3.5,
			outlineColor = { 0.1, 0.1, 0.1, 0.9 },
		},
	}
	
	return {
		checkbox = checkbox,
		counter = counter,
		description = description,
		oneGoalWidget = oneGoalWidget,
	}
end

function SetMissionGoalsParent(parent)
	parent:AddChild(allGoalsWidget)
end

function UpdateMissionGoalsWidget(dt)

	local encodedMissionGoals = SpGetTeamRulesParam(myTeamID, "missionGoals")
	if (encodedMissionGoals ~= nil) then
		local rawMissionGoals = message.Decode(encodedMissionGoals)
		
		for index=1, #rawMissionGoals do
			local goalData = rawMissionGoals[index]
			local key = goalData.key
			local goalType = goalData.goalType
			local creationNeeded = false
			
			if (missionGoals[index] == nil) then
				-- init goal table
				missionGoals[index] = {
					key = key,
					goalType = goalType,
				}
				-- init goal per type
				for k,v in pairs(goalTypes[goalType]) do
					missionGoals[index][k] = v
				end
				
				creationNeeded = true
			end
			
			-- apply update patch
			for k,v in pairs(goalData) do
				missionGoals[index][k] = v
			end
			
			-- create after all patches applied
			if (creationNeeded) then
				goalsWidgets[goalData.key] = CreateMissionGoal(missionGoals[index])
			end
			
			-- update UI
			UpdateGoal(missionGoals[index])
		end
	end
	UpdateMissionGoalsGeometry()
end

function UpdateGoal(goalData)
	
	local w = goalsWidgets[goalData.key]
	
	if (goalData.Value(goalData)) then
		if (not w.checkbox.checked) then
			w.checkbox:Toggle()
		end
		w.counter.font.color = completedColor
		w.description.font.color = completedColor
	else
		if (w.checkbox.checked) then
			w.checkbox:Toggle()
		end		
		w.counter.font.color = notCompletedColor
		w.description.font.color = notCompletedColor
	end
	
	w.checkbox.tooltip = goalData.Tooltip(goalData)
	w.counter:SetCaption(goalData.Counter(goalData))
	w.description:SetCaption(goalData.Description(goalData))
	w.oneGoalWidget.weight = GetOneGoalHeight(goalData)
	-- update hack until color updates are fixed on caption in notAchili framework
	w.description:Invalidate()
	w.counter:Invalidate()
end

function UpdateMissionGoalsGeometry()
	local height = 0
	for i=1, #missionGoals do
		height = height + GetOneGoalHeight(missionGoals[i])
	end
	allGoalsWidget:Resize(allGoalsW, height)
	goalsButton:Resize(goalsButtonW, goalsButtonH)
	allGoalsWidget:Invalidate()
	goalsButton:Invalidate()
end

function ResetWidget()
	if allGoalsWidget then
		allGoalsWidget:Dispose()
	end
	if goalsButton then
		goalsButton:Dispose()
	end
	CreateMissionGoalsWidget()
end

-- Export constants and functions, used in other modules
MISSION_GOALS_WIDGET = {
	CreateMissionGoalsWidget = CreateMissionGoalsWidget,
	SetMissionGoalsParent = SetMissionGoalsParent,
	UpdateMissionGoalsGeometry = UpdateMissionGoalsGeometry,
	UpdateMissionGoalsWidget = UpdateMissionGoalsWidget,
	ResetWidget = ResetWidget,
}
