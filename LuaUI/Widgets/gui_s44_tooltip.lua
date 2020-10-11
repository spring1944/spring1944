--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--
--  file:    gui_tooltip.lua
--  brief:   recolors some of the tooltip info
--  author:  Dave Rodgers
--
--  Copyright (C) 2007.
--  Licensed under the terms of the GNU GPL, v2 or later.
--
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

function widget:GetInfo()
  return {
    name      = "1944 Tooltip",
    desc      = "Custom tooltip window for Spring 1944",
    author    = "Jose Luis Cercos Pita",
    date      = "2020-06-30",
    license   = "GNU GPL v2 or later",
    layer     = 1,
    enabled   = true,
    handler   = true,
  }
end

-- CONSTANTS
local magic = '\001'
local mainScaleLeft   = 0.0   -- Default widget position
local mainScaleTop    = 0.89  -- Default widget position
local mainScaleWidth  = 0.25  -- Default widget width
local mainScaleHeight = 0.10  -- Default widget height
WG.TOOLTIPWINOPTS = {
    x = mainScaleLeft,
    y = mainScaleTop,
    width = mainScaleWidth,
    height = mainScaleHeight,
}
local IMAGE_DIRNAME = LUAUI_DIRNAME .. "Images/ComWin/"

-- MEMBERS
local Chili
local main_win, txt_box

-- CONTROLS
local floor, ceil = math.floor, math.ceil
local spGetCurrentTooltip     = Spring.GetCurrentTooltip
local spGetSelectedUnitsCount = Spring.GetSelectedUnitsCount
local spSendCommands          = Spring.SendCommands


function ResetTooltipWin(cmd, optLine)
    -- Reset default values
    WG.TOOLTIPWINOPTS.x = mainScaleLeft
    WG.TOOLTIPWINOPTS.y = mainScaleTop
    WG.TOOLTIPWINOPTS.width = mainScaleWidth
    WG.TOOLTIPWINOPTS.height = mainScaleHeight
    local viewSizeX, viewSizeY = Spring.GetViewGeometry()
    x = WG.TOOLTIPWINOPTS.x * viewSizeX
    y = WG.TOOLTIPWINOPTS.y * viewSizeY
    w = WG.TOOLTIPWINOPTS.width * viewSizeX
    h = WG.TOOLTIPWINOPTS.height * viewSizeY
    main_win:SetPosRelative(x, y, w, h, true, false)
end

local function __OnLockWindow(self)
    local viewSizeX, viewSizeY = Spring.GetViewGeometry()
    WG.TOOLTIPWINOPTS.x = self.x / viewSizeX
    WG.TOOLTIPWINOPTS.y = self.y / viewSizeY
    WG.TOOLTIPWINOPTS.width = self.width / viewSizeX
    WG.TOOLTIPWINOPTS.height = self.height / viewSizeY
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
    spSendCommands({"tooltip 0"})

    main_win = Chili.Window:New{
        parent = Chili.Screen0,
        x = tostring(floor(100 * WG.TOOLTIPWINOPTS.x)) .. "%",
        y = tostring(floor(100 * WG.TOOLTIPWINOPTS.y)) .. "%",
        width = tostring(floor(100 * WG.TOOLTIPWINOPTS.width)) .. "%",
        height = tostring(floor(100 * WG.TOOLTIPWINOPTS.height)) .. "%",
        draggable = true,
        resizable = true,
        padding = {0, 0, 0, 0},
        minWidth = 50,
        minHeight = 24,
    }
    Chili.AddCustomizableWindow(main_win)

    local container = Chili.Window:New{
        parent = main_win,
        x = "0%",
        y = "0%",
        width = "100%",
        height = "100%",
        draggable = false,
        resizable = false,
        BorderTileImage = IMAGE_DIRNAME .. "empty.png",
        BackgroundTileImage = IMAGE_DIRNAME .. "empty.png",
    }

    txt_box = Chili.TextBox:New{
        parent = container,
        x = "0%",
        y = 2,
        width = "100%",
        height = "100%",
        text = ""
    }

    widgetHandler.actionHandler:AddAction(widget, "resettooltipwin", ResetTooltipWin)

    -- Save the new dimensions when the widget is locked
    main_win.OnLockWindow = {__OnLockWindow,}
end

function widget:WorldTooltip(ttType, data1, data2, data3)
  if (ttType == 'feature') then
    local fColor = "\255\255\128\255" 
    local fd = FeatureDefs[Spring.GetFeatureDefID(data1)]
    local description = fd.tooltip
    if description then return fColor .. description end
    return fColor .. fd.name
  end
end

function widget:ViewResize(viewSizeX, viewSizeY)
    if main_win == nil then
        return
    end
    x = WG.TOOLTIPWINOPTS.x * viewSizeX
    y = WG.TOOLTIPWINOPTS.y * viewSizeY
    w = WG.TOOLTIPWINOPTS.width * viewSizeX
    h = WG.TOOLTIPWINOPTS.height * viewSizeY
    main_win:SetPosRelative(x, y, w, h, true, false)
end

function widget:DrawScreen()
    local tooltip = Chili.Screen0.currentTooltip or spGetCurrentTooltip()

    local white = "\255\255\255\255"
    local bland = "\255\211\219\255"
    local mSub, eSub
    local tooltip = Chili.Screen0.currentTooltip or spGetCurrentTooltip()

    if (tooltip:sub(1, #magic) == magic) then
        tooltip = 'WORLD TOOLTIP:  ' .. tooltip
    end

    tooltip, mSub = tooltip:gsub(bland .. "Me",   "\255\1\255\255Me")
    tooltip, eSub = tooltip:gsub(bland .. "En", "  \255\255\255\1En")
    --S44 specific substitutions
    tooltip = tooltip:gsub("Energy cost 0 ", "")
    tooltip = tooltip:gsub("Metal", "Command")
    tooltip = tooltip:gsub("Energy", "Logistics")
    --end of S44 specific substitutions
    tooltip = tooltip:gsub("Hotkeys:", "\255\255\128\128Hotkeys:\255\128\192\255")
    tooptip = tooltip:gsub("a", "b")
    local unitTip = ((mSub + eSub) == 2)

    local i = 0
    for line in tooltip:gmatch("([^\n]*)\n?") do
        if (unitTip and (i == 0)) then
            line = "\255\255\128\255" .. line
        else
            line = "\255\255\255\255" .. line
        end
        i = i + 1
    end

    txt_box:SetText(tooltip)
end

function widget:Shutdown()
    if main_win ~= nil then
        Chili.RemoveCustomizableWindow(main_win)
        main_win:Dispose()
    end
    spSendCommands({"tooltip 1"})
    widgetHandler.actionHandler:RemoveAction("resettooltipwin")
end

function widget:GetConfigData()
    return {
        x      = WG.TOOLTIPWINOPTS.x,
        y      = WG.TOOLTIPWINOPTS.y,
        width  = WG.TOOLTIPWINOPTS.width,
        height = WG.TOOLTIPWINOPTS.height,
    }
end

function widget:SetConfigData(data)
    WG.TOOLTIPWINOPTS.x      = data.x or WG.TOOLTIPWINOPTS.x
    WG.TOOLTIPWINOPTS.y      = data.y or WG.TOOLTIPWINOPTS.y
    WG.TOOLTIPWINOPTS.width  = data.width or WG.TOOLTIPWINOPTS.width
    WG.TOOLTIPWINOPTS.height = data.height or WG.TOOLTIPWINOPTS.height
end
