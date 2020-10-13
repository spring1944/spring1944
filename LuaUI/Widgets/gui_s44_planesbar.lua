function widget:GetInfo()
    return {
        name        = "1944 Aircraft Selection Bar",
        desc        = "A selection bar for aircrafts",
        author      = "Ray Modified by Godde, Szunti, kmar, Jose Luis Cercos Pita",
        date        = "2011-09-06",
        license     = "GNU GPL v2 or later",
        layer       = 1,
        enabled     = true,
    }
end

-- CONSTANTS
local mainScaleLeft   = 0.900  -- Default widget position
local mainScaleTop    = 0.050  -- Default widget position
local mainScaleWidth  = 0.050  -- Default widget width
local mainScaleHeight = 0.835  -- Default widget height
WG.PLANESBAROPTS = {
    x = mainScaleLeft,
    y = mainScaleTop,
    width = mainScaleWidth,
    height = mainScaleHeight,
}
local IMAGE_DIRNAME = LUAUI_DIRNAME .. "Images/ComWin/"
local MINBUTTONSIZE = 0.04

-- MEMBERS
local Chili
local main_win, container, buttonsize
local myTeamID = 0
local aircrafts = {}
local overAircraft = nil
-- To optimize we want to traverse just one aircraft per frame
local aircrafts_iterator, current_aircraft = {}, 0

-- CONTROLS
local floor, ceil = math.floor, math.ceil
local min, max    = math.min, math.max
local GetViewGeometry    = Spring.GetViewGeometry
local GetUnitDefID       = Spring.GetUnitDefID
local GetUnitHealth      = Spring.GetUnitHealth
local GetSelectedUnits   = Spring.GetSelectedUnits
local GetTeamUnits       = Spring.GetTeamUnits
local GetMyTeamID        = Spring.GetMyTeamID
local GetUnitRulesParam  = Spring.GetUnitRulesParam
local GetMyTeamID        = Spring.GetMyTeamID
local GetUnitPosition    = Spring.GetUnitPosition
local SelectUnitArray    = Spring.SelectUnitArray
local glUnit             = gl.Unit
local glDrawGroundCircle = gl.DrawGroundCircle

-- SCRIPT FUNCTIONS
function ResetPlanesBar()
    -- Reset default values
    WG.PLANESBAROPTS.x = mainScaleLeft
    WG.PLANESBAROPTS.y = mainScaleTop
    WG.PLANESBAROPTS.width = mainScaleWidth
    WG.PLANESBAROPTS.height = mainScaleHeight
    local viewSizeX, viewSizeY = GetViewGeometry()
    x = WG.PLANESBAROPTS.x * viewSizeX
    y = WG.PLANESBAROPTS.y * viewSizeY
    w = WG.PLANESBAROPTS.width * viewSizeX
    h = WG.PLANESBAROPTS.height * viewSizeY
    main_win:SetPosRelative(x, y, w, h, true, false)
end

local function ResizeContainer()
    if #container.children == 0 and not main_win.force_show then
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
        c.hbar:SetPos(0.5 * buttonsize, buttonsize - 20, 0.5 * buttonsize - 1, 10)
        c.fbar:SetPos(0.5 * buttonsize, buttonsize - 10, 0.5 * buttonsize - 1, 10)
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
    WG.PLANESBAROPTS.x = self.x / viewSizeX
    WG.PLANESBAROPTS.y = self.y / viewSizeY
    WG.PLANESBAROPTS.width = self.width / viewSizeX
    WG.PLANESBAROPTS.height = self.height / viewSizeY
    self.force_show = false
    ResizeContainer()
end

local function __OnUnlockWindow(self)
    self.force_show = true
    ResizeContainer()
end

local function GetColourScale(value, alpha)
    local v = 100 - value
    local colour = {0, 1, 0, alpha or 1}
    colour[1] = min(50, v) / 50
    colour[2] = 1 - (max(0, v - 50) / 50)
    return colour
end

local function __HealthBarAutoColor(self, value)
    self:SetColor(GetColourScale(value, 0.8))
end

local function __makeButton(unitDefID, parent, size)
    local unitDef = UnitDefs[unitDefID]
    size = size or buttonsize

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
    local hbar = Chili.Progressbar:New{
        parent = image,
        x = "50%",
        bottom = 0,
        width = "50%",
        height = 10,
        color = GetColourScale(100, 0.8),
        backgroundColor = {0.1, 0.1, 0.1, 0.6},
        orientation = "horizontal",
        caption = "",
        value = 100,
        OnChange = {__HealthBarAutoColor, },
        TileImageFG = IMAGE_DIRNAME .. "s44_cpu_progressbar_full.png",
        TileImageBK = IMAGE_DIRNAME .. "s44_cpu_progressbar_empty.png",
    }
    local fbar = Chili.Progressbar:New{
        parent = image,
        x = "50%",
        bottom = 10,
        width = "100%",
        height = 10,
        color = {0.8, 0.5, 0.05, 0.8},
        backgroundColor = {0.1, 0.1, 0.1, 0.6},
        orientation = "horizontal",
        caption = "",
        value = 100,
        TileImageFG = IMAGE_DIRNAME .. "s44_cpu_progressbar_full.png",
        TileImageBK = IMAGE_DIRNAME .. "s44_cpu_progressbar_empty.png",
    }
    button.image = image
    button.hbar = hbar
    button.fbar = fbar
    return button
end

local function OnAircraft(self, x, y, btn)
    local unitID = self.unitID

    if btn == 1 then
        Spring.SelectUnitArray({unitID})
    elseif btn == 2 then
        local x,y,z = GetUnitPosition(unitID)
        Spring.SetCameraTarget(x,y,z)
    elseif btn == 3 then
        local units = GetSelectedUnits()
        units[#units + 1] = unitID
        Spring.SelectUnitArray(units)
    end
end

local function DrawAircraft(self)
    local unitID = self.unitID
    overAircraft = unitID
end

local function UndrawAircraft(self)
    local unitID = self.unitID
    if overAircraft == unitID then
        overAircraft = nil
    end
end

local function __makeAircraft(unitID, unitDefID, unitDef)
    local tooltip = unitDef.humanName .. "\n"
    tooltip = tooltip .. "Left mouse: Select\n"
    tooltip = tooltip .. "Middle mouse: set camera target\n"
    tooltip = tooltip .. "Right mouse: Add to selection\n"
    local button = __makeButton(unitDefID, container)
    button.unitID = unitID
    button.unitDefID = unitDefID
    button.unitDef = unitDef
    button.OnClick = {OnAircraft, }
    button.OnMouseOver = {DrawAircraft, }
    button.OnMouseOut = {UndrawAircraft, }
    button.tooltip = tooltip
    aircrafts_iterator[#aircrafts_iterator + 1] = unitID
    aircrafts[unitID] = button
end

function GenerateAircrafts()
    aircrafts = {}
    aircrafts_iterator = {}
    current_aircraft = 0
    container:ClearChildren()
    local teamUnits = GetTeamUnits(myTeamID)
    for _, unitID in ipairs(teamUnits) do
        local unitDefID = GetUnitDefID(unitID)
        local unitDef = UnitDefs[unitDefID]
        if unitDef.canFly then
            __makeAircraft(unitID, unitDefID, unitDef)
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
        x = tostring(floor(100 * WG.PLANESBAROPTS.x)) .. "%",
        y = tostring(floor(100 * WG.PLANESBAROPTS.y)) .. "%",
        width = tostring(floor(100 * WG.PLANESBAROPTS.width)) .. "%",
        height = tostring(floor(100 * WG.PLANESBAROPTS.height)) .. "%",
        draggable = true,
        resizable = true,
        padding = {0, 0, 0, 0},
        minWidth = 96,
        minHeight = 96,
        caption = "Aircrafts",
        force_show = true,
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

    widgetHandler:AddAction("resetplanesbar", ResetPlanesBar)

    -- Set the widget size, which apparently were not working well
    x = WG.PLANESBAROPTS.x * viewSizeX
    y = WG.PLANESBAROPTS.y * viewSizeY
    w = WG.PLANESBAROPTS.width * viewSizeX
    h = WG.PLANESBAROPTS.height * viewSizeY
    main_win:SetPosRelative(x, y, w, h, true, false)
    main_win.OnMove = {__OnMainWinSize,}
    main_win.OnResize = {__OnMainWinSize,}
    ResizeContainer()
    -- Save the new dimensions when the widget is locked
    main_win.OnLockWindow = {__OnLockWindow,}
    main_win.OnUnlockWindow = {__OnUnlockWindow,}
end

function widget:ViewResize(viewSizeX, viewSizeY)
    if main_win == nil then
        return
    end
    x = WG.PLANESBAROPTS.x * viewSizeX
    y = WG.PLANESBAROPTS.y * viewSizeY
    w = WG.PLANESBAROPTS.width * viewSizeX
    h = WG.PLANESBAROPTS.height * viewSizeY
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
    if unitDef.canFly then
        __makeAircraft(unitID, unitDefID, unitDef)
        ResizeContainer()
    end
end

function widget:UnitGiven(unitID, unitDefID, unitTeam, oldTeam)
    widget:UnitCreated(unitID, unitDefID, unitTeam)
end

function widget:UnitDestroyed(unitID, unitDefID, unitTeam)
    if (unitTeam ~= myTeamID) or (aircrafts[unitID] == nil) then
        return
    end

    for i, u in ipairs(aircrafts_iterator) do
        if u == unitID then
            table.remove(aircrafts_iterator, i)
            break
        end
    end
    aircrafts[unitID]:Dispose()
    aircrafts[unitID] = nil
    ResizeContainer()
end

function widget:UnitTaken(unitID, unitDefID, unitTeam, newTeam)
    widget:UnitDestroyed(unitID, unitDefID, unitTeam)
end

function widget:Update()
    if myTeamID ~= GetMyTeamID() then
        myTeamID = GetMyTeamID()
        GenerateAircrafts()
        return
    end

    if #aircrafts_iterator == 0 then
        return
    end
    current_aircraft = (current_aircraft % #aircrafts_iterator) + 1
    local unitID = aircrafts_iterator[current_aircraft]
    local button = aircrafts[unitID]
    local unitDef = button.unitDef

    local sHP, sMaxHP = GetUnitHealth(unitID)
    button.hbar:SetValue(sHP / sMaxHP * 100)

    local sMaxFuel = unitDef.customParams.maxfuel or 1
    local sFuel = GetUnitRulesParam(unitID, "fuel") or sMaxFuel
    button.fbar:SetValue(sFuel / sMaxFuel * 100)
end

function widget:DrawWorld()
    local unitID = overAircraft
    if unitID == nil then
        return
    end

    -- hilight the unit we are about to click on
    glUnit(unitID, true)
    local ux, uy, uz = GetUnitPosition(unitID)

    -- should help for cases when currently selected plane dies
    if ux and uy and uz then
        -- glDrawGroundCircle( ux, uy, uz, 3200, 24 )
        glDrawGroundCircle( ux, uy, uz, 1600, 20 )
        glDrawGroundCircle( ux, uy, uz, 800, 16 )
        glDrawGroundCircle( ux, uy, uz, 400, 12 )
        glDrawGroundCircle( ux, uy, uz, 200, 8 )
    end
end

function widget:Shutdown()
    if main_win ~= nil then
        Chili.RemoveCustomizableWindow(main_win)
        main_win:Dispose()
    end
    container = nil
    widgetHandler:RemoveAction("resetplanesbar")
end 

function widget:GetConfigData()
    return {
        x      = WG.PLANESBAROPTS.x,
        y      = WG.PLANESBAROPTS.y,
        width  = WG.PLANESBAROPTS.width,
        height = WG.PLANESBAROPTS.height,
    }
end

function widget:SetConfigData(data)
    WG.PLANESBAROPTS.x      = data.x or WG.PLANESBAROPTS.x
    WG.PLANESBAROPTS.y      = data.y or WG.PLANESBAROPTS.y
    WG.PLANESBAROPTS.width  = data.width or WG.PLANESBAROPTS.width
    WG.PLANESBAROPTS.height = data.height or WG.PLANESBAROPTS.height
end
