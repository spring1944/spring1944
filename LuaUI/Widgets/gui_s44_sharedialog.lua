--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

function widget:GetInfo()
    return {
        name         = "1944 Share dialog",
        desc         = "Share dialog for Spring 1944",
        author       = "Jose Luis Cercos-Pita",
        date         = "2020-08-28",
        license      = "GNU GPL, v2 or later",
        layer        = 50,
        experimental = false,
        enabled      = true,
    }
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

local SELECTED_BACKGROUND = {1, 1, 1, 0.7}
local UNSELECTED_BACKGROUND = {1, 1, 1, 0.1}
local IMAGE_DIRNAME = LUAUI_DIRNAME .. "Images/ComWin/"
local GLYPHS = {
    tick = '\204\136',
    metal = '\204\134',
    energy = '\204\137',
}

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

local Chili
local main_win, main_players, main_metal, main_energy, main_shareunits
local main_sendto, main_msg, main_send, main_cancel
local myPlayerName, myTeamID, myAllyTeamId
local selected_player = nil
local teamColors = {}
local buttons_players = {}
local isAI = {}
local mCurr, eCurr = 0, 0

------------------------------------------------
--speedups
------------------------------------------------
local min, max = math.min, math.max
local floor, ceil = math.floor, math.ceil
local GetTeamResources = Spring.GetTeamResources
local GetPlayerRoster  = Spring.GetPlayerRoster

--------------------------------------------------------------------------------
-- 
--------------------------------------------------------------------------------
local function OnSelectPlayer(self)
    if selected_player ~= nil then
        selected_player:SetCaption(selected_player.playername)
        selected_player.backgroundColor = UNSELECTED_BACKGROUND
    end
    selected_player = self
    self:SetCaption(GLYPHS["tick"] .. " " .. self.playername)
    self.backgroundColor = SELECTED_BACKGROUND
end

local function __playerButton(name, color, parent)
    local glyph = ""
    if (selected_player ~= nil) and (selected_player.playername == name) then
        glyph = GLYPHS["tick"] .. " "
    end

    local button = Chili.Button:New {
        x = 0,
        y = 0,
        right = 0,
        height = 34,
        caption = glyph .. name,
        OnClick = { OnSelectPlayer, },
        parent = parent ~= nil and parent or main_players,
        playername = name,
        font = {
            outlineWidth  = 3,
            outlineWeight = 10,
            outline       = true,
            color         = color,
        },
        padding = { 2,2,2,2 },
        backgroundColor = UNSELECTED_BACKGROUND,
        children = children,
    }

    if not isAI[name] then
        Chili.Progressbar:New{
            right = 30,
            y = 2,
            width = 20,
            bottom = 2,
            backgroundColor = {0, 0, 0, 0},
            orientation = "vertical",
            caption = "",
            value = 0,
            TileImageFG = IMAGE_DIRNAME .. "s44_cpu_progressbar_full.png",
            TileImageBK = IMAGE_DIRNAME .. "s44_cpu_progressbar_empty.png",
            parent = button,
        }
        Chili.Progressbar:New{
            right = 10,
            y = 2,
            width = 20,
            bottom = 2,
            backgroundColor = {0, 0, 0, 0},
            orientation = "vertical",
            caption = "",
            value = 0,
            TileImageFG = IMAGE_DIRNAME .. "s44_cpu_progressbar_full.png",
            TileImageBK = IMAGE_DIRNAME .. "s44_cpu_progressbar_empty.png",
            parent = button,
        }
    end

    return button
end

local function OnResSlider(self, value, old_value)
    local pbar = self.parent
    pbar:SetValue(value)
end

local function __OnResBarSize(self, w, h)
    local icon = self.icon
    local pbar = self.pbar
    local slider = self.slider
    h = floor(0.9 * min(self.height, 0.15 * self.width))
    icon:Resize(h, h, true, true)
    icon.font.size = Chili.OptimumFontSize(self.font,
                                           icon.caption,
                                           h,
                                           h) - 2
    pbar:SetPos(h + 5, 0.1 * h, self.width - h - 20, 0.7 * h, true, true)
    pbar.font.size = Chili.OptimumFontSize(self.font,
                                           "XXXXX/XXXXX",
                                           0.9 * (self.width - h - 20),
                                           0.5 * h) - 1
end

local function __ResBar(parent, y, h, color, res_name)
    -- Create an invisible window container
    local container = Chili.Window:New{
        parent = parent,
        x = 0,
        y = y,
        width = "100%",
        height = h,
        padding = {0, 0, 0, 0},
        resizable = false,
        draggable = false,
        TileImage = ":cl:empty.png",
    }
    -- Create the icon at the left
    h = floor(0.9 * container.height)
    local icon = Chili.Label:New{
        parent = container,
        x = "0%",
        y = "0%",
        width = h,
        height = h,
        align = "left",
        valign = "top",
        caption = GLYPHS[res_name],
        font = {size = Chili.OptimumFontSize(container.font,
                                             GLYPHS[res_name],
                                             h,
                                             h) - 2,
                color = color},
    }
    container.icon = icon

    -- And the resource bar at the right
    local w = container.width - h - 20
    local bgcolor = {color[1] * 0.5,
                     color[2] * 0.5,
                     color[3] * 0.5,
                     color[4]}
    local pbar = Chili.Progressbar:New{
        parent = container,
        x = h + 5,
        y = floor(0.1 * h),
        width = w,
        height = floor(0.7 * h),
        color = color,
        backgroundColor = bgcolor,
        caption = "0/0",
        value = 0,
        font = {size = Chili.OptimumFontSize(container.font,
                                             "XXXXX/XXXXX",
                                             0.9 * w,
                                             0.5 * h) - 1,
                color = {1.0,1.0,1.0,1.0},
                outlineColor = {0.0,0.0,0.0,1.0},
                outline = true,
                shadow  = false,},
    }
    container.pbar = pbar

    -- We need a slider overlapped with the progress bar, which is actually
    -- invisible
    local slider = Chili.Trackbar:New{
        parent = pbar,
        x = "0%",
        y = "0%",
        width = "100%",
        height = "150%",
        TileImage = ":cl:empty.png",
        StepImage  = ":cl:empty.png",
        ThumbImage = ":cl:empty.png",
        value = 0,
        OnChange = {}
    }
    slider.res_name = res_name
    slider.OnChange = {OnResSlider,}
    container.slider = slider

    container.OnResize = {__OnResBarSize,}
    __OnResBarSize(container, container.width, container.height)
    return container
end


local function setupPlayers(playerID)
    local stack
    if playerID then
        local name, active, spec, teamId, allyTeamId = Spring.GetPlayerInfo(playerID)
        if buttons_players[name] ~= nil then
            if selected_player == buttons_players[name] then
                selected_player = nil
            end
            buttons_players[name]:Dispose()
        end
        if not spec and Spring.ArePlayersAllied(Spring.GetMyPlayerID(), playerID) then
            teamColors[name] = {Spring.GetTeamColor(teamId)}
            local button = __playerButton(name, teamColors[name])
            button.teamId = teamId
            buttons_players[name] = button
            main_players:AddChild(button)
        else
            
        end
    else
        main_players:ClearChildren()
        selected_player = nil
        buttons_players = {}
        isAI = {}
        local teams = Spring.GetTeamList(myAllyTeamId)
        for _, teamId in ipairs(teams) do
            local _, _, _, ai = Spring.GetTeamInfo(teamId)
            if ai then
                local _, name = Spring.GetAIInfo(teamId)
                isAI[name] = true
                teamColors[name] = {Spring.GetTeamColor(teamId)}
                local button = __playerButton(name, teamColors[name])
                button.teamId = teamId
                buttons_players[name] = button
            else
                local players = Spring.GetPlayerList(teamId, true)
                for _, id in ipairs(players) do
                    local name, active, spec = Spring.GetPlayerInfo(id)
                    if not spec then
                        teamColors[name] = {Spring.GetTeamColor(teamId)}
                        local button = __playerButton(name, teamColors[name])
                        button.teamId = teamId
                        buttons_players[name] = button
                    end
                end
            end
        end
    end

    main_players:SetPosRelative(nil, nil, nil, #main_players.children * 34 + 10, true, false)
end

local function GetColourScale(value)
    local colour = {0, 1, 0, 1}
    colour[1] = math.min(50, value) / 50
    colour[2] = 1 - (math.max(0, value - 50) / 50)
    return colour
end

function ShowWin()
    main_win:Show()
    if selected_player == nil and #main_players.children > 0 then
        OnSelectPlayer(main_players.children[1])
    end
end

function HideWin()
    main_win:Hide()
end

function OnApply()
    if selected_player == nil then
        return
    end
    local mshare = mCurr * main_metal.pbar.value / 100
    Spring.ShareResources(selected_player.teamId, "metal", mshare)
    local eshare = eCurr * main_energy.pbar.value / 100
    Spring.ShareResources(selected_player.teamId, "energy", eshare)
    if main_shareunits.checked then
        Spring.ShareResources(selected_player.teamId, "units")
    end
end

function __AddButton(parent, caption, action, y)
    y = y or "0%"
    local fontsize = Chili.OptimumFontSize(parent.font,
                                           "Close",
                                           0.8 * ((parent.width - 10) - 10),
                                           0.6 * (0.05 * (parent.height - 10) - 10))
    return Chili.Button:New{
        parent = parent,
        x = "0%",
        y = y,
        width = "100%",
        height = "5%",
        padding = {0, 0, 0, 0},
        caption = caption,
        font = {size = fontsize},
        OnClick = {action}
    }
end

function OnShareDialog()
    if main_win.visible then
        HideWin()
    else
        ShowWin()
    end
end

--------------------------------------------------------------------------------
-- Callins
--------------------------------------------------------------------------------

function widget:Initialize()
    if (not WG.Chili) then
        widgetHandler:RemoveWidget()
        return
    end

    Chili = WG.Chili
    local viewSizeX, viewSizeY = Spring.GetViewGeometry()
    myPlayerName, _, _, myTeamID, myAllyTeamId = Spring.GetPlayerInfo(Spring.GetMyPlayerID())

    main_win = Chili.Window:New{
        parent = Chili.Screen0,
        x = "30%",
        y = "20%",
        width = "40%",
        height = "60%",
        draggable = false,
        resizable = false,
    }

    -- Players list
    local main_players_scroll = Chili.ScrollPanel:New{
        padding = {1, 1, 1, 1},
        x = "0%",
        y = "0%",
        width = '100%',
        height = '66%',
        verticalSmartScroll = true,
        ignoreMouseWheel = false,
        verticalScrollbar = true,
        horizontalScrollbar = false,
        parent = main_win,
    }

    main_players = Chili.StackPanel:New{
        margin = { 0, 0, 0, 0 },
        padding = { 0, 0, 0, 0 },
        x = 0,
        y = 0,
        width = "100%",
        height = "100%",
        resizeItems = false,
        itemPadding  = { 1, 1, 1, 1 },
        itemMargin  = {0, 0, 0, 0},
        autosize = true,
        preserveChildrenOrder = true,
        parent = main_players_scroll,
    }

    -- Resources sharing
    main_metal = __ResBar(main_win, "66%", "8%", {0.7, 0.7, 0.7, 1}, "metal")
    main_energy = __ResBar(main_win, "74%", "8%", {0.9, 0.9, 0.1, 1}, "energy")

    -- Units sharing
    main_shareunits = Chili.Checkbox:New{
        x = 0,
        y = "82%",
        width = "100%",
        height = "8%",
        caption = "Share selected units",
        checked = false,
        boxalign = "left",
        boxsize = 20,
        parent = main_win,
    }

    -- Buttons
    __AddButton(main_win, "Share", OnApply, "90%")
    __AddButton(main_win, "Close", HideWin, "95%")

    setupPlayers()
    main_win:Hide()
    Spring.SendCommands("unbind any+h sharedialog")
    widgetHandler:AddAction("s44sharedialog", OnShareDialog)
    Spring.SendCommands("bind any+h s44sharedialog")
end

function widget:GameStart()
    setupPlayers()
end

function widget:PlayerChanged(playerID)
    setupPlayers(playerID)
end

function widget:GameFrame(n)
    if main_win == nil or not main_win.visible then
        return
    end

    mCurr, _ = GetTeamResources(myTeamID, "metal")
    eCurr, _ = GetTeamResources(myTeamID, "energy")

    local mfactor = main_metal.pbar.value / 100
    main_metal.pbar:SetCaption(Chili.ToSI(mCurr * mfactor) .. "/" .. Chili.ToSI(mCurr))
    local efactor = main_energy.pbar.value / 100
    main_energy.pbar:SetCaption(Chili.ToSI(eCurr * efactor) .. "/" .. Chili.ToSI(eCurr))
end

function widget:DrawScreen()
    if main_win == nil or not main_win.visible then
        return
    end

    playerlist = GetPlayerRoster(1)
    if playerlist == nil then
        return
    end

    for _, player_data in ipairs(playerlist) do
        local name = player_data[1]
        local button = buttons_players[name]
        if button ~= nil then
            local cpu = math.floor(player_data[6] * 100 + 0.5)
            local ping = math.floor(player_data[7] * 1000 + 0.5)
            -- Rescale ping
            ping = math.max(0, ping - 100)
            ping = math.min(1000, ping)
            ping = ping / 10
            -- Set the progress bars
            button.children[1]:SetValue(cpu)
            button.children[1]:SetColor(GetColourScale(cpu))
            button.children[2]:SetValue(ping)
            button.children[2]:SetColor(GetColourScale(ping))
        end
    end
end

function widget:Shutdown()
    if (main_win) then
        main_win:Dispose()
    end

    widgetHandler:RemoveAction("s44sharedialog")
    Spring.SendCommands({"unbind any+h s44sharedialog"})
    Spring.SendCommands({"bind any+h sharedialog"})
end
