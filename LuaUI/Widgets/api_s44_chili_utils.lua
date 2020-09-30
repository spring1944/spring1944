--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

function widget:GetInfo()
    return {
        name      = "Some utils for S44 GUI",
        desc      = "Utils for S44 GUI, injected into WG.Chili object",
        author    = "Jose Luis Cercos-Pita",
        date      = "30-09-2020",
        license   = "GNU GPL v2 or later",
        version   = "1.0",
        layer     = -999,
        enabled   = true,
        handler   = true,
        api       = true,
        hidden    = true,
    }
end


local abs = math.abs
local min, max = math.min, math.max
local floor, ceil = math.floor, math.ceil
local strFormat = string.format
local customizable_windows = {}


function OptimumFontSize(font, txt, w, h)
    local wf = w / font:GetTextWidth(txt)
    local hf, _, _ = h / font:GetTextHeight(txt)
    return floor(min(wf, hf) * font.size)
end

function ToSI(num)
    if (num == 0) then
        return "0"
    else
        local absNum = abs(num)
        if (absNum < 0.1) then
            return "0" --too small to matter
        elseif (absNum < 1e3) then
            return strFormat("%.2f", num)
        elseif (absNum < 1e6) then
            return strFormat("%.2fk", 1e-3 * num)
        elseif (absNum < 1e9) then
            return strFormat("%.2fM", 1e-6 * num)
        else
            return strFormat("%.2fB", 1e-9 * num)
        end
    end
end

function AddCustomizableWindow(window)
    customizable_windows[#customizable_windows + 1] = window
end

local function __SetCustomizableWindowsState(state)
    for _, w in ipairs(customizable_windows) do
        w.resizable = state
        w.draggable = state
    end
end

function LockCustomizableWindows()
    __SetCustomizableWindowsState(false)
end

function UnlockCustomizableWindows()
    __SetCustomizableWindowsState(true)
end

function widget:Initialize()
    if (not WG.Chili) then
        widgetHandler:RemoveWidget()
        return
    end

    WG.Chili.OptimumFontSize = OptimumFontSize
    WG.Chili.ToSI = ToSI
    WG.Chili.AddCustomizableWindow = AddCustomizableWindow
    WG.Chili.LockCustomizableWindows = LockCustomizableWindows
    WG.Chili.UnlockCustomizableWindows = UnlockCustomizableWindows
end

function widget:Shutdown()
end
