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

local heatmaps_manager = nil

local MY_PLAYER_ID = Spring.GetMyPlayerID()
local HEATMAPS_DEBUG = nil
local HEATMAPS_DEBUG_SIZE = 0.5

local GL_COLOR_BUFFER_BIT = GL.COLOR_BUFFER_BIT
local GL_POINTS = GL.POINTS
local GL_TRIANGLE_FAN = GL.TRIANGLE_FAN

local glCreateTexture = gl.CreateTexture
local glCreateFBO = gl.CreateFBO
local glDeleteTexture = gl.DeleteTexture
local glDeleteFBO = gl.DeleteFBO
local glBlending = gl.Blending
local glColor = gl.Color
local glPushMatrix = gl.PushMatrix
local glLoadIdentity = gl.LoadIdentity
local glActiveFBO = gl.ActiveFBO
local glPopMatrix = gl.PopMatrix
local glClear = gl.Clear
local glVertex = gl.Vertex
local glBeginEnd = gl.BeginEnd
local glTexture = gl.Texture
local glTexRect = gl.TexRect
local glUseShader = gl.UseShader
local glRenderToTexture = gl.RenderToTexture
local glReadPixels = gl.ReadPixels

local spGetAllUnits = Spring.GetAllUnits
local spValidUnitID = Spring.ValidUnitID
local spGetUnitPosition = Spring.GetUnitPosition
local spGetWindowGeometry = Spring.GetWindowGeometry

local min, max = math.min, math.max
local floor = math.floor
local function clamp(v, vmin, vmax)
    return min(max(v, vmin), vmax)
end

--- DEBUG ----------------------------------------------------------------------

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
    elseif heatmaps_manager == nil then
        Error("No heatmaps manager has been built")
    elseif heatmaps_manager:GetHeatmap(words[1]) == nil then
        Error("Cannot find a heatmap named '" .. words[1] .. "'")
        return true
    end

    if HEATMAPS_DEBUG ~= nil and heatmaps_manager:GetHeatmap(HEATMAPS_DEBUG) ~= nil then
        heatmaps_manager:GetHeatmap(HEATMAPS_DEBUG).debug = false
    end

    HEATMAPS_DEBUG = words[1]
    heatmaps_manager:GetHeatmap(words[1]).debug = true
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

--- Utilities ------------------------------------------------------------------

local function DrawPoints(heat_objs)
    for _, data in ipairs(heat_objs) do
        if data.radius <= 1.42 then
            local c = data.color
            if (type(c) == "number") then
                glColor(c, c, c, 1.0)
            else
                glColor(c.r, c.g, c.b, c.a)
            end
            glVertex(2.0 * data.x_norm - 1.0, 2.0 * data.y_norm - 1.0, 0.0)
        end
    end
end

local function DrawCircle(x, y, rx, ry, n)
    n = n or 8
    glVertex(x, y)

    for i=0,n do
        local a = i * 2.0 * math.pi / n
        gl.Vertex(x + (rx * math.cos(a)), y + (ry * math.sin(a)))
    end
end

local function DrawObjs(heat_objs)
    gl.BeginEnd(GL_POINTS, DrawPoints, heat_objs)

    for _, data in ipairs(heat_objs) do
        if data.radius > 1.42 then
            local c = data.color
            if (type(c) == "number") then
                c = clamp(c, 0, 1)
                glColor(c, c, c, 1.0)
            else
                glColor(clamp(c.r, 0, 1),
                        clamp(c.g, 0, 1),
                        clamp(c.b, 0, 1),
                        clamp(c.a, 0, 1))
            end
            local rx, ry = data.rx_norm, data.ry_norm
            glBeginEnd(GL_TRIANGLE_FAN,
                        DrawCircle,
                        2.0 * data.x_norm - 1.0, 2.0 * data.y_norm - 1.0,
                        rx, ry)
        end
    end
end

local function world2tex(x, z)
    return x / Game.mapSizeX, (Game.mapSizeZ - z) / Game.mapSizeZ
end

--- Heatmaps manager -----------------------------------------------------------

HeatMap = {}
HeatMap.__index = HeatMap

function HeatMap:Create(tilesize)
    local heatmap = {}
    setmetatable(heatmap, HeatMap)
    heatmap.tilesize = (tilesize ~= nil) and tilesize or 256
    heatmap.sx = floor(Game.mapSizeX / heatmap.tilesize)
    heatmap.sy = floor(Game.mapSizeZ / heatmap.tilesize)
    heatmap.textures = {}
    heatmap.fbos = {}
    for i = 1,2 do
        heatmap.textures[i] = glCreateTexture(heatmap.sx, heatmap.sy, {
            fbo = true, min_filter = GL.NEAREST, mag_filter = GL.NEAREST,
            wrap_s = GL.CLAMP, wrap_t = GL.CLAMP,
        })
        heatmap.fbos[i] = glCreateFBO({color0 = heatmap.textures[i]})
    end
    heatmap.active_texture = 1   -- The one becoming drawn
    heatmap.has_texture = false  -- No texture has been drawn yet
    heatmap.debug = false

    -- Initialize the gradient computation shader
    shader = shader or gl.CreateShader({
        fragment = VFS.LoadFile("LuaRules/Gadgets/ai_heatmaps/rsc/gradient.fs", VFS.ZIP),
        uniformInt = {heatmap = 0},
        uniformFloat = {dx = 1.0 / heatmap.sx, dy = 1.0 / heatmap.sx}
    })
    if not shader then
        Error("Failure creating heatmap shader")
        Spring.Echo(gl.GetShaderLog())
        return nil
    end
    heatmap.grad_shader = shader
    heatmap.grad_texture = glCreateTexture(heatmap.sx, heatmap.sy, {
        fbo = true, min_filter = GL.NEAREST, mag_filter = GL.NEAREST,
        wrap_s = GL.CLAMP, wrap_t = GL.CLAMP,
    })

    return heatmap
end

function HeatMap:Destroy()
    for i = 1,2  do 
        glDeleteTexture(self.textures[i] or "")
        glDeleteFBO(self.fbos[i])
    end
    glDeleteTexture(self.grad_texture or "")
    gl.DeleteShader(self.grad_shader)
end

function HeatMap:SwapBuffer()
    -- Compute the new gradient texture
    glBlending(false);
    glPushMatrix();
    glLoadIdentity();

    glUseShader(shader)
        glTexture(0, self.textures[self.active_texture])
        glRenderToTexture(self.grad_texture, glTexRect, -1, 1, 1, -1)
        glTexture(0, false)
    glUseShader(0)

    glTexture(self.grad_texture)
    self.grad_value = glReadPixels(1, 1, self.sx, self.sy)
    glTexture(false)

    -- Swap the active texture
    self.active_texture = (self.active_texture == 1) and 2 or 1
    -- Clear the content
    local r, g, b, a = 0.0, 0.0, 0.0, 0.0
    if self.debug then
        a = 1.0
    end

    glColor(r, g, b, a)
    glActiveFBO(self.fbos[self.active_texture],
                glClear,
                GL_COLOR_BUFFER_BIT,
                r, g, b, a);

    glPopMatrix();
end

function HeatMap:Draw(heat_objs)
    if not self.has_texture then
        self:SwapBuffer()
    end
    self.has_texture = true

    glPushMatrix();
    glLoadIdentity();
    glBlending("add")
    glActiveFBO(self.fbos[self.active_texture],
                DrawObjs, heat_objs)
    glBlending(false)

    glPopMatrix()
end

function HeatMap:GetTexture()
    local finished = (self.active_texture == 1) and 2 or 1
    return self.textures[finished]
end

function HeatMap:GetGradientTexture()
    return self.grad_texture
end

function HeatMap:GetGradient(x, z)
    if self.grad_value == nil then
        return 0, 0
    end
    local u, v = world2tex(x, z)
    local i, j = min(floor(u * self.sx + 1), self.sx), min(floor(v * self.sy + 1), self.sy)
    local color = self.grad_value[i][j]
    return 2 * color[1] - 1, 2 * color[2] - 1
end


function HeatMap:ReadTexture(texture, x, z)
    local i, j = world2tex(x, z)

    glPushMatrix();
    glLoadIdentity();
    glTexture(texture)
    glReadPixels(floor(i * self.sx), floor(j * self.sy), 1, 1)
    glTexture(false)
    glPopMatrix()    
end

HeatmapManager = {}
HeatmapManager.__index = HeatmapManager

function HeatmapManager:Create(units_per_timestep)
    local manager = {}
    setmetatable(manager, HeatmapManager)
    manager.units_per_timestep = (units_per_timestep ~= nil) and units_per_timestep or 64
    manager.current_unit = 1
    manager.heatmaps = {}
    manager.callbacks = {}
    return manager
end

function HeatmapManager:Destroy()
    for name, heatmap in pairs(self.heatmaps)  do
        heatmap:Destroy()
    end
    self.heatmaps = {}
    self.callbacks = {}
end

-- The callback should be a function to which a unitID is sent, and is returing
-- a list of heat objects. Each heat object is featured by a color and a radius
-- in world space units
-- tilesize is optional (256 by default)
function HeatmapManager:AddHeatmap(name, callback, tilesize)
    self.heatmaps[name] = HeatMap:Create(tilesize)
    self.callbacks[name] = callback

    -- Testing
    -- SetDebug("ai_heatmaps", "ai_heatmaps " .. name, {name}, nil)
end

function HeatmapManager:GetHeatmap(name)
    return self.heatmaps[name]
end

function HeatmapManager:DestroyHeatmap(name)
    self.heatmaps[name]:Destroy()
    self.heatmaps[name] = nil
end

function HeatmapManager:__ParseUnit(unitID, out_obj)
    local x, y, z = spGetUnitPosition(unitID)
    x_norm, y_norm = world2tex(x, z)
    for name, f in pairs(self.callbacks) do
        local new_objs = f(unitID)
        for _, new_obj in ipairs(new_objs) do
            new_obj.x, new_obj.y, new_obj.z = x, y, z
            new_obj.x_norm, new_obj.y_norm = x_norm, y_norm
            local rx, ry = new_obj.radius / Game.mapSizeX, new_obj.radius / Game.mapSizeZ
            new_obj.rx_norm, new_obj.ry_norm = rx, ry
            out_obj[name][#out_obj[name] + 1] = new_obj
        end
    end
end

function HeatmapManager:Update()
    -- Parse the queried units
    local units = spGetAllUnits()

    local first_unit = self.current_unit
    local last_unit = math.min(first_unit + self.units_per_timestep - 1, #units)
    local heat_objs = {}
    for name, _ in pairs(self.heatmaps) do
        heat_objs[name] = {}
    end
    for i = first_unit, last_unit do
        local unitID = units[i]
        if spValidUnitID(unitID) then
            self:__ParseUnit(unitID, heat_objs)
        end
    end

    -- Apply the collected heat footprints
    for name, heatmap in pairs(self.heatmaps) do
        heatmap:Draw(heat_objs[name])
    end

    -- Check if the job is done
    self.current_unit = last_unit + 1
    if self.current_unit > #units then
        self.current_unit = 1
        for _, heatmap in pairs(self.heatmaps) do
            heatmap:SwapBuffer()
        end
    end
end

--- API ------------------------------------------------------------------------

function gadget:Initialize()
    SetupCmdChangeAIDebug()

    heatmaps_manager = HeatmapManager:Create()
    GG.HeatmapManager = heatmaps_manager
end

function gadget:Shutdown()
    heatmaps_manager:Destroy()
    GG.HeatmapManager = nil
end

function gadget:Update()
    -- heatmaps_manager:Update()
end

function gadget:DrawGenesis()
    heatmaps_manager:Update()
end

function gadget:DrawScreen()
    if HEATMAPS_DEBUG == nil then
        return
    end
    local heatmap = heatmaps_manager:GetHeatmap(HEATMAPS_DEBUG)

    local aspect = heatmap.sy / heatmap.sx
    local ww, wh = spGetWindowGeometry()
    local sx = HEATMAPS_DEBUG_SIZE * ww
    local sy = sx * aspect
    if sy > HEATMAPS_DEBUG_SIZE * wh then
        sy = HEATMAPS_DEBUG_SIZE * wh
        sx = sy / aspect
    end

    -- glTexture(heatmap:GetTexture())
    glTexture(heatmap:GetGradientTexture())
    glTexRect(0, 0, sx, sy, false, true)
    glTexture(false)
end

end
