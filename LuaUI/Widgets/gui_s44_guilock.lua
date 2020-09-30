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

function widget:Initialize()
    if (not WG.Chili) then
        widgetHandler:RemoveWidget()
        return
    end

    WG.Chili.LockCustomizableWindows()
end

function widget:Shutdown()
    WG.Chili.UnlockCustomizableWindows()
end
