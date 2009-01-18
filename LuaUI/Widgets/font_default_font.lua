function widget:GetInfo()
  return {
    name      = "Default Font",
    desc      = "Sets a default font.",
    author    = "Evil4Zerggin",
    date      = "17 January 2009",
    license   = "Public Domain",
    layer     = -16,
    enabled   = true  --  loaded by default?
  }
end

local font = ":n:" .. LUAUI_DIRNAME .. "Fonts/cour.ttf"

function widget:Initialize()
	fontHandler.SetDefaultFont(font)
	widgetHandler:RemoveWidget()
end
