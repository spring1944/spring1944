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

    -- Show/hide the drag and resize controls
    window.resizable = customizable_state
    window.draggable = customizable_state
    -- Call the event
    local callbacks = window.OnLockWindow
    if customizable_state then
        callbacks = window.OnUnlockWindow
    end
    if callbacks ~= nil then
        for _, c in ipairs(callbacks) do
            c(window)
        end
    end
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

local function __str_common(str1, str2, plain)
    local str = str1
    while str2:find(str, 1, plain) == nil do
        str = str:sub(1, #str - 1)
    end
    return str
end

local function Autocomplete(text, alternatives)
    -- Get the last word, i.e. the one to look for autocompletes. The last word
    -- can be eventually followed by spaces or tabulators, that we must take
    -- into account
    local last_word = text:reverse():gmatch("%S+")():reverse()
    local _, rindex = text:reverse():find(last_word:reverse(), 1, true)
    last_word = text:sub(#text - rindex  + 1)
    -- Look for all the alternatives with the asked prefix
    local candidates = {}
    for _, alternative in ipairs(alternatives) do
        if alternative:sub(1, #last_word) == last_word then
            candidates[#candidates + 1] = alternative
        end
    end
    if #candidates == 0 then
        return nil
    end
    -- Remove the last word from the message
    text = text:sub(1, #text - rindex)
    -- Add as many characters as possible
    if #candidates == 1 then
        -- Perfect!
        text = text .. candidates[1]
    else
        last_word = candidates[1]
        for _, candidate in ipairs(candidates) do
            last_word = __str_common(last_word, candidate, true)
        end
        text = text .. last_word
    end
    return text
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
    WG.Chili.Autocomplete = Autocomplete
end

function widget:Shutdown()
end
