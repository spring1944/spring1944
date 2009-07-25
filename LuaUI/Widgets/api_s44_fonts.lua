function widget:GetInfo()
	return {
		name      = "1944 Fonts",
		desc      = "Fonts for s44",
		author    = "Evil4Zerggin",
		date      = "25 July 2009",
		license   = "GNU LGPL, v2.1 or later",
		layer     = -10000,
		enabled   = true  --  loaded by default?
  }
end

function widget:Initialize()
  local glLoadFont = gl.LoadFont
  
  local FONT_DIR = LUAUI_DIRNAME .. "Fonts/"
  
  local TypewriterBold16 = glLoadFont(FONT_DIR .. "cmuntb.otf", 16, 0, 0)
  local TypewriterBold32 = glLoadFont(FONT_DIR .. "cmuntb.otf", 32, 0, 0)
  
  WG.S44Fonts = {
    TypewriterBold16 = TypewriterBold16,
    TypewriterBold32 = TypewriterBold32,
  }
end

function widget:Shutdown()
  local glDeleteFont = gl.DeleteFont
  for _, font in pairs(WG.S44Fonts) do
    glDeleteFont(font)
  end
end
