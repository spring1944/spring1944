----------------------------------------------------------------------------------------------------
--                                        Local constants                                         --
----------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------
--                                        Local variables                                         --
----------------------------------------------------------------------------------------------------
local consoleWidget
local textWidget
local textAreaWidget
local textBoxWidget

local globalSize = 2.5


local consoleFontSize = 4.8 * globalSize
local textBoxH = 45
local textBoxOffset = 0.4 * globalSize



local cyclicBuffer = {}
local maxLineCount = 1000
local lastLine = 0

local chatLineCount = 7
local consoleLineCount = 20

local labelH = 8 * globalSize
local lineH = labelH

local consoleX, consoleY = 0, 16 * globalSize
local consoleW, consoleH = 296 * globalSize, lineH * ( chatLineCount + 1 )

local consoleOffset = 10
local consoleTextW = consoleW - 10 * globalSize
local labelW = consoleTextW - consoleOffset

local chatTransparency = 0.0
local textBoxTransparency = 0.5
local consoleTransparency = 0.5

-- Timer for hiding old lines
local timer = 0
-- Message time in sec, that line shown in chat box
local expiredTime = 10

local chatMode = true

local players

----------------------------------------------------------------------------------------------------
--                                      Function declarations                                     --
----------------------------------------------------------------------------------------------------
local function CreateConsoleWidget			() end
local function UpdateConsoleWidget			( dt ) end
local function UpdateConsoleGeometry		() end

local function AddConsoleLine				( line ) end
local function ToggleConsoleTextBox			() end
local function DisableConsoleTextBox		() end
local function UpdateInputTextBoxGeometry	() end
local function ToggleConsoleMode			() end

local function ResetWidget					() end

local function ReadSettings					() end

----------------------------------------------------------------------------------------------------
--                          Shortcut to used global functions to speedup                          --
----------------------------------------------------------------------------------------------------
local SpSendCommands	= Spring.SendCommands

local math_floor	= math.floor
local string_format	= string.format

local SetColorTransparency		= TOOLS.SetColorTransparency
local GetUnitIconByHumanName	= TOOLS.GetUnitIconByHumanName
local GetSideIconByName			= TOOLS.GetSideIconByName

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
function CreateConsoleWidget()
	
	-- setup NotAchili
	NotAchili		= WG.NotAchili
	Button		= NotAchili.Button
	Label		= NotAchili.Label
	Colorbars	= NotAchili.Colorbars
	Checkbox	= NotAchili.Checkbox
	Window		= NotAchili.Window
	ScrollPanel	= NotAchili.ScrollPanel
	StackPanel	= NotAchili.StackPanel
	LayoutPanel	= NotAchili.LayoutPanel
	Panel		= NotAchili.Panel
	Grid		= NotAchili.Grid
	Trackbar	= NotAchili.Trackbar
	TextBox		= NotAchili.TextBox
	Image		= NotAchili.Image
	Progressbar	= NotAchili.Progressbar
	Colorbars	= NotAchili.Colorbars
	Control		= NotAchili.Control
	screen0		= NotAchili.Screen0
	
	players	= NOTA_UI.players
	
	ReadSettings()
	
	consoleWidget = Panel:New{
		parent = screen0,
		right = consoleX, width = consoleW,
		y = consoleY, height = consoleH,
	}
	SetColorTransparency( consoleWidget.backgroundColor, chatTransparency )
	
	textWidget = ScrollPanel:New{
		parent = consoleWidget,
		x = 0, width = "100%",
		y = 0, height = consoleH,
		padding = { 0, 4, 5, 4 }, -- strictly for carbon skin
		verticalSmartScroll = true,
	}
	SetColorTransparency( textWidget.backgroundColor, chatTransparency )
	
	textAreaWidget = StackPanel:New{
		parent = textWidget,
		x = 0, width = "100%",
		y = 0,
		padding = { 2, 0, 0, 0 },
		autosize = true,
		resizeItems = false,
		itemMargin = { 0, 0, 0, 0 },
	}
	
	textBoxWidget = Panel:New{
		padding = { 10, 10, 10, 10 },
		x = 0, width = "100%",
		y = 0, height = textBoxH,
	}
	
	NOTA_UI.consoleWidget = consoleWidget
	
	UpdateConsoleGeometry()
end

----------------------------------------------------------------------------------------------------
local function UpdateChatLines()
	local chatLines = {}
	local lineIndex = lastLine
	for i = 1, chatLineCount do
		local line = cyclicBuffer[ lineIndex ]
		if not line then
			break
		end
		
		local delta = timer - line.timestamp
		if delta > expiredTime then
			break
		end
				
		chatLines[ i ] = line
		
		if lineIndex == 1 then
			lineIndex = maxLineCount
		else
			lineIndex = lineIndex - 1
		end
	end
	
	local isChanged = #chatLines ~= #textAreaWidget.children
		or chatLines[ #chatLines ] ~= textAreaWidget.children[ 1 ]

	if isChanged then
		if #textAreaWidget.children > 0 then
			textAreaWidget:ClearChildren()
		end
		
		if #chatLines > 0 then
			for i = #chatLines, 1, -1 do
				textAreaWidget:AddChild( chatLines[ i ] )
			end
		end
		textWidget:UpdateLayout()
		textAreaWidget:Invalidate()
	end
end

local function UpdateConsoleLines()
	local pastLastIndex = lastLine + 1
	local pastLastLine = cyclicBuffer[ pastLastIndex ]
	local firstChild = textAreaWidget.children[ 1 ]

	if pastLastLine then
		local isChanged = firstChild == nil
			or firstChild.caption ~= pastLastLine.caption

		if isChanged then
			if #textAreaWidget.children > 0 then
				textAreaWidget:ClearChildren()
			end

			local line, lineIndex = pastLastLine, pastLastIndex
			for i = 1, maxLineCount do
				textAreaWidget:AddChild( line )
				if lineIndex == maxLineCount then
					lineIndex = 1
				else
					lineIndex = lineIndex + 1
				end
				line = cyclicBuffer[ lineIndex ]
			end
			textWidget:UpdateLayout()
			textAreaWidget:Invalidate()

		end
	else
		local isNotFirst = firstChild == nil 
			or firstChild.caption ~= cyclicBuffer[ 1 ].caption

		if isNotFirst then
			if #textAreaWidget.children > 0 then
				textAreaWidget:ClearChildren()
			end

			for i = 1, lastLine do
				textAreaWidget:AddChild( cyclicBuffer[ i ] )
			end
			textWidget:UpdateLayout()
			textAreaWidget:Invalidate()

		elseif #textAreaWidget.children ~= lastLine then
			for i = #textAreaWidget.children + 1, lastLine do
				textAreaWidget:AddChild( cyclicBuffer[ i ] )
			end
			textWidget:UpdateLayout()
			textAreaWidget:Invalidate()

		end
	end
end

function UpdateConsoleWidget( dt )
	timer = timer + dt
	
	if chatMode then
		UpdateChatLines()
	else
		UpdateConsoleLines()
	end
end

----------------------------------------------------------------------------------------------------
function UpdateConsoleGeometry()
	consoleWidget:SetPos( screen0.width - consoleWidget.width )
	if textBoxWidget.parent then
		UpdateInputTextBoxGeometry()
	end
end

----------------------------------------------------------------------------------------------------
function AddConsoleLine( line )
	
	local lastLabel = cyclicBuffer[ lastLine ]
	if lastLabel then
		if lastLabel.message.rawText == line then
			local message = lastLabel.message
			message.count = message.count + 1
			
			lastLabel.caption = "\t\t[ " .. message.count .. "x ] " .. message.formattedText
			lastLabel.timestamp = timer
			
			return
		end
	end
	
	if lastLine == maxLineCount then
		lastLine = 1
	else
		lastLine = lastLine + 1
	end
	
	local parsed = ParseMessage( line )
	
	local lineLabel = Label:New{
		width = labelW, height = labelH,
		autosize = false,
		caption = "\t\t" .. parsed.formattedText,
		message = parsed,
		font = { 
			outline = true,
			size = consoleFontSize
		},
		timestamp = timer,
		padding = { 0, 0, 0, 0 },
	}
	
	-- multiline support for text longer then label width
	local textW = lineLabel.font:GetTextWidth( lineLabel.caption );
	if textW > labelW then
		lineLabel.lineCount = math.ceil( textW / labelW )
		lineLabel.height = labelH * lineLabel.lineCount
		lineLabel.caption = lineLabel.font:WrapText( lineLabel.caption, labelW, lineLabel.height )
	end
	
	if parsed.image then
		Image:New{
			parent = lineLabel,
			x = 0, width = labelH,
			y = 0, height = labelH,
			file = parsed.image,
			color = parsed.color,
		}
	end
	
	cyclicBuffer[ lastLine ] = lineLabel
end

----------------------------------------------------------------------------------------------------
function ToggleConsoleTextBox()
	if textBoxWidget.parent then
		DisableConsoleTextBox()
	else
		consoleWidget.inputText = true
		consoleWidget:AddChild( textBoxWidget )
		
		-- resize console, don't resize textArea
		consoleWidget:Resize( nil, consoleH + textBoxH, true, true )
		
		textBoxWidget:SetPos( nil, consoleH )
		UpdateInputTextBoxGeometry()
	end
end

function DisableConsoleTextBox()
	if textBoxWidget.parent then
		consoleWidget.inputText = false
		consoleWidget:RemoveChild( textBoxWidget )
		consoleWidget:Resize( nil, consoleH, true, true )
	end
end
----------------------------------------------------------------------------------------------------
function UpdateInputTextBoxGeometry()
	local clientArea = textBoxWidget.clientArea
	local w, h = clientArea[ 3 ], clientArea[ 4 ]
	local x, y = textBoxWidget:LocalToScreen( clientArea[ 1 ], clientArea[ 2 ] )
	local rx, ry = 1 / screen0.width, 1 / screen0.height
	
	local gx, gy, gw, gh = x * rx, 1 - ( y + h ) * ry, w * rx, h * ry
	SpSendCommands( string_format( "inputtextgeo %f %f %f %f", gx, gy, gw, gh ) )
	-- Default InputTextGeo = 0.26 0.73 0.02 0.028
end

----------------------------------------------------------------------------------------------------
function ToggleConsoleMode()
	chatMode = not chatMode
	
	if chatMode then
		SetColorTransparency( textWidget.backgroundColor, chatTransparency )
		consoleH = lineH * ( chatLineCount + 1 )
		textWidget.verticalSmartScroll = false
	else
		SetColorTransparency( textWidget.backgroundColor, consoleTransparency )
		consoleH = lineH * ( consoleLineCount + 1 )
		textWidget.verticalSmartScroll = true
	end
	
	textWidget.height = consoleH
	textAreaWidget:ClearChildren()
	textAreaWidget.height = 0
	
	if textBoxWidget.parent then
		consoleWidget:Resize( nil, consoleH + textBoxH, true, true )
	else
		consoleWidget:Resize( nil, consoleH, true, true )
	end
	
end

----------------------------------------------------------------------------------------------------
function ResetWidget()
	if consoleWidget then
		consoleWidget:Dispose()
	end
	
	cyclicBuffer = {}
	lastLine = 0
	
	CreateConsoleWidget()
	
	local buffer = Spring.GetConsoleBuffer( maxLineCount )
	for i = 1, #buffer do
		AddConsoleLine( buffer[ i ].text )
	end
end

----------------------------------------------------------------------------------------------------
function ReadSettings()
	globalSize = NOTA_UI.globalSize

	
	consoleFontSize = 5.6 * globalSize
	
	textBoxH = 45
	textBoxOffset = 0.4 * globalSize

	cyclicBuffer = {}
	lastLine = 0

	labelH = 8 * globalSize
	lineH = labelH
	
	consoleX, consoleY = 0, 16 * globalSize
	consoleW, consoleH = 296 * globalSize, lineH * ( chatLineCount + 1 )

	consoleTextW = consoleW - 10 * globalSize
	consoleOffset = NOTA_UI.skinMargin
	
	labelW = consoleTextW - consoleOffset
end

----------------------------------------------------------------------------------------------------
local green = "\255\0\255\0"
local red	= "\255\255\0\0"
local yellow= "\255\255\255\0"
local white	= "\255\255\255\255"
local gray	= "\255\127\127\127"

local specColor = "\255\255\255\127"
local playerNameColor = "\255\196\196\196"

local msgTypes
local msgTypesCount

do
	msgTypes = {
		{ msgType = 'player_to_allies',				pattern = '^<PLAYERNAME> Allies: (.*)',					msgFormat = "%s: " .. green		.. "%s", isPlayer = true },
		{ msgType = 'player_to_player_received',	pattern = '^<PLAYERNAME> Private: (.*)',				msgFormat = "%s: " .. yellow	.. "%s", isPlayer = true },				
		{ msgType = 'player_to_player_sent',		pattern = '^You whispered PLAYERNAME: (.*)',			msgFormat = "%s: " .. yellow	.. "%s", isPlayer = true },
		{ msgType = 'player_to_specs',				pattern = '^<PLAYERNAME> Spectators: (.*)',				msgFormat = "%s: " .. specColor	.. "%s", isPlayer = true },
		{ msgType = 'player_to_everyone',			pattern = '^<PLAYERNAME> (.*)',							msgFormat = "%s: " .. white		.. "%s", isPlayer = true },

		{ msgType = 'spec_to_specs',				pattern = '^%[PLAYERNAME%] Spectators: (.*)',			msgFormat = "%s: " .. specColor	.. "%s", isPlayer = true },
		{ msgType = 'spec_to_allies',				pattern = '^%[PLAYERNAME%] Allies: (.*)',				msgFormat = "%s: " .. green		.. "%s", isPlayer = true },
		{ msgType = 'spec_to_everyone',				pattern = '^%[PLAYERNAME%] (.*)',						msgFormat = "%s: " .. white		.. "%s", isPlayer = true },

		{ msgType = 'replay_spec_to_specs',			pattern = '^%[PLAYERNAME %(replay%)%] Spectators: (.*)',msgFormat = "%s: " .. specColor	.. "%s", isPlayer = true },
		{ msgType = 'replay_spec_to_allies',		pattern = '^%[PLAYERNAME %(replay%)%] Allies: (.*)',	msgFormat = "%s: " .. green		.. "%s", isPlayer = true },
		{ msgType = 'replay_spec_to_everyone',		pattern = '^%[PLAYERNAME %(replay%)%] (.*)',			msgFormat = "%s: " .. white		.. "%s", isPlayer = true },

		{ msgType = 'label',						pattern = '^PLAYERNAME added point: (.+)',				msgFormat = "%s pointed: " .. green	.. "%s", isPlayer = true },
		{ msgType = 'point',						pattern = '^PLAYERNAME added point: ',					msgFormat = "%s added point", isPlayer = true },
		
		{ msgType = 'under_attack',					pattern = '^-> (.+) is being attacked!',				msgFormat = "%s" .. red .. " attacked" },
		{ msgType = 'autohost',						pattern = '^> (.+)' },
		 
		 -- no pattern... will match anything else
		{ msgType = 'other', }
	}
	
	-- from zero-k cawidgets.lua
	-- to make message patterns easier to read/update
	local PLAYERNAME_PATTERN = '([%%w%%[%%]_]+)'
	msgTypesCount = #msgTypes
	
	for i = 1, msgTypesCount do
		local define = msgTypes[ i ]
		
		local pattern = define.pattern
		if pattern then
			define.pattern = pattern:gsub( 'PLAYERNAME', PLAYERNAME_PATTERN )
		end
	end
end

----------------------------------------------------------------------------------------------------
function ParseMessage( message )
	
	local result = {
		rawText = message,
		count = 1,
	}
	
	for i = 1, msgTypesCount do
		local define = msgTypes[ i ]
		local pattern = define.pattern
		
		 -- for fallback/other messages
		if pattern == nil then
			result.msgType = define.msgType
			result.formattedText = gray .. message
			return result
		end

		local capture1, capture2 = message:match( pattern )

		if capture1 then
			result.msgType = define.msgType

			if define.isPlayer then				
				local player = players[ capture1 ]
				if player then
					result.formattedText = string_format( define.msgFormat, 
						playerNameColor .. capture1, 
						capture2 or ''
					)
					
					if player.spectator then
						result.image		= "LuaUI/Widgets/notAchili/ss44UI/images/console/spectator.png"
						result.color		= { 1, 1, 1, 1 }
					else
						result.image		= GetSideIconByName( player.side )
						result.color		= player.color
					end
					return result
				end

			elseif define.msgType == "autohost" then
				result.formattedText = gray .. capture1
				return result
				
			elseif result.msgType == "under_attack" then
				result.formattedText = string_format( define.msgFormat, capture1 or '' )
				result.image = GetUnitIconByHumanName( capture1 )
				result.color = { 1, 0, 0, 1 }
				return result
				
			end
		end
	end
end


----------------------------------------------------------------------------------------------------
--                     Export constants and functions, used in other modules                      --
----------------------------------------------------------------------------------------------------
CONSOLE_WIDGET = {
	CreateConsoleWidget		= CreateConsoleWidget,
	UpdateConsoleWidget		= UpdateConsoleWidget,
	UpdateConsoleGeometry	= UpdateConsoleGeometry,
	AddConsoleLine			= AddConsoleLine,
	
	ToggleConsoleTextBox	= ToggleConsoleTextBox,
	DisableConsoleTextBox	= DisableConsoleTextBox,
	ToggleConsoleMode		= ToggleConsoleMode,
	
	ResetWidget				= ResetWidget,
}
----------------------------------------------------------------------------------------------------