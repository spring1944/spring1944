local component = {}

function component:Initialize()
  Spring.SendCommands("ctrlpanel LuaUI/Widgets/gui_s44_gui/ctrlpanel.txt")
end

return component
