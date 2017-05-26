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
local toneMappingShader = nil  -- Exposure tonemapping shader
local colorTex  = nil  -- rendered fragments texture

-- shader uniform handles
local gammaLoc = nil

local gamma = 0.75

-----------------------------------------------------------------

function widget:ViewResize(x, y)
	vsx, vsy = gl.GetViewSizes()
	glDeleteTexture(colorTex or "")
	colorTex = nil

	colorTex = gl.CreateTexture(vsx, vsy, {
		border = false,
		min_filter = GL.NEAREST,
		mag_filter = GL.NEAREST,
	})

	if not colorTex then
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

	-- Exposure based tone-mapping
	-- ===========================
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

	-- Generate the textures
	-- =====================
	widget:ViewResize()
end

function widget:Shutdown()
	if (glDeleteShader and toneMappingShader) then
		glDeleteShader(toneMappingShader)
	end

	if glDeleteTexture then
		glDeleteTexture(colorTex or "")
	end
	toneMappingShader = nil
	colorTex = nil
end

function widget:DrawScreenEffects()
	-- Get the color rendered image
	glCopyToTexture(colorTex,  0, 0, 0, 0, vsx, vsy)

	-- Exposure based tone-mapping
	glUseShader(toneMappingShader)
		glUniform(gammaLoc, gamma)
		glTexture(0, colorTex)

		glTexRect(0, 0, vsx, vsy, false, true)

		glTexture(0, false)
	glUseShader(0)
end
