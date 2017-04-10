--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

function widget:GetInfo()
  return {
    name      = "NotAchili Framework",
    desc      = "Hot GUI Framework (DO NOT DISABLE)",
    author    = "jK & quantum",
    date      = "WIP",
    license   = "GPLv2",
    layer     = -math.huge,
    enabled   = true,  --  loaded by default?
    handler   = true,
    api       = true,
	alwaysStart = true,
  }
end


--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

local NotAchili
local screen0
local th
local tk

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

function widget:Initialize()
  NotAchili = VFS.Include(LUAUI_DIRNAME.."Widgets/notAchili/data/core.lua")

  screen0 = NotAchili.Screen:New{}
  th = NotAchili.TextureHandler
  tk = NotAchili.TaskHandler

  --// Export Widget Globals
  WG.NotAchili = NotAchili
  WG.NotAchili.Screen0 = screen0

  --// do this after the export to the WG table!
  --// because other widgets use it with `parent=NotAchili.Screen0`,
  --// but notAchili itself doesn't handle wrapped tables correctly (yet)
  screen0 = NotAchili.DebugHandler.SafeWrap(screen0)
end

function widget:Shutdown()
  --table.clear(NotAchili) the NotAchili table also is the global of the widget so it contains a lot more than notAchili's controls (pairs,select,...)
  WG.NotAchili = nil
end

function widget:Dispose()
  screen0:Dispose()
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

function widget:DrawScreen()
  if (not screen0:IsEmpty()) then
    gl.PushMatrix()
    local vsx,vsy = gl.GetViewSizes()
    gl.Translate(0,vsy,0)
    gl.Scale(1,-1,1)
    screen0:Draw()
    gl.PopMatrix()
  end
  
  if NotAchili.PostNotAchiliDraw then
	NotAchili.PostNotAchiliDraw()
  end
end


function widget:TweakDrawScreen()
  if (not screen0:IsEmpty()) then
    gl.PushMatrix()
    local vsx,vsy = gl.GetViewSizes()
    gl.Translate(0,vsy,0)
    gl.Scale(1,-1,1)
    screen0:TweakDraw()
    gl.PopMatrix()
  end
end


function widget:Update()
  tk.Update()
end


function widget:DrawGenesis()
  th.Update()
end

function widget:IsAbove(x,y)  
  return (not screen0:IsEmpty()) and screen0:IsAbove(x,y)
end


local mods = {}
function widget:MousePress(x,y,button)
  local alt, ctrl, meta, shift = Spring.GetModKeyState()
  mods.alt=alt; mods.ctrl=ctrl; mods.meta=meta; mods.shift=shift;

  return screen0:MouseDown(x,y,button,mods)
end


function widget:MouseRelease(x,y,button)
  local alt, ctrl, meta, shift = Spring.GetModKeyState()
  mods.alt=alt; mods.ctrl=ctrl; mods.meta=meta; mods.shift=shift;

  return screen0:MouseUp(x,y,button,mods)
end


function widget:MouseMove(x,y,dx,dy,button)
  local alt, ctrl, meta, shift = Spring.GetModKeyState()
  mods.alt=alt; mods.ctrl=ctrl; mods.meta=meta; mods.shift=shift;

  return screen0:MouseMove(x,y,dx,dy,button,mods)
end


function widget:MouseWheel(up,value)
  local x,y = Spring.GetMouseState()
  local alt, ctrl, meta, shift = Spring.GetModKeyState()
  mods.alt=alt; mods.ctrl=ctrl; mods.meta=meta; mods.shift=shift;

  return screen0:MouseWheel(x,y,up,value,mods)
end


function widget:ViewResize(vsx, vsy) 
	screen0.width = vsx 
	screen0.height= vsy
end 

widget.TweakIsAbove      = widget.IsAbove
widget.TweakMousePress   = widget.MousePress
widget.TweakMouseRelease = widget.MouseRelease
widget.TweakMouseMove    = widget.MouseMove
widget.TweakMouseWheel   = widget.MouseWheel

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
