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
local customizable_state = true


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

local function __SetCustomizableWindowsState(window)
    if window == nil then
        for _, w in ipairs(customizable_windows) do
            __SetCustomizableWindowsState(w)
        end
        return
    end

    window.resizable = customizable_state
    window.draggable = customizable_state
end

function AddCustomizableWindow(window)
    customizable_windows[#customizable_windows + 1] = window
    __SetCustomizableWindowsState(window)
end

function RemoveCustomizableWindow(window)
    for i=#customizable_windows,1,-1 do
        if customizable_windows[i] == window then
            table.remove(customizable_windows, i)
        end
    end
end

function LockCustomizableWindows()
    customizable_state = false
    __SetCustomizableWindowsState()
end

function UnlockCustomizableWindows()
    customizable_state = true
    __SetCustomizableWindowsState()
end

function SetOpacity(control, opacity)
    local backup = false
    if control.opacity_backup == nil then
        backup = true
        control.opacity_backup = {}
    end

    if control.font ~= nil then
        if control.font.color ~= nil then
            local c = control.font.color
            if backup then
                control.opacity_backup["fontColor"] = (c[4] == nil) and 1 or c[4]
            end
            control.font:SetColor(c[1], c[2], c[3],
                                  control.opacity_backup["fontColor"] * opacity)
            control:Invalidate()
        end
        if control.font.outlineColor ~= nil then
            local c = control.font.outlineColor
            if backup then
                control.opacity_backup["fontOutlineColor"] = (c[4] == nil) and 1 or c[4]
            end
            control.font:SetOutlineColor(c[1], c[2], c[3],
                                         control.opacity_backup["fontOutlineColor"] * opacity)
            control:Invalidate()
        end
    end

    local colors = {"focusColor", "borderColor", "backgroundColor",
                    "captionColor", "cursorColor", "colorBK",
                    "colorBK_selected", "colorFG", "colorFG_selected",
                    "KnobColorSelected", "treeColor"}
    for _, color in ipairs(colors) do
        if control[color] ~= nil then
            local c = control[color]
            if backup then
                control.opacity_backup[color] = (c[4] == nil) and 1 or c[4]
            end
            control[color][4] = control.opacity_backup[color] * opacity
            control:Invalidate()
        end
    end

    for _, c in ipairs(control.children) do
        SetOpacity(c, opacity)
    end
end

function widget:Initialize()
    if (not WG.Chili) then
        widgetHandler:RemoveWidget()
        return
    end

    WG.Chili.OptimumFontSize = OptimumFontSize
    WG.Chili.ToSI = ToSI
    WG.Chili.AddCustomizableWindow = AddCustomizableWindow
    WG.Chili.RemoveCustomizableWindow = RemoveCustomizableWindow
    WG.Chili.LockCustomizableWindows = LockCustomizableWindows
    WG.Chili.UnlockCustomizableWindows = UnlockCustomizableWindows
    WG.Chili.SetOpacity = SetOpacity
end

function widget:Shutdown()
end
