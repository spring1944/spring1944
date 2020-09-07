local versionNumber = "v1.0"

function widget:GetInfo()
	return {
		name = "1944 Quit menu",
		desc = versionNumber .. " custom quit menu for Spring 1944",
		author = "Jose Luis Cercos-Pita",
		date = "26/06/2020",
		license = "GNU GPL v2 or later",
		layer = 1,
		enabled = true,
	}
end

------------------------------------------------
--constants
------------------------------------------------
local WIDTH = 0.25 --Default widget width
local HEIGHT = 0.15 -- Default widget height

------------------------------------------------
--locals
------------------------------------------------
local Chili, main_win

------------------------------------------------
--speedups
------------------------------------------------
local abs = math.abs
local min, max = math.min, math.max
local floor, ceil = math.floor, math.ceil

local strFormat = string.format

------------------------------------------------
--util
------------------------------------------------
local function __OptimumFontSize(font, txt, w, h)
    local wf = w / font:GetTextWidth(txt)
    local hf, _, _ = h / font:GetTextHeight(txt)
    return floor(min(wf, hf) * font.size)
end

function __AddButton(parent, caption, action, y)
    y = y or "0%"
    local fontsize = __OptimumFontSize(parent.font,
                                       "Continue playing",
                                       0.8 * ((parent.width - 10) - 10),
                                       0.6 * (0.33 * (parent.height - 10) - 10))
    return Chili.Button:New{
        parent = parent,
        x = "0%",
        y = y,
        width = "100%",
        height = "33%",
        padding = {0, 0, 0, 0},
        caption = caption,
        font = {size = fontsize},
        OnClick = {CloseMenu, action}
    }
end

function OnCancel(self)
    -- Nothing to do actually
end

function OnResign(self)
    Spring.SendCommands("spectator")
end

function OnQuit(self)
    if WG.LOBBY2GAME and WG.LOBBY2GAME.launched_by_lobby then
        Spring.Reload("")
    else
        Spring.Quit()
    end
end

function ShowMenu()
    if main_win then
        CloseMenu()
        return
    end

    local viewSizeX, viewSizeY = Spring.GetViewGeometry()

    main_win = Chili.Window:New{
        parent = Chili.Screen0,
        x = tostring(floor(100 * 0.5 * (1 - WIDTH))) .. "%",
        y = tostring(floor(100 * 0.5 * (1 - HEIGHT))) .. "%",
        width = tostring(floor(100 * WIDTH)) .. "%",
        height = tostring(floor(100 * HEIGHT)) .. "%",
        padding = {5, 5, 5, 5},
        resizable = false,
        draggable = false,
        minWidth = 128,
        minHeight = 32 * 3,
    }

    __AddButton(main_win, "Continue playing", OnCancel, "0%")
    __AddButton(main_win, "Resign", OnResign, "33%")
    __AddButton(main_win, "Quit", OnQuit, "66%")
end

function CloseMenu()
    if main_win then
        main_win:Dispose()
    end
    main_win = nil
end

------------------------------------------------
--callins
------------------------------------------------
function widget:Initialize()
    Chili = WG.Chili
    if Chili == nil then
        Spring.Log(widget:GetInfo().name, LOG.ERROR,
                   "Chili not available, disabling widget")
        WG.RemoveWidget(self)
        return
    end
  
    Spring.SendCommands("unbindaction quitmessage",
                        "unbindaction quitmenu")
    widgetHandler:AddAction("s44quitmenu", ShowMenu)
    Spring.SendCommands("bind any+esc s44quitmenu")
end

function widget:Shutdown()
    widgetHandler:RemoveAction("s44quitmenu")
    Spring.SendCommands("unbind any+esc s44quitmenu")
    Spring.SendCommands({
        "bind esc quitmessage",
        "bind shift+esc quitmenu",
    })
    CloseMenu()
end
