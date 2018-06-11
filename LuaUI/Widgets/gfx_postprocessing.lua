function widget:GetInfo()
    return {
        name      = "Post-processing",
        version      = 1.0,
        desc      = "Several post-processing effects",
        author    = "Sanguinario_Joe",
        date      = "May. 2017",
        license   = "GPL",
        layer     = math.huge,
        enabled   = false
    }
end

-----------------------------------------------------------------
-- Engine Functions
-----------------------------------------------------------------

local glCopyToTexture        = gl.CopyToTexture
local glCreateShader         = gl.CreateShader
local glCreateTexture        = gl.CreateTexture
local glDeleteShader         = gl.DeleteShader
local glDeleteTexture        = gl.DeleteTexture
local glGetShaderLog         = gl.GetShaderLog
local glTexture              = gl.Texture
local glTexRect              = gl.TexRect
local glRenderToTexture      = gl.RenderToTexture
local glUseShader            = gl.UseShader
local glGetUniformLocation   = gl.GetUniformLocation
local glUniform              = gl.Uniform
local GL_COLOR_BUFFER_BIT    = GL.COLOR_BUFFER_BIT
local GL_NEAREST             = GL.NEAREST

local glTexCoord = gl.TexCoord
local glVertex = gl.Vertex
local glColor = gl.Color
local glRect = gl.Rect
local glBeginEnd = gl.BeginEnd
local GL_QUADS = GL.QUADS
local glPushMatrix = gl.PushMatrix
local glPopMatrix = gl.PopMatrix
local glTranslate = gl.Translate
local glBeginText = gl.BeginText
local glEndText = gl.EndText
local glText = gl.Text
local glCallList = gl.CallList
local glCreateList = gl.CreateList
local glDeleteList = gl.DeleteList

-----------------------------------------------------------------


-----------------------------------------------------------------
-- Global Vars
-- The effects objects are actually stored in WG. See
-- api_postprocessing.lua
-----------------------------------------------------------------

local vsx = nil    -- current viewport width
local vsy = nil    -- current viewport height
local colorTex       = nil

local gamma_noise = {
    A = {0.075, 0.06, 0.03, 0.015},
    T = {1.0, 0.25, 0.1, 0.05},
    L = {},
}
gamma_noise.n = #gamma_noise.A
for i=1,gamma_noise.n do
    gamma_noise.L[i] = math.random() * math.pi
end

-----------------------------------------------------------------

function gammaNoise(t)
    local noise = 0
    for i=1,gamma_noise.n do
        local A = gamma_noise.A[i]
        local w = 2 * math.pi / gamma_noise.T[i]
        local lag = gamma_noise.L[i]
        noise = noise + A * math.sin(w * t + lag)
    end
    return noise
end

function widget:ViewResize(x, y)
    vsx, vsy = gl.GetViewSizes()

    glDeleteTexture(colorTex or "")
    colorTex = nil

    colorTex = gl.CreateTexture(vsx, vsy, {
        border = false,
        min_filter = GL.NEAREST,
        mag_filter = GL.NEAREST,
    })

    for name, effect in pairs(WG.POSTPROC) do
        glDeleteTexture(effect.texture or "")
        effect.texture = glCreateTexture(vsx, vsy, {
            fbo = true, min_filter = GL.LINEAR, mag_filter = GL.LINEAR,
            wrap_s = GL.CLAMP, wrap_t = GL.CLAMP,
        })
        if not effect.texture then
            Spring.Log("Post-processing", "error",
                       "Failed to create texture for " .. name)
            widgetHandler:RemoveWidget()
            return
        end
    end
end

function widget:Initialize()
    if (glCreateShader == nil) then
        Spring.Log("Post-processing", "error",
                   "removing widget, no shader support")
        widgetHandler:RemoveWidget()
        return
    end

    if Script.IsEngineMinVersion(104,0,1) then
        Spring.Log("Post-processing", "error",
                   "removing widget, engine version not supported yet")
        widgetHandler:RemoveWidget()
        return        
    end

    local tonemapping = WG.POSTPROC.tonemapping
    local grayscale = WG.POSTPROC.grayscale
    local filmgrain = WG.POSTPROC.filmgrain
    local scratches = WG.POSTPROC.scratches
    local vignette = WG.POSTPROC.vignette
    local aberration = WG.POSTPROC.aberration
    
    -- Tone-mapping
    -- ============
    tonemapping.shader = tonemapping.shader or glCreateShader({
        fragment = VFS.LoadFile("LuaUI\\Widgets\\Shaders\\color_tonemapping.fs", VFS.ZIP),
        uniformInt = {colors = 0},
    })
    if not tonemapping.shader then
        Spring.Log("Post-processing", "error",
                   "Failed to create tone-mapping shader!")
        Spring.Echo(gl.GetShaderLog())
        widgetHandler:RemoveWidget()
        return
    end

    tonemapping.gammaLoc = gl.GetUniformLocation(tonemapping.shader, "gamma")

    -- Grayscale/sepia
    -- ===============
    grayscale.shader = grayscale.shader or glCreateShader({
        fragment = VFS.LoadFile("LuaUI\\Widgets\\Shaders\\color_grayscale.fs", VFS.ZIP),
        uniformInt = {colors = 0},
    })
    if not grayscale.shader then
        Spring.Log("Post-processing", "error",
                   "Failed to create grayscale/sepia shader!")
        Spring.Echo(gl.GetShaderLog())
        widgetHandler:RemoveWidget()
        return
    end

    grayscale.sepiaLoc = gl.GetUniformLocation(grayscale.shader, "sepiaFactor")

    -- Film-grain
    -- ==========
    filmgrain.shader = filmgrain.shader or glCreateShader({
        fragment = VFS.LoadFile("LuaUI\\Widgets\\Shaders\\color_filmgrain.fs", VFS.ZIP),
        uniformInt = {colors = 0},
    })
    if not filmgrain.shader then
        Spring.Log("Post-processing", "error",
                   "Failed to create film grain shader!")
        Spring.Echo(gl.GetShaderLog())
        widgetHandler:RemoveWidget()
        return
    end

    filmgrain.widthLoc = gl.GetUniformLocation(filmgrain.shader, "width")
    filmgrain.heightLoc = gl.GetUniformLocation(filmgrain.shader, "height")
    filmgrain.timerLoc = gl.GetUniformLocation(filmgrain.shader, "timer")
    filmgrain.grainLoc = gl.GetUniformLocation(filmgrain.shader, "grainamount")

    -- Scratches
    -- =========
    scratches.shader = scratches.shader or glCreateShader({
        fragment = VFS.LoadFile("LuaUI\\Widgets\\Shaders\\scratches.fs", VFS.ZIP),
        uniformInt = {colors = 0},
    })
    if not scratches.shader then
        Spring.Log("Post-processing", "error",
                   "Failed to create scratches shader!")
        Spring.Echo(gl.GetShaderLog())
        widgetHandler:RemoveWidget()
        return
    end

    scratches.thresholdLoc = gl.GetUniformLocation(scratches.shader, "threshold")
    scratches.randomLoc = gl.GetUniformLocation(scratches.shader, "randomValue")
    scratches.timerLoc = gl.GetUniformLocation(scratches.shader, "timer")

    -- Vignetting
    -- ==========
    vignette.shader = vignette.shader or glCreateShader({
        fragment = VFS.LoadFile("LuaUI\\Widgets\\Shaders\\color_vignetting.fs", VFS.ZIP),
        uniformInt = {colors = 0},
    })
    if not vignette.shader then
        Spring.Log("Post-processing", "error",
                   "Failed to create Vignetting shader!")
        Spring.Echo(gl.GetShaderLog())
        widgetHandler:RemoveWidget()
        return
    end

    vignette.vignetteLoc = gl.GetUniformLocation(vignette.shader, "vignette")

    -- Chromatic aberration
    -- ====================
    aberration.shader = aberration.shader or glCreateShader({
        fragment = VFS.LoadFile("LuaUI\\Widgets\\Shaders\\color_aberration.fs", VFS.ZIP),
        uniformInt = {colors = 0},
    })
    if not aberration.shader then
        Spring.Log("Post-processing", "error",
                   "Failed to create Vignetting shader!")
        Spring.Echo(gl.GetShaderLog())
        widgetHandler:RemoveWidget()
        return
    end

    aberration.widthLoc = gl.GetUniformLocation(aberration.shader, "width")
    aberration.heightLoc = gl.GetUniformLocation(aberration.shader, "height")
    aberration.aberrationLoc = gl.GetUniformLocation(aberration.shader, "max_distort")

    -- Generate the textures
    -- =====================
    widget:ViewResize()
end

function widget:Shutdown()
    if glDeleteTexture then
        glDeleteTexture(colorTex or "")
    end
    colorTex = nil
    
    for name, effect in pairs(WG.POSTPROC) do
        if (glDeleteShader and effect.shader) then
            glDeleteShader(effect.shader)
        end
        if glDeleteTexture then
            glDeleteTexture(effect.texture or "")
        end
        effect.shader = nil
        effect.texture = nil
    end
end

function widget:DrawScreenEffects()
    local tonemapping = WG.POSTPROC.tonemapping
    local grayscale = WG.POSTPROC.grayscale
    local filmgrain = WG.POSTPROC.filmgrain
    local scratches = WG.POSTPROC.scratches
    local vignette = WG.POSTPROC.vignette
    local aberration = WG.POSTPROC.aberration

    -- Get the color rendered image
    glCopyToTexture(colorTex,  0, 0, 0, 0, vsx, vsy)

    -- Tone-mapping
    local timer = Spring.GetGameSeconds()
    glUseShader(tonemapping.shader)
        glUniform(tonemapping.gammaLoc,
                  tonemapping.gamma + tonemapping.dGamma * gammaNoise(timer))
        glTexture(0, colorTex)

        glRenderToTexture(tonemapping.texture, glTexRect, -1, 1, 1, -1)

        glTexture(0, false)
    glUseShader(0)

    -- Grayscale/sepia
    local filmGrainInTex = tonemapping.texture
    if grayscale.enabled then
        filmGrainInTex = grayscale.texture
        glUseShader(grayscale.shader)
            glUniform(grayscale.sepiaLoc, grayscale.sepia)
            glTexture(0, tonemapping.texture)

            glRenderToTexture(grayscale.texture, glTexRect, -1, 1, 1, -1)

            glTexture(0, false)
        glUseShader(0)
    end

    -- Film grain
    glUseShader(filmgrain.shader)
        glUniform(filmgrain.widthLoc, vsx)
        glUniform(filmgrain.heightLoc, vsy)
        glUniform(filmgrain.timerLoc, timer)
        glUniform(filmgrain.grainLoc, filmgrain.grain)
        glTexture(0, filmGrainInTex)

        glRenderToTexture(filmgrain.texture, glTexRect, -1, 1, 1, -1)

        glTexture(0, false)
    glUseShader(0)

    -- Scratches
    local randomValue = math.random()
    glUseShader(scratches.shader)
        glUniform(scratches.thresholdLoc, scratches.threshold)
        glUniform(scratches.randomLoc, randomValue)
        glUniform(scratches.timerLoc, timer)
        glTexture(0, filmgrain.texture)

        glRenderToTexture(scratches.texture, glTexRect, -1, 1, 1, -1)

        glTexture(0, false)
    glUseShader(0)
    
    
    -- Vignetting
    glUseShader(vignette.shader)
        glUniform(vignette.vignetteLoc, vignette.vignette[1], vignette.vignette[2])
        glTexture(0, scratches.texture)

        glRenderToTexture(vignette.texture, glTexRect, -1, 1, 1, -1)

        glTexture(0, false)
    glUseShader(0)

    -- Chromatic aberration
    glUseShader(aberration.shader)
        glUniform(aberration.widthLoc, vsx)
        glUniform(aberration.heightLoc, vsy)
        glUniform(aberration.aberrationLoc, aberration.aberration)
        glTexture(0, vignette.texture)

        glTexRect(0, 0, vsx, vsy, false, true)

        glTexture(0, false)
    glUseShader(0)
end
