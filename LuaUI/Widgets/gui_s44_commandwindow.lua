function widget:GetInfo()
    return {
        name        = "1944 Commands window",
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
SORTIES = include("LuaRules/Configs/sortie_defs.lua")

-- CONSTANTS
local mainScaleLeft   = 0.05  -- Default widget position
local mainScaleTop    = 0.135 -- Default widget position
local mainScaleWidth  = 0.1   -- Default widget width
local mainScaleHeight = 0.75  -- Default widget height
WG.COMMWINOPTS = {
    x = mainScaleLeft,
    y = mainScaleTop,
    width = mainScaleWidth,
    height = mainScaleHeight,
}
local IMAGE_DIRNAME = LUAUI_DIRNAME .. "Images/ComWin/"
local COMMANDSTOEXCLUDE = {"timewait", "deathwait", "squadwait", "gatherwait",
                           "loadonto", "nextmenu", "prevmenu", "canceltarget",
                           "settarget", "selfd", "look"}
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
    look = '\204\175',
    loadunits = '\204\176',
    unloadunits = '\204\177',
    ["Repeat on"] = '\204\180',
    ["Repeat off"] = '\204\181',
    ["Fire at will"] = '\204\182',
    ["Return fire"] = '\204\183',
    ["Hold fire"] = '\204\184',
    ["Roam"] = '\204\185',
    ["Maneuver"] = '\204\186',
    ["Hold pos"] = '\204\187',
    ["Fire HE"] = '\204\188',
    ["Fire Smoke"] = '\204\189',
    ["Prefer HE"] = '\204\188',
    ["Prefer AP"] = '\204\190',
}
local MINBUTTONSIZE = 0.04
local MAXBUTTONSONROW = 3

-- MEMBERS
local Chili
local main_win
local commandWindow
local stateWindow
local sortiesWindow
local buildWindow
local updateRequired = true
local queue = {}

-- CONTROLS
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

local function __split(str, sep)
    if sep == nil then
        sep = "%s"
    end
    local t = {}
    for s in string.gmatch(str, "([^".. sep .."]+)") do
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

local function __isMorph(cmd)
    if cmd.name == "Deploy" or ((cmd.id > 0) and (cmd.action == "deploy")) then
        return true
    end

    return false
end

function findButtonData(cmd)
    local isState = (cmd.type == CMDTYPE.ICON_MODE and #cmd.params > 1)
    local isBuild = (cmd.id < 0)
    local isMorph = __isMorph(cmd)
    local isSortie = SORTIES[cmd.action] ~= nil
    local buttontext = ""
    local container
    local texture = nil
    local tooltip = cmd.tooltip
    if isMorph then
        buttontext = cmd.name
        container = buildWindow
        if cmd.texture == "" then texture = '#'..-cmd.id else texture = cmd.texture end
    elseif not isState and not isBuild and not isSortie then
        buttontext = GLYPHS[cmd.action] or cmd.name
        container = commandWindow
    elseif isState then
        local indexChoice = cmd.params[1] + 2
        tooltip = tooltip .. "\n(" .. cmd.params[indexChoice] .. ")"
        buttontext = GLYPHS[cmd.params[indexChoice]] or cmd.params[indexChoice]
        container = stateWindow
    elseif isSortie then
        buttontext = GLYPHS[cmd.action] or cmd.name
        container = sortiesWindow
        texture = "unitpics/" .. SORTIES[cmd.action].buildPic:lower()
    else
        if queue[-cmd.id] ~= nil then
            buttontext = tostring(queue[-cmd.id])
        end
        container = buildWindow
        texture = '#'..-cmd.id
    end
    return buttontext, container, isMorph, isState, isSortie, isBuild, texture, tooltip    
end

function createMyButton(cmd)
    if(type(cmd) == 'table')then
        local viewSizeX, viewSizeY = Spring.GetViewGeometry()
        local buttontext, container, isMorph, isState, isSortie, isBuild, texture, tooltip = findButtonData(cmd)
        local size = MINBUTTONSIZE * max(viewSizeX, viewSizeY) * container.buttonsize_mult
        if isSortie then
            -- We definitively have sorties
            sortiesWindow.parent:Show()
        end
        -- Spring.Echo("createMyButton", cmd.action, buttontext, isMorph, isState, isSortie, isBuild, texture)
        -- Spring.Echo(cmd.id, cmd.name, cmd.action, cmd.tooltip)

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
            tooltip = tooltip,
            OnMouseDown = {ClickFunc},
            TileImageBK = IMAGE_DIRNAME .. "empty.png",
            TileImageFG = IMAGE_DIRNAME .. "s44_button_alt_fg.png",
            font = {
                size = Chili.OptimumFontSize(main_win.font, buttontext, size, size) - 2,
                outlineColor = {0.0,0.0,0.0,1.0},
                outline = true,
                shadow  = false,
            },
        }
        
        if texture then
            local image = Chili.Image:New {
                parent = button,
                width="100%",
                height="100%",
                y="0%",
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
    -- We must remove the building actions refered to morphs
    if (cmd.id < 0) and (cmd.name:match(".+_morph_.+") == cmd.name) and (cmd.action:match("buildunit_.+_morph_.+") == cmd.action) then
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
    if sortiesWindow.parent.visible then
        conts = {stateWindow, commandWindow, sortiesWindow, buildWindow}
    end
    -- Let's start rearraging each container.
    local cols, rows, n, buttonsize
    local h, scroll_rows = 0, {}
    for _, c in pairs(conts) do
        cols = floor((main_win.clientWidth - 12) / (minbuttonsize * c.buttonsize_mult))
        buttonsize = (main_win.clientWidth - 12) / cols
        n = #(c.children)
        rows = floor(n / cols)
        if n % cols > 0 then
            rows = rows + 1
        end
        c.columns = cols
        c.rows = rows
        c.buttonsize = buttonsize
        c:SetPosRelative(nil, nil, nil, c.rows * buttonsize, true, false)
        -- c:UpdateLayout()
        h = h + c.rows * buttonsize + 24
        table.insert(scroll_rows, c.rows)
    end
    -- Now analyze the better disposition of the containers, taking into account
    -- that they are wrapped in a scroll panel. To this end we are progressively
    -- hiding rows from bottom to top, granting at least one row per container
    local H = main_win.clientHeight
    local i = #conts
    while (i >= 0) and (h > H) do
        local c = conts[i]
        local extra_rows = ceil((h - H) / c.buttonsize)
        scroll_rows[i] = max(c.rows - extra_rows, 1)
        h = h - (c.rows - scroll_rows[i]) * c.buttonsize
        i = i - 1
    end

    -- Set all the panels position and size, except the last one, which is
    -- taking all the remaining space
    local y = 0
    for i = 1, #conts - 1 do
        local c = conts[i]
        local rows = scroll_rows[i]
        local h = c.buttonsize * rows + 24
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
    resetWindow(sortiesWindow)
    resetWindow(buildWindow)
    -- It may or may not have sorties
    sortiesWindow.parent:Hide()

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
        minHeight = (buttonsize + 24) * 4,
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
    }
    Chili.Label:New {
        parent = stateScroll,
        caption = "State",
        x=4,
        y=4,
        align   = "left",
        valign  = "top",
        font = {
            outlineColor = {0.0,0.0,0.0,1.0},
            outline = true,
            shadow  = false,
        },
    }
    stateWindow = Chili.Grid:New{
        parent = stateScroll,
        x = 0,
        y = 10,
        width = "100%",
        height = "100%",
        minHeight = 50,
        buttonsize_mult = 0.5,
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
    }
    Chili.Label:New {
        parent = commandScroll,
        caption = "Commands",
        x=4,
        y=4,
        align   = "left",
        valign  = "top",
        font = {
            outlineColor = {0.0,0.0,0.0,1.0},
            outline = true,
            shadow  = false,
        },
    }
    commandWindow = Chili.Grid:New{
        parent = commandScroll,
        x = 0,
        y = 10,
        width = "100%",
        height = "100%",
        minWidth = 50,
        buttonsize_mult = 0.5,
    }
    commandScroll.win = commandWindow

    local sortiesScroll = Chili.ScrollPanel:New{
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
    }
    Chili.Label:New {
        parent = sortiesScroll,
        caption = "Sorties",
        x=4,
        y=4,
        align   = "left",
        valign  = "top",
        font = {
            outlineColor = {0.0,0.0,0.0,1.0},
            outline = true,
            shadow  = false,
        },
    }
    sortiesWindow = Chili.Grid:New{
        parent = sortiesScroll,
        x = 0,
        y = 10,
        width = "100%",
        height = "100%",
        minWidth = 50,
        buttonsize_mult = 1.0,
    }
    sortiesScroll.win = sortiesWindow

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
    }
    Chili.Label:New {
        parent = buildScroll,
        caption = "Build",
        x=4,
        y=4,
        align   = "left",
        valign  = "top",
        font = {
            outlineColor = {0.0,0.0,0.0,1.0},
            outline = true,
            shadow  = false,
        },
    }
    buildWindow = Chili.Grid:New{
        parent = buildScroll,
        x = 0,
        y = 10,
        width = "100%",
        height = "100%",
        minWidth = 50,
        buttonsize_mult = 1.0,
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

    ResizeContainers()
end

function widget:CommandsChanged()
    updateRequired = true
end

function widget:DrawScreen()
    local selection = Spring.GetSelectedUnits()
    if (selection == nil) or (#selection == 0) then
        main_win:Hide()
        return
    end

    main_win:Show()
    if updateRequired then
        updateRequired = false
        loadPanel()
    end
end

function widget:ViewResize(viewSizeX, viewSizeY)
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
    main_win:Dispose()
    if widgetHandler.ConfigLayoutHandler then
        widgetHandler:ConfigLayoutHandler( true )
    end
    Spring.ForceLayoutUpdate()
    widgetHandler.actionHandler:RemoveAction("resetcomwin")
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
