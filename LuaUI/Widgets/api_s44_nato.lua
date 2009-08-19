function widget:GetInfo()
  return {
    name      = "1944 NATO API",
    desc      = "NATO symbol API.",
    author    = "Evil4Zerggin",
    date      = "17 August 2009",
    license   = "GNU LGPL, v2.1 or later",
    layer     = 1, 
    enabled   = true  --  loaded by default?
  }
end

----------------------------------------------------------------
--speedups
----------------------------------------------------------------

local Echo = Spring.Echo

----------------------------------------------------------------
--local vars
----------------------------------------------------------------
local MAIN_DIRNAME = LUAUI_DIRNAME .. "Widgets/api_s44_nato/"

----------------------------------------------------------------
--setup
----------------------------------------------------------------

NATO = {} --global

WG.NATO = NATO

do
  local vfsInclude = VFS.Include
  local strSub = string.sub
  
  local files = VFS.DirList(MAIN_DIRNAME, "*.lua")
  local nameStart = string.len(MAIN_DIRNAME) + 1
  
  for i=1,#files do
    local file = files[i]
    local partName = strSub(file, nameStart, -5)
    local partFunctions = vfsInclude(file)
    NATO[partName] = partFunctions
    
    local functionString = "{"
    
    for k, v in pairs(partFunctions) do
      functionString = functionString .. "'" .. k .. "', "
    end
    
    functionString = functionString .. "}"
    
    Echo("<api_s44_nato>: Loaded functions " .. functionString .. " into WG.NATO." .. partName)
  end
  
end

function widget:DrawScreen()
  gl.PushMatrix()
    gl.PointSize(16)
    gl.LineWidth(2)
    gl.Translate(600, 400, 0)
    gl.Scale(64, 64, 1)
    gl.Smoothing(true, true, true)
    for k, v in pairs(NATO) do
      if string.sub(k, 1, 1) ~= "_" then
        for kk, vv in pairs(v) do
          vv()
        end
      end
    end
    gl.Smoothing(false, false, false)
    gl.PointSize(1)
    gl.LineWidth(1)
  gl.PopMatrix()
end
