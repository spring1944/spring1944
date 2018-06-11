function widget:GetInfo()
   return {
      name      = "s44MapShader",
      desc      = "Spring:1944 map shader",
      author    = "jlcercos",
      date      = "11/06/2018",
      license   = "GPLv3",
      layer     = 0,
      enabled   = true,
   }
end

local glCreateShader = gl.CreateShader
local glGetShaderLog = gl.GetShaderLog

local shader

function widget:Initialize()
    if not Script.IsEngineMinVersion or not Script.IsEngineMinVersion(104,0,1) then
        Spring.Log("Map shader", "error",
                   "spring >= 104.0.1 is required")
        widgetHandler:RemoveWidget()
        return        
    end

    shader = glCreateShader({
        -- vertex = VFS.LoadFile("LuaUI\\Widgets\\Shaders\\GL4.X\\mapshader.vs", VFS.ZIP),
        fragment = VFS.LoadFile("LuaUI\\Widgets\\Shaders\\GL4.X\\mapshader.fs", VFS.ZIP),
        uniformInt = {},
    })
    if not shader then
        Spring.Log("Map shader", "error",
                   "Failed to create map shader!")
        Spring.Echo(gl.GetShaderLog())
        widgetHandler:RemoveWidget()
        return
    end

    Spring.SetMapShader(shader, 0)
end

function widget:Shutdown()
    Spring.SetMapShader(0, 0)
end

function widget:DrawWorld()
    -- gl.UseShader(shader)
    -- if not timeID then
    --     timeID         = gl.GetUniformLocation(shader, "time")
    --     pointsID       = gl.GetUniformLocation(shader, "points")
    --     pointSizeID    = gl.GetUniformLocation(shader, "pointSize")
    -- end
    -- gl.Uniform(     timeID,       os.clock())
    -- gl.UniformInt(  pointSizeID,  #points/3)
    -- gl.UniformArray(pointsID,     1, points)
    -- gl.UseShader(0)
end
