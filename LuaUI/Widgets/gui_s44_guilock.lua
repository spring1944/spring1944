--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

function widget:GetInfo()
    return {
        name         = "1944 GUI Lock",
        desc         = "Locks the GUI, so users are not accidentally editing windows while playing",
        author       = "Jose Luis Cercos-Pita",
        date         = "2020-09-30",
        license      = "GNU GPL, v2 or later",
        layer        = 1001,
        experimental = false,
        enabled      = true,
    }
end

local WIDTH = 0.25 --Default widget width
local HEIGHT = 0.15 -- Default widget height
local main_win

local function Unlock()
    WG.Chili.UnlockCustomizableWindows()
    main_win:Show()
end

function widget:Initialize()
    if (not WG.Chili) then
        widgetHandler:RemoveWidget()
        return
    end

    main_win = WG.Chili.Window:New{
        parent = WG.Chili.Screen0,
        x = tostring(math.floor(100 * 0.5 * (1 - WIDTH))) .. "%",
        y = tostring(math.floor(100 * 0.5 * (1 - HEIGHT))) .. "%",
        width = tostring(math.floor(100 * WIDTH)) .. "%",
        height = tostring(math.floor(100 * HEIGHT)) .. "%",
        padding = {5, 5, 5, 5},
        resizable = false,
        draggable = false,
        minWidth = 256,
        minHeight = 32 * 4,
        children = {
            WG.Chili.Label:New{
                x = "0%",
                y = "6.25%",
                width = "100%",
                height = "12.5%",
                align = "center",
                caption = "Windows unlocked! Now you can:",
            },
            WG.Chili.Label:New{
                x = "0%",
                y = "25%",
                width = "100%",
                height = "12.5%",
                align = "left",
                caption = "* Resize the windows dragging the lower-bottom indocator",
            },
            WG.Chili.Label:New{
                x = "0%",
                y = "37.5%",
                width = "100%",
                height = "12.5%",
                align = "left",
                caption = "* Move the windows dragging the window itself",
            },
            WG.Chili.Button:New{
                x = "0%",
                y = "50%",
                width = "100%",
                height = "25%",
                padding = {0, 0, 0, 0},
                caption = "Reset to default",
                OnClick = {function()
                    Spring.SendCommands({"resetgui"})
                end}
            },
            WG.Chili.Button:New{
                x = "0%",
                y = "75%",
                width = "100%",
                height = "25%",
                padding = {0, 0, 0, 0},
                caption = "Save and close",
                OnClick = {function()
                    WG.Chili.LockCustomizableWindows()
                    main_win:Hide()
                end}
            }
        },
    }

    WG.Chili.LockCustomizableWindows()
    widgetHandler:AddAction("s44unlockwidgets", Unlock)
    main_win:Hide()
end

function widget:Shutdown()
    if (not WG.Chili) then
        return
    end
    widgetHandler:RemoveAction("s44unlockwidgets")
    WG.Chili.UnlockCustomizableWindows()
end
