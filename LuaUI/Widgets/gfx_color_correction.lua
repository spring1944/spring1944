function widget:GetInfo()
    return {
        name      = "Color correction",
        version      = 1.0,
        desc      = "Apply color correction techniques",
        author    = "Sanguinario_Joe",
        date      = "May. 2017",
        license   = "GPL",
        layer     = 100,
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
-----------------------------------------------------------------

local vsx = nil    -- current viewport width
local vsy = nil    -- current viewport height
local toneMappingShader = nil
local filmGrainShader = nil
local vignettingShader = nil
local aberrationShader = nil
local colorTex       = nil
local toneMappingTex = nil
local filmGrainTex   = nil
local vignettingTex  = nil

-- shader uniform handles
local gammaLoc = nil
local widthLoc = nil
local heightLoc = nil
local timerLoc = nil
local grainLoc = nil
local vignetteLoc = nil
local widthLoc2 = nil
local heightLoc2 = nil
local aberrationLoc = nil

local gamma = 0.75
local grain = 0.02
local vignette = {0.3, 1.0}
local aberration = 0.1

-----------------------------------------------------------------

function widget:ViewResize(x, y)
    vsx, vsy = gl.GetViewSizes()
    glDeleteTexture(colorTex or "")
    glDeleteTexture(toneMappingTex or "")
    glDeleteTexture(filmGrainTex or "")
    glDeleteTexture(vignettingTex or "")
    colorTex = nil
    toneMappingTex = nil
    filmGrainTex = nil
    vignettingTex = nil

    colorTex = gl.CreateTexture(vsx, vsy, {
        border = false,
        min_filter = GL.NEAREST,
        mag_filter = GL.NEAREST,
    })
    toneMappingTex = glCreateTexture(vsx, vsy, {
        fbo = true, min_filter = GL.LINEAR, mag_filter = GL.LINEAR,
        wrap_s = GL.CLAMP, wrap_t = GL.CLAMP,
    })
    filmGrainTex = glCreateTexture(vsx, vsy, {
        fbo = true, min_filter = GL.LINEAR, mag_filter = GL.LINEAR,
        wrap_s = GL.CLAMP, wrap_t = GL.CLAMP,
    })
    vignettingTex = glCreateTexture(vsx, vsy, {
        fbo = true, min_filter = GL.LINEAR, mag_filter = GL.LINEAR,
        wrap_s = GL.CLAMP, wrap_t = GL.CLAMP,
    })

    if not colorTex or not toneMappingTex or not filmGrainTex or not vignettingTex then
        Spring.Echo("Color correction: Failed to create textures!")
        widgetHandler:RemoveWidget()
        return
    end
end

function widget:Initialize()
    if (glCreateShader == nil) then
        Spring.Echo("[Color correction::Initialize] removing widget, no shader support")
        widgetHandler:RemoveWidget()
        return
    end

    -- Tone-mapping
    -- ============
    toneMappingShader = toneMappingShader or glCreateShader({
        fragment = VFS.LoadFile("LuaUI\\Widgets\\Shaders\\color_tonemapping.fs", VFS.ZIP),
        uniformInt = {colors = 0},
    })
    if not toneMappingShader then
        Spring.Echo("Color correction: Failed to create tone-mapping shader!")
        Spring.Echo(gl.GetShaderLog())
        widgetHandler:RemoveWidget()
        return
    end

    gammaLoc = gl.GetUniformLocation(toneMappingShader, "gamma")

    -- Film-grain
    -- ==========
    filmGrainShader = filmGrainShader or glCreateShader({
        fragment = VFS.LoadFile("LuaUI\\Widgets\\Shaders\\color_filmgrain.fs", VFS.ZIP),
        uniformInt = {colors = 0},
    })
    if not filmGrainShader then
        Spring.Echo("Color correction: Failed to create film grain shader!")
        Spring.Echo(gl.GetShaderLog())
        widgetHandler:RemoveWidget()
        return
    end

    widthLoc = gl.GetUniformLocation(filmGrainShader, "width")
    heightLoc = gl.GetUniformLocation(filmGrainShader, "height")
    timerLoc = gl.GetUniformLocation(filmGrainShader, "timer")
    grainLoc = gl.GetUniformLocation(filmGrainShader, "grainamount")

    -- Vignetting
    -- ==========
    vignettingShader = vignettingShader or glCreateShader({
        fragment = VFS.LoadFile("LuaUI\\Widgets\\Shaders\\color_vignetting.fs", VFS.ZIP),
        uniformInt = {colors = 0},
    })
    if not vignettingShader then
        Spring.Echo("Color correction: Failed to create Vignetting shader!")
        Spring.Echo(gl.GetShaderLog())
        widgetHandler:RemoveWidget()
        return
    end

    vignetteLoc = gl.GetUniformLocation(vignettingShader, "vignette")

    -- Chromatic aberration
    -- ====================
    aberrationShader = aberrationShader or glCreateShader({
        fragment = VFS.LoadFile("LuaUI\\Widgets\\Shaders\\color_aberration.fs", VFS.ZIP),
        uniformInt = {colors = 0},
    })
    if not aberrationShader then
        Spring.Echo("Color correction: Failed to create Vignetting shader!")
        Spring.Echo(gl.GetShaderLog())
        widgetHandler:RemoveWidget()
        return
    end

    widthLoc2 = gl.GetUniformLocation(aberrationShader, "width")
    heightLoc2 = gl.GetUniformLocation(aberrationShader, "height")
    aberrationLoc = gl.GetUniformLocation(aberrationShader, "max_distort")

    -- Generate the textures
    -- =====================
    widget:ViewResize()
end

function widget:Shutdown()
    if (glDeleteShader and toneMappingShader) then
        glDeleteShader(toneMappingShader)
    end
    if (glDeleteShader and filmGrainShader) then
        glDeleteShader(filmGrainShader)
    end
    if (glDeleteShader and vignettingShader) then
        glDeleteShader(vignettingShader)
    end
    if (glDeleteShader and aberrationShader) then
        glDeleteShader(aberrationShader)
    end

    if glDeleteTexture then
        glDeleteTexture(colorTex or "")
        glDeleteTexture(toneMappingTex or "")
        glDeleteTexture(filmGrainTex or "")
        glDeleteTexture(vignettingTex or "")
    end
    toneMappingShader, filmGrainShader, vignettingShader, aberrationShader = nil, nil, nil, nil
    colorTex, toneMappingTex, filmGrainTex, vignettingTex = nil, nil, nil, nil
end

function widget:DrawScreenEffects()
    -- Get the color rendered image
    glCopyToTexture(colorTex,  0, 0, 0, 0, vsx, vsy)

    -- Tone-mapping
    glUseShader(toneMappingShader)
        glUniform(gammaLoc, gamma)
        glTexture(0, colorTex)

        glRenderToTexture(toneMappingTex, glTexRect, -1, 1, 1, -1)

        glTexture(0, false)
    glUseShader(0)

    -- Film grain
    local timer = Spring.GetGameSeconds()
    glUseShader(filmGrainShader)
        glUniform(widthLoc, vsx)
        glUniform(heightLoc, vsy)
        glUniform(timerLoc, timer)
        glUniform(grainLoc, grain)
        glTexture(0, toneMappingTex)

        glRenderToTexture(filmGrainTex, glTexRect, -1, 1, 1, -1)

        glTexture(0, false)
    glUseShader(0)
    
    -- Vignetting
    glUseShader(vignettingShader)
        glUniform(vignetteLoc, vignette[1], vignette[2])
        glTexture(0, filmGrainTex)

        glRenderToTexture(vignettingTex, glTexRect, -1, 1, 1, -1)

        glTexture(0, false)
    glUseShader(0)

    -- Chromatic aberration
    glUseShader(aberrationShader)
        glUniform(widthLoc2, vsx)
        glUniform(heightLoc2, vsy)
        glUniform(aberrationLoc, aberration)
        glTexture(0, vignettingTex)

        glTexRect(0, 0, vsx, vsy, false, true)

        glTexture(0, false)
    glUseShader(0)
end

-----------------------------------------------------------------
-- GUI
-----------------------------------------------------------------

local wWidth, wHeight = Spring.GetWindowGeometry()
local px, py = 0.25 * wWidth - 260, wHeight - 4
local isMinimized = true
local gui_w, gui_h = 256, 32
local vertexList = nil

local gammaBounds = {0.5, 1.5}
local grainBounds = {0.0, 0.1}
local vignetteBounds = {math.sqrt(2.0) * 0.5, 2.0}
local aberrationBounds = {0.0, 0.5}


local function sliderPos(val, bounds)
    percentage = (val - bounds[1]) / (bounds[2] - bounds[1])
    -- The bar comes from 64 to gui_w
    return 64 + percentage * (gui_w - 8 - 64)
end

local function sliderVal(pos, bounds)
    -- The bar comes from 64 to gui_w
    percentage = (pos - 64) / (gui_w - 8 - 64)
    return bounds[1] + percentage * (bounds[2] - bounds[1])
end


local function DrawRect(px,py,sx,sy)
    glVertex(px, py, 0)
    glVertex(sx, py, 0)
    glVertex(sx, sy, 0)
    glVertex(px, sy, 0)
end

local function DrawRectRound(px,py,sx,sy,cs)
    glTexCoord(0.8,0.8)
    glVertex(px+cs, py, 0)
    glVertex(sx-cs, py, 0)
    glVertex(sx-cs, sy, 0)
    glVertex(px+cs, sy, 0)
    
    glVertex(px, py+cs, 0)
    glVertex(px+cs, py+cs, 0)
    glVertex(px+cs, sy-cs, 0)
    glVertex(px, sy-cs, 0)
    
    glVertex(sx, py+cs, 0)
    glVertex(sx-cs, py+cs, 0)
    glVertex(sx-cs, sy-cs, 0)
    glVertex(sx, sy-cs, 0)
    
    local offset = 0.05        -- texture offset, because else gaps could show
    local o = offset
    
    -- top left
    if py <= 0 or px <= 0 then o = 0.5 else o = offset end
    glTexCoord(o,o)
    glVertex(px, py, 0)
    glTexCoord(o,1-o)
    glVertex(px+cs, py, 0)
    glTexCoord(1-o,1-o)
    glVertex(px+cs, py+cs, 0)
    glTexCoord(1-o,o)
    glVertex(px, py+cs, 0)
    -- top right
    if py <= 0 or sx >= vsx then o = 0.5 else o = offset end
    glTexCoord(o,o)
    glVertex(sx, py, 0)
    glTexCoord(o,1-o)
    glVertex(sx-cs, py, 0)
    glTexCoord(1-o,1-o)
    glVertex(sx-cs, py+cs, 0)
    glTexCoord(1-o,o)
    glVertex(sx, py+cs, 0)
    -- bottom left
    if sy >= vsy or px <= 0 then o = 0.5 else o = offset end
    glTexCoord(o,o)
    glVertex(px, sy, 0)
    glTexCoord(o,1-o)
    glVertex(px+cs, sy, 0)
    glTexCoord(1-o,1-o)
    glVertex(px+cs, sy-cs, 0)
    glTexCoord(1-o,o)
    glVertex(px, sy-cs, 0)
    -- bottom right
    if sy >= vsy or sx >= vsx then o = 0.5 else o = offset end
    glTexCoord(o,o)
    glVertex(sx, sy, 0)
    glTexCoord(o,1-o)
    glVertex(sx-cs, sy, 0)
    glTexCoord(1-o,1-o)
    glVertex(sx-cs, sy-cs, 0)
    glTexCoord(1-o,o)
    glVertex(sx, sy-cs, 0)
end


function MinimizedList()
    local w, h = 256, 32
    gui_w, gui_h = w, h
    glColor(0, 0, 0, 0.5)
    glBeginEnd(GL_QUADS, DrawRectRound, 0, -h, w, 0, 0)
    glColor(1, 1, 1, 1)
    local fontsize = 16
    glText('\255\225\255\225Color correction', w / 2, -16, fontsize, 'cv')
    glText('\255\0\0\225+', w - 8, -16, fontsize, 'cv')
end

function MaximizedList()
    local w, h = 256, 128
    gui_w, gui_h = w, h
    glColor(0, 0, 0, 0.5)
    glBeginEnd(GL_QUADS, DrawRectRound, 0, -h, w, 0, 0)
    glColor(1, 1, 1, 1)
    local fontsize = 16
    glText('\255\225\255\225Color correction', w / 2, -16, fontsize, 'cv')
    glText('\255\0\0\225-', w - 8, -16, fontsize, 'cv')
    local vpos = -16
    local fontsize = 8
    -- Gamma controller
    vpos = vpos - 32
    glText('\255\225\255\225Gamma', 8, vpos, fontsize, 'lv')
    glBeginEnd(GL_QUADS, DrawRect, 64, vpos - 2, w - 8, vpos + 2)
    -- Film grain controller
    vpos = vpos - 16
    glText('\255\225\255\225Film grain', 8, vpos, fontsize, 'lv')
    glBeginEnd(GL_QUADS, DrawRect, 64, vpos - 2, w - 8, vpos + 2)
    -- Vignetting controller
    vpos = vpos - 16
    glText('\255\225\255\225Vignetting', 8, vpos, fontsize, 'lv')
    glBeginEnd(GL_QUADS, DrawRect, 64, vpos - 2, w - 8, vpos + 2)
    -- Chromatic aberration
    vpos = vpos - 16
    glText('\255\225\255\225C. Aberration', 8, vpos, fontsize, 'lv')
    glBeginEnd(GL_QUADS, DrawRect, 64, vpos - 2, w - 8, vpos + 2)
end


function widget:DrawScreen()
    -- Positioning
    glPushMatrix()
    glTranslate(px, py, 0)
    --call list
    if vertexList then
        glCallList(vertexList)
    else
        if isMinimized then
            vertexList = glCreateList(MinimizedList)
        else
            vertexList = glCreateList(MaximizedList)
        end
    end
    if isMinimized then
        glColor(1, 1, 1, 1)
        glPopMatrix()
        return
    end
    local vpos = -16
    glColor(1, 0, 0, 1)
    local hpos
    -- Gamma slider
    vpos = vpos - 32
    hpos = sliderPos(gamma, gammaBounds)
    glBeginEnd(GL_QUADS, DrawRect, hpos - 1, vpos - 4, hpos + 1, vpos + 4)
    -- FilmGrain slider
    vpos = vpos - 16
    hpos = sliderPos(grain, grainBounds)
    glBeginEnd(GL_QUADS, DrawRect, hpos - 1, vpos - 4, hpos + 1, vpos + 4)
    -- FilmGrain slider
    vpos = vpos - 16
    hpos = sliderPos(vignette[2], vignetteBounds)
    glBeginEnd(GL_QUADS, DrawRect, hpos - 1, vpos - 4, hpos + 1, vpos + 4)
    -- C.Aberration slider
    vpos = vpos - 16
    hpos = sliderPos(aberration, aberrationBounds)
    glBeginEnd(GL_QUADS, DrawRect, hpos - 1, vpos - 4, hpos + 1, vpos + 4)

    glColor(1, 1, 1, 1)
    glPopMatrix()
end

function widget:MousePress(mx, my, mButton)

    -- Check we are on the widget
    w, h = gui_w, gui_h
    local R = RADIUS
    local rx = mx - px
    local ry = -(my - py)
    if rx <= 0 or rx >= w or ry <= 0 or ry >= h then
        return
    end

    if (mButton == 2 or mButton == 3) then
        -- Dragging
        return true
    end

    if ry < 32 then
        -- Minimize/maximize
        if isMinimized then
            isMinimized = false
            vertexList = glCreateList(MaximizedList)
        else
            isMinimized = true
            vertexList = glCreateList(MinimizedList)
        end
    elseif ry >= 48 - 8 and ry < 48 + 8 and rx >= 64 and rx <= w - 8 then
        -- Gamma
        gamma = sliderVal(rx, gammaBounds)
    elseif ry >= 64 - 8 and ry < 64 + 8 and rx >= 64 and rx <= w - 8 then
        -- Film grain
        grain = sliderVal(rx, grainBounds)
    elseif ry >= 80 - 8 and ry < 80 + 8 and rx >= 64 and rx <= w - 8 then
        -- Vignette
        vignette[2] = sliderVal(rx, vignetteBounds)
    elseif ry >= 96 - 8 and ry < 96 + 8 and rx >= 64 and rx <= w - 8 then
        -- Vignette
        aberration = sliderVal(rx, aberrationBounds)
    end
    return true
end

function widget:MouseMove(mx, my, dx, dy, mButton)
    -- Dragging
    if mButton == 2 or mButton == 3 then
        px = px + dx
        py = py + dy
    end
end
