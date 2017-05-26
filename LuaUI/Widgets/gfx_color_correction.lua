function widget:GetInfo()
	return {
		name      = "Color correction",
		version	  = 1.0,
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

-----------------------------------------------------------------


-----------------------------------------------------------------
-- Global Vars
-----------------------------------------------------------------

local vsx = nil	-- current viewport width
local vsy = nil	-- current viewport height
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
local vignetteLoc = nil
local widthLoc2 = nil
local heightLoc2 = nil

local gamma = 0.75
local vignette = {0.3, 1.0}

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
		glTexture(0, toneMappingTex)

		glRenderToTexture(filmGrainTex, glTexRect, -1, 1, 1, -1)

		glTexture(0, false)
	glUseShader(0)

	-- Vignetting
	local timer = Spring.GetGameSeconds()
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
		glTexture(0, vignettingTex)

		glTexRect(0, 0, vsx, vsy, false, true)

		glTexture(0, false)
	glUseShader(0)
end
