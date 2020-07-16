function widget:GetInfo()
    return {
        name        = "Commands window",
        desc        = "Custom commands window for Spring 1944",
        author      = "Jose Luis Cercos Pita",
        date        = "2020-06-30",
        license     = "GNU GPL v2 or later",
        layer       = 1,
        handler     = true,
        enabled     = true,
    }
end

-- INCLUDES
MORPHS = include("LuaRules/Configs/morph_defs.lua")

-- CONSTANTS
local mainScaleLeft   = 0.0   -- Default widget position
local mainScaleTop    = 0.135 -- Default widget position
local mainScaleWidth  = 0.15  -- Default widget width
local mainScaleHeight = 0.86  -- Default widget height
WG.COMMWINOPTS = {
    x = mainScaleLeft,
    y = mainScaleTop,
    width = mainScaleWidth,
    height = mainScaleHeight,
}
local IMAGE_DIRNAME = LUAUI_DIRNAME .. "Images/ComWin/"
local COMMANDSTOEXCLUDE = {"timewait", "deathwait", "squadwait", "gatherwait",
                           "loadonto", "nextmenu", "prevmenu", "canceltarget",
                           "settarget", "selfd"}
local GLYPHS = {
    attack = '\204\164',
    fight = '\204\165',
    guard = '\204\166',
    move = '\204\167',
    patrol = '\204\168',
    stop = '\204\169',
    wait = '\204\170',
    turn = '\204\171',
    reclaim = '\204\172',
    clearpath = '\204\173',
    repair = '\204\174',
}
local MINBUTTONSIZE = 0.04
local MAXBUTTONSONROW = 3

-- MEMBERS
local Chili
local main_win
local commandWindow
local stateWindow
local buildWindow
local updateRequired = true
local queue = {}

-- CONTROLS
local abs = math.abs
local min, max = math.min, math.max
local floor, ceil = math.floor, math.ceil
local spGetActiveCommand    = Spring.GetActiveCommand
local spGetActiveCmdDesc    = Spring.GetActiveCmdDesc
local spGetSelectedUnits    = Spring.GetSelectedUnits
local spSendCommands        = Spring.SendCommands


-- SCRIPT FUNCTIONS
function LayoutHandler(xIcons, yIcons, cmdCount, commands)
    widgetHandler.commands   = commands
    widgetHandler.commands.n = cmdCount
    widgetHandler:CommandsChanged()
    local reParamsCmds = {}
    local customCmds = {}

    return "", xIcons, yIcons, {}, customCmds, {}, {}, {}, {}, reParamsCmds, {[1337]=9001}
end

function ClickFunc(chiliButton, x, y, button, mods) 
    local index = Spring.GetCmdDescIndex(chiliButton.cmdid)
    if (index) then
        local left, right = (button == 1), (button == 3)
        local alt, ctrl, meta, shift = mods.alt, mods.ctrl, mods.meta, mods.shift

        Spring.SetActiveCommand(index, button, left, right, alt, ctrl, meta, shift)
    end
end

local function OptimumFontSize(font, txt, w, h)
    local wf = w / font:GetTextWidth(txt)
    local hf, _, _ = h / font:GetTextHeight(txt)
    return floor(min(wf, hf) * font.size)
end

local function __split(str, sep)
    if sep == nil then
        sep = "%s"
    end
    local t = {}
    for s in string.gmatch(str, "([^".. sep .."]+)") do
        Spring.Echo(s)
        table.insert(t, s)
    end
    return t
end

local function __unique(t)
    local hash = {}
    local res = {}

    for _,v in ipairs(t) do
        if (not hash[v]) then
            table.insert(res, v)
            hash[v] = true
        end
    end

    return res
end

local function __morphName(cmd)
    if cmd.name == "Deploy" then
        return cmd.name
    end
    if (cmd.id < 0) and (cmd.name:match(".+_morph_.+") == cmd.name) and (cmd.action:match("buildunit_.+_morph_.+") == cmd.action) then
        local names = __unique(__split(cmd.name:match("^.+_morph_(.*)"), "_"))
        local from, into = names[1], names[2]

        if MORPHS[from] == nil then
            -- Special case of packable factories
            from = from .. "_" .. into
        end
        if MORPHS[from] == nil then
            Spring.Echo("MORPHS[from] == nil")
            return nil
        end

        if MORPHS[from].into ~= nil then
            if (MORPHS[from].into == into) or (MORPHS[from].into == into .. "_" .. from) then
                return MORPHS[from].name
            end
        else
            for _, morph in ipairs(MORPHS[from]) do
                if (morph.into == into) or (morph.into == into .. "_" .. from) then
                    return morph.name
                end
            end
        end
        return nil
    end

    return nil
end

function findButtonData(cmd)
    local isState = (cmd.type == CMDTYPE.ICON_MODE and #cmd.params > 1)
    local isBuild = (cmd.id < 0)
    local morphName = __morphName(cmd)
    local isMorph = morphName ~= nil
    local buttontext = ""
    local container
    local texture = nil
    if isMorph then
        buttontext = morphName
        container = buildWindow
        if cmd.texture == "" then texture = '#'..-cmd.id else texture = cmd.texture end
    elseif not isState and not isBuild then
        buttontext = GLYPHS[cmd.action] or cmd.name
        container = commandWindow
    elseif isState then
        local indexChoice = cmd.params[1] + 2
        buttontext = cmd.params[indexChoice]
        container = stateWindow
    else
        if queue[-cmd.id] ~= nil then
            buttontext = tostring(queue[-cmd.id])
        end
        container = buildWindow
        texture = '#'..-cmd.id
    end
    return buttontext, container, isMorph, isState, isBuild, texture    
end

function createMyButton(cmd)
    if(type(cmd) == 'table')then
        local viewSizeX, viewSizeY = Spring.GetViewGeometry()
        local size = MINBUTTONSIZE * max(viewSizeX, viewSizeY)
        buttontext, container, isMorph, isState, isBuild, texture = findButtonData(cmd)
        Spring.Echo("createMyButton", cmd.action, buttontext, isMorph, isState, isBuild, texture)
        Spring.Echo(cmd.id, cmd.name, cmd.action, cmd.tooltip)

        local color = {0,0,0,1}
        local button = Chili.Button:New {
            parent = container,
            x = 0,
            y = 0,
            padding = {5, 5, 5, 5},
            margin = {0, 0, 0, 0},
            minWidth = size,
            minHeight = size,
            caption = buttontext,
            isDisabled = false,
            cmdid = cmd.id,
            OnMouseDown = {ClickFunc},
            TileImageBK = IMAGE_DIRNAME .. "empty.png",
            TileImageFG = IMAGE_DIRNAME .. "s44_button_alt_fg.png",
            font = {
                size = OptimumFontSize(main_win.font, buttontext, size, size) - 2,
                outlineColor = {0.0,0.0,0.0,1.0},
                outline = true,
                shadow  = false,
            },
        }
        
        if texture then
            local image = Chili.Image:New {
                parent = button,
                width="100%",
                height="90%",
                y="5%",
                keepAspect = true,
                file = texture,
            }
            if buttontext ~= "" then
                button.caption = ""
                local image = Chili.Label:New {
                    parent = image;
                    width="100%",
                    height="100%",
                    y=5,
                    x=5,
                    caption = buttontext,
                    align   = "left",
                    valign  = "top",
                    font = {
                        outlineColor = {0.0,0.0,0.0,1.0},
                        outline = true,
                        shadow  = false,
                    },
                }
            end
        end
        
        if(increaseRow)then
            container.ystep = container.ystep+1
        end        
    end
end

local function __isUnwanted(cmd)
    if table.contains(COMMANDSTOEXCLUDE, cmd.action) then
        return true
    end
    -- We must remove the fake morphs for factories. Unfortunately, we cannot
    -- use the hidden property, since all the commands are marked as hidden
    -- after the default menu. Therefore, we look for commands with:
    --  * id > 0
    --  * action == "fake_morph"
    if (cmd.id > 0) and (cmd.action == "deploy") and (cmd.name ~= "Deploy") then
        Spring.Echo("__isUnwanted", cmd.id, cmd.action, cmd.name)
        return true
    end

    return false
end

function filterUnwanted(commands)
    local uniqueList = {}
    if not(#commands == 0)then
        j = 1
        for _, cmd in ipairs(commands) do
            if not __isUnwanted(cmd) then
                uniqueList[j] = cmd
                j = j + 1
            end
        end
    end
    return uniqueList
end

function resetWindow(container)
    container:ClearChildren()
end

function ResizeContainers()
    local viewSizeX, viewSizeY = Spring.GetViewGeometry()
    local minbuttonsize = MINBUTTONSIZE * max(viewSizeX, viewSizeY)
    local conts = {stateWindow, commandWindow, buildWindow}
    -- Let's start rearraging each container.
    local cols, rows, n, buttonsize
    cols = floor((main_win.clientWidth - 12) / minbuttonsize)
    buttonsize = (main_win.clientWidth - 12) / cols
    for _, c in pairs(conts) do
        n = #(c.children)
        rows = floor(n / cols)
        if n % cols > 0 then
            rows = rows + 1
        end
        c.columns = cols
        c.rows = rows
        c:SetPosRelative(nil, nil, nil, c.rows * buttonsize, true, false)
        -- c:UpdateLayout()
    end
    -- Now analyze the better disposition of the containers, taking into account
    -- that they are wrapped in a scroll panel. To this end we are progressively
    -- hiding rows from bottom to top, granting at least one row per container
    local H = main_win.clientHeight
    local max_rows = max(floor((H - 3 * 10) / buttonsize), 3)
    local rows = stateWindow.rows + commandWindow.rows + buildWindow.rows
    local out_rows = rows - max_rows
    local showing_rows = {stateWindow.rows, commandWindow.rows, buildWindow.rows}
    local i
    for i = #conts, 1, -1 do
        local c = conts[i]
        showing_rows[i] = max(c.rows - out_rows, 1)
        out_rows = out_rows - (c.rows - showing_rows[i])
    end

    -- Set all the panels position and size, except the last one, which is
    -- taking all the remaining space
    local y = 0
    for i = 1, #conts - 1 do
        local c = conts[i]
        local rows = showing_rows[i]
        local h = buttonsize * rows + 10
        c.parent:SetPosRelative(nil, y, nil, h, true, false)
        c:UpdateLayout()
        y = y + h
    end

    -- Set the last panel as biggest as posible
    local c = conts[#conts]
    c.parent:SetPosRelative(nil, y, nil, H - y - 10, true, false)
    c:UpdateLayout()

end

local function getQueue()
    queue = {}
    for _,u in ipairs(Spring.GetSelectedUnits()) do
        local buildQueue  = Spring.GetFullBuildQueue(u)
        if (buildQueue ~= nil) then
            local i = 1
            while buildQueue[i] do
                local unitBuildDefID, count = next(buildQueue[i], nil)
                if queue[unitBuildDefID] == nil then
                    queue[unitBuildDefID] = count
                else
                    queue[unitBuildDefID] = queue[unitBuildDefID] + count
                end
                i = i + 1
            end
        end
    end
end

function loadPanel()
    resetWindow(commandWindow)
    resetWindow(stateWindow)
    resetWindow(buildWindow)
    getQueue()
    local commands = Spring.GetActiveCmdDescs()
    commands = filterUnwanted(commands)
    -- table.sort(commands, function(x,y) return x.action < y.action end)
    for cmdid, cmd in pairs(commands) do
        createMyButton(commands[cmdid]) 
    end
    ResizeContainers()
end

function ResetComWin(cmd, optLine)
    -- Reset default values
    WG.COMMWINOPTS.x = mainScaleLeft
    WG.COMMWINOPTS.y = mainScaleTop
    WG.COMMWINOPTS.width = mainScaleWidth
    WG.COMMWINOPTS.height = mainScaleHeight
    local viewSizeX, viewSizeY = Spring.GetViewGeometry()
    x = WG.COMMWINOPTS.x * viewSizeX
    y = WG.COMMWINOPTS.y * viewSizeY
    w = WG.COMMWINOPTS.width * viewSizeX
    h = WG.COMMWINOPTS.height * viewSizeY
    main_win:SetPosRelative(x, y, w, h, true, false)
end

local function __OnMainWinSize(self, w, h)
    local viewSizeX, viewSizeY = Spring.GetViewGeometry()
    WG.COMMWINOPTS.x = self.x / viewSizeX
    WG.COMMWINOPTS.y = self.y / viewSizeY
    WG.COMMWINOPTS.width = self.width / viewSizeX
    WG.COMMWINOPTS.height = self.height / viewSizeY
    ResizeContainers()
end

local function __OnContainerSize(self, w, h)
    
end


------------------------------------------------
--callins
------------------------------------------------
function widget:Initialize()
    if (not WG.Chili) then
        widgetHandler:RemoveWidget()
        return
    end
    Chili = WG.Chili
    local viewSizeX, viewSizeY = Spring.GetViewGeometry()

    if widgetHandler.ConfigLayoutHandler then
        widgetHandler:ConfigLayoutHandler(LayoutHandler)
    end
    Spring.ForceLayoutUpdate()
    spSendCommands({"tooltip 0"})

    local buttonsize = MINBUTTONSIZE * max(viewSizeX, viewSizeY)
    main_win = Chili.Window:New{
        parent = Chili.Screen0,
        x = tostring(floor(100 * WG.COMMWINOPTS.x)) .. "%",
        y = tostring(floor(100 * WG.COMMWINOPTS.y)) .. "%",
        width = tostring(floor(100 * WG.COMMWINOPTS.width)) .. "%",
        height = tostring(floor(100 * WG.COMMWINOPTS.height)) .. "%",
        draggable = true,
        resizable = true,
        padding = {0, 0, 0, 0},
        minWidth = buttonsize + 12 + 10,
        minHeight = (buttonsize + 10) * 3,
    }

    local stateScroll = Chili.ScrollPanel:New{
        parent = main_win,
        x = 0,
        y = 0,
        width = "100%",
        height = buttonsize,
        minHeight = buttonsize,
        horizontalScrollbar = false,
        padding = {0, 0, 0, 0},
        BorderTileImage = IMAGE_DIRNAME .. "empty.png",
        BackgroundTileImage = IMAGE_DIRNAME .. "empty.png",
        OnResize = {__OnContainerSize,}
    }
    stateWindow = Chili.Grid:New{
        parent = stateScroll,
        x = 0,
        y = 0,
        width = "100%",
        height = "100%",
        minHeight = 50,
    }    
    stateScroll.win = stateWindow

    local commandScroll = Chili.ScrollPanel:New{
        parent = main_win,
        x = 0,
        y = buttonsize,
        width = "100%",
        height = 3 * buttonsize,
        minHeight = 50,
        horizontalScrollbar = false,
        padding = {0, 0, 0, 0},
        BorderTileImage = IMAGE_DIRNAME .. "empty.png",
        BackgroundTileImage = IMAGE_DIRNAME .. "empty.png",
        OnResize = {__OnContainerSize,}
    }
    commandWindow = Chili.Grid:New{
        parent = commandScroll,
        x = 0,
        y = 0,
        width = "100%",
        height = "100%",
        minWidth = 50,
    }
    commandScroll.win = commandWindow

    local buildScroll = Chili.ScrollPanel:New{
        parent = main_win,
        x = 0,
        y = 4 * buttonsize,
        width = "100%",
        height = 3 * buttonsize,
        minHeight = 50,
        horizontalScrollbar = false,
        padding = {0, 0, 0, 0},
        BorderTileImage = IMAGE_DIRNAME .. "empty.png",
        BackgroundTileImage = IMAGE_DIRNAME .. "empty.png",
        OnResize = {__OnContainerSize,}
    }
    buildWindow = Chili.Grid:New{
        parent = buildScroll,
        x = 0,
        y = 0,
        width = "100%",
        height = "100%",
        minWidth = 50,
    }
    buildScroll.win = buildWindow

    widgetHandler.actionHandler:AddAction(widget, "resetcomwin", ResetComWin)

    -- Set the widget size, which apparently were not working well
    x = WG.COMMWINOPTS.x * viewSizeX
    y = WG.COMMWINOPTS.y * viewSizeY
    w = WG.COMMWINOPTS.width * viewSizeX
    h = WG.COMMWINOPTS.height * viewSizeY
    main_win:SetPosRelative(x, y, w, h, true, false)
    -- If we set OnMove/OnResize during the initialization, they are called
    -- eventually breaking our WG.COMMWINOPTS data
    main_win.OnMove = {__OnMainWinSize,}
    main_win.OnResize = {__OnMainWinSize,}

    __OnContainerSize(commandWindow,
                      commandWindow.clientWidth,
                      commandWindow.clientHeight)
    __OnContainerSize(stateWindow,
                      stateWindow.clientWidth,
                      stateWindow.clientHeight)
    __OnContainerSize(buildWindow,
                      buildWindow.clientWidth,
                      buildWindow.clientHeight)
    ResizeContainers()
end

function widget:CommandsChanged()
    updateRequired = true
end

function widget:DrawScreen()
    if updateRequired then
        updateRequired = false
        loadPanel()
    end
end

function widget:ViewResize(viewSizeX, viewSizeY)
    vsx = viewSizeX
    vsy = viewSizeY
    if main_win == nil then
        return
    end
    x = WG.COMMWINOPTS.x * viewSizeX
    y = WG.COMMWINOPTS.y * viewSizeY
    w = WG.COMMWINOPTS.width * viewSizeX
    h = WG.COMMWINOPTS.height * viewSizeY
    main_win.minHeight = (MINBUTTONSIZE * viewSizeY + 10) * 3
    if h < main_win.minHeight then
        h = main_win.minHeight
    end
    main_win:SetPosRelative(x, y, w, h, true, false)
end

function widget:Shutdown()
    if widgetHandler.ConfigLayoutHandler then
        widgetHandler:ConfigLayoutHandler( true )
    end
    Spring.ForceLayoutUpdate()
    widgetHandler.actionHandler:RemoveAction("resetresbar")
    spSendCommands({"tooltip 1"})
end 

function widget:GetConfigData()
    return {
        x      = WG.COMMWINOPTS.x,
        y      = WG.COMMWINOPTS.y,
        width  = WG.COMMWINOPTS.width,
        height = WG.COMMWINOPTS.height,
    }
end

function widget:SetConfigData(data)
    WG.COMMWINOPTS.x      = data.x or WG.COMMWINOPTS.x
    WG.COMMWINOPTS.y      = data.y or WG.COMMWINOPTS.y
    WG.COMMWINOPTS.width  = data.width or WG.COMMWINOPTS.width
    WG.COMMWINOPTS.height = data.height or WG.COMMWINOPTS.height
end
