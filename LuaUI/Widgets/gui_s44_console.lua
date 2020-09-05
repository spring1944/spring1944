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

local IMAGE_DIRNAME = LUAUI_DIRNAME .. "Images/ComWin/"
local SOUNDS = {
    ally = "sounds/talk.wav",
    label = "sounds/talk.wav",
}
local MAX_STORED_MESSAGES = 300
local CHAT_COLOR = {1, 1, 0.6, 1}
local GLYPHS = {
    flag = '\204\134',
}


--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

local chat_win, chat_stack, chat_scroll
local teamColors = {}

--------------------------------------------------------------------------------
-- 
--------------------------------------------------------------------------------

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
    local txt = "\\255"
    for i = 1,3 do 
        txt = txt .. "\\" .. tostring(math.floor(color[i] * 255))
    end
    local func, err = loadstring( "return \"" .. txt .. "\"" )
    if (not func) then
        return ''
    end
    return func()
end

local function formatMessage(msg)
    if msg.playername then
        local out = msg.text
        local playerName = __escape_lua_pattern(msg.playername)
        out = out:gsub( '^<' .. playerName ..'> ', '' )
        out = out:gsub( '^%[' .. playerName ..'%] ', '' )
        msg.textFormatted = __color2str(chat_win.font.color) .. out
        msg.source2 = __color2str(teamColors[msg.playername]) .. playerName
    else
        msg.textFormatted = msg.text
        msg.source2 = ''
    end
end

local function removeToMaxLines()
    while #chat_stack.children > MAX_STORED_MESSAGES do
        if chat_stack.children[1] then
            chat_stack.children[1]:Dispose()
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
            outlineWidth  = 3,
            outlineWeight = 10,
            outline       = true,
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

    chat_stack:AddChild(control, false)
    chat_stack:UpdateClientArea()
end

function AddConsoleMessage(msg)
    if not isChat(msg) then
        return
    end
    formatMessage(msg)
    AddMessage(msg)

    if (msg.msgtype == "player_to_allies") then
        PlaySound("ally")
    elseif msg.msgtype == "label" then
        PlaySound("label")
    end

    removeToMaxLines()
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
    local viewSizeX, viewSizeY = Spring.GetViewGeometry()

    -- Create the chat window
    chat_win = Chili.Window:New{
        parent = Chili.Screen0,
        x = "40%",
        y = "80%",
        width = "60%",
        height = "20%",
        draggable = false,
        resizable = false,
        padding = {0, 0, 0, 0},
        TileImage = IMAGE_DIRNAME .. "empty.png",
    }

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
        right=5,
        height = 10,
        resizeItems = false,
        itemPadding  = { 1, 1, 1, 1 },
        itemMargin  = {0, 0, 0, 0},
        autosize = true,
        preserveChildrenOrder = true,
        parent = chat_scroll,  
    }

    -- This spacer grants chats is always scrolled down
    WG.Chili.Panel:New{
        width = '100%',
        height = 500,
        backgroundColor = {0,0,0,0},
        parent = chat_stack,
    }

    Spring.SendCommands({"console 0"})
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

    if newMsg.msgtype == 'other' then
        return
    end
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

function widget:Shutdown()
    if (chat_win) then
        chat_win:Dispose()
    end
    Spring.SendCommands({"console 1"})
end
