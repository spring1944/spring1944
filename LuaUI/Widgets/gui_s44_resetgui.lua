--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

function widget:GetInfo()
    return {
        name         = "1944 Reset GUI",
        desc         = "Create a command to reset the GUI",
        author       = "Jose Luis Cercos-Pita",
        date         = "2020-09-29",
        license      = "GNU GPL, v2 or later",
        layer        = 1000,
        experimental = false,
        enabled      = true,
    }
end

local widgets = {
    "1944 Armor Display",
    "1944 Building bar",
    "1944 Commands window",
    "1944 Console",
    "1944 Field of Fire",
    "1944 Healthbars",
    "1944 Aircraft Selection Bar",
    "1944 Quit menu",
    "1944 Ranks",
    "1944 Resource Bars",
    "1944 Minimum Ranges",
    "1944 Selection bar",
    "1944 Share dialog",
    "1944 Supply Radius",
    "1944 Tooltip",
}


function RestartGUI()
    for _, widget in ipairs(widgets) do
        Spring.SendCommands{"luaui enablewidget " .. widget,}
    end
end

function ResetGUI()
    Spring.SendCommands({"resetresbar",
                         "resetbuildbar",
                         "resetplanesbar",
                         "resetselbar",
                         "resetcomwin",
                         "resettooltipwin"})
end

--------------------------------------------------------------------------------
-- Callins
--------------------------------------------------------------------------------

function widget:Initialize()
    if (not WG.Chili) then
        widgetHandler:RemoveWidget()
        return
    end

    widgetHandler:AddAction("resetgui", ResetGUI)
    widgetHandler:AddAction("restartgui", RestartGUI)
end

function widget:Shutdown()
    widgetHandler:RemoveAction("resetgui")
    widgetHandler:RemoveAction("restartgui")
end
