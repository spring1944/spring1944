--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

function widget:GetInfo()
    return {
        name         = "1944 Console",
        desc         = "Console for Spring 1944",
        author       = "Jose Luis Cercos-Pita",
        date         = "2020-08-28",
        license      = "GNU GPL, v2 or later",
        layer        = 50,
        experimental = false,
        enabled      = true,
    }
end

local myName, transmitMagic, voiceMagic, transmitLobbyMagic, MessageProcessor = include("chat_preprocess.lua")

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

local mainScaleLeft   = 0.25  -- Default widget position
local mainScaleTop    = 0.89  -- Default widget position
local mainScaleWidth  = 0.75  -- Default widget width
local mainScaleHeight = 0.11  -- Default widget height
WG.CHATBAROPTS = {
    x = mainScaleLeft,
    y = mainScaleTop,
    width = mainScaleWidth,
    height = mainScaleHeight,
}
local IMAGE_DIRNAME = LUAUI_DIRNAME .. "Images/ComWin/"
local SOUNDS = {
    ally = "sounds/talk.wav",
    label = "sounds/talk.wav",
}
local MAX_STORED_MESSAGES = 100
local CHAT_COLOR = {1.0, 1.0, 0.6, 1.0}
local CHAT_ALLIES_COLOR = {0.6, 0.8, 0.35, 1.0}
local GLYPHS = {
    flag = '\204\134',
    muted = '\204\138',
    unmuted = '\204\139',
}
local SENDTO = 'all'  -- It may take 'all', 'allies' and 'spectators' values

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

local Chili
local chat_win, chat_stack, chat_scroll
local main_win, main_log, main_players
local main_sendto, main_msg, main_send, main_cancel
local playerName, allyTeamId
local muted = {}
local teamColors = {}
local allies = {}
local specs = {}
local sent_history = {}
local sent_history_index = 1
local buttons_players = {}
local fadeLag, fadePeriod = 10.0, 1.0


local min, max, floor = math.min, math.max, math.floor
local function clamp(v, vmin, vmax)
    return max(min(v, vmax), vmin)
end
local GetViewGeometry = Spring.GetViewGeometry
local GetPlayerRoster = Spring.GetPlayerRoster

--------------------------------------------------------------------------------
-- 
--------------------------------------------------------------------------------

function ResetChatBar()
    -- Reset default values
    WG.CHATBAROPTS.x = mainScaleLeft
    WG.CHATBAROPTS.y = mainScaleTop
    WG.CHATBAROPTS.width = mainScaleWidth
    WG.CHATBAROPTS.height = mainScaleHeight
    local viewSizeX, viewSizeY = GetViewGeometry()
    x = WG.CHATBAROPTS.x * viewSizeX
    y = WG.CHATBAROPTS.y * viewSizeY
    w = WG.CHATBAROPTS.width * viewSizeX
    h = WG.CHATBAROPTS.height * viewSizeY
    chat_win:SetPosRelative(x, y, w, h, true, false)
end

local function OnSwitchMute(self)
    local name = self.playername
    local glyph
    if muted[name] then
        muted[name] = nil
        glyph = GLYPHS["unmuted"]
    else
        muted[name] = true
        glyph = GLYPHS["muted"]
    end
    self:SetCaption(name .. " " .. glyph)
end

local function __playerButton(name, color, spec)
    local glyph = GLYPHS["unmuted"]
    if muted[name] then
        glyph = GLYPHS["muted"]
    end
    local children = {}
    if not spec then
        children = {
            Chili.Progressbar:New{
                right = 18,
                y = 2,
                width = 20,
                bottom = 2,
                backgroundColor = {0, 0, 0, 0},
                orientation = "vertical",
                caption = "",
                value = 0,
                TileImageFG = IMAGE_DIRNAME .. "s44_cpu_progressbar_full.png",
                TileImageBK = IMAGE_DIRNAME .. "s44_cpu_progressbar_empty.png",
            },
            Chili.Progressbar:New{
                right = 0,
                y = 2,
                width = 20,
                bottom = 2,
                backgroundColor = {0, 0, 0, 0},
                orientation = "vertical",
                caption = "",
                value = 0,
                TileImageFG = IMAGE_DIRNAME .. "s44_cpu_progressbar_full.png",
                TileImageBK = IMAGE_DIRNAME .. "s44_cpu_progressbar_empty.png",
            },
        }
    end
    return Chili.Button:New {
        x = 0,
        y = 0,
        right = 0,
        height = 34,
        caption = name .. " " .. glyph,
        OnClick = { OnSwitchMute, },
        parent = main_win,
        playername = name,
        font = {
            outlineWidth  = 3,
            outlineWeight = 10,
            outline       = true,
            color = color,
        },
        padding = { 2,2,2,2 },
        children = children,
    }
end

local function setupPlayers(playerID)
    local stack
    if playerID then
        local name, active, spec, teamId, allyTeamId = Spring.GetPlayerInfo(playerID)
        --lobby: grey chat, spec: white chat, player: color chat
        teamColors[name] = (spec and {1,1,1,1}) or {Spring.GetTeamColor(teamId)}
        for _, stack in ipairs(main_players.children) do
            for j = #stack.children,2,-1 do
                if stack.children[j].playername == name then
                    stack.children[j]:Dispose()
                end
            end
        end
        stack = main_players.children[2]
        specs[name] = nil
        allies[name] = nil
        if spec then
            stack = main_players.children[3]
            specs[name] = playerID
        elseif Spring.ArePlayersAllied(Spring.GetMyPlayerID(), playerID) then
            stack = main_players.children[1]
            allies[name] = playerID
        end
        buttons_players[name] = __playerButton(name, teamColors[name], spec)
        stack:AddChild(buttons_players[name])
    else
        for _, stack in ipairs(main_players.children) do
            for j = #stack.children,2,-1 do
                stack.children[j]:Dispose()
            end
        end
        local players = Spring.GetPlayerList()
        for i, id in ipairs(players) do
            local name, active, spec, teamId, allyTeamId = Spring.GetPlayerInfo(id)
            teamColors[name] = (spec and {1,1,1,1}) or {Spring.GetTeamColor(teamId)}
            stack = main_players.children[2]
            if spec then
                stack = main_players.children[3]
                specs[name] = id
            elseif Spring.ArePlayersAllied(Spring.GetMyPlayerID(), id) then
                stack = main_players.children[1]
                allies[name] = id
            end
            buttons_players[name] = __playerButton(name, teamColors[name], spec)
            stack:AddChild(buttons_players[name])
        end
    end
end

local function PlaySound(id, condition)
    if condition ~= nil and not condition then
        return
    end
    local file = SOUNDS[id]
    if file then
        Spring.PlaySoundFile(file, 1, 'ui')
    end
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
           -- S44 specific stuff: never hide air raid warnings
           or string.find(msg.argument,'aircraft spotted')
end

local function isChat(msg)
    return msg.msgtype ~= 'other' or MessageIsChatInfo(msg)
end

local function isPoint(msg)
    return msg.msgtype == "point" or msg.msgtype == "label"
end

local function __escape_lua_pattern(s)
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

local function __color2str(color)
    -- Let's be safe. Buumi reported errors, maybe related with cached content.
    -- So if the received color is just nil, we use the default one, defined in
    -- LuaUI/Widgets/chili/skins/s44/skin.lua
    if color == nil then
        color = {1.0, 1.0, 0.6, 1.0}
    end

    local txt = "\\255"
    for i = 1,3 do 
        txt = txt .. "\\" .. tostring(floor(color[i] * 255))
    end
    local func, err = loadstring( "return \"" .. txt .. "\"" )
    if (not func) then
        return ''
    end
    return func()
end

local function formatMessage(msg)
    if msg.playername then
        local msg_color = CHAT_COLOR
        if msg.msgtype == "player_to_allies" then
                msg_color = CHAT_ALLIES_COLOR
        end
        if teamColors[msg.playername] == nil then
            -- How this guy got here??
            Spring.Log("Chat", LOG.WARNING, "The player '" .. msg.playername .. "' was not already parsed when calling formatMessage()")
            setupPlayers()
        end
        local out = msg.text
        local playerName = __escape_lua_pattern(msg.playername)
        out = out:gsub( '^<' .. playerName ..'> ', '' )
        out = out:gsub( '^%[' .. playerName ..'%] ', '' )
        msg.playername2 = playerName
        msg.textFormatted = __color2str(msg_color) .. out
        msg.source2 = __color2str(teamColors[msg.playername]) .. msg.playername
    else
        msg.textFormatted = msg.text
        msg.source2 = ''
    end
end

local function removeToMaxLines()
    while #chat_stack.children > MAX_STORED_MESSAGES do
        if chat_stack.children[1] then
            chat_stack.children[1]:Dispose()
            chat_stack.last_faded = chat_stack.last_faded - 1
        end
    end
end

local function AddControlToFadeTracker(control, fadeType)
    control.life = decayTime
    control.fadeType = fadeType or ''
    killTracker[control_id] = control
    control_id = control_id + 1
end

local function AddMessage(msg)
    if (not WG.Chili) then
        return
    end

    local messageText = msg.textFormatted
    if msg.source2 ~= '' then
        messageText = msg.source2 .. ": " .. messageText
    end

    local messageTextBox = WG.Chili.TextBox:New{
        width = '100%',
        align = "left",
        valign = "ascender",
        lineSpacing = 1,
        padding = { 2,2,2,2 },
        text = messageText,
        fontShadow=false,
        autoHeight=true,
        font = {
            outlineWidth     = 3,
            outlineWeight    = 10,
            outline          = true,
            autoOutlineColor = false,
            outlineColor  = {0, 0, 0, 1},
        }
    }

    local control = messageTextBox
    if msg.point then
        messageTextBox:SetPos(30, nil, nil, nil)
        local flagButton = WG.Chili.Button:New{
            caption=GLYPHS.flag,
            x = 0;
            --y=0;
            width = 30,
            --height = 18,
            height = '100%',
            backgroundColor = {1,1,1,1},
            padding = {2,2,2,2},
            OnClick = {function(self, x, y, mouse)
                local alt,ctrl, meta,shift = Spring.GetModKeyState()
                if (shift or ctrl or meta or alt) or ( mouse ~= 1 ) then
                    return false
                end
                Spring.SetCameraTarget(msg.point.x, msg.point.y, msg.point.z, 1)
            end}
        }
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
            children = {flagButton, messageTextBox},        
        }
    end
    control.timer = 0.0
    chat_stack:AddChild(control, false)
    chat_stack:UpdateClientArea()
end

function AddConsoleMessage(msg)
    if not isChat(msg) then
        return
    end
    formatMessage(msg)
    if muted[msg.playername2] then
        return
    end
    AddMessage(msg)

    if (msg.msgtype == "player_to_allies") then
        PlaySound("ally")
    elseif msg.msgtype == "label" then
        PlaySound("label")
    end

    removeToMaxLines()
end

local function GetColourScale(value)
    local colour = {0, 1, 0, 1}
    colour[1] = min(50, value) / 50
    colour[2] = 1 - (max(0, value - 50) / 50)
    return colour
end

function ShowWin()
    -- Hide the default chat window
    if not chat_win.force_show then
        chat_win:Hide()
    end
    -- Transfer the chat stack to the main window
    chat_stack:SetParent(nil)
    if main_log == nil then
        -- Properly build the scroll panel for the chat now, so hereinafter we
        -- can safely transfer the chat_stack parenting between main_log and
        -- chat_stack scroll panels
        main_log = Chili.ScrollPanel:New{
            --margin = {5,5,5,5},
            padding = {1, 1, 1, 1},
            x = 0,
            y = 0,
            width = '70%',
            bottom = 37,
            verticalSmartScroll = true,
            ignoreMouseWheel = false,
            verticalScrollbar = true,
            horizontalScrollbar = false,
            parent = main_win,
            children = {chat_stack},
            BorderTileImage = IMAGE_DIRNAME .. "empty.png",
            BackgroundTileImage = IMAGE_DIRNAME .. "empty.png",
            TileImage = IMAGE_DIRNAME .. "empty.png",
        }
    end
    chat_stack:SetParent(main_log)
    -- Set all the messages opaque
    for i, c in ipairs(chat_stack.children) do
        Chili.SetOpacity(c, 1.0)
    end    
    -- Show the main window
    main_sendto:Select(SENDTO)
    sent_history_index = #sent_history + 1
    main_msg:SetText("")
    Chili.Screen0:FocusControl(main_msg)
    main_win:Show()

    if WG.bindAnyEsc ~= nil then
        -- WG.bindAnyEsc is provided by "1944 Quit menu" widget
        WG.bindAnyEsc(false)
    end
    Spring.SendCommands("bind esc s44chat")
end

function HideWin()
    -- Hide the main window
    main_win:Hide()
    Chili.Screen0:FocusControl(nil)
    -- Transfer the chat stack to the default chat window
    chat_stack:SetParent(chat_scroll)
    -- Reset the transparency of the outdated messages
    for i = 2, chat_stack.last_faded do
        local c = chat_stack.children[i]
        Chili.SetOpacity(c, 0.0)
    end
    -- Show the default chat window
    chat_win:Show()

    Spring.SendCommands("unbind esc s44chat")
    if WG.bindAnyEsc ~= nil then
        WG.bindAnyEsc(true)
    end
end

function OnCancel()
    main_msg:SetText("")
    HideWin()
end

function OnSend()
    local msg = main_msg.text
    if msg == "" then
        OnCancel()
        return
    end

    sent_history[#sent_history + 1] = msg
    if msg:find("/") == 1 then
        Spring.SendCommands(msg:sub(2))
        OnCancel()
        return
    end

    local prefix = ""
    SENDTO = main_sendto.caption
    if SENDTO == 'allies' then
        prefix = "a:"
    elseif SENDTO == 'spectators' then
        prefix = "s:"
    end

    Spring.SendCommands("say " .. prefix .. msg)
    OnCancel()
end

function OnChat()
    if main_win.visible then
        OnSend()
    else
        ShowWin()
    end
end

function OnChatSwitchAll()
    SENDTO = 'all'
    main_sendto:Select(SENDTO)
    main_msg.font:SetColor(CHAT_COLOR)
end

function OnChatSwitchAlly()
    SENDTO = 'allies'
    main_sendto:Select(SENDTO)
    main_msg.font:SetColor(CHAT_ALLIES_COLOR)
end

function OnChatSwitchSpec()
    SENDTO = 'spectators'
    main_sendto:Select(SENDTO)
    main_msg.font:SetColor(CHAT_COLOR)
end

local function TextSendToSwitcher(self)
    local txt = self:GetText()
    if string.sub(txt, 1, 2) == 'a:' then
        if main_sendto.caption == 'allies' then
            OnChatSwitchAll()
        else
            OnChatSwitchAlly()
        end
        self:SetText(string.sub(txt, 3))
    elseif string.sub(txt, 1, 2) == 's:' then
        if main_sendto.caption == 'spectators' then
            OnChatSwitchAll()
        else
            OnChatSwitchSpec()
        end
        self:SetText(string.sub(txt, 3))
    end
end

local function OnChatInputKey(self, key, mods, isRepeat, label, unicode, ...)
    local msg
    if Spring.GetKeyCode("up") == key then
        sent_history_index = sent_history_index - 1
        if sent_history_index < 0 then
            sent_history_index = 0
        end
        msg = sent_history[sent_history_index]
        if msg == nil then
            msg = ""
        end
    elseif Spring.GetKeyCode("down") == key then
        sent_history_index = sent_history_index + 1
        if sent_history_index > #sent_history + 1 then
            sent_history_index = #sent_history + 1
        end
        msg = sent_history[sent_history_index]
        if msg == nil then
            msg = ""
        end
    end
    if msg ~= nil then
        self:SetText(msg)
        return
    end
end

local function __OnLockWindow(self)
    local viewSizeX, viewSizeY = GetViewGeometry()
    WG.CHATBAROPTS.x = self.x / viewSizeX
    WG.CHATBAROPTS.y = self.y / viewSizeY
    WG.CHATBAROPTS.width = self.width / viewSizeX
    WG.CHATBAROPTS.height = self.height / viewSizeY
    self.force_show = false
    self.caption = nil
    self.TileImage = IMAGE_DIRNAME .. "empty.png"
end

local function __OnUnlockWindow(self)
    self.force_show = true
    self.caption = "Chat"
    self.TileImage = IMAGE_DIRNAME .. "s44_customizable_window.png"
end

--------------------------------------------------------------------------------
-- Callins
--------------------------------------------------------------------------------

function widget:Initialize()
    if (not WG.Chili) then
        widgetHandler:RemoveWidget()
        return
    end

    Chili = WG.Chili
    local viewSizeX, viewSizeY = GetViewGeometry()
    playerName, _, _, _, allyTeamId = Spring.GetPlayerInfo(Spring.GetMyPlayerID())

    -- Chat window (anchored at bottom-right of the screen)
    -------------------------------------------------------
    chat_win = Chili.Window:New{
        parent = Chili.Screen0,
        x = tostring(floor(100 * WG.CHATBAROPTS.x)) .. "%",
        y = tostring(floor(100 * WG.CHATBAROPTS.y)) .. "%",
        width = tostring(floor(100 * WG.CHATBAROPTS.width)) .. "%",
        height = tostring(floor(100 * WG.CHATBAROPTS.height)) .. "%",
        draggable = true,
        resizable = true,
        padding = {0, 0, 0, 0},
        TileImage = IMAGE_DIRNAME .. "s44_customizable_window.png",
        caption = "Chat",
    }
    Chili.AddCustomizableWindow(chat_win)

    chat_scroll = Chili.ScrollPanel:New{
        --margin = {5,5,5,5},
        padding = {1, 1, 1, 1},
        x = 0,
        y = 0,
        width = '100%',
        height = '100%',
        verticalSmartScroll = true,
        ignoreMouseWheel = true,
        verticalScrollbar = false,
        horizontalScrollbar = false,
        parent = chat_win,
        BorderTileImage = IMAGE_DIRNAME .. "empty.png",
        BackgroundTileImage = IMAGE_DIRNAME .. "empty.png",
        TileImage = IMAGE_DIRNAME .. "empty.png",
    }

    chat_stack = Chili.StackPanel:New{
        margin = { 0, 0, 0, 0 },
        padding = { 0, 0, 0, 0 },
        x = 0,
        y = 0,
        right = 5,
        height = 10,
        resizeItems = false,
        itemPadding  = { 1, 1, 1, 1 },
        itemMargin  = {0, 0, 0, 0},
        autosize = true,
        preserveChildrenOrder = true,
        parent = chat_scroll,
        last_faded = 1, -- Care, the stackpanel has a child already
    }

    -- This spacer grants chats is always scrolled down
    WG.Chili.Panel:New{
        width = '100%',
        height = 500,
        backgroundColor = {0,0,0,0},
        parent = chat_stack,
    }

    Spring.SendCommands({"console 0"})

    -- Players window:
    --  * Send new chat messages
    --  * Visit the whole chat log
    --  * Mute/unmute players
    ------------------------------
    main_win = Chili.Window:New{
        parent = Chili.Screen0,
        x = "20%",
        y = "20%",
        width = "60%",
        height = "60%",
        draggable = false,
        resizable = false,
    }
    -- We can not create the scroll panel for the chat stack yet.
    -- For some reason, chili is not able to conveniently set the chat_stack
    -- parent if we do that now.
    -- see ShowWin()
    main_log = nil

    main_sendto = Chili.ComboBox:New{
        x = "0%",
        bottom = "0%",
        width = 128,
        height = 32,
        items = {"all", "allies", "spectators"},
        parent = main_win,
    }

    main_msg = Chili.EditBox:New {
        x = 133,
        bottom = '0%',
        width = main_win.width - 133 * 3 - 20,
        height = 32,
        text = "",
        parent = main_win,
        OnKeyPress = { OnChatInputKey },
        OnTextInput = { TextSendToSwitcher },
    }
    -- To allow changing the font color on the Chili skin
    CHAT_COLOR = main_msg.font.color

    main_send = Chili.Button:New {
        right = 133,
        bottom = '0%',
        width = 128,
        height = 32,
        caption = "Send",
        OnClick = { OnSend, },
        parent = main_win,
    }

    main_cancel = Chili.Button:New {
        right = 0,
        bottom = '0%',
        width = 128,
        height = 32,
        caption = "Cancel",
        OnClick = { OnCancel, },
        parent = main_win,
    }

    local main_players_scroll = Chili.ScrollPanel:New{
        padding = {1, 1, 1, 1},
        right = "0%",
        y = 0,
        width = '30%',
        bottom = 37,
        verticalSmartScroll = true,
        ignoreMouseWheel = false,
        verticalScrollbar = true,
        horizontalScrollbar = true,
        parent = main_win,
    }

    main_players = Chili.StackPanel:New{
        margin = { 0, 0, 0, 0 },
        padding = { 0, 0, 0, 0 },
        x = 0,
        y = 0,
        right = 5,
        height = 10,
        resizeItems = false,
        itemPadding  = { 1, 1, 1, 1 },
        itemMargin  = {0, 0, 0, 0},
        autosize = true,
        preserveChildrenOrder = true,
        parent = main_players_scroll,
    }

    local allies_stack = Chili.StackPanel:New{
        margin = { 0, 0, 0, 0 },
        padding = { 0, 0, 0, 0 },
        x = 0,
        y = 0,
        right = 5,
        height = 10,
        resizeItems = false,
        itemPadding  = { 1, 1, 1, 1 },
        itemMargin  = {0, 0, 0, 0},
        autosize = true,
        preserveChildrenOrder = true,
        parent = main_players,
        children = {Chili.Label:New{
            x = 0,
            y = 0,
            width = "100%",
            height = "100%",
            caption = "Allies",
        }},
    }
    local enemies_stack = Chili.StackPanel:New{
        margin = { 0, 0, 0, 0 },
        padding = { 0, 0, 0, 0 },
        x = 0,
        y = 0,
        right = 5,
        height = 10,
        resizeItems = false,
        itemPadding  = { 1, 1, 1, 1 },
        itemMargin  = {0, 0, 0, 0},
        autosize = true,
        preserveChildrenOrder = true,
        parent = main_players,
        children = {Chili.Label:New{
            x = 0,
            y = 0,
            width = "100%",
            height = "100%",
            caption = "Enemies",
        }},
    }
    local specs_stack = Chili.StackPanel:New{
        margin = { 0, 0, 0, 0 },
        padding = { 0, 0, 0, 0 },
        x = 0,
        y = 0,
        right = 5,
        height = 10,
        resizeItems = false,
        itemPadding  = { 1, 1, 1, 1 },
        itemMargin  = {0, 0, 0, 0},
        autosize = true,
        preserveChildrenOrder = true,
        parent = main_players,
        children = {Chili.Label:New{
            x = 0,
            y = 0,
            width = "100%",
            height = "100%",
            caption = "Spectators",
        }},
    }

    main_win:Hide()
    setupPlayers()

    widgetHandler:AddAction("resetchatbar", ResetChatBar)
    Spring.SendCommands("unbind any+enter chat")
    widgetHandler:AddAction("s44chat", OnChat)
    Spring.SendCommands("bind any+enter s44chat")
    Spring.SendCommands({"unbindkeyset alt+ctrl+a"})
    widgetHandler:AddAction("s44chatswitchally", OnChatSwitchAlly)
    Spring.SendCommands({"bind alt+ctrl+a s44chatswitchally"})
    Spring.SendCommands({"unbindkeyset alt+ctrl+s"})
    widgetHandler:AddAction("s44chatswitchspec", OnChatSwitchSpec)
    Spring.SendCommands({"bind alt+ctrl+s s44chatswitchspec"})

    -- Set the widget size, which apparently were not working well
    x = WG.CHATBAROPTS.x * viewSizeX
    y = WG.CHATBAROPTS.y * viewSizeY
    w = WG.CHATBAROPTS.width * viewSizeX
    h = WG.CHATBAROPTS.height * viewSizeY
    chat_win:SetPosRelative(x, y, w, h, true, false)
    -- Save the new dimensions when the widget is locked
    chat_win.OnLockWindow = {__OnLockWindow,}
    chat_win.OnUnlockWindow = {__OnUnlockWindow,}
end

function widget:ViewResize(viewSizeX, viewSizeY)
    if chat_win == nil then
        return
    end
    x = WG.CHATBAROPTS.x * viewSizeX
    y = WG.CHATBAROPTS.y * viewSizeY
    w = WG.CHATBAROPTS.width * viewSizeX
    h = WG.CHATBAROPTS.height * viewSizeY
    if w < chat_win.minWidth then
        w = chat_win.minWidth
    end
    if h < chat_win.minHeight then
        h = chat_win.minHeight
    end
    chat_win:SetPosRelative(x, y, w, h, true, false)
end

function widget:AddConsoleLine(msg, priority)
    if StringStarts(msg, "Error: Invalid command received") or StringStarts(msg, "Error: Dropped command ") then
        return
    elseif StringStarts(msg, transmitLobbyMagic) then -- sending to the lobby
        return -- ignore
    elseif StringStarts(msg, transmitMagic) then -- receiving from the lobby
        return -- ignore??
    end

    local newMsg = { text = msg, priority = priority }
    MessageProcessor:ProcessConsoleLine(newMsg) --chat_preprocess.lua

    -- if newMsg.msgtype == 'other' then
    --     return
    -- end
    if isPoint(newMsg) then
        -- Points are handled by MapDrawCmd callin
        return
    end

    AddConsoleMessage(newMsg)
end

function widget:MapDrawCmd(playerId, cmdType, px, py, pz, caption)
    if (cmdType ~= 'point') then
        return
    end

    local name, _, spec, teamId, allyTeamId = Spring.GetPlayerInfo(playerId)
    if muted[name] then
        return
    end
    AddConsoleMessage({
        msgtype = ((caption:len() > 0) and 'label' or 'point'),
        playername = name,
        text = caption,
        argument = caption,
        priority = 0, -- just in case ... probably useless
        point = { x = px, y = py, z = pz }
    })
end

function widget:GameStart()
    setupPlayers()
end

function widget:PlayerChanged(playerID)
    setupPlayers(playerID)
end

function widget:DrawScreen()
    if not main_win.visible then
        return
    end

    playerlist = GetPlayerRoster(3)
    if playerlist == nil then
        return
    end

    for _, player_data in ipairs(playerlist) do
        local name = player_data[1]
        local spectator = player_data[5]
        local button = buttons_players[name]
        if (not spectator) and (button ~= nil) then
            local cpu = floor(player_data[6] * 100 + 0.5)
            local ping = floor(player_data[7] * 1000 + 0.5)
            -- Rescale ping
            ping = max(0, ping - 100)
            ping = min(1000, ping)
            ping = ping / 10
            -- Set the progress bars
            button.children[1]:SetValue(cpu)
            button.children[1]:SetColor(GetColourScale(cpu))
            button.children[2]:SetValue(ping)
            button.children[2]:SetColor(GetColourScale(ping))
        end
    end
end

function widget:Update(dt)
    if main_win.visible then
        -- The chat window is visible, so we don't want to fade away messages
        return
    end

    for i=max(2, chat_stack.last_faded + 1), #chat_stack.children do
        local c = chat_stack.children[i]

        c.timer = c.timer + dt
        local opacity = clamp(1.0 - (c.timer - fadeLag) / fadePeriod, 0.0, 1.0)
        if opacity <= 0 then
            chat_stack.last_faded = i
        end
        Chili.SetOpacity(c, opacity)
    end
end

function widget:Shutdown()
    if (chat_win) then
        chat_win:Dispose()
    end
    Spring.SendCommands({"console 1"})

    widgetHandler:RemoveAction("resetchatbar")
    widgetHandler:RemoveAction("s44chat")
    Spring.SendCommands({"unbind any+enter s44chat"})
    Spring.SendCommands({"bind any+enter chat"})
    widgetHandler:RemoveAction("s44chatswitchally")
    Spring.SendCommands({"unbind alt+ctrl+a s44chatswitchally"})
    Spring.SendCommands({"bind alt+ctrl+a chatswitchally"})
    widgetHandler:RemoveAction("s44chatswitchspec")
    Spring.SendCommands({"unbind alt+ctrl+s s44chatswitchspec"})
    Spring.SendCommands({"bind alt+ctrl+s chatswitchspec"})
end

function widget:GetConfigData()
    return {
        x      = WG.CHATBAROPTS.x,
        y      = WG.CHATBAROPTS.y,
        width  = WG.CHATBAROPTS.width,
        height = WG.CHATBAROPTS.height,
    }
end

function widget:SetConfigData(data)
    WG.CHATBAROPTS.x      = data.x or WG.CHATBAROPTS.x
    WG.CHATBAROPTS.y      = data.y or WG.CHATBAROPTS.y
    WG.CHATBAROPTS.width  = data.width or WG.CHATBAROPTS.width
    WG.CHATBAROPTS.height = data.height or WG.CHATBAROPTS.height
end
