function gadget:GetInfo()
    return {
        name = "AI Heatmaps",
        desc = "Heatmaps provider for AIs",
        author = "Jose Luis Cercos-Pita",
        date = "2020-05-13",
        license = "GPL-v2",
        layer = 1,
        enabled = true
    }
end

if (gadgetHandler:IsSyncedCode()) then

--------------------------------------------------------------------------------
--  SYNCED ---------------------------------------------------------------------
--------------------------------------------------------------------------------

else

--------------------------------------------------------------------------------
--  UNSYNCED -------------------------------------------------------------------
--------------------------------------------------------------------------------

local MY_PLAYER_ID = Spring.GetMyPlayerID()

-- locals
local HEATMAPS_DEBUG = nil
local HEATMAPS_DEBUG_SIZE = 0.5
local DT = 0.0
local heatmaps = {}
local shader
local uni_dx, uni_dy, uni_dt, uni_diffusion, uni_heating

--------------------------------------------------------------------------------

function gadget.Log(...)
    Spring.Log(gadget:GetInfo().name, LOG.INFO, table.concat{...})
end

function gadget.Warning(...)
    Spring.Log(gadget:GetInfo().name, LOG.WARNING, table.concat{...})
end

function gadget.Error(...)
    Spring.Log(gadget:GetInfo().name, LOG.ERROR, table.concat{...})
end

local function SetDebug(cmd, line, words, player)
    if #words ~= 1 then
        Error("1 parameter expected, got " .. tostring(#words))
        return true
    elseif HEATMAPS_DEBUG == words[1] then
        HEATMAPS_DEBUG = nil
        Log("debug disabled")
        return true
    elseif words[1] == nil then
        HEATMAPS_DEBUG = nil
        return true
    elseif heatmaps[words[1]] == nil then
        Error("Cannot find a heatmap named '" .. words[1] .. "'")
        return true
    end
    
    HEATMAPS_DEBUG = words[1]
    Log("debug set to " .. HEATMAPS_DEBUG)

    return true
end

local function SetupCmdChangeAIDebug()
    local cmd, func, help
    cmd  = "ai_heatmaps"
    func = SetDebug
    help = " [name]: enable/disable AIs heatmaps debug"
    gadgetHandler:AddChatAction(cmd, func, help)
end

local function world2tex(x, z)
    return x / Game.mapSizeX, (Game.mapSizeZ - z) / Game.mapSizeZ
end

local function __new_heatmap(name, tsize, diffusion, heating)
    if name == "nil" then
        Error("Cannot create a heatmap with the reserved name '" .. name .. "'")
        return false
    end
    if heatmaps[name] ~= nil then
        Error("Already exists a heatmap named '" .. name .. "'")
        return false
    end
    local tile_size = math.floor(tsize)
    if tile_size <= 0 then
        Error("Invalid tile size, '" .. tostring(tsize) .. "'")
        return false
    end
    if diffusion <= 0 then
        Error("Invalid diffusion factor, '" .. tostring(diffusion) .. "'")
        return false
    end
    if heating <= 0 then
        Error("Invalid heating factor, '" .. tostring(heating) .. "'")
        return false
    end

    heatmaps[name] = {tile_size = tile_size,
                      diffusion = diffusion,
                      heating = heating,
                      sx = math.floor(Game.mapSizeX / tile_size),
                      sy = math.floor(Game.mapSizeZ / tile_size),
                      textures = {},
                      current_texture = 1,
                      pumps = {},
                      pump_tex = nil,
                      pumps_fbo = nil}

    for i = 1,3  do 
        local t = gl.CreateTexture(heatmaps[name].sx, heatmaps[name].sy, {
            fbo = true, min_filter = GL.NEAREST, mag_filter = GL.NEAREST,
            wrap_s = GL.CLAMP, wrap_t = GL.CLAMP,
        })
        if not t then
            Error("Failure creating heatmap texture")
            heatmaps[name] = nil
            return false
        end
        heatmaps[name].textures[i] = t
    end
    heatmaps[name].pump_tex = heatmaps[name].textures[3]
    heatmaps[name].pump_fbo = gl.CreateFBO({color0 = heatmaps[name].pump_tex})

    Log("New heatmap : '" .. name .. "'")
    SetDebug("ai_heatmaps", "ai_heatmaps " .. name, {name}, nil)

    return true
end

local function __set_pump(name, pump_name, x, z, q, r)
    if heatmaps[name] == nil then
        Error("Cannot find a heatmap named '" .. name .. "'")
        return false
    end
    local lx, ly = world2tex(x, z)
    local lr = (r or heatmaps[name].tile_size) / heatmaps[name].tile_size
    if lr < 1.0 then
        lr = 1.0
    end
    heatmaps[name].pumps[pump_name] = {x = lx, y = ly, q = q, r = lr}

    return true
end

local function __unset_pump(name, pump_name)
    if heatmaps[name] == nil then
        Error("Cannot find a heatmap named '" .. name .. "'")
        return false
    end
    if heatmaps[name].pumps[pump_name] == nil then
        Error("Cannot find a pump named '" .. pump_name .. "'")
        return false
    end
    heatmaps[name].pumps[pump_name] = nil

    return true
end

function gadget:Initialize()
    SetupCmdChangeAIDebug()

    shader = shader or gl.CreateShader({
        fragment = VFS.LoadFile("LuaRules\\Gadgets\\ai_heatmaps\\rsc\\diffusion.fs", VFS.ZIP),
        uniformInt = {T = 0, Q = 1},
    })
    if not shader then
        Error("Failure creating heatmap shader")
        Spring.Echo(gl.GetShaderLog())
        return
    end
    uni_dx = gl.GetUniformLocation(shader, "dx")
    uni_dy = gl.GetUniformLocation(shader, "dy")
    uni_dt = gl.GetUniformLocation(shader, "dt")
    uni_diffusion = gl.GetUniformLocation(shader, "diffusion")
    uni_heating = gl.GetUniformLocation(shader, "heating")

    GG.CreateAIHeatmap = __new_heatmap
    GG.SetAIHeatmapPump = __set_pump
    GG.UnsetAIHeatmapPump = __unset_pump

    -- Testing
    --[[
    __new_heatmap("testing", 64, 30.0, 10.0)
    __set_pump("testing", "pump1", Game.mapSizeX / 4.0, Game.mapSizeZ / 4.0, {r=1.0, g=0.8, b=0.6, a=1.0}, 8.0 * 64)
    __set_pump("testing", "pump2", Game.mapSizeX / 1.25, Game.mapSizeZ / 1.25, {r=0.0, g=0.4, b=0.2, a=1.0}, 64)
    __set_pump("testing", "pump3", Game.mapSizeX / 1.2499, Game.mapSizeZ / 1.24995, {r=1.0, g=0.0, b=0.0, a=1.0}, 64)
    __set_pump("testing", "pump4", Game.mapSizeX / 1.24, Game.mapSizeZ / 1.26, {r=0.0, g=0.0, b=0.5, a=1.0}, 8.0 * 64)
    SetDebug("ai_heatmaps", "ai_heatmaps testing", {"testing"}, nil)
    --]]
end

function gadget:Shutdown()
    gl.DeleteShader(shader)
    shader, uni_dx, uni_dy, uni_dt, uni_diffusion, uni_heating = nil, nil, nil, nil, nil, nil

    for name, heatmap in pairs(heatmaps) do
        for i = 1,2  do 
            gl.DeleteTexture(heatmap.textures[i] or "")
            gl.DeleteFBO(heatmap.pump_fbo);
        end
        heatmaps[name] = nil
    end
end

local t = nil
function gadget:Update()
    local _, speedFactor, paused = Spring.GetGameSpeed()
    if paused or t == nil then
        t = Spring.GetTimer()
        DT = 0.0
        return
    end
    DT = speedFactor * Spring.DiffTimers(Spring.GetTimer(), t)
    t = Spring.GetTimer()
end

function DrawPumpCircle(x, y, rx, ry, n)
    n = n or 8
    gl.Vertex(x, y)

    for i=0,n do
        local a = i * 2.0 * math.pi / n
        gl.Vertex(x + (rx * math.cos(a)), y + (ry * math.sin(a)))
    end
end

local function DrawPumpPoints(heatmap)
    for name, pump in pairs(heatmap.pumps) do
        if pump.r <= 1.42 then
            local q = pump.q
            if (type(q) == "number") then
                gl.Color(q, q, q, 1.0)
            else
                gl.Color(q.r, q.g, q.b, q.a)
            end
            gl.Vertex(2.0 * pump.x - 1.0, 2.0 * pump.y - 1.0, 0.0)
        end
    end
end

local function DrawPumps(heatmap)
    gl.BeginEnd(GL.POINTS, DrawPumpPoints, heatmap)

    for name, pump in pairs(heatmap.pumps) do
        if pump.r > 1.42 then
            local q = pump.q
            if (type(q) == "number") then
                gl.Color(q, q, q, 1.0)
            else
                gl.Color(q.r, q.g, q.b, q.a)
            end
            local rx, ry = pump.r / heatmap.sx, pump.r / heatmap.sy
            gl.BeginEnd(GL.TRIANGLE_FAN,
                        DrawPumpCircle,
                        2.0 * pump.x - 1.0, 2.0 * pump.y - 1.0,
                        rx, ry)
        end
    end
end

function gadget:DrawGenesis()
    if shader == nil then
        return
    end

    for name, heatmap in pairs(heatmaps) do
        -- Set the heat pumps texture
        local r, g, b, a = 0.0, 0.0, 0.0, 0.0
        if HEATMAPS_DEBUG == name then
            a = 1.0
        end

        gl.Blending(false);
        gl.Color(r, g, b, a)

        gl.PushMatrix();
        gl.LoadIdentity();

        gl.ActiveFBO(heatmap.pump_fbo, gl.Clear, GL.COLOR_BUFFER_BIT, r, g, b, a);
        gl.Blending("add");
        gl.ActiveFBO(heatmap.pump_fbo, DrawPumps, heatmap);
        gl.Blending(false);

        -- Solve the diffusion equation
        local next_texture
        if heatmap.current_texture == 1 then
            next_texture = 2
        else
            next_texture = 1
        end
        t_in = heatmap.textures[heatmap.current_texture]
        t_out = heatmap.textures[next_texture]

        gl.UseShader(shader)
            gl.Texture(0, t_in)
            gl.Texture(1, heatmap.pump_tex)
            -- The theoretical value for dx and dy is 1/text_size. However,
            -- using that value the offset can be so small than the method is
            -- fetching the same texel several times, impairing diffusion.
            -- Thus, we want to increase this value to something closer to 2
            -- pixels, but not too close
            gl.Uniform(uni_dx, 1.25 / heatmap.sx)
            gl.Uniform(uni_dy, 1.25 / heatmap.sy)
            gl.Uniform(uni_dt, DT)
            gl.Uniform(uni_diffusion, heatmap.diffusion)
            gl.Uniform(uni_heating, heatmap.heating)

            gl.RenderToTexture(t_out, gl.TexRect, -1, 1, 1, -1)

            gl.Texture(1, false)
            gl.Texture(0, false)
        gl.UseShader(0)

        gl.PopMatrix();

        heatmap.current_texture = next_texture

        heatmaps[name] = heatmap
    end
end

function gadget:DrawScreen()
    if HEATMAPS_DEBUG == nil or heatmaps[HEATMAPS_DEBUG] == nil then
        HEATMAPS_DEBUG = nil
        return
    end
    local heatmap = heatmaps[HEATMAPS_DEBUG]

    local aspect = heatmap.sy / heatmap.sx
    local ww, wh = Spring.GetWindowGeometry()
    local sx = HEATMAPS_DEBUG_SIZE * ww
    local sy = sx * aspect
    if sy > HEATMAPS_DEBUG_SIZE * wh then
        sy = HEATMAPS_DEBUG_SIZE * wh
        sx = sy / aspect
    end

    gl.Texture(heatmap.textures[heatmap.current_texture])
    -- gl.Texture(heatmap.pump_tex)
    gl.TexRect(0, 0, sx, sy, false, true)
    gl.Texture(false)
end

end
