function widget:GetInfo()
	return {
		name      = "Screen-Space Ambient Occlusion",
		version	  = 1.0,
		desc      = "Generate ambient occlusion in screen space",
		author    = "Sanguinario_Joe",
		date      = "Apr. 2017",
		license   = "GPL",
		layer     = -1,
		enabled   = false
	}
end

-----------------------------------------------------------------
-- Engine Functions
-----------------------------------------------------------------

local GL_DEPTH_BITS = 0x0D56
local GL_DEPTH_COMPONENT   = 0x1902
local GL_DEPTH_COMPONENT16 = 0x81A5
local GL_DEPTH_COMPONENT24 = 0x81A6
local GL_DEPTH_COMPONENT32 = 0x81A7

local spGetCameraPosition    = Spring.GetCameraPosition

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
local glUniformMatrix        = gl.UniformMatrix
local glBlitFBO              = gl.BlitFBO
local GL_DEPTH_BUFFER_BIT    = GL.DEPTH_BUFFER_BIT
local GL_COLOR_BUFFER_BIT    = GL.COLOR_BUFFER_BIT
local GL_NEAREST             = GL.NEAREST

-----------------------------------------------------------------


-----------------------------------------------------------------
-- Global Vars
-----------------------------------------------------------------

local vsx = nil	-- current viewport width
local vsy = nil	-- current viewport height
local noiseShader       = nil  -- Used just once to generate noiseTex (due to the lack of glTexImage2D)
local normalBlendShader = nil  -- Since spring is separately rendering map and units, we should mix all together here
local ssaoShader        = nil
local blurShader        = nil
local renderShader      = nil
local depthTex  = nil  -- rendered depths texture
local colorTex  = nil  -- rendered fragments texture
local noiseTex  = nil  -- Noise to add to the samples data
local normalTex = nil  -- normals blended texture
local ssaoTex   = nil  -- Actual ambient occlusion texture
local blurTex   = nil  -- Blurred ambient occlusion texture, to avoid noise and band artifacts

-- shader uniform handles
local eyePosLoc = nil
local viewMatLoc = nil
local projectionMatLoc = nil
local projectionMatInvLoc = nil
local noiseScaleLoc = nil
local samplesXLoc = nil
local samplesYLoc = nil
local samplesZLoc = nil
local texelSizeLoc = nil
-- Constant uniform values
local samplesX = nil
local samplesY = nil
local samplesZ = nil


-----------------------------------------------------------------

function widget:ViewResize(x, y)
	vsx, vsy = gl.GetViewSizes()
	glDeleteTexture(depthTex or "")
	glDeleteTexture(colorTex or "")
	glDeleteTexture(noiseTex or "")
	glDeleteTexture(normalTex or "")
	glDeleteTexture(ssaoTex or "")
	glDeleteTexture(blurTex or "")
	depthTex, colorTex, noiseTex, normalTex, ssaoTex, blurTex = nil, nil, nil, nil, nil, nil

	depthTex = gl.CreateTexture(vsx,vsy, {
		border = false,
		format = GL_DEPTH_COMPONENT32,
		min_filter = GL.NEAREST,
		mag_filter = GL.NEAREST,
	})
	colorTex = gl.CreateTexture(vsx, vsy, {
		border = false,
		min_filter = GL.NEAREST,
		mag_filter = GL.NEAREST,
	})

	normalTex = glCreateTexture(vsx, vsy, {
		fbo = true, min_filter = GL.LINEAR, mag_filter = GL.LINEAR,
		wrap_s = GL.CLAMP, wrap_t = GL.CLAMP,
	})

	ssaoTex = glCreateTexture(vsx, vsy, {
		fbo = true, min_filter = GL.LINEAR, mag_filter = GL.LINEAR,
		wrap_s = GL.CLAMP, wrap_t = GL.CLAMP,
	})

	blurTex = glCreateTexture(vsx, vsy, {
		fbo = true, min_filter = GL.LINEAR, mag_filter = GL.LINEAR,
		wrap_s = GL.CLAMP, wrap_t = GL.CLAMP,
	})

	if not depthTex or not colorTex or not normalTex or not ssaoTex or not blurTex then
		Spring.Echo("Screen-Space Ambient Occlusion: Failed to create textures!")
		widgetHandler:RemoveWidget()
		return
	end
end

function widget:Initialize()
	if (glCreateShader == nil) then
		Spring.Echo("[Screen-Space Ambient Occlusion::Initialize] removing widget, no shader support")
		widgetHandler:RemoveWidget()
		return
	end

	if (Spring.GetConfigInt("AllowDeferredMapRendering") == 0 or Spring.GetConfigInt("AllowDeferredModelRendering") == 0) then
		Spring.Echo('SSAO (gfx_ssao.lua) requires restarting Spring to properly work!') 
		Spring.SetConfigInt("AllowDeferredMapRendering", 1)
		Spring.SetConfigInt("AllowDeferredModelRendering", 1)
		widgetHandler:RemoveWidget()
		return
	end

	-- The Noise texture generation shader, called just once
	-- =====================================================
	noiseShader = noiseShader or glCreateShader({
		fragment = VFS.LoadFile("LuaUI\\Widgets\\Shaders\\ssao_noise.fs", VFS.ZIP),
	})
	if not noiseShader then
		Spring.Echo("Screen-Space Ambient Occlusion: Failed to create noise shader!")
		Spring.Echo(gl.GetShaderLog())
		widgetHandler:RemoveWidget()
		return
	end

	-- The map and model normal blending shader
	-- ========================================
	normalBlendShader = normalBlendShader or glCreateShader({
		fragment = VFS.LoadFile("LuaUI\\Widgets\\Shaders\\ssao_normal_blend.fs", VFS.ZIP),
		uniformInt = {mapdepths = 0, modeldepths = 1, mapnormals = 2, modelnormals = 3},
	})
	if not normalBlendShader then
		Spring.Echo("Screen-Space Ambient Occlusion: Failed to create SSAO normal blend shader!")
		Spring.Echo(gl.GetShaderLog())
		widgetHandler:RemoveWidget()
		return
	end

	-- The SSAO oclussion map computation
	-- ==================================
	ssaoShader = ssaoShader or glCreateShader({
		fragment = VFS.LoadFile("LuaUI\\Widgets\\Shaders\\ssao.fs", VFS.ZIP),
		uniformInt = {normals = 0, depths = 1, texNoise = 2},
	})
	if not ssaoShader then
		Spring.Echo("Screen-Space Ambient Occlusion: Failed to create SSAO shader!")
		Spring.Echo(gl.GetShaderLog())
		widgetHandler:RemoveWidget()
		return
	end

	eyePosLoc = gl.GetUniformLocation(ssaoShader, "eyePos")
	viewMatLoc = gl.GetUniformLocation(ssaoShader, "viewMat")
	projectionMatLoc = gl.GetUniformLocation(ssaoShader, "projectionMat")
	projectionMatInvLoc = gl.GetUniformLocation(ssaoShader, "projectionMatInv")
	noiseScaleLoc = gl.GetUniformLocation(ssaoShader, "noiseScale")
	samplesXLoc = gl.GetUniformLocation(ssaoShader, "samplesX")
	samplesYLoc = gl.GetUniformLocation(ssaoShader, "samplesY")
	samplesZLoc = gl.GetUniformLocation(ssaoShader, "samplesZ")

	-- The SSAO oclussion map blurring shader
	-- ======================================
	blurShader = blurShader or glCreateShader({
		fragment = VFS.LoadFile("LuaUI\\Widgets\\Shaders\\blur.fs", VFS.ZIP),
		uniformInt = {ssao = 0},
	})
	if not blurShader then
		Spring.Echo("Screen-Space Ambient Occlusion: Failed to create SSAO blur shader!")
		Spring.Echo(gl.GetShaderLog())
		widgetHandler:RemoveWidget()
		return
	end

	texelSizeLoc = gl.GetUniformLocation(blurShader, "texelSize")

	-- The SSAO application final step
	-- ===============================
	renderShader = renderShader or glCreateShader({
		fragment = VFS.LoadFile("LuaUI\\Widgets\\Shaders\\ssao_apply.fs", VFS.ZIP),
		uniformInt = {depths = 0, ssao = 1, colors = 2},
	})
	if not renderShader then
		Spring.Echo("Screen-Space Ambient Occlusion: Failed to create SSAO application shader!")
		Spring.Echo(gl.GetShaderLog())
		widgetHandler:RemoveWidget()
		return
	end

	-- Generate the samples kernel
	samplesX = {}
	samplesY = {}
	samplesZ = {}
	for i=1,16 do
		local sx = math.random() * 2.0 - 1.0
		local sy = math.random() * 2.0 - 1.0
		local ss = math.sqrt(sx*sx + sy*sy)
		local sz = math.random() * (1.0 - ss) + ss
		ss = math.sqrt(sx*sx + sy*sy + sz*sz)
		if ss > 0.000001 then
			sx = sx / ss
			sy = sy / ss
			sz = sz / ss
		end
		--[[
		ss = math.random()
		sx = sx * ss
		sy = sy * ss
		sz = sz * ss
		--]]
		ss = i / 64.0
		ss = 0.1 + ss * ss * (1.0 - 0.1)  -- lerp
		samplesX[i] = sx * ss
		samplesY[i] = sy * ss
		samplesZ[i] = sz * ss
	end

	widget:ViewResize()
end

function widget:Shutdown()
	if (glDeleteShader and noiseShader) then
		glDeleteShader(noiseShader)
	end
	if (glDeleteShader and normalBlendShader) then
		glDeleteShader(normalBlendShader)
	end
	if (glDeleteShader and ssaoShader) then
		glDeleteShader(ssaoShader)
	end
	if (glDeleteShader and blurShader) then
		glDeleteShader(blurShader)
	end
	if (glDeleteShader and renderShader) then
		glDeleteShader(renderShader)
	end
	
	if glDeleteTexture then
		glDeleteTexture(depthTex or "")
		glDeleteTexture(colorTex or "")
		glDeleteTexture(noiseTex or "")
		glDeleteTexture(normalTex or "")
		glDeleteTexture(ssaoTex or "")
		glDeleteTexture(blurTex or "")
	end
	noiseShader, normalBlendShader, ssaoShader, blurShader, renderShader = nil, nil, nil, nil, nil
	depthTex, colorTex, noiseTex, normalTex, ssaoTex, blurTex = nil, nil, nil, nil, nil, nil
end

function widget:DrawScreenEffects()
	-- Get the depth and color rendered images
	glCopyToTexture(depthTex,  0, 0, 0, 0, vsx, vsy)
	glCopyToTexture(colorTex,  0, 0, 0, 0, vsx, vsy)

	-- Compute the noise texture (if it is not already computed)
	if not noiseTex then
		-- Due to the lack of glTexImage2D, the noise should be rendered once
		-- to a FBO texture
		noiseTex = glCreateTexture(4, 4, {
			fbo = true, min_filter = GL.NEAREST, mag_filter = GL.NEAREST,
			wrap_s = GL.REPEAT, wrap_t = GL.REPEAT,
		})
		glUseShader(noiseShader)
			glRenderToTexture(noiseTex, glTexRect, -1, 1, 1, -1)
		glUseShader(0)
	end

	-- Blend normal maps into a single one
	glUseShader(normalBlendShader)
		glTexture(0, "$map_gbuffer_zvaltex")
		glTexture(1, "$model_gbuffer_zvaltex")
		glTexture(2, "$map_gbuffer_normtex")
		glTexture(3, "$model_gbuffer_normtex")

		glRenderToTexture(normalTex, glTexRect, -1, 1, 1, -1)
		
		glTexture(0, false)
		glTexture(1, false)
		glTexture(2, false)
		glTexture(3, false)
	glUseShader(0)

	-- Now we wanna generate the SSAO texture
	local cpx, cpy, cpz = spGetCameraPosition()
	glUseShader(ssaoShader)
		glUniform(eyePosLoc, cpx, cpy, cpz)
		glUniformMatrix(viewMatLoc, "view")
		glUniformMatrix(projectionMatLoc, "projection")
		glUniformMatrix(projectionMatInvLoc, "projectioninverse")
		-- For some reason, gl.UniformArray is not working in 104.0. On the
		-- other hand, future spring versions will mover to GL 4.X, where all
		-- this stuff will be deprecated, so not worth investigating/fixing,
		-- better working around...
		glUniformMatrix(samplesXLoc,
            samplesX[1],  samplesX[2],  samplesX[3],  samplesX[4],
            samplesX[5],  samplesX[6],  samplesX[7],  samplesX[8],
            samplesX[9],  samplesX[10], samplesX[11], samplesX[12],
            samplesX[13], samplesX[14], samplesX[15], samplesX[16])
		glUniformMatrix(samplesYLoc,
            samplesY[1],  samplesY[2],  samplesY[3],  samplesY[4],
            samplesY[5],  samplesY[6],  samplesY[7],  samplesY[8],
            samplesY[9],  samplesY[10], samplesY[11], samplesY[12],
            samplesY[13], samplesY[14], samplesY[15], samplesY[16])
		glUniformMatrix(samplesZLoc,
            samplesZ[1],  samplesZ[2],  samplesZ[3],  samplesZ[4],
            samplesZ[5],  samplesZ[6],  samplesZ[7],  samplesZ[8],
            samplesZ[9],  samplesZ[10], samplesZ[11], samplesZ[12],
            samplesZ[13], samplesZ[14], samplesZ[15], samplesZ[16])
		glUniform(noiseScaleLoc, vsx / 4.0, vsy / 4.0)
		glTexture(0, normalTex)
		glTexture(1, depthTex)
		glTexture(2, noiseTex)

		glRenderToTexture(ssaoTex, glTexRect, -1, 1, 1, -1)

		glTexture(0, false)
		glTexture(1, false)
		glTexture(2, false)
	glUseShader(0)

	-- Which should be blured
	glUseShader(blurShader)
		glUniform(texelSizeLoc, 1.0 / vsx, 1.0 / vsy)
		glTexture(0, ssaoTex)

		glRenderToTexture(blurTex, glTexRect, -1, 1, 1, -1)

		glTexture(0, false)
	glUseShader(0)
	
	-- Apply the SSAO to the rendered image
	glUseShader(renderShader)
		glTexture(0, depthTex)
		glTexture(1, blurTex)
		glTexture(2, colorTex)

		glTexRect(0, 0, vsx, vsy, false, true)

		glTexture(0, false)
		glTexture(1, false)
		glTexture(2, false)
	glUseShader(0)

	-- Debug
	--[[
	glTexture(ssaoTex)
	glTexRect(vsx/2, vsy/2, vsx, vsy, false, true)
	glTexture(false)
	--]]
end
