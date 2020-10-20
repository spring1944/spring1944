--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

function widget:GetInfo()
    return {
        name         = "1944 Graphic Settings",
        desc         = "Graphic settings dialog for Spring 1944",
        author       = "Jose Luis Cercos-Pita",
        date         = "2020-10-20",
        license      = "GNU GPL, v2 or later",
        layer        = 50,
        experimental = false,
        enabled      = true,
    }
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

local IMAGE_DIRNAME = LUAUI_DIRNAME .. "Images/ComWin/"
local GLYPHS = {
    tick = '\204\136',
    metal = '\204\134',
    energy = '\204\137',
}

local RESOLUTIONS = {'800x600 (4:3)','1024x768 (4:3)','1152x864 (4:3)',
                     '1280x960 (4:3)','1280x1024 (4:3)', '1600x1200 (4:3)',
                     '1280x800 (16:9)', '1440x900 (16:9)', '1680x1050 (16:9)',
                     '1920x1080 (16:9)', '2048x768 (dual)', '2560x1024 (dual)',
                     '3200x1200 (dual)'}
local QUALITY_KEYS = {'very low', 'low', 'medium', 'high', 'very high'}  -- To ensure the order
local QUALITIES = {['very low']  = {["DepthBufferBits"]=16,
                                    ["ReflectiveWater"]=0,
                                    ["Shadows"]=0,
                                    ["3DTrees"]=0,
                                    ["AdvSky"]=0,
                                    ["DynamicSky"]=0,
                                    ["SmoothPoints"]=0,
                                    ["SmoothLines"]=0,
                                    ["FSAA"]=0,
                                    ["FSAALevel"]=0,
                                    ["AdvUnitShading"]=0,
                                    ["AllowDeferredMapRendering"]=0},
                   ['low']       = {["DepthBufferBits"]=16,
                                    ["ReflectiveWater"]=0,
                                    ["Shadows"]=0,
                                    ["3DTrees"]=1,
                                    ["AdvSky"]=0,
                                    ["DynamicSky"]=0,
                                    ["SmoothPoints"]=0,
                                    ["SmoothLines"]=0,
                                    ["FSAA"]=0,
                                    ["FSAALevel"]=0,
                                    ["AdvUnitShading"]=0,
                                    ["AllowDeferredMapRendering"]=0},
                   ['medium']    = {["DepthBufferBits"]=16,
                                    ["ReflectiveWater"]=1,
                                    ["Shadows"]=0,
                                    ["3DTrees"]=1,
                                    ["AdvSky"]=0,
                                    ["DynamicSky"]=0,
                                    ["SmoothPoints"]=0,
                                    ["SmoothLines"]=1,
                                    ["FSAA"]=0,
                                    ["FSAALevel"]=0,
                                    ["AdvUnitShading"]=0,
                                    ["AllowDeferredMapRendering"]=0},
                   ['high']      = {["DepthBufferBits"]=24,
                                    ["ReflectiveWater"]=2,
                                    ["Shadows"]=1,
                                    ["3DTrees"]=1,
                                    ["AdvSky"]=0,
                                    ["DynamicSky"]=0,
                                    ["SmoothPoints"]=0,
                                    ["SmoothLines"]=1,
                                    ["FSAA"]=0,
                                    ["FSAALevel"]=0,
                                    ["AdvUnitShading"]=1,
                                    ["AllowDeferredMapRendering"]=0},
                   ['very high'] = {["DepthBufferBits"]=24,
                                    ["ReflectiveWater"]=3,
                                    ["Shadows"]=1,
                                    ["3DTrees"]=1,
                                    ["AdvSky"]=1,
                                    ["DynamicSky"]=1,
                                    ["SmoothPoints"]=1,
                                    ["SmoothLines"]=1,
                                    ["FSAA"]=1,
                                    ["FSAALevel"]=1,
                                    ["AdvUnitShading"]=1,
                                    ["AllowDeferredMapRendering"]=1}}
local QUALITY_WIDGETS = {['very low'] =  {"disablewidget Screen-Space Ambient Occlusion",
                                          "disablewidget Post-processing"},
                         ['low'] =       {"disablewidget Screen-Space Ambient Occlusion",
                                          "disablewidget Post-processing"},
                         ['medium'] =    {"disablewidget Screen-Space Ambient Occlusion",
                                          "disablewidget Post-processing"},
                         ['high'] =      {"disablewidget Screen-Space Ambient Occlusion",
                                          "enablewidget Post-processing"},
                         ['very high'] = {"enablewidget Screen-Space Ambient Occlusion",
                                          "enablewidget Post-processing"}}
local DEF_QUALITY = 'unknown'

local DETAIL_KEYS = {'low', 'medium', 'high'}  -- To ensure the order
local DETAILS = {['low']    = {["ShadowMapSize"]=1024,
                               -- ["TreeRadius"]=600,  -- Overwritten at restart
                               ["GroundDetail"]=20,
                               ["UnitLodDist"]=100,
                               ["GrassDetail"]=0,
                               ["GroundDecals"]=0,
                               ["UnitIconDist"]=100,
                               ["MaxParticles"]=100,
                               ["MaxNanoParticles"]=100},
                 ['medium'] = {["ShadowMapSize"]=4096,
                               -- ["TreeRadius"]=1900,  -- Overwritten at restart
                               ["GroundDetail"]=70,
                               ["UnitLodDist"]=350,
                               ["GrassDetail"]=15,
                               ["GroundDecals"]=0,
                               ["UnitIconDist"]=550,
                               ["MaxParticles"]=4000,
                               ["MaxNanoParticles"]=6000},
                 ['high']   = {["ShadowMapSize"]=8192,
                               -- ["TreeRadius"]=3000,  -- Overwritten at restart
                               ["GroundDetail"]=120,
                               ["UnitLodDist"]=1000,
                               ["GrassDetail"]=30,
                               ["GroundDecals"]=1,
                               ["UnitIconDist"]=1000,
                               ["MaxParticles"]=20000,
                               ["MaxNanoParticles"]=20000}}
local DEF_DETAIL = 'unknown'

local GAMMA      = {start_val=0.5, end_val=1.0, steps=51}
local DGAMMA     = {start_val=0.0, end_val=1.0, steps=51}
local GRAIN      = {start_val=0.0, end_val=0.1, steps=51}
local SCRATCHES  = {start_val=0.0, end_val=1.0, steps=51}
local VIGNETTE   = {start_val=2.0, end_val=0.7, steps=51}
local ABERRATION = {start_val=0.0, end_val=0.5, steps=51}
local SEPIA      = {start_val=0.0, end_val=1.0, steps=51}

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

local Chili, Slider
local main_win, restart_label

------------------------------------------------
--speedups
------------------------------------------------
local min, max = math.min, math.max
local floor, ceil = math.floor, math.ceil

--------------------------------------------------------------------------------
-- 
--------------------------------------------------------------------------------
local function GetDefaultSettings(map)
    -- map shall be QUALITIES or DETAILS
    local stored_settings = {}
    for name, settings in pairs(map) do
        local is_this = true
        for k, v in pairs(settings) do
            stored_settings[k] = Spring.GetConfigInt(k)
            if stored_settings[k] ~= v then
                is_this = false
            end
        end
        if is_this then
            return name, settings
        end
    end
    return "custom", stored_settings
end

local function SetSettings(settings)
    for k, v in pairs(settings) do
        Spring.SetConfigInt(k, v)
    end    
end

local function QualityChange(self, itemIdx)
    local name = self.items[itemIdx]
    if name ~= DEF_QUALITY then
        restart_label.font:SetColor({0.8, 0, 0, 1})
    end
    SetSettings(QUALITIES[name])
    if QUALITY_WIDGETS[name] ~= nil then
        for _,cmd in ipairs(QUALITY_WIDGETS[name]) do
            Spring.SendCommands({"luaui " .. cmd})
        end
    end
end

local function DetailChange(self, itemIdx)
    local name = self.items[itemIdx]
    if name ~= DEF_DETAIL then
        restart_label.font:SetColor({0.8, 0, 0, 1})
    end
    SetSettings(DETAILS[name])
end

local function ResolutionStrToNum(str)
    local i
    i = string.find(str, "x")
    if i == nil then
        return 0, 0
    end
    local x = tonumber(string.sub(str, 1, i - 1))
    str = string.sub(str, i + 1)
    i = string.find(str, " ")
    if i == nil then
        i = string.len(str) + 1
    end
    local y = tonumber(string.sub(str, 1, i - 1))
    return x, y
end

local function ResolutionChange(self, itemIdx)
    local vsx, vsy
    if itemIdx > #RESOLUTIONS then
        vsx, vsy = gl.GetViewSizes()
    else
        vsx, vsy = ResolutionStrToNum(RESOLUTIONS[itemIdx])
    end

    Spring.SetConfigInt("Fullscreen", 1)
    Spring.SendCommands("Fullscreen 0")
    Spring.SetConfigInt("XResolution", vsx)
    Spring.SetConfigInt("YResolution", vsy)
    Spring.SendCommands("Fullscreen 1")
end

function ShowWin()
    main_win:Show()
    local viewSizeX, viewSizeY = Spring.GetViewGeometry()
    main_win:SetPos(nil, 0.5 * (viewSizeY - main_win.height))

    if WG.bindAnyEsc ~= nil then
        -- WG.bindAnyEsc is provided by "1944 Quit menu" widget
        WG.bindAnyEsc(false)
    end
    Spring.SendCommands("bind esc s44graphicsettings")
end

function HideWin()
    main_win:Hide()

    Spring.SendCommands("unbind esc s44graphicsettings")
    if WG.bindAnyEsc ~= nil then
        -- WG.bindAnyEsc is provided by "1944 Quit menu" widget
        WG.bindAnyEsc(true)
    end
end

function OnGraphicSettings()
    if main_win.visible then
        HideWin()
    else
        ShowWin()
    end
end

local function ComboBoxWithLabel(obj)
    local grid = Chili.Grid:New {
        parent = obj.parent,
        rows = 1,
        columns = 2,
        padding = {0, 0, 0, 0},
        itemMargin = {1, 1, 1, 1},
    }
    obj.parent = grid
    local label = Chili.Label:New {
        parent = obj.parent,
        caption = obj.caption,
        align = "center",
        valign = "center"
    }
    obj.caption = ""
    -- We don't want the combobox trigger an action while it is setup
    OnSelect = obj.OnSelect
    obj.OnSelect = nil
    local combobox = Chili.ComboBox:New(obj)
    combobox.OnSelect = OnSelect

    return grid, label, combobox
end

function SliderWithLabel(obj)
    if Slider == nil then
        Slider = WG.Chili.Trackbar:Inherit{
            start_val = 0.0,
            end_val   = 1.0,
            curr_val  = 0.5,
            steps     = 51,

            drawcontrolv2 = true,
        }

        function Slider:New(obj)
            obj.min   = 0
            obj.max   = 1
            obj.step  = 1 / (obj.steps - 1)
            obj.value = (obj.curr_val - obj.start_val) / (obj.end_val - obj.start_val)

            obj = Slider.inherited.New(self, obj)

            return obj
        end 

        function Slider:SetValue(v)
            -- Hang the execution of the event while we translate the value to the new
            -- scale
            OnChange = self.OnChange
            -- self.OnChange = {}
            local oldvalue = self.value
            Slider.inherited.SetValue(self, v)
            -- self.OnChange = OnChange

            -- Translate the values to the new scale
            oldvalue = self.start_val + oldvalue * (self.end_val - self.start_val)
            newvalue = self.start_val + self.value * (self.end_val - self.start_val)
            self:CallListeners(self.OnChange, newvalue, oldvalue)
        end
    end

    local grid = Chili.Grid:New {
        parent = obj.parent,
        rows = 1,
        columns = 2,
        padding = {0, 0, 0, 0},
        itemMargin = {1, 1, 1, 1},
    }
    obj.parent = grid
    local label = Chili.Label:New {
        parent = obj.parent,
        caption = obj.caption,
        align = "center",
        valign = "center"
    }
    obj.caption = ""

    -- We don't want the combobox trigger an action while it is setup
    local OnChange = obj.OnChange
    obj.OnChange = nil
    local slider = Slider:New(obj)
    slider.OnChange = OnChange

    return grid, label, slider
end

function CheckboxWithLabel(obj)
    local grid = Chili.Grid:New {
        parent = obj.parent,
        rows = 1,
        columns = 2,
        padding = {0, 0, 0, 0},
        itemMargin = {1, 1, 1, 1},
    }
    obj.parent = grid
    local label = Chili.Label:New {
        parent = obj.parent,
        caption = obj.caption,
        align = "center",
        valign = "center"
    }
    obj.caption = ""

    -- We don't want the combobox trigger an action while it is setup
    local OnChange = obj.OnChange
    obj.OnChange = nil
    local checkbox = Chili.Checkbox:New(obj)
    checkbox.OnChange = OnChange

    return grid, label, checkbox
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

    local h = 32 * 14 + 6 * 5 + 18
    main_win = Chili.Window:New{
        parent = Chili.Screen0,
        x = "30%",
        y = "20%",
        width = "40%",
        height = h,
        minWidth = 320,
        minHeight = h,
        draggable = false,
        resizable = false,
    }

    -- Quality controls --------------------------------------------------------
    local grid = Chili.Grid:New {
        parent = main_win,
        x = '0%',
        y = '0%',
        width = '100%',
        height = 32 * 3 + 2 * 5,
        rows = 4,
        columns = 1,
        itemMargin = {0, 0, 0, 0},
    }

    Chili.Label:New {
        parent = grid,
        caption = "Quality controls:",
    }

    local name, settings = GetDefaultSettings(QUALITIES)
    DEF_QUALITY = name
    local itemIdx
    for i,k in ipairs(QUALITY_KEYS) do
        if name == k then
            itemIdx = i
        end
    end
    if itemIdx == nil then
        itemIdx = #QUALITY_KEYS + 1
        QUALITY_KEYS[itemIdx] = name
        QUALITIES[name] = settings
    end
    local _, _, quality = ComboBoxWithLabel({
        parent = grid,
        caption = "Graphics Quality",
        backgroundColor = { 1, 1, 1, 1 },
        OnSelect = { QualityChange },
        items = QUALITY_KEYS,
        selected = itemIdx,
    })

    local name, settings = GetDefaultSettings(DETAILS)
    DEF_DETAIL = name
    local itemIdx
    for i,k in ipairs(DETAIL_KEYS) do
        if name == k then
            itemIdx = i
        end
    end
    if itemIdx == nil then
        itemIdx = #DETAIL_KEYS + 1
        DETAIL_KEYS[itemIdx] = name
        DETAILS[name] = settings
    end
    local _, _, detail = ComboBoxWithLabel({
        parent = grid,
        caption = "Graphics Detail",
        backgroundColor = { 1, 1, 1, 1 },
        OnSelect = { DetailChange },
        items = DETAIL_KEYS,
        selected = itemIdx,
    })

    local vsx, vsy = gl.GetViewSizes()
    local items = {}
    for i,v in ipairs(RESOLUTIONS) do
        items[i] = v
    end
    items[#items + 1] = tostring(vsx) .. 'x' .. tostring(vsy) .. ' (current)'
    local _, _, resolution = ComboBoxWithLabel({
        parent = grid,
        caption = "Resolution",
        backgroundColor = { 1, 1, 1, 1 },
        OnSelect = { ResolutionChange },
        items = items,
        selected = #items,
    })

    -- Post-processing ---------------------------------------------------------
    local grid = Chili.Grid:New {
        parent = main_win,
        x = '0%',
        y = 32 * 3 + 2 * 5,
        width = '100%',
        height = 32 * 9 + 2 * 5,
        rows = 9,
        columns = 1,
        itemMargin = {0, 0, 0, 0},
    }

    Chili.Label:New {
        parent = grid,
        caption = "Post-processing controls:",
    }

    SliderWithLabel({
        parent = grid,
        caption = "Gamma",
        backgroundColor = { 1, 1, 1, 1 },
        OnChange = { function(self, v)
            if v == nil then return end
            WG.POSTPROC.tonemapping.gamma = v
        end },
        start_val = GAMMA.start_val,
        end_val = GAMMA.end_val,
        steps = GAMMA.steps,
        curr_val = WG.POSTPROC.tonemapping.gamma,
    })
    SliderWithLabel({
        parent = grid,
        caption = "Gamma Fluctuation",
        backgroundColor = { 1, 1, 1, 1 },
        OnChange = { function(self, v)
            if v == nil then return end
            WG.POSTPROC.tonemapping.dGamma = v
        end },
        start_val = DGAMMA.start_val,
        end_val = DGAMMA.end_val,
        steps = DGAMMA.steps,
        curr_val = WG.POSTPROC.tonemapping.dGamma,
    })
    SliderWithLabel({
        parent = grid,
        caption = "Film grain",
        backgroundColor = { 1, 1, 1, 1 },
        OnChange = { function(self, v)
            if v == nil then return end
            WG.POSTPROC.filmgrain.grain = v
        end },
        start_val = GRAIN.start_val,
        end_val = GRAIN.end_val,
        steps = GRAIN.steps,
        curr_val = WG.POSTPROC.filmgrain.grain,
    })
    SliderWithLabel({
        parent = grid,
        caption = "Scratches",
        backgroundColor = { 1, 1, 1, 1 },
        OnChange = { function(self, v)
            if v == nil then return end
            WG.POSTPROC.scratches.threshold = v
        end },
        start_val = SCRATCHES.start_val,
        end_val = SCRATCHES.end_val,
        steps = SCRATCHES.steps,
        curr_val = WG.POSTPROC.scratches.threshold,
    })
    SliderWithLabel({
        parent = grid,
        caption = "Vignette",
        backgroundColor = { 1, 1, 1, 1 },
        OnChange = { function(self, v)
            if v == nil then return end
            WG.POSTPROC.vignette.vignette[2] = v
        end },
        start_val = VIGNETTE.start_val,
        end_val = VIGNETTE.end_val,
        steps = VIGNETTE.steps,
        curr_val = WG.POSTPROC.vignette.vignette[2],
    })
    SliderWithLabel({
        parent = grid,
        caption = "Color aberration",
        backgroundColor = { 1, 1, 1, 1 },
        OnChange = { function(self, v)
            if v == nil then return end
            WG.POSTPROC.aberration.aberration = v
        end },
        start_val = ABERRATION.start_val,
        end_val = ABERRATION.end_val,
        steps = ABERRATION.steps,
        curr_val = WG.POSTPROC.aberration.aberration,
    })
    CheckboxWithLabel({
        parent = grid,
        caption = "Gray/Sepia color",
        backgroundColor = { 1, 1, 1, 1 },
        OnChange = { function(self, v)
            if v == nil then return end
            WG.POSTPROC.grayscale.enabled = v
        end },
        checked = WG.POSTPROC.grayscale.enabled,
    })
    SliderWithLabel({
        parent = grid,
        caption = "Sepia Tone",
        backgroundColor = { 1, 1, 1, 1 },
        OnChange = { function(self, v)
            if v == nil then return end
            WG.POSTPROC.grayscale.sepia = v
        end },
        start_val = SEPIA.start_val,
        end_val = SEPIA.end_val,
        steps = SEPIA.steps,
        curr_val = WG.POSTPROC.grayscale.sepia,
    })

    -- Buttons -----------------------------------------------------------------
    local grid = Chili.Grid:New {
        parent = main_win,
        x = '0%',
        y = 32 * 12 + 4 * 5,
        width = '100%',
        height = 32 * 2 + 2 * 5,
        rows = 3,
        columns = 1,
        itemMargin = {0, 0, 0, 0},
    }
    restart_label = Chili.Label:New {
        parent = grid,
        caption = "Restart the game to apply the changes!",
        align = "center",
        font = {
            color = {0.8, 0, 0, 0}
        },
    }
    local close = Chili.Button:New {
        parent = grid,
        caption = "Close",
        OnClick = {HideWin},
    }

    main_win:Hide()
    widgetHandler:AddAction("s44graphicsettings", OnGraphicSettings)
end

function widget:Shutdown()
    if (main_win) then
        HideWin()
        main_win:Dispose()
    end

    widgetHandler:RemoveAction("s44graphicsettings")
end
