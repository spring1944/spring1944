local includes = {
  "util.lua",
  "taskhandler.lua",
  "theme.lua",
  "fonthandler.lua",
  "texturehandler.lua",
  "object.lua",
  "control.lua",
  "screen.lua",
  "window.lua",
  "label.lua",
  "button.lua",
  "textbox.lua",
  "checkbox.lua",
  "trackbar.lua",
  "colorbars.lua",
  "scrollpanel.lua",
  "image.lua",
  "textbox.lua",
  "layoutpanel.lua",
  "grid.lua",
  "stackpanel.lua",
  "imagelistview.lua",
}

local Chili = widget

local debug = true

if (debug) then
  Chili = {}
  -- make the table strict
  VFS.Include("LuaUI/Widgets/chiligui/strict.lua")(Chili, widget)
end

for _, file in ipairs(includes) do
  VFS.Include(LUAUI_DIRNAME.."Widgets/chiligui/"..file, Chili)
end

return Chili