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
    name      = "1944 Tooltip Replacement",
    desc      = "A colorful tooltip modification",
    author    = "trepan",
    date      = "Jan 8, 2007",
    license   = "GNU GPL, v2 or later",
    layer     = -4,    --  must be initialized after widgets it replaces!
    enabled   = true,  --  loaded by default?
    handler   = true,
  }
end


-- modified by quantum to use the mod fonthandler and supress the default
-- tooltip widget

-- modified by Tobi for Spring: 1944 to:
--  * not use the mod fonthandler by default
--  * not enable the "Tooltip" widget in widget:Initialize()
--  * replace not only "Tooltip", but also "Tooltip Replacement" widget
--  * "Energy cost 0 " is removed (nothing costs logistics after all)
--  * "Metal" is replaced by "Command"
--  * "Energy" is replaced by "Logistics"

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

-- Automatically generated local definitions

local glColor                 = gl.Color
local glText                  = gl.Text
local spGetCurrentTooltip     = Spring.GetCurrentTooltip
local spGetSelectedUnitsCount = Spring.GetSelectedUnitsCount
local spSendCommands          = Spring.SendCommands
local glTexture               = gl.Texture


--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

include("colors.h.lua")

local fontSize = 12
local ySpace   = 4
local yStep    = fontSize + ySpace
local gap      = 4

local fh = false
local fontName  = LUAUI_DIRNAME.."Fonts/FreeSansBold_14"
if (fh) then
  fh = fontHandler.UseFont(fontName)
end
if (fh) then
  fontSize  = fontHandler.GetFontSize()
  yStep     = fontHandler.GetFontYStep() + 2
end

local currentTooltip = ''

local found

--------------------------------------------------------------------------------

local vsx, vsy = widgetHandler:GetViewSizes()

function widget:ViewResize(viewSizeX, viewSizeY)
  vsx = viewSizeX
  vsy = viewSizeY
end


local function Replace(widgetName)
  for i, widget in ipairs(widgetHandler.widgets) do
    if (widget:GetInfo().name == widgetName) then
      widgetHandler:RemoveWidget(widget)
      return
    end
  end
end

--------------------------------------------------------------------------------

function widget:Initialize()
  spSendCommands({"tooltip 0"})
  --if (Spring.GetGameSeconds() > 1) then
  --  spSendCommands{"luaui enablewidget Tooltip"}
  --end
end


function widget:Shutdown()
  spSendCommands({"tooltip 1"})
end


--------------------------------------------------------------------------------

local magic = '\001'

function widget:WorldTooltip(ttType, data1, data2, data3)
  if (ttType == 'feature') then
    local fColor = "\255\255\128\255" 
    local fd = FeatureDefs[Spring.GetFeatureDefID(data1)]
    local description = fd.tooltip
    if description then return fColor .. description end
    return fColor .. fd.name
  end
end


if (true) then
  --widget.WorldTooltip = nil
end


--------------------------------------------------------------------------------
local replaced

function widget:DrawScreen()
  if ((widgetHandler.knownWidgets.Tooltip or {}).active) then
    Replace"Tooltip"
    spSendCommands{"tooltip 0"}
    replaced = true
  end
  if ((widgetHandler.knownWidgets["Tooltip Replacement"] or {}).active) then
    Replace"Tooltip Replacement"
    spSendCommands{"tooltip 0"}
    replaced = true
  end
  --if (Spring.GetGameSeconds() < 0.1 and not replaced) then
  --  widgetHandler:RemoveWidget(widget)
  --end
  if (fh) then
    fh = fontHandler.UseFont(fontName)
    fontHandler.BindTexture()
    glColor(1, 1, 1)
  end
  local white = "\255\255\255\255"
  local bland = "\255\211\219\255"
  local mSub, eSub
  local tooltip = spGetCurrentTooltip()

  if (tooltip:sub(1, #magic) == magic) then
    tooltip = 'WORLD TOOLTIP:  ' .. tooltip
  end

  tooltip, mSub = tooltip:gsub(bland.."Me",   "\255\1\255\255Me")
  tooltip, eSub = tooltip:gsub(bland.."En", "  \255\255\255\1En")
  --S44 specific substitutions
  tooltip = tooltip:gsub("Energy cost 0 ", "")
  tooltip = tooltip:gsub("Metal", "Command")
  tooltip = tooltip:gsub("Energy", "Logistics")
  --end of S44 specific substitutions
  tooltip = tooltip:gsub("Hotkeys:", "\255\255\128\128Hotkeys:\255\128\192\255")
  tooptip = tooltip:gsub("a", "b")
  local unitTip = ((mSub + eSub) == 2)

  local disableCache = (fh and tooltip:find("^Pos"))
  if (disableCache) then
    fontHandler.DisableCache()
  end

  local i = 0
  for line in tooltip:gmatch("([^\n]*)\n?") do
    if (unitTip and (i == 0)) then
      line = "\255\255\128\255" .. line
    else
      line = "\255\255\255\255" .. line
    end

    if (fh) then
      fontHandler.DrawStatic(line, gap, gap + (4 - i) * yStep)
    else
      glText(line, gap, gap + (4 - i) * yStep, fontSize, "o")
    end

    i = i + 1
  end

  if (fh) then
    gl.Texture(false)
  end

  if (disableCache) then
    fontHandler.EnableCache()
  end
end


--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
