function widget:GetInfo()
    return {
        name        = "1944 Selection bar",
        desc        = "An extended selection menu to filter in/out selected units",
        author      = "Jose Luis Cercos Pita (heavily inspired in the work of jK, trepan (D. Rodgers) and FLOZi (C. Lawrence))",
        date        = "2020-09-08",
        license     = "GNU GPL v2 or later",
        layer       = 1,
        enabled     = true,
    }
end

-- CONSTANTS
local mainScaleLeft   = 0.95  -- Default widget position
local mainScaleTop    = 0.05  -- Default widget position
local mainScaleWidth  = 0.05  -- Default widget width
local mainScaleHeight = 0.85  -- Default widget height
WG.SELBAROPTS = {
    x = mainScaleLeft,
    y = mainScaleTop,
    width = mainScaleWidth,
    height = mainScaleHeight,
}
local IMAGE_DIRNAME = LUAUI_DIRNAME .. "Images/ComWin/"
local GLYPHS = {
    locked = '\204\132',
}

-- MEMBERS
local Chili
local main_win, container, buttonsize
local selection = {}
local keep_selected = {}

-- CONTROLS
local GetUnitDefID           = Spring.GetUnitDefID
local GetSelectedUnitsSorted = Spring.GetSelectedUnitsSorted
local GetSelectedUnitsCount  = Spring.GetSelectedUnitsCount
local SelectUnitArray        = Spring.SelectUnitArray
local ValidUnitID            = Spring.ValidUnitID
local GetUnitIsDead          = Spring.GetUnitIsDead
local IsUnitSelected         = Spring.IsUnitSelected

-- SCRIPT FUNCTIONS
function ResetSelBar()
    -- Reset default values
    WG.SELBAROPTS.x = mainScaleLeft
    WG.SELBAROPTS.y = mainScaleTop
    WG.SELBAROPTS.width = mainScaleWidth
    WG.SELBAROPTS.height = mainScaleHeight
    local viewSizeX, viewSizeY = Spring.GetViewGeometry()
    x = WG.SELBAROPTS.x * viewSizeX
    y = WG.SELBAROPTS.y * viewSizeY
    w = WG.SELBAROPTS.width * viewSizeX
    h = WG.SELBAROPTS.height * viewSizeY
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
        c.label:SetPos(7, -48)
        c.lock_label:SetPos(buttonsize - 48, buttonsize - 70)
    end
end

local function __OnMainWinSize(self, w, h)
    ResizeContainer()
end

local function __OnLockWindow(self)
    local viewSizeX, viewSizeY = Spring.GetViewGeometry()
    WG.SELBAROPTS.x = self.x / viewSizeX
    WG.SELBAROPTS.y = self.y / viewSizeY
    WG.SELBAROPTS.width = self.width / viewSizeX
    WG.SELBAROPTS.height = self.height / viewSizeY
    ResizeContainer()
end

local function OnSelectedUnit(self, x, y, btn)
    local unitIDs = self.unitIDs

    if btn == 1 then
        local toselect = self.unitIDs
        for unitDefID, _ in pairs(keep_selected) do
            for _, unitID in ipairs(selection[unitDefID].unitIDs) do
                toselect[#toselect + 1] = unitID
            end
        end
        SelectUnitArray(toselect)
    elseif btn == 2 then
        if keep_selected[self.unitDefID] then
            keep_selected[self.unitDefID] = nil
        else
            keep_selected[self.unitDefID] = true
        end
    elseif btn == 3 then
        if keep_selected[self.unitDefID] then
            keep_selected[self.unitDefID] = nil
            return
        end
        local toselect = {}
        for unitDefID, data in pairs(selection) do
            if unitDefID ~= self.unitDefID then
                for _, unitID in ipairs(data.unitIDs) do
                    toselect[#toselect + 1] = unitID
                end
            end
        end
        SelectUnitArray(toselect)
    end
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
    local lock_label = Chili.Label:New{
        parent = image,
        x = 0,
        y = 0,
        caption = GLYPHS.locked,
        font = {
            size  = 64,
            color = {0.1, 0.6, 0.1, 0.7},
        }
    }
    lock_label:Hide()
    button.image = image
    button.label = label
    button.lock_label = lock_label
    return button
end

local function __makeUnitsButton(unitIDs, unitDefID, unitDef)
    local tooltip = unitDef.humanName .. "\n"
    tooltip = tooltip .. "Left mouse: Deselect all others\n"
    tooltip = tooltip .. "Middle mouse: Keep selected\n"
    tooltip = tooltip .. "Right mouse: Deselect\n"
    local button = __makeButton(unitDefID, container)
    button.unitIDs = unitIDs
    button.unitDefID = unitDefID
    button.unitDef = unitDef
    button.tooltip = tooltip
    button.OnMouseUp = {OnSelectedUnit, }
    button.label:SetCaption(#unitIDs)
    selection[unitDefID] = button
end

function GenerateSelection()
    local units = GetSelectedUnitsCount() > 0 and GetSelectedUnitsSorted() or {}
    units.n = nil
    local reselect = false
    -- Check that the units marked as keep selection are still selected
    for unitDefID, _ in pairs(keep_selected) do
        if selection[unitDefID] == nil then
            keep_selected[unitDefID] = nil
        else
            for _, unitID in ipairs(selection[unitDefID].unitIDs) do
                if ValidUnitID(unitID) and not GetUnitIsDead(unitID) and not IsUnitSelected(unitID) then
                    reselect = true
                    if units[unitDefID] == nil then
                        units[unitDefID] = {}
                    end
                    units[unitDefID][#units[unitDefID] + 1] = unitID
                end
            end
        end
    end
    if reselect then
        local toselect = {}
        for unitDefID, unitIDs in pairs(units) do
            for _, unitID in ipairs(unitIDs) do
                toselect[#toselect + 1] = unitID
            end
        end
        SelectUnitArray(toselect)
    end

    selection = {}
    container:ClearChildren()
    for unitDefID, unitIDs in pairs(units) do
        local unitDef = UnitDefs[unitDefID]
        __makeUnitsButton(unitIDs, unitDefID, unitDef)
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

    main_win = Chili.Window:New{
        parent = Chili.Screen0,
        x = tostring(math.floor(100 * WG.SELBAROPTS.x)) .. "%",
        y = tostring(math.floor(100 * WG.SELBAROPTS.y)) .. "%",
        width = tostring(math.floor(100 * WG.SELBAROPTS.width)) .. "%",
        height = tostring(math.floor(100 * WG.SELBAROPTS.height)) .. "%",
        draggable = true,
        resizable = true,
        padding = {0, 0, 0, 0},
        minWidth = 96,
        minHeight = 96,
        caption = "Selection"
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

    widgetHandler:AddAction("resetselbar", ResetSelBar)

    main_win.OnMove = {__OnMainWinSize,}
    main_win.OnResize = {__OnMainWinSize,}
    ResizeContainer()
    -- Save the new dimensions when the widget is locked
    main_win.OnLockWindow = {__OnLockWindow,}
end

function widget:ViewResize(viewSizeX, viewSizeY)
    if main_win == nil then
        return
    end
    x = WG.SELBAROPTS.x * viewSizeX
    y = WG.SELBAROPTS.y * viewSizeY
    w = WG.SELBAROPTS.width * viewSizeX
    h = WG.SELBAROPTS.height * viewSizeY
    if w < main_win.minWidth then
        w = main_win.minWidth
    end
    if h < main_win.minHeight then
        h = main_win.minHeight
    end
    main_win:SetPosRelative(x, y, w, h, true, false)
    ResizeContainer()
end

function widget:Update()
    GenerateSelection()
end

function widget:DrawScreen()
    for unitDefID, button in pairs(selection) do
        if keep_selected[unitDefID] then
            button.lock_label:Show()
        else
            button.lock_label:Hide()
        end
    end
end

function widget:Shutdown()
    if main_win ~= nil then
        Chili.RemoveCustomizableWindow(main_win)
        main_win:Dispose()
    end
    container = nil
    widgetHandler:RemoveAction("resetselbar")
end 

function widget:GetConfigData()
    return {
        x      = WG.SELBAROPTS.x,
        y      = WG.SELBAROPTS.y,
        width  = WG.SELBAROPTS.width,
        height = WG.SELBAROPTS.height,
    }
end

function widget:SetConfigData(data)
    WG.SELBAROPTS.x      = data.x or WG.SELBAROPTS.x
    WG.SELBAROPTS.y      = data.y or WG.SELBAROPTS.y
    WG.SELBAROPTS.width  = data.width or WG.SELBAROPTS.width
    WG.SELBAROPTS.height = data.height or WG.SELBAROPTS.height
end
