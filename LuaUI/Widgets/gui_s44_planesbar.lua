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
local mainScaleLeft   = 0.90  -- Default widget position
local mainScaleTop    = 0.05  -- Default widget position
local mainScaleWidth  = 0.05  -- Default widget width
local mainScaleHeight = 0.85  -- Default widget height
WG.PLANESBAROPTS = {
    x = mainScaleLeft,
    y = mainScaleTop,
    width = mainScaleWidth,
    height = mainScaleHeight,
}
local IMAGE_DIRNAME = LUAUI_DIRNAME .. "Images/ComWin/"

-- MEMBERS
local Chili
local main_win, container, buttonsize
local myTeamID = 0
local aircrafts = {}
local overAircraft = nil

-- CONTROLS
local GetUnitDefID       = Spring.GetUnitDefID
local GetUnitHealth      = Spring.GetUnitHealth
local GetSelectedUnits   = Spring.GetSelectedUnits
local GetTeamUnitsSorted = Spring.GetTeamUnitsSorted
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
    local viewSizeX, viewSizeY = Spring.GetViewGeometry()
    x = WG.PLANESBAROPTS.x * viewSizeX
    y = WG.PLANESBAROPTS.y * viewSizeY
    w = WG.PLANESBAROPTS.width * viewSizeX
    h = WG.PLANESBAROPTS.height * viewSizeY
    main_win:SetPosRelative(x, y, w, h, true, false)
end

local function ResizeContainer()
    if #container.children == 0 then
        main_win:Hide()
        return
    end
    main_win:Show()

    buttonsize = container.width
    if not container.parent._vscrollbar then
        buttonsize = buttonsize - container.parent.scrollbarSize
    end
    for _, c in ipairs(container.children) do
        c:Resize(buttonsize, buttonsize)
        c.image:Resize(buttonsize - 2, buttonsize - 2)
        c.hbar:SetPos(0.5 * buttonsize, buttonsize - 20, 0.5 * buttonsize - 1, 10)
        c.fbar:SetPos(0.5 * buttonsize, buttonsize - 10, 0.5 * buttonsize - 1, 10)
    end
end

local function OnMainWinSize(self, w, h)
    local viewSizeX, viewSizeY = Spring.GetViewGeometry()
    WG.PLANESBAROPTS.x = self.x / viewSizeX
    WG.PLANESBAROPTS.y = self.y / viewSizeY
    WG.PLANESBAROPTS.width = self.width / viewSizeX
    WG.PLANESBAROPTS.height = self.height / viewSizeY
    ResizeContainer()
end

local function GetColourScale(value, alpha)
    local v = 100 - value
    local colour = {0, 1, 0, alpha or 1}
    colour[1] = math.min(50, v) / 50
    colour[2] = 1 - (math.max(0, v - 50) / 50)
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
    aircrafts[unitID] = button
end

function GenerateAircrafts()
    aircrafts = {}
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
    local viewSizeX, viewSizeY = Spring.GetViewGeometry()
    myTeamID = GetMyTeamID()

    main_win = Chili.Window:New{
        parent = Chili.Screen0,
        x = tostring(math.floor(100 * WG.PLANESBAROPTS.x)) .. "%",
        y = tostring(math.floor(100 * WG.PLANESBAROPTS.y)) .. "%",
        width = tostring(math.floor(100 * WG.PLANESBAROPTS.width)) .. "%",
        height = tostring(math.floor(100 * WG.PLANESBAROPTS.height)) .. "%",
        draggable = true,
        resizable = true,
        padding = {0, 0, 0, 0},
        minWidth = 96,
        minHeight = 96,
        caption = "Aircrafts"
    }
    Chili.AddCustomizableWindow(main_win)

    local scroll = Chili.ScrollPanel:New{
        parent = main_win,
        x = 0,
        y = 20,
        width = "100%",
        bottom = 10,
        horizontalScrollbar = false,
        BorderTileImage = IMAGE_DIRNAME .. "empty.png",
        BackgroundTileImage = IMAGE_DIRNAME .. "empty.png",
    }
    container = Chili.StackPanel:New{
        parent = scroll,
        x = 0,
        y = 10,
        width = "100%",
        height = "100%",
        resizeItems = false,
        itemPadding  = { 1, 1, 1, 1 },
        itemMargin  = {0, 0, 0, 0},
        autosize = true,
        preserveChildrenOrder = true,
    }

    widgetHandler:AddAction("resetplanesbar", ResetPlanesBar)

    -- Set the widget size, which apparently were not working well
    x = WG.PLANESBAROPTS.x * viewSizeX
    y = WG.PLANESBAROPTS.y * viewSizeY
    w = WG.PLANESBAROPTS.width * viewSizeX
    h = WG.PLANESBAROPTS.height * viewSizeY
    main_win:SetPosRelative(x, y, w, h, true, false)
    -- If we set OnMove/OnResize during the initialization, they are called
    -- eventually breaking our WG.PLANESBAROPTS data
    main_win.OnMove = {OnMainWinSize,}
    main_win.OnResize = {OnMainWinSize,}
    ResizeContainer()
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

    for unitID, button in pairs(aircrafts) do
        local unitDef = button.unitDef

        local sHP, sMaxHP = GetUnitHealth(unitID)
        button.hbar:SetValue(sHP / sMaxHP * 100)

        local sMaxFuel = unitDef.customParams.maxfuel or 1
        local sFuel = GetUnitRulesParam(unitID, "fuel") or sMaxFuel
        button.fbar:SetValue(sFuel / sMaxFuel * 100)
    end
end

function widget:DrawWorld()
    local unitID = overAircraft
    if unitID == nil then
        return
    end

    local inTweak
    if widgetHandler.InTweakMode then
        inTweak = widgetHandler:InTweakMode()
    else
        inTweak = widgetHandler.tweakMode
    end
    if inTweak then
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
    main_win:Dispose()
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
