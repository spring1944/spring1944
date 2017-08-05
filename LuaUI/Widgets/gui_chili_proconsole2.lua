--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

function widget:GetInfo()
	return {
		name         = "Chili Pro Console2",
		desc         = "v2.004 Chili Chat Pro Console.",
		author       = "CarRepairer (adapted to S44 by Jose Luis Cercos-Pita)",
		date         = "2014-04-20",
		license      = "GNU GPL, v2 or later",
		layer        = 50,
		experimental = false,
		enabled      = false,
	}
end

include("keysym.h.lua")
local myName, transmitMagic, voiceMagic, transmitLobbyMagic, MessageProcessor = include("chat_preprocess.lua")
SetCameraTarget = Spring.SetCameraTarget

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

-- message rules - widget stuff
--[[
each message definition can have:
	- either 1 format
	- either name + output, output containing pairs of { name = '', format = '' }
all the names are used when displaying the options

format syntax:
- #x : switch to color 'x' where 'x' can be:
	- a : ally (option)
	- e : everyone (option)
	- o : other (option)
	- s : spec (option)
	- h : highlight (option)
	- p : color of the player who sent message (dynamic)
- $var : gets replaced by msg['var'] ; interesting vars:
	- playername
	- argument	for messages, this is only the message part; for labels, this is the caption
	- msgtype	type of message as identified by parseMessage()
	- priority	as received by widget:AddConsoleLine()
	- text		full message, as received by widget:AddConsoleLine()

--]]
local MESSAGE_RULES = {
	player_to_allies = {
		name = "Player to allies message",
		output = {
			{
				name = "Only bracket in player's color, message in 'ally' color",
				format = '#p<#e$playername#p> #a$argument'
			},
			{
				name = "Playername in his color, message in 'ally' color",
				format = '#p<$playername> #a$argument',
				default = true
			},
			{
				name = "Playername and message in player's color",
				format = '#p<$playername> $argument'
			},
		}
	},
	player_to_player_received = { format = '#p*$playername* $argument' },
	player_to_player_sent = { format = '#p -> *$playername* $argument' }, -- NOTE: #p will be color of destination player!
	player_to_specs = { format = '#p<$playername> #s$argument' },
	player_to_everyone = { format = '#p<$playername> #e$argument' },

	spec_to_specs = { format = '#s[$playername] $argument' },
	spec_to_allies = { format = '#s[$playername] $argument' }, -- TODO is there a reason to differentiate spec_to_specs and spec_to_allies??
	spec_to_everyone = { format = '#s[$playername] #e$argument' },

	-- shameful copy-paste -- TODO remove this duplication
	replay_spec_to_specs = { format = '#s[$playername (replay)] $argument' },
	replay_spec_to_allies = { format = '#s[$playername (replay)] $argument' }, -- TODO is there a reason to differentiate spec_to_specs and spec_to_allies??
	replay_spec_to_everyone = { format = '#s[$playername (replay)] #e$argument' },

	label = { format = '#p$playername#e added label: $argument' },
	point = { format = '#p$playername#e added point.' },
	autohost = { format = '#o> $argument', noplayername = true },
	other = { format = '#o$text' }, -- no pattern... will match anything else
	game_message = { format = '#o$text' } -- no pattern...
}

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

local SOUNDS = {
	ally = "sounds/talk.wav",
	label = "sounds/talk.wav",
	highlight = "LuaUI/Sounds/communism/cash-register-01.wav" -- TODO find a better sound :)
}

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

local HIGHLIGHT_SURROUND_SEQUENCE_1 = ' >>> '
local HIGHLIGHT_SURROUND_SEQUENCE_2 = ' <<<'
local DEDUPE_SUFFIX = 'x '

local MIN_HEIGHT = 50
local MIN_WIDTH = 300
local MAX_STORED_MESSAGES = 300

local LEFTCOLWIDTH = 120

local inputsize = 25

local MUTE_SPECTATORS = false  -- Get it from modoptions
local MUTE_LOBBY = false  -- Get it from modoptions

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

WG.enteringText = false
WG.chat = WG.chat or {}

local screen0
local myName -- my console name
local myAllyTeamId

local control_id = 0
local stack_console, stack_chat, stack_backchat
local window_console, window_chat
local killTracker = {}
local fadeTracker = {}
local scrollpanel_chat, scrollpanel_console, scrollpanel_backchat
local inputspace
local backlogButton
local backlogButtonImage
local consoleButton
local consoleButtonImage

local echo = Spring.Echo

local incolor_dup
local incolor_highlight
--local incolors = {} -- incolors indexed by playername + special #a/#e/#o/#s/#h colors based on config--
local teamColors = {} -- incolors indexed by playername + special #a/#e/#o/#s/#h colors based on config

local consoleMessages = {} -- message buffer
local chatMessages = {} -- message buffer
local highlightPattern -- currently based on player name -- TODO add configurable list of highlight patterns

local firstEnter = true --used to activate ally-chat at game start. To run once
local noAlly = false	--used to skip the ally-chat above. eg: if 1vs1 skip ally-chat

local decayTime = 20 

local lastMsgChat, lastMsgBackChat, lastMsgConsole

------------------------------------------------------------
-- options

options = {
	lblAutohide = {name='Auto Hiding', type='label'},
	lblGeneral = {name='General Settings', type='label'},
	lblMisc = {name='Misc. Settings', type='label'},
	
	error_opengl_source = {
		value = true,
	},
	
	enableConsole = {
		value = false,
	},
	
	text_height_chat = {
		value = 14,
	},
	text_height_console = {
		value = 14,
	},
	
	highlighted_text_height = {
		value = 16,
	},
	clickable_points = {
		value = true,
	},
	
	-- TODO work in progress
	dedupe_messages = {
		value = true,
	},
	dedupe_points = {
		value = true,
	},
	highlight_all_private = {
		value = true,
	},
	highlight_filter_allies = {
		value = true,
	},
	highlight_filter_enemies = {
		value = true,
	},
	highlight_filter_specs = {
		value = true,
	},
	highlight_filter_other = {
		value = false,
	},
	highlight_sound = {
		value = false,
	},
	hideSpec = {
		value = false,
	},
	hideAlly = {
		value = false,
	},
	hidePoint = {
		value = false,
	},
	hideLabel = {
		value = false,
	},
	hideLog = {
		value = false,
	},
	max_lines = {
		value = 60,
	},
	
	color_chat = {
		value = { 1, 1, 1, 1 },
	},
	color_ally = {
		value = { 0.2, 1, 0.2, 1 },
	},
	color_other = {
		value = { 0.6, 0.6, 0.6, 1 },
	},
	color_spec = {
		value = { 0.8, 0.8, 0.8, 1 },
	},
	color_highlight = {
		value = { 1, 1, 0.2, 1 },
	},
	color_chat_background = {
		value = { 0, 0, 0, 0},
	},
	color_console_background = {
		value = { 0, 0, 0, 0},
	},
	defaultAllyChat = {
		value = true,
	},
	defaultBacklogEnabled = {
		value = false,
	},
	mousewheelBacklog = {
		value = true,
	},
	enableSwap = {
		value = true,
	},
	changeFont = {
		value = false,
	},
	enableChatBackground = {
		value = false,
	},
	backchatOpacity = {
		value = 0.5,
	},
	autohide_text_time = {
		value = 20,
	},
	
}
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--functions

local function SetInputFontSize(size)
	if options.changeFont.value then
		Spring.SetConfigInt("FontSize", size, true) --3rd param true is "this game only"
		Spring.SendCommands('font ' .. WG.Chili.EditBox.font.font)
	end
end	

--------------------------------------------------------------------------------
-- TODO : should these pattern/escape functions be moved to some shared file/library?

local function nocase(s)
	return string.gsub(s, "%a", function (c)
		return string.format("[%s%s]", string.lower(c), string.upper(c))
	end)
end

local function escapePatternMatchChars(s)
	return string.gsub(s, "(%W)", "%%%1")
end

local function caseInsensitivePattern(s)
	return nocase(escapePatternMatchChars(s))
end

-- local widget only
function getMessageRuleOptionName(msgtype, suboption)
	return msgtype .. "_" .. suboption
end

--[[
for msgtype,rule in pairs(MESSAGE_RULES) do
	if rule.output and rule.name then -- if definition has multiple output formats, make associated config option
		local option_name = getMessageRuleOptionName(msgtype, "output_format")
		options_order[#options_order + 1] = option_name
		local o = {
			name = "Format for " .. rule.name,
			type = 'list',
			OnChange = function (self)
				Spring.Echo('Selected: ' .. self.value)
				onOptionsChanged()
			end,
			value = '1', -- may be overriden
			items = {},
			advanced = true,
		}
		
		for i, output in ipairs(rule.output) do
			o.items[i] = { key = i, name = output.name }
			if output.default then
				o.value = i
			end
		end
		options[option_name] = o
	end
end

local function getOutputFormat(msgtype)
	local rule = MESSAGE_RULES[msgtype]
	if not rule then
		Spring.Echo("UNKNOWN MESSAGE TYPE: " .. msgtype or "NiL")
		return
	elseif rule.output then -- rule has multiple user-selectable output formats
		local option_name = getMessageRuleOptionName(msgtype, "output_format")
		local value = options[option_name].value
		return rule.output[value].format
	else -- rule has only 1 format defined
		return rule.format
	end
end
--]]

local function getSource(spec, allyTeamId)
	return (spec and 'spec')
		or ((Spring.GetMyTeamID() == allyTeamId) and 'ally')
		or 'enemy'
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

local function PlaySound(id, condition)
	if condition ~= nil and not condition then
		return
	end
	local file = SOUNDS[id]
	if file then
		Spring.PlaySoundFile(file, 1, 'ui')
	end
end

local function detectHighlight(msg)
	-- must handle case where we are spec and message comes from player

	if msg.msgtype == 'player_to_player_received' and options.highlight_all_private.value then
		msg.highlight = true
		return
	end

	-- Spring.Echo("msg.source = " .. (msg.source or 'NiL'))

	if msg.source == 'ally' and not options.highlight_filter_allies.value
	or msg.source == 'enemy' and not options.highlight_filter_enemies.value
	or msg.source == 'spec' and not options.highlight_filter_specs.value
	or msg.source == 'other' and not options.highlight_filter_other.value then
		return
	end

	if (msg.argument and msg.argument:find(highlightPattern)) then
		msg.highlight = true
	end
end

local function escape_lua_pattern(s)

	local matches =
	{
		["^"] = "%^";
		["$"] = "%$";
		["("] = "%(";
		[")"] = "%)";
		["%"] = "%%";
		["."] = "%.";
		["["] = "%[";
		["]"] = "%]";
		["*"] = "%*";
		["+"] = "%+";
		["-"] = "%-";
		["?"] = "%?";
		["\0"] = "%z";
	}

	return (s:gsub(".", matches))
end

local function formatMessage(msg)
--[[
	local format = getOutputFormat(msg.msgtype) or getOutputFormat("other")
	
	-- insert/sandwich colour string into text
	local formatted, _ = format:gsub('([#%$]%w+)', function(parameter) -- FIXME pattern too broad for 1-char color specifiers
			if parameter:sub(1,1) == '$' then
				return msg[parameter:sub(2,parameter:len())]
			elseif parameter == '#p' then
				if msg.playername and incolors[msg.playername] then
					return incolors[msg.playername]
				else
					return incolors['#o'] -- player still at lobby, use grey text
				end
			else
				return incolors[parameter]
			end
		end)
	msg.formatted = formatted
	--]]
	msg.textFormatted = msg.text
	if msg.playername then
		local out = msg.text
		local playerName = escape_lua_pattern(msg.playername)
		out = out:gsub( '^<' .. playerName ..'> ', '' )
		out = out:gsub( '^%[' .. playerName ..'%] ', '' )
		msg.textFormatted = out
	end
	msg.source2 = msg.playername or ''
end

local function MessageIsChatInfo(msg)
	return string.find(msg.argument,'Speed set to') or
	string.find(msg.argument,'following') or
	string.find(msg.argument,'Connection attempted') or
	string.find(msg.argument,'exited') or 
	string.find(msg.argument,'is no more') or 
	string.find(msg.argument,'paused the game') or
	string.find(msg.argument,'Sync error for') or
	string.find(msg.argument,'Cheating is') or
	string.find(msg.argument,'resigned') or
	string.find(msg.argument,'Buildings set') or
	(string.find(msg.argument,'left the game') and string.find(msg.argument,'Player'))
	--string.find(msg.argument,'Team') --endgame comedic message. Engine message, loaded from gamedata/messages.lua (hopefully 'Team' with capital 'T' is not used anywhere else)
end

local function hideMessage(msg)
	return (msg.msgtype == "spec_to_everyone" and options.hideSpec.value) -- can only hide spec when playing
		or (msg.msgtype == "player_to_allies" and options.hideAlly.value)
		or (msg.msgtype == "point" and options.hidePoint.value)
		or (msg.msgtype == "label" and options.hideLabel.value)
		or (msg.msgtype == 'other' and options.hideLog.value and not MessageIsChatInfo(msg))
end


local function AddControlToFadeTracker(control, fadeType)
	control.life = decayTime
	control.fadeType = fadeType or ''
	killTracker[control_id] = control
	control_id = control_id + 1
end

local msgTypeColors = {
	player_to_allies 	= 'color_ally';
	spec_to_allies		= 'color_ally';
	player_to_specs		= 'color_spec';
	spec_to_specs		= 'color_spec';
	other				= 'color_other';
	autohost			= 'color_other';
}

local function GetColor(msg)
	if msg.highlight then
		return options.color_highlight.value
	end
	return options[ msgTypeColors[msg.msgtype] or 'color_chat' ].value
end

local function AddMessage(msg, target, remake)
	if hideMessage(msg) or (not WG.Chili) then
		return
	end

	local stack
	local fade
	local size
	local lastMsg
	local size
	if target == 'chat' then
		stack = stack_chat
		size = options.text_height_chat.value
		if not remake then
			fade = true
		end
		lastMsg = lastMsgChat
	elseif target == 'console' then
		stack = stack_console
		size = options.text_height_console.value
		lastMsg = lastMsgConsole
	elseif target == 'backchat' then
		size = options.text_height_chat.value
		stack = stack_backchat
		lastMsg = lastMsgBackChat
	end

	-- TODO betterify this / make configurable
	--[[
	local highlight_sequence1 = (msg.highlight and options.highlight_surround.value and (incolor_highlight .. HIGHLIGHT_SURROUND_SEQUENCE_1) or '')
	local highlight_sequence2 = (msg.highlight and options.highlight_surround.value and (incolor_highlight .. HIGHLIGHT_SURROUND_SEQUENCE_2) or '')
	--local text = (msg.dup > 1 and (incolor_dup .. msg.dup .. DEDUPE_SUFFIX) or '') .. highlight_sequence1 .. msg.textFormatted .. highlight_sequence2
	local text = (msg.dup > 1 and (msg.dup .. DEDUPE_SUFFIX) or '') .. highlight_sequence1 .. msg.textFormatted .. highlight_sequence2
	--]]
	local text = (msg.dup > 1 and (msg.dup .. DEDUPE_SUFFIX) or '') .. msg.textFormatted

	if msg.dup > 1 and not remake then
		if lastMsg then
			if lastMsg.SetText then
				lastMsg:SetText(text)
				-- UpdateClientArea() is not enough - last message keeps disappearing until new message is added
				lastMsg:Invalidate()
			end
		end
		return
	end

	local control 
	local sourceTextBox
	local message
	local messageTextBox
	local flagButton

	local messageText = msg.text
	if target == 'chat' or target == 'backchat' then
		messageText = msg.textFormatted
	end

	--colors
	local messageColor = GetColor(msg)

	local nameColor = teamColors[msg.source2] or {1,1,1,1}

	messageTextBox = WG.Chili.TextBox:New{
		width = '100%',
		align = "left",
		fontsize = size,
		valign = "ascender",
		lineSpacing = 1,
		padding = { 2,2,2,2 },
		text = messageText,
		fontShadow=false,
		autoHeight=true,
		--[[
		autoHeight=true,
		autoObeyLineHeight=true,
		--]]
		font = {
			-- [[
			outlineWidth = 3,
			outlineWeight = 10,
			outline = true,
			--]]
			--color         = {1,0,0,1},
			color         = messageColor,
		}
	}

	local messageTextBoxCont = WG.Chili.StackPanel:New{
		--width = '100%',
		orientation='horizontal';
		right=0;
		x=LEFTCOLWIDTH +10 + (msg.point and 30 or 0);
		autosize = true,
		resizeItems = false,
		centerItems = false,
		padding={0,0,0,0};
		itemMargin  = {0,0,0,0},
		children = {messageTextBox};
	}


	sourceTextBox = WG.Chili.Label:New{
		caption = msg.source2,
		width = LEFTCOLWIDTH,
		align = "right",
		fontsize = size,
		--valign = "ascender",
		lineSpacing = 0,
		padding = { 0, 0, 0, 0 },
		
		fontShadow=false,
		autoHeight=true,
		--autoObeyLineHeight=true,
		
		font = {
			-- outlineWidth = 3,
			-- outlineWeight = 10,
			-- outline = true,
			color = nameColor,
		}
	}

	local controlChildren = {sourceTextBox, messageTextBoxCont}
	if msg.point then
		flagButton = WG.Chili.Button:New{
			caption='',
			x=LEFTCOLWIDTH + 10;
			--y=0;
			width = 30,
			--height = 18,
			height = '100%',
			
			backgroundColor = {1,1,1,1},
			padding = {2,2,2,2},
			children = {
				WG.Chili.Image:New {
					x=7;y=1;
					width = 12,
					height = '100%',
					keepAspect = true,
					file = 'LuaUI/Images/Crystal_Clear_action_flag.png',
				}
			},
			OnClick = {function(self, x, y, mouse)
				if not options.clickable_points.value then
					return
				end
				local alt,ctrl, meta,shift = Spring.GetModKeyState()
				if (shift or ctrl or meta or alt) or ( mouse ~= 1 ) then return false end --skip modifier key since they indirectly meant player are using click to issue command (do not steal click)
				SetCameraTarget(msg.point.x, msg.point.y, msg.point.z, 1)
			end}
		}
		controlChildren = {sourceTextBox, flagButton, messageTextBoxCont}
	end
	--control = WG.Chili.Grid:New{
	control = WG.Chili.Panel:New{
		--columns=2,
		width = '100%',
		orientation = "horizontal",
		padding = {0,0,0,0},
		margin = {0,0,0,0},
		--itemPadding = {5,5,5,5};
		--backgroundColor = {0,0,0,0.5};
		backgroundColor = {0,0,0,0};
		autosize = true,
		resizeItems = false,
		centerItems = false,
		children = controlChildren;		
	}

	if target == 'chat' or target == 'backchat' then
		stack:AddChild(control, false)
	else
		stack:AddChild(messageTextBox, false)
	end

	if fade then
		AddControlToFadeTracker(control)
		AddControlToFadeTracker(messageTextBox, 'text')
		AddControlToFadeTracker(sourceTextBox, 'text')
		if msg.point then
			AddControlToFadeTracker(flagButton, 'button')
		end
	end

	--[[
		elseif WG.alliedCursorsPos and msg.player and msg.player.id then --message is regular chat, make hidden button
			local cur = WG.alliedCursorsPos[msg.player.id]
			if cur then
				textbox.OnMouseDown = {function(self, x, y, mouse)
						local alt,ctrl, meta,shift = Spring.GetModKeyState()
						if ( shift or ctrl or meta or alt ) then return false end --skip all modifier key
						local click_on_text = x <= textbox.font:GetTextWidth(self.text); -- use self.text instead of text to include dedupe message prefix
						if (mouse == 1 and click_on_text) then
							SetCameraTarget(cur[1], 0,cur[2], 1) --go to where player is pointing at. NOTE: "cur" is table referenced to "WG.alliedCursorsPos" so its always updated with latest value
						end
				end}
				function textbox:HitTest(x, y)  -- copied this hack from chili bubbles
					return self
				end
			end
		end
	--]]

	if target == 'chat' then
		lastMsgChat = messageTextBox
	elseif target == 'backchat' then
		lastMsgBackChat = messageTextBox
	else
		lastMsgConsole = messageTextBox
	end

	stack:UpdateClientArea()
end 

local function setupPlayers(playerID)
	if playerID then
		local name, active, spec, teamId, allyTeamId = Spring.GetPlayerInfo(playerID)
		--lobby: grey chat, spec: white chat, player: color chat
		teamColors[name] = (spec and {1,1,1,1}) or {Spring.GetTeamColor(teamId)}
	else
		local playerroster = Spring.GetPlayerList()
		for i, id in ipairs(playerroster) do
			local name,active, spec, teamId, allyTeamId = Spring.GetPlayerInfo(id)
			--lobby: grey chat, spec: white chat, player: color chat
			teamColors[name] = (spec and {1,1,1,1}) or {Spring.GetTeamColor(teamId)}
		end
	end
end

local function SetupAITeamColor() --Copied from gui_chili_chat2_1.lua
	-- register any AIs
	-- Copied from gui_chili_crudeplayerlist.lua
	local teamsSorted = Spring.GetTeamList()
	for i=1,#teamsSorted do
		local teamID = teamsSorted[i]
		if teamID ~= Spring.GetGaiaTeamID() then
			local isAI = select(4,Spring.GetTeamInfo(teamID))
			if isAI then
				local name = select(2,Spring.GetAIInfo(teamID))
				teamColors[name] = {Spring.GetTeamColor(teamID)}
			end
		end --if teamID ~= Spring.GetGaiaTeamID() 
	end --for each team		
end

local function setupMyself()
	myName, _, _, _, myAllyTeamId = Spring.GetPlayerInfo(Spring.GetMyPlayerID()) -- or do it in the loop?
	highlightPattern = caseInsensitivePattern(myName)
end

local function setup()
	setupMyself()
	--setupColors()
	setupPlayers()
	SetupAITeamColor()
end

local function removeToMaxLines()
	while #stack_console.children > options.max_lines.value do
		-- stack:RemoveChild(stack.children[1]) --disconnect children
		if stack_console.children[1] then
			stack_console.children[1]:Dispose() --dispose/disconnect children (safer)
		end
		--stack:UpdateLayout()
	end
	while #stack_backchat.children > options.max_lines.value do
		-- stack:RemoveChild(stack.children[1]) --disconnect children
		if stack_backchat.children[1] then
			stack_backchat.children[1]:Dispose() --dispose/disconnect children (safer)
		end
		--stack:UpdateLayout()
	end
end


function RemakeConsole()
	setup()
	-- stack_console:ClearChildren() --disconnect from all children
	for i=1, #stack_console.children do
		stack_console.children[1]:Dispose() --dispose/disconnect all children (safer)
	end

	for i=1, #stack_backchat.children do
		stack_backchat.children[1]:Dispose() --dispose/disconnect all children (safer)
	end

	-- FIXME : messages collection changing while iterating (if max_lines option has been shrinked)
	for i = 1, #chatMessages do 
		local msg = chatMessages[i]
		--AddMessage(msg, 'chat', true, true )
		AddMessage(msg, 'backchat', true )
	end
	for i = 1, #consoleMessages do 
		local msg = consoleMessages[i]
		AddMessage(msg, 'console', true )
	end
	removeToMaxLines()

end

local function ShowInputSpace()
	WG.enteringText = true
	inputspace.backgroundColor = {1,1,1,1}
	inputspace.borderColor = {0,0,0,1}
	inputspace:Invalidate()
end
local function HideInputSpace()
	WG.enteringText = false
	inputspace.backgroundColor = {0,0,0,0}
	inputspace.borderColor = {0,0,0,0}
	inputspace:Invalidate()
end

local function MakeMessageStack(margin)
	return WG.Chili.StackPanel:New{
		margin = { 0, 0, 0, 0 },
		padding = { 0, 0, 0, 0 },
		x = 0,
		y = 0,
		--width = '100%',
		right=5,
		height = 10,
		resizeItems = false,
		itemPadding  = { 1, 1, 1, 1 },
		itemMargin  = { margin, margin, margin, margin },
		autosize = true,
		preserveChildrenOrder = true,
	}
end

local function MakeMessageWindow(name, enabled)
	local x,y,bottom,width,height
	local screenWidth, screenHeight = Spring.GetWindowGeometry()
	if name == "ProChat" then
		local integralWidth = math.max(350, math.min(450, screenWidth*screenHeight*0.0004))
		local integralHeight = math.min(screenHeight/4.5, 200*integralWidth/450)
		width = 450
		x = integralWidth
		height = integralHeight*0.84
		bottom = integralHeight*0.84
	else
		local resourceBarWidth = 430
		local maxWidth = math.min(screenWidth/2 - resourceBarWidth/2, screenWidth - 400 - resourceBarWidth)
		bottom = nil
		width  = screenWidth * 0.30
		height = screenHeight * 0.20
		x = screenWidth - width
		y = 50
		if maxWidth < width then
			y = 50 -- resource bar height
		end
	end

	return WG.Chili.Window:New{
		parent = (enabled and screen0) or nil,
		margin = { 0, 0, 0, 0 },
		padding = { 0, 0, 0, 0 },
		dockable = true,
		name = name,
		x = x,
		y = y,
		bottom = bottom,
		width  = width,
		height = height,
		draggable = false,
		resizable = false,
		tweakDraggable = true,
		tweakResizable = true,
		minimizable = false,
		parentWidgetName = widget:GetInfo().name, --for gui_chili_docking.lua (minimize function)
		minWidth = MIN_WIDTH,
		minHeight = MIN_HEIGHT,
		maxHeight = 500,
		color = { 0, 0, 0, 0 },
	}
end

local showingBackchat = false
local function SwapBacklog()
	if showingBackchat then
		window_chat:RemoveChild(scrollpanel_backchat)
		window_chat:AddChild(scrollpanel_chat)
		backlogButtonImage.file = 'LuaUI/Images/arrowhead.png'
		backlogButtonImage:Invalidate()
	else
		window_chat:RemoveChild(scrollpanel_chat)
		window_chat:AddChild(scrollpanel_backchat)
		backlogButtonImage.file = 'LuaUI/Images/arrowhead_flipped.png'
		backlogButtonImage:Invalidate()
	end
	showingBackchat = not showingBackchat
end

local showingConsole = options.enableConsole.value
local function SwitchConsole()
	if showingConsole then
		screen0:RemoveChild(window_console)
	else
		screen0:AddChild(window_console)
	end
	showingConsole = not showingConsole
end

-----------------------------------------------------------------------
-- callins
-----------------------------------------------------------------------


function widget:KeyPress(key, modifier, isRepeat)
	if (key == KEYSYMS.RETURN) then
		if noAlly then
			firstEnter = false --skip the default-ally-chat initialization if there's no ally. eg: 1vs1
		end
		if firstEnter then
			if (not (modifier.Shift or modifier.Ctrl)) and options.defaultAllyChat.value then
				Spring.SendCommands("chatally")
			end
			firstEnter = false
		end
		ShowInputSpace()
	else
		HideInputSpace()
	end 
end


--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

function widget:MapDrawCmd(playerId, cmdType, px, py, pz, caption)
--	Spring.Echo("########### MapDrawCmd " .. playerId .. " " .. cmdType .. " coo="..px..","..py..","..pz .. (caption and (" caption " .. caption) or ''))
	if (cmdType == 'point') then
		widget:AddMapPoint(playerId, px, py, pz, caption) -- caption may be an empty string
		-- FIXME return true or false?
	end
end

function widget:AddMapPoint(playerId, px, py, pz, caption)
	local playerName, active, spec, teamId, allyTeamId = Spring.GetPlayerInfo(playerId)

	widget:AddConsoleMessage({
		msgtype = ((caption:len() > 0) and 'label' or 'point'),
		playername = playerName,
		source = getSource(spec, allyTeamId),
		--text = 'MapDrawCmd ' .. caption, --removed for proconsole 2
		text = caption,
		argument = caption,
		priority = 0, -- just in case ... probably useless
		point = { x = px, y = py, z = pz }
	})
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
local function isChat(msg)
	return msg.msgtype ~= 'other' or MessageIsChatInfo(msg)
end

-- new callin! will remain in widget
function widget:AddConsoleMessage(msg)
	if options.error_opengl_source.value and msg.msgtype == 'other' and (msg.argument):find('Error: OpenGL: source') then return end
	if msg.msgtype == 'other' and (msg.argument):find('added point') then return end

	local isChat = isChat(msg)
	local isPoint = msg.msgtype == "point" or msg.msgtype == "label"
	local messages = isChat and chatMessages or consoleMessages

	if #messages > 0
		and messages[#messages].text == msg.text 
		and (isPoint and options.dedupe_points.value or options.dedupe_messages.value)
		then

		if isPoint then
			-- update MapPoint position with most recent, as it is probably more relevant
			messages[#messages].point = msg.point
		end

		messages[#messages].dup = messages[#messages].dup + 1

		if isChat then
			AddMessage(messages[#messages], 'chat')
			AddMessage(messages[#messages], 'backchat')
		else
			AddMessage(messages[#messages], 'console')
		end

		return

	end

	msg.dup = 1
	
	detectHighlight(msg)
	formatMessage(msg) -- does not handle dedupe or highlight

	messages[#messages + 1] = msg

	if isChat then 
		AddMessage(msg, 'chat')
		AddMessage(msg, 'backchat')
	else
		AddMessage(msg, 'console')
	end

	if msg.highlight and options.highlight_sound.value then
		PlaySound("highlight")
	elseif (msg.msgtype == "player_to_allies") then -- FIXME not for sent messages
		PlaySound("ally")
	elseif msg.msgtype == "label" then
		PlaySound("label")
	end

	if #messages > MAX_STORED_MESSAGES then
		table.remove(messages, 1)
	end

	removeToMaxLines()

	-- if playername == myName then
		if WG.enteringText then
			HideInputSpace()
		end 		
	-- end
end

-----------------------------------------------------------------------
local firstUpdate = true
local timer = 0
local fadeTimer = 0
local period = 1
local fadePeriod = 0.1
local fadeLength = 4

function widget:Update(s)
	timer = timer + s
	fadeTimer = fadeTimer + s
	
	if timer > period then
		timer = 0
		Spring.SendCommands({string.format("inputtextgeo %f %f 0.02 %f", 
			window_chat.x / screen0.width + 0.003, 
			1 - (window_chat.y + window_chat.height) / screen0.height + 0.004, 
			window_chat.width / screen0.width)})
		
		for k,control in pairs(killTracker) do
			control.life = control.life - 1
			if control.life <= fadeLength and not fadeTracker[k] then
				control.fade = 1
				fadeTracker[k] = control
			end
			if control.life <= 0 then
				control:Dispose()
				killTracker[k] = nil
				fadeTracker[k] = nil
			end
		end
	end
	if fadeTimer > fadePeriod then
		fadeTimer = 0
		for k,control in pairs(fadeTracker) do
			control.fade = control.fade - (fadePeriod / fadeLength )
			local alpha = control.fade 
			
			if alpha < 1 then
				if control.fadeType == 'text' then
					local f = control.font
					local c = f.color
					local o = f.outlineColor
					f:SetColor(c[1],c[2],c[3], alpha)
					f:SetOutlineColor(o[1],o[2],o[3], alpha)
					control:Invalidate()
				elseif control.fadeType == 'button' then
					control.backgroundColor = {1,1,1, alpha}
					control:Invalidate()
				end
			end
			
		end
	end

	if firstUpdate then
		if options.defaultBacklogEnabled.value then
			SwapBacklog()
		end
		firstUpdate = false
		SetInputFontSize(15)
	end
end

-----------------------------------------------------------------------

-- function widget:PlayerAdded(playerID)
	-- setup()
-- end
function widget:PlayerChanged(playerID)
	setupPlayers(playerID)
end

-----------------------------------------------------------------------
function widget:LocalColorRegister()
	if WG.LocalColor and WG.LocalColor.RegisterListener then
		WG.LocalColor.RegisterListener(widget:GetInfo().name, onOptionsChanged)
	end
end

function widget:LocalColorUnregister()
	if WG.LocalColor and WG.LocalColor.UnregisterListener then
		WG.LocalColor.UnregisterListener(widget:GetInfo().name)
	end
end

-----------------------------------------------------------------------

function MessageProcessor:ProcessConsoleBuffer(count)
	local bufferMessages = Spring.GetConsoleBuffer(count)
	for i = 1,#bufferMessages do
		self:ProcessConsoleLine(bufferMessages[i])
	end
	return bufferMessages
end

function widget:AddConsoleLine(msg, priority)
	if StringStarts(msg, "Error: Invalid command received") or StringStarts(msg, "Error: Dropped command ") then
		return
	elseif StringStarts(msg, transmitLobbyMagic) then -- sending to the lobby
		return -- ignore
	elseif StringStarts(msg, transmitMagic) then -- receiving from the lobby
		return -- ignore
	end

	-- censor message for muted player. This is mandatory, everyone is forced to
	-- close ears to muted players (ie: if it is optional, then everyone will
	-- opt to hear muted player for spec-cheat info. Thus it will defeat the
	-- purpose of mute)
	local newMsg = { text = msg, priority = priority }
	MessageProcessor:ProcessConsoleLine(newMsg) --chat_preprocess.lua
	if newMsg.msgtype ~= 'other' and newMsg.msgtype ~= 'autohost' and newMsg.msgtype ~= 'userinfo' and newMsg.msgtype ~= 'game_message' then 
		if MUTE_SPECTATORS and newMsg.msgtype == 'spec_to_everyone' then
			local spectating = select(1, Spring.GetSpectatingState())
			if not spectating then
				return
			end
			newMsg.msgtype = 'spec_to_specs'
		end
		local playerID_msg = newMsg.player and newMsg.player.id --retrieve playerID from message.
		local customkeys = select(10, Spring.GetPlayerInfo(playerID_msg))
		if customkeys and (customkeys.muted or (newMsg.msgtype == 'spec_to_everyone' and ((customkeys.can_spec_chat or '1') == '0'))) then
			local myPlayerID = Spring.GetLocalPlayerID()
			if myPlayerID == playerID_msg then --if I am the muted, then:
				newMsg.argument = "<your message was blocked by mute>"	--remind myself that I am muted.		
				msg = "<your message was blocked by mute>" 
			else --if I am NOT the muted, then: delete this message
				return
			end
			--TODO: improve chili_chat2 spam-filter/dedupe-detection too.
		end
		-- IGNORE FEATURE--
		if WG.ignorelist.ignorees[select(1,Spring.GetPlayerInfo(playerID_msg))] then
			return
		end
	end

	if MUTE_LOBBY and newMsg.msgtype == 'autohost' then
		local spectating = select(1, Spring.GetSpectatingState())
		if (not spectating) and newMsg.argument then
			-- Chat from lobby has format '<PlayerName>message'
			if string.sub(newMsg.argument, 1, 1) == "<" then
				local endChar = string.find(newMsg.argument, ">")
				if endChar then
					local name = string.sub(newMsg.argument, 2, endChar-1)
					if playerNameToID[name] then
						local spectating = select(3, Spring.GetPlayerInfo(playerNameToID[name]))
						if spectating then
							playerNameToID[name] = nil
							return
						end
					else
						return
					end
				else
					return
				end
			end
		end
	end
	--Ignore's lobby blocker.--
	if newMsg.msgtype == 'autohost' and newMsg.argument and string.sub(newMsg.argument, 1, 1) == "<" then
		local endChar = string.find(newMsg.argument, ">")
		if endChar then
			local name = string.sub(newMsg.argument, 2, endChar-1)
			if WG.ignorelist.ignorees[name] then
				return -- block chat
			end
		end
	end
	if newMsg.msgtype == 'userinfo' and newMsg.argument then
		return
	end

	if newMsg.msgtype == 'point' or newMsg.msgtype == 'label' then
		return -- ignore all console messages about points... those come in through the MapDrawCmd callin
	end
	self:AddConsoleMessage(newMsg)
end

function widget:Initialize()
	if (not WG.Chili) then
		widgetHandler:RemoveWidget()
		return
	end

	local spectating = Spring.GetSpectatingState()
	local myAllyTeamID = Spring.GetMyAllyTeamID() -- get my alliance ID
	local teams = Spring.GetTeamList(myAllyTeamID) -- get list of teams in my alliance
	if #teams == 1 and (not spectating) then -- if I'm alone and playing (no ally), then no need to set default-ally-chat during gamestart . eg: 1vs1
		noAlly = true
	end

	WG.ignorelist = {count = 0,ignorees ={}}
	local customkeys = select(10, Spring.GetPlayerInfo(Spring.GetMyPlayerID()))
	if customkeys["ignored"] then
		if string.find(customkeys["ignored"],",") then
			local newignorelist = string.gsub(customkeys["ignored"],","," ")
			Spring.Echo("Setting Serverside ignorelist: " .. newignorelist)
			for ignoree in string.gmatch(newignorelist,"%S+") do
				WG.ignorelist.ignorees[ignoree] = true
				WG.ignorelist.count = WG.ignorelist.count + 1
			end
			newignorelist = nil
		elseif string.len(customkeys["ignored"]) > 1 then
			WG.ignorelist.ignorees[customkeys["ignored"]] = true
			WG.ignorelist.count = ignorelist.count + 1
		end
	end
	customkeys = nil
	local wh = widgetHandler
	wh.Ignore = function (_,name)
		if not WG.ignorelist.ignorees[name] then
			WG.ignorelist.ignorees[name] = true
			WG.ignorelist.count = WG.ignorelist.count + 1
		end
	end
	wh.Unignore = function (_,name)
		WG.ignorelist.ignorees[name] = nil
		WG.ignorelist.count = WG.ignorelist.count - 1
	end
	wh.GetIgnoreList = function (_)
		return WG.ignorelist["ignorees"], WG.ignorelist.count
	end

	screen0 = WG.Chili.Screen0

	Spring.SendCommands("bind Any+enter  chat")

	stack_console = MakeMessageStack(1)

	stack_chat = MakeMessageStack(0)

	stack_backchat = MakeMessageStack(1)

	inputspace = WG.Chili.ScrollPanel:New{
		x = 0,
		bottom = 0,
		right = inputsize,
		height = inputsize,
		backgroundColor = {1,1,1,1},
		borderColor = {0,0,0,1},
		--backgroundColor = {1,1,1,1},
	}
	backlogButtonImage = WG.Chili.Image:New {
		width = inputsize - 7,
		height = inputsize - 7,
		keepAspect = true,
		--color = {0.7,0.7,0.7,0.4},
		file = 'LuaUI/Images/arrowhead.png',
	}
	backlogButton = WG.Chili.Button:New{
		right=0,
		bottom=1,
		width = inputsize - 3,
		height = inputsize - 3,
		padding = { 1,1,1,1 },
		backgroundColor = {1,1,1,1},
		caption = '',
		tooltip = 'Swap between decaying chat and scrollable chat backlog.',
		OnClick = {SwapBacklog},
		children={ backlogButtonImage },
	}

	consoleButtonImage = WG.Chili.Image:New {
		width = inputsize - 7,
		height = inputsize - 7,
		keepAspect = true,
		--color = {0.7,0.7,0.7,0.4},
		file = 'LuaUI/Images/console.png',
	}
	consoleButton = WG.Chili.Button:New{
		right=inputsize,
		bottom=1,
		width = inputsize - 3,
		height = inputsize - 3,
		padding = { 1,1,1,1 },
		backgroundColor = {1,1,1,1},
		caption = '',
		tooltip = 'Show the console',
		OnClick = {SwitchConsole},
		children={ consoleButtonImage },
	}

	scrollpanel_chat = WG.Chili.ScrollPanel:New{
		--margin = {5,5,5,5},
		padding = { 1,1,1,4 },
		x = 0,
		y = 0,
		width = '100%',
		bottom = inputsize + 2, -- This line is temporary until chili is fixed so that ReshapeConsole() works both times! -- TODO is it still required??
		verticalSmartScroll = true,
-- DISABLED FOR CLICKABLE TextBox		disableChildrenHitTest = true,
		backgroundColor = options.color_chat_background.value,
		borderColor = options.color_chat_background.value,
		ignoreMouseWheel = true,
		children = {
			stack_chat,
		},
		verticalScrollbar = false,
		horizontalScrollbar = false,
	}

	--spacer that forces chat to be scrolled to bottom of chat window
	WG.Chili.Panel:New{
		width = '100%',
		height = 500,
		backgroundColor = {0,0,0,0},
		parent = stack_chat,
	}

	scrollpanel_backchat = WG.Chili.ScrollPanel:New{
		--margin = {5,5,5,5},
		padding = { 3,3,3,3 },
		x = 0,
		y = 0,
		width = '100%',
		bottom = inputsize + 2, -- This line is temporary until chili is fixed so that ReshapeConsole() works both times! -- TODO is it still required??
		verticalSmartScroll = true,
		backgroundColor = options.color_chat_background.value,
		borderColor = {0,0,0,options.backchatOpacity.value},
		horizontalScrollbar = false,
		ignoreMouseWheel = not options.mousewheelBacklog.value,
		children = {
			stack_backchat,
		},
	}

	scrollpanel_console = WG.Chili.ScrollPanel:New{
		--margin = {5,5,5,5},
		padding = { 5, 5, 5, 5 },
		x = 5,
		y = 5,
		right = 5,
		bottom = 5, 
		verticalSmartScroll = true,
		backgroundColor = {0,0,0,0},
		borderColor = {0,0,0,0},
		
		--ignoreMouseWheel = not options.mousewheel.value,
		children = {
			stack_console,
		},
	}

	window_chat = MakeMessageWindow("ProChat", true)
	window_chat:AddChild(scrollpanel_chat)
	window_chat:AddChild(backlogButton)
	window_chat:AddChild(consoleButton)
	if options.enableChatBackground.value then
		window_chat:AddChild(inputspace)
	end

	window_console = MakeMessageWindow("ProConsole", options.enableConsole.value)
	window_console:AddChild(scrollpanel_console)

	RemakeConsole()
	local buffer = MessageProcessor:ProcessConsoleBuffer(options.max_lines.value)
	for i=1,#buffer do
		widget:AddConsoleMessage(buffer[i])
	end

	Spring.SendCommands({"console 0"})

	HideInputSpace()

	self:LocalColorRegister()
end

function widget:GameStart()
	setupPlayers() --re-check teamColor at gameStart for Singleplayer (special case. widget Initialized before player join).
end

-----------------------------------------------------------------------

function widget:Shutdown()
	if (window_chat) then
		window_chat:Dispose()
	end
	SetInputFontSize(20)
	Spring.SendCommands({"console 1", "inputtextgeo default"}) -- not saved to spring's config file on exit
	Spring.SetConfigString("InputTextGeo", "0.26 0.73 0.02 0.028") -- spring default values

	self:LocalColorUnregister()
end
