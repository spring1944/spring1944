local versionNumber = "v2.1"

function widget:GetInfo()
	return {
		name = "1944 Resource Bars",
		desc = versionNumber .. " Custom resource bars for Spring 1944",
		author = "Evil4Zerggin",
		date = "11 July 2009",
		license = "GNU LGPL, v2.1 or later",
		layer = 1,
		enabled = true,
	}
end

------------------------------------------------
--constants
------------------------------------------------
local mainScaleHeight = 0.045 --height as a proportion of screen height; sets the overall scale of things
local mainScaleWidth = 0.75 --width as a proportion of screen width
local IMAGE_DIRNAME = LUAUI_DIRNAME .. "Images/ResBar/"
local GLYPHS = {
    metal = '\204\134',
    energy = '\204\137',
}

------------------------------------------------
--locals
------------------------------------------------
local vsx, vsy

local mCurr, mStor, mPull, mInco, mExpe, mShar, mSent, mReci = 0, 0, 0, 0, 0, 0, 0, 0
local eCurr, eStor, ePull, eInco, eExpe, eShar, eSent, eReci = 0, 0, 0, 0, 0, 0, 0, 0

local resupplyPeriod = 450 * 30
local resupplyString = ""
local lastStor
local estimatedSupplySurplus = 1

local main_win

------------------------------------------------
--speedups
------------------------------------------------
local abs = math.abs
local min, max = math.min, math.max
local floor, ceil = math.floor, math.ceil

local strFormat = string.format

local GetTeamResources = Spring.GetTeamResources
local GetMyTeamID = Spring.GetMyTeamID
local SetShareLevel = Spring.SetShareLevel

------------------------------------------------
--util
------------------------------------------------

local function ToSI(num)
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

local function FramesToTimeString(n)
  local seconds = n / 30
  return strFormat(floor(seconds / 60) .. ":" .. strFormat("%02i", ceil(seconds % 60)))
end

local function OptimumFontSize(font, txt, w, h)
    local wf = w / font:GetTextWidth(txt)
    local hf, _, _ = h / font:GetTextHeight(txt)
    return floor(min(wf, hf) * font.size)
end

local function __OnResBarSize(self, w, h)
    local icon = self.icon
    local pbar = self.pbar
    local slider = self.slider
    h = floor(0.9 * min(self.height, 0.15 * self.width))
    icon:Resize(h, h, true, true)
    icon.font.size = OptimumFontSize(self.font, icon.caption, h, h) - 2
    pbar:SetPos(h + 5, 0.1 * h, self.width - h - 20, 0.7 * h, true, true)
    pbar.font.size = OptimumFontSize(self.font, "XXXXX/XXXXX (Resupply in 00:00)", 0.9 * (self.width - h - 20), 0.5 * h) - 1
end

local function __OnResSlider(self, value, old_value)
    SetShareLevel(self.res_name, value / 100)
end

local function __SetSliderValue(slider, v)
    local tmp = slider.OnChange
    slider.OnChange = {}
    slider:SetValue(v)
    slider.OnChange = tmp
end

local function ResBar(parent, x, color, res_name)
    -- Create an invisible window container
    local container = Chili.Window:New{
        parent = parent,
        x = x,
        y = "0%",
        width = "50%",
        height = "100%",
        minHeight = 25,
        padding = {0, 0, 0, 0},
        resizable = false,
        draggable = false,
        TileImage = ":cl:empty.png",
    }
    -- Create the icon at the left
    h = floor(0.9 * min(container.height, 0.15 * container.width))
    local icon = Chili.Label:New{
        parent = container,
        x = "0%",
        y = "0%",
        width = h,
        height = h,
        align = "left",
        valign = "top",
        caption = GLYPHS[res_name],
        font = {size = OptimumFontSize(container.font, GLYPHS[res_name], h, h) - 2,
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
        caption = "0/0 (0)",
        font = {size = OptimumFontSize(container.font, "XXXXX/XXXXX (Resupply in 00:00)", 0.9 * w, 0.5 * h) - 1,
                color = {1.0,1.0,1.0,1.0},
                outlineColor = {0.0,0.0,0.0,1.0},
                outline = true,
                shadow  = false,},
    }
    container.pbar = pbar

    -- We need a slider overlapped with the progress bar
    local slider = Chili.Trackbar:New{
        parent = pbar,
        x = "0%",
        y = "0%",
        width = "100%",
        height = "150%",
        TileImage = ":cl:empty.png",
        StepImage  = ":cl:empty.png",
        ThumbImage = IMAGE_DIRNAME .. "share_thumb.png",
        OnChange = {}
    }
    slider.res_name = res_name
    slider.OnChange = {__OnResSlider,}
    container.slider = slider

    container.OnResize = {__OnResBarSize,}
    __OnResBarSize(container, container.width, container.height)
    return container
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
  
    Spring.SendCommands("resbar 0")
    
    local viewSizeX, viewSizeY = Spring.GetViewGeometry()
    widget:ViewResize(viewSizeX, viewSizeY)
    widget:GameFrame(0)

    resupplyPeriod = Spring.GetGameRulesParam("resupplyPeriod") or 450 * 30

    -- Create the window
    main_win = Chili.Window:New{
        parent = Chili.Screen0,
        x = tostring(floor(100 * (1.0 - mainScaleWidth))) .. "%",
        y = "0%",
        width = tostring(floor(100 * mainScaleWidth)) .. "%",
        height = tostring(floor(100 * mainScaleHeight)) .. "%",
        minHeight = 25,
        padding = {0, 0, 0, 0},
    }

    local mresbar = ResBar(main_win, "0%", {0.7, 0.7, 0.7, 1}, "metal")
    local eresbar = ResBar(main_win, "50%", {0.9, 0.9, 0.1, 1}, "energy")

    main_win.mresbar = mresbar
    main_win.eresbar = eresbar
end

function widget:ViewResize(viewSizeX, viewSizeY)
    vsx = viewSizeX
    vsy = viewSizeY
end

function widget:GameFrame(n)
    local myTeamID = GetMyTeamID()
    mCurr, mStor, mPull, mInco, mExpe, mShar, mSent, mReci = GetTeamResources(myTeamID, "metal")
    eCurr, eStor, ePull, eInco, eExpe, eShar, eSent, eReci = GetTeamResources(myTeamID, "energy")
    
    if not lastStor then lastStor = eStor end
    
    local elapsedSupplyTime = n % resupplyPeriod
    local remainingSupplyTime = resupplyPeriod - n % resupplyPeriod
    
    if remainingSupplyTime == 0 or n <= 32 then
        estimatedSupplySurplus = 1
        lastStor = eStor
    else
        estimatedSupplySurplus = lastStor - (lastStor - eCurr) * resupplyPeriod / elapsedSupplyTime
        if estimatedSupplySurplus > eStor then
        estimatedSupplySurplus = eStor
        elseif estimatedSupplySurplus < 0 then
        estimatedSupplySurplus = 0
        end
    end
    
    resupplyString = FramesToTimeString(remainingSupplyTime)

    if main_win == nil then
        return
    end

    local mresbar = main_win.mresbar
    mresbar.pbar:SetValue(100 * mCurr / mStor)
    mresbar.pbar:SetCaption(ToSI(mCurr) .. "/" .. ToSI(mStor) .. " (" .. ToSI(mInco - mPull) .. ")" )
    __SetSliderValue(mresbar.slider, 100 * mShar)
    local eresbar = main_win.eresbar
    eresbar.pbar:SetValue(100 * eCurr / eStor)
    eresbar.pbar:SetCaption(ToSI(eCurr) .. "/" .. ToSI(eStor) .. " (Resupply in " .. resupplyString .. ")" )
    __SetSliderValue(eresbar.slider, 100 * eShar)
end
