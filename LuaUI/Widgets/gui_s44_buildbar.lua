function widget:GetInfo()
    return {
        name        = "1944 Building bar",
        desc        = "An extended build menu to access the build options everywhere",
        author      = "Jose Luis Cercos Pita (heavily inspired in the work of jK)",
        date        = "2020-09-08",
        license     = "GNU GPL v2 or later",
        layer       = 1,
        enabled     = true,
    }
end

-- CONSTANTS
local mainScaleLeft   = 0.0   -- Default widget position
local mainScaleTop    = 0.135 -- Default widget position
local mainScaleWidth  = 0.05  -- Default widget width
local mainScaleHeight = 0.75  -- Default widget height
WG.BUILDBAROPTS = {
    x = mainScaleLeft,
    y = mainScaleTop,
    width = mainScaleWidth,
    height = mainScaleHeight,
}
local IMAGE_DIRNAME = LUAUI_DIRNAME .. "Images/ComWin/"
local GLYPHS = {
    repeat_on = '\204\180',
    repeat_off = '\204\181',
}
local MINBUTTONSIZE = 0.04

-- MEMBERS
local Chili
local main_win, container, buttonsize
local myTeamID = 0
local factories = {}

-- CONTROLS
local floor, ceil = math.floor, math.ceil
local min, max    = math.min, math.max
local GetViewGeometry   = Spring.GetViewGeometry
local GetUnitDefID      = Spring.GetUnitDefID
local GetUnitHealth     = Spring.GetUnitHealth
local GetUnitStates     = Spring.GetUnitStates
local GetUnitIsBuilding = Spring.GetUnitIsBuilding
local GetMyTeamID       = Spring.GetMyTeamID
local GetTeamUnits      = Spring.GetTeamUnits

-- SCRIPT FUNCTIONS
function ResetBuildBar()
    -- Reset default values
    WG.BUILDBAROPTS.x = mainScaleLeft
    WG.BUILDBAROPTS.y = mainScaleTop
    WG.BUILDBAROPTS.width = mainScaleWidth
    WG.BUILDBAROPTS.height = mainScaleHeight
    local viewSizeX, viewSizeY = GetViewGeometry()
    x = WG.BUILDBAROPTS.x * viewSizeX
    y = WG.BUILDBAROPTS.y * viewSizeY
    w = WG.BUILDBAROPTS.width * viewSizeX
    h = WG.BUILDBAROPTS.height * viewSizeY
    main_win:SetPosRelative(x, y, w, h, true, false)
end

local function ResizeContainer()
    if #container.children == 0 then
        main_win:Hide()
        return
    end
    main_win:Show()

    local w = container.width
    if not container.parent._vscrollbar then
        w = w - container.parent.scrollbarSize
    end

    -- Count the number of columns and rows
    local viewSizeX, viewSizeY = GetViewGeometry()
    local buttonsize = min(w, MINBUTTONSIZE * max(viewSizeX, viewSizeY))
    local cols = floor(w / buttonsize)
    local rows = max(1, ceil(#container.children / cols))
    -- Fit the buttons to the available space
    buttonsize = w / cols
    for _, c in ipairs(container.children) do
        c:Resize(buttonsize, buttonsize)
        c.image:Resize(buttonsize - 2, buttonsize - 2)
        c.label:SetPos(7, -48)
        c.pbar:SetPos(5, buttonsize - 22, buttonsize - 15, 12)
    end
    -- Set the number of rows and columns of the widget
    container.columns = cols
    container.rows = rows
    -- Set a more convenient height
    container:SetPosRelative(nil, nil, nil, rows * buttonsize, true, false)
end

local function __OnMainWinSize(self, w, h)
    ResizeContainer()
end

local function __OnLockWindow(self)
    local viewSizeX, viewSizeY = GetViewGeometry()
    WG.BUILDBAROPTS.x = self.x / viewSizeX
    WG.BUILDBAROPTS.y = self.y / viewSizeY
    WG.BUILDBAROPTS.width = self.width / viewSizeX
    WG.BUILDBAROPTS.height = self.height / viewSizeY
end

local function __makeButton(unitDefID, parent, size)
    local unitDef = UnitDefs[unitDefID]
    size = size or buttonsize
    --[[
    local tooltip = unitDef.humanName .. "\n"
    tooltip = tooltip .. "\255\210\210\210Middle mouse: set camera target\n"
    --]]
    local button = Chili.Button:New {
        parent = parent,
        width = size,
        height = size,
        padding = {1, 1, 1, 1},
        margin = {0, 0, 0, 0},
        caption = "",
        isDisabled = false,
        TileImageBK = IMAGE_DIRNAME .. "empty.png",
        TileImageFG = IMAGE_DIRNAME .. "s44_button_alt_fg.png",
    }
    local image = Chili.Image:New {
        parent = button,
        x=0,
        y=0,
        width = "100%",
        keepAspect = true,
        file = '#' .. unitDefID,
        padding = {0, 0, 0, 0}
    }
    local pbar = Chili.Progressbar:New{
        parent = image,
        x = 0,
        bottom = 0,
        width = "100%",
        height = 12,
        color = {0.1, 0.8, 0.1, 0.8},
        backgroundColor = {0.1, 0.1, 0.1, 0.6},
        orientation = "horizontal",
        caption = "",
        value = 0,
        TileImageFG = IMAGE_DIRNAME .. "s44_cpu_progressbar_full.png",
        TileImageBK = IMAGE_DIRNAME .. "s44_cpu_progressbar_empty.png",
    }
    local label = Chili.Label:New{
        parent = image,
        x = 0,
        y = 0,
        caption = "",
        font = {
            size          = 32,
            outlineWidth  = 3,
            outlineWeight = 10,
            outline       = true,
        }
    }
    button.image = image
    button.pbar = pbar
    button.label = label
    return button
end

local function OnFactory(self, x, y, btn)
    local unitID = self.unitID

    if btn == 1 then
        Spring.SelectUnitArray({unitID})
    elseif btn == 2 then
        local x,y,z = Spring.GetUnitPosition(unitID)
        Spring.SetCameraTarget(x,y,z)
    elseif btn == 3 then
        local ustate = GetUnitStates(unitID)
        local onoff = ustate["repeat"] and {0} or {1}
        Spring.GiveOrderToUnit(unitID, CMD.REPEAT, onoff, { })
    end
end

local function __makeFactory(unitID, unitDefID, unitDef)
    local tooltip = unitDef.humanName .. "\n"
    tooltip = tooltip .. "Left mouse: Select\n"
    tooltip = tooltip .. "Middle mouse: set camera target\n"
    tooltip = tooltip .. "Right mouse: Switch on/off repeat\n"
    local button = __makeButton(unitDefID, container)
    button.unitID = unitID
    button.unitDefID = unitDefID
    button.unitDef = unitDef
    button.OnClick = {OnFactory, }
    button.tooltip = tooltip
    factories[unitID] = button
    local ustate = GetUnitStates(unitID)
    if ustate["repeat"] then
        button.label:SetCaption(GLYPHS.repeat_on)
    else
        button.label:SetCaption(GLYPHS.repeat_off)
    end
    button.pbar:Hide()
end

function GenerateFactories()
    factories = {}
    container:ClearChildren()
    local teamUnits = GetTeamUnits(myTeamID)
    for _, unitID in ipairs(teamUnits) do
        local unitDefID = GetUnitDefID(unitID)
        local unitDef = UnitDefs[unitDefID]
        if unitDef.isFactory then
            __makeFactory(unitID, unitDefID, unitDef)
        end
    end
    ResizeContainer()
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
    local viewSizeX, viewSizeY = GetViewGeometry()
    myTeamID = GetMyTeamID()

    main_win = Chili.Window:New{
        parent = Chili.Screen0,
        x = tostring(math.floor(100 * WG.BUILDBAROPTS.x)) .. "%",
        y = tostring(math.floor(100 * WG.BUILDBAROPTS.y)) .. "%",
        width = tostring(math.floor(100 * WG.BUILDBAROPTS.width)) .. "%",
        height = tostring(math.floor(100 * WG.BUILDBAROPTS.height)) .. "%",
        draggable = true,
        resizable = true,
        padding = {0, 0, 0, 0},
        minWidth = 96,
        minHeight = 96,
        caption = "Factories",
    }
    Chili.AddCustomizableWindow(main_win)

    local scroll = Chili.ScrollPanel:New{
        parent = main_win,
        x = 0,
        y = 10,
        width = "100%",
        bottom = 10,
        horizontalScrollbar = false,
        BorderTileImage = IMAGE_DIRNAME .. "empty.png",
        BackgroundTileImage = IMAGE_DIRNAME .. "empty.png",
    }
    container = Chili.Grid:New{
        parent = scroll,
        x = 0,
        y = 0,
        width = "100%",
        height = "100%",
    }

    widgetHandler:AddAction("resetbuildbar", ResetBuildBar)

    main_win.OnMove = {__OnMainWinSize,}
    main_win.OnResize = {__OnMainWinSize,}
    GenerateFactories()
    -- Save the new dimensions when the widget is locked
    main_win.OnLockWindow = {__OnLockWindow,}
end

function widget:ViewResize(viewSizeX, viewSizeY)
    if main_win == nil then
        return
    end
    x = WG.BUILDBAROPTS.x * viewSizeX
    y = WG.BUILDBAROPTS.y * viewSizeY
    w = WG.BUILDBAROPTS.width * viewSizeX
    h = WG.BUILDBAROPTS.height * viewSizeY
    if w < main_win.minWidth then
        w = main_win.minWidth
    end
    if h < main_win.minHeight then
        h = main_win.minHeight
    end
    main_win:SetPosRelative(x, y, w, h, true, false)
    ResizeContainer()
end

function widget:UnitCreated(unitID, unitDefID, unitTeam)
    if (unitTeam ~= myTeamID) then
        return
    end

    local unitDef = UnitDefs[unitDefID]
    if unitDef.isFactory then
        __makeFactory(unitID, unitDefID, unitDef)
        ResizeContainer()
    end
end

function widget:UnitGiven(unitID, unitDefID, unitTeam, oldTeam)
    widget:UnitCreated(unitID, unitDefID, unitTeam)
end

function widget:UnitDestroyed(unitID, unitDefID, unitTeam)
    if (unitTeam ~= myTeamID) or (factories[unitID] == nil) then
        return
    end

    factories[unitID]:Dispose()
    factories[unitID] = nil
    ResizeContainer()
end

function widget:UnitTaken(unitID, unitDefID, unitTeam, newTeam)
    widget:UnitDestroyed(unitID, unitDefID, unitTeam)
end

function widget:Update()
    if myTeamID ~= GetMyTeamID() then
        myTeamID = GetMyTeamID()
        GenerateFactories()
        return
    end

    local progress
    for unitID, button in pairs(factories) do
        -- Check if the factory is building something
        unitBuildID = GetUnitIsBuilding(unitID)
        if unitBuildID ~= nil then
            button.image.file = '#' .. GetUnitDefID(unitBuildID)
            _, _, _, _, progress = GetUnitHealth(unitBuildID)
        else
            button.image.file = '#' .. GetUnitDefID(unitID)
            _, _, _, _, progress = GetUnitHealth(unitID)
        end
        if progress >= 1 then
            button.pbar:SetValue(0)
            button.pbar:Hide()
        else
            button.pbar:SetValue(100 * progress)
            button.pbar:Show()
        end
        -- Update the repeat label
        local ustate = GetUnitStates(unitID)
        if ustate["repeat"] then
            button.label:SetCaption(GLYPHS.repeat_on)
        else
            button.label:SetCaption(GLYPHS.repeat_off)
        end
    end
end

function widget:Shutdown()
    if main_win ~= nil then
        Chili.RemoveCustomizableWindow(main_win)
        main_win:Dispose()
    end
    container = nil
    widgetHandler:RemoveAction("resetbuildbar")
end 

function widget:GetConfigData()
    return {
        x      = WG.BUILDBAROPTS.x,
        y      = WG.BUILDBAROPTS.y,
        width  = WG.BUILDBAROPTS.width,
        height = WG.BUILDBAROPTS.height,
    }
end

function widget:SetConfigData(data)
    WG.BUILDBAROPTS.x      = data.x or WG.BUILDBAROPTS.x
    WG.BUILDBAROPTS.y      = data.y or WG.BUILDBAROPTS.y
    WG.BUILDBAROPTS.width  = data.width or WG.BUILDBAROPTS.width
    WG.BUILDBAROPTS.height = data.height or WG.BUILDBAROPTS.height
end
