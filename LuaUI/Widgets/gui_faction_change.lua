
function widget:GetInfo()
    return {
        name    = 'Faction Change',
        desc    = 'Adds button to switch faction',
        author    = 'Niobium (addapted to s44 by Jose Luis Cercos-Pita)',
        date    = 'May 2011',
        license    = 'GNU GPL v2',
        layer    = -100,
        enabled    = true,
    }
end

--------------------------------------------------------------------------------
-- Var
--------------------------------------------------------------------------------
local wWidth, wHeight = Spring.GetWindowGeometry()
local px, py = 50, 0.55*wHeight

--------------------------------------------------------------------------------
-- Speedups
--------------------------------------------------------------------------------
local teamList = Spring.GetTeamList()
local myTeamID = Spring.GetMyTeamID()

local glTexCoord = gl.TexCoord
local glVertex = gl.Vertex
local glColor = gl.Color
local glRect = gl.Rect
local glTexture = gl.Texture
local glTexRect = gl.TexRect
local glDepthTest = gl.DepthTest
local glBeginEnd = gl.BeginEnd
local GL_QUADS = GL.QUADS
local GL_TRIANGLE_FAN = GL.TRIANGLE_FAN
local glPushMatrix = gl.PushMatrix
local glPopMatrix = gl.PopMatrix
local glTranslate = gl.Translate
local glBeginText = gl.BeginText
local glEndText = gl.EndText
local glText = gl.Text
local glCallList = gl.CallList
local glCreateList = gl.CreateList
local glDeleteList = gl.DeleteList

local spGetTeamStartPosition = Spring.GetTeamStartPosition
local spGetTeamInfo = Spring.GetTeamInfo
local spGetTeamRulesParam = Spring.GetTeamRulesParam
local spSetTeamRulesParam = Spring.SetTeamRulesParam
local spGetGroundHeight = Spring.GetGroundHeight
local spSendLuaRulesMsg = Spring.SendLuaRulesMsg
local spGetSpectatingState = Spring.GetSpectatingState
-- local spGetSideData = Spring.GetSideData  -- Overloaded by a custom sidedata

local amNewbie = (spGetTeamRulesParam(myTeamID, 'isNewbie') == 1)
local mySide = select(5, spGetTeamInfo(myTeamID))

local factionChangeList

local RADIUS = 128

local SIDEDATA = {
    [1] = {
        sideName = "random team (gm)",
    },
}

local N_AXIS = 0
local N_ALLIES = 0
local N_NEUTRAL = 0
local factions = VFS.Include("gamedata/sidedata.lua")
-- Parse axis forces
for _, faction in ipairs(factions) do
    if faction.alliance and faction.alliance == "axis" then
        SIDEDATA[#SIDEDATA + 1] = {
            sideName = string.lower(faction.name),
        }
        N_AXIS = N_AXIS + 1
    end
end
-- Parse allies forces
for _, faction in ipairs(factions) do
    if faction.alliance and faction.alliance == "allies" then
        SIDEDATA[#SIDEDATA + 1] = {
            sideName = string.lower(faction.name),
        }
        N_ALLIES = N_ALLIES + 1
    end
end
-- Parse neutral forces
for _, faction in ipairs(factions) do
    if (faction.alliance == nil) or (faction.alliance == "neutral") then
        SIDEDATA[#SIDEDATA + 1] = {
            sideName = string.lower(faction.name),
        }
        N_NEUTRAL = N_NEUTRAL + 1
    end
end

--------------------------------------------------------------------------------
-- Functions
--------------------------------------------------------------------------------
local function QuadVerts(x, y, z, r)
    glTexCoord(0, 0); glVertex(x - r, y, z - r)
    glTexCoord(1, 0); glVertex(x + r, y, z - r)
    glTexCoord(1, 1); glVertex(x + r, y, z + r)
    glTexCoord(0, 1); glVertex(x - r, y, z + r)
end

function spGetSideData()
    return SIDEDATA
end

function getTeamName()
    local side = mySide
    if side == "" then
        side = "random team (gm)"
    end
    return side
end

function getTeamNumber()
    local side = getTeamName()
    local sidedata = spGetSideData()
    for i=1,#sidedata do
        if side == sidedata[i].sideName then
            return i
        end
    end

    -- Error, return 0, and let's see
    return 0
end

function getTeamNameByNumber(teamNum)
    local sidedata = spGetSideData()
    while teamNum < 1 do
        teamNum = teamNum + #sidedata
    end
    while teamNum > #sidedata do
        teamNum = teamNum - #sidedata
    end

    local side = sidedata[teamNum].sideName
    -- Convert the "OVNI" into a random team
    if side == "random team (gm)" then
        side = ""
    end
    return side
end

function readAll(file)
    local f = io.open(file, "rb")
    local content = f:read("*all")
    f:close()
    return content
end

--------------------------------------------------------------------------------
-- Callins
--------------------------------------------------------------------------------
function widget:Initialize()
    if spGetSpectatingState() or
       Spring.GetGameFrame() > 0 or
       amNewbie then
        widgetHandler:RemoveWidget(self)
        return
    end
    -- Check that game_setup.lua has a faction already set
    spSendLuaRulesMsg('\138' .. mySide)
end

function widget:DrawWorld()
    glColor(1, 1, 1, 0.5)
    glDepthTest(false)
    for i = 1, #teamList do
        local teamID = teamList[i]
        local tsx, tsy, tsz = spGetTeamStartPosition(teamID)
        if tsx and tsx > 0 then
            local side = spGetTeamRulesParam(teamID, 'side')
            if side == "" or side == 0 or side == nil then
                -- No idea why it takes 0 value after choosing random team...
                side = "random team (gm)"
            end
            glTexture('LuaUI/Widgets/faction_change/' .. side .. '.png')
            glBeginEnd(GL_QUADS, QuadVerts, tsx, spGetGroundHeight(tsx, tsz), tsz, 80)
        end
    end
    glTexture(false)
end

function widget:DrawScreen()

    -- Spectator check
    if spGetSpectatingState() then
        widgetHandler:RemoveWidget(self)
        return
    end

    -- Positioning
    glPushMatrix()
    glTranslate(px, py, 0)
    --call list
    if factionChangeList then
        glCallList(factionChangeList)
    else 
        factionChangeList = glCreateList(FactionChangeList)
    end
    glPopMatrix()

    
end

function DrawCircle(a0, a1, n)
    local da = a1 - a0
    local r = RADIUS
    glVertex(r, r)

    for i=0,n do
        local a = a0 + i * da / n
        glVertex(
            r + (r * math.sin(a)), 
            r + (r * math.cos(a))
        )
    end
end

function FactionChangeList()
    -- Panel (Divided in Axis/Allies/Neutral)
    local sidedata = spGetSideData()
    local n = #sidedata
    local da = 2.0 * math.pi / (n - 1)  -- Random is placed at mid
    local a0 = 0.5 * N_NEUTRAL * da     -- Neutrals are placed at top
    local a1 = a0 + N_AXIS * da
    glColor(0.5, 0, 0, 0.5)
    glBeginEnd(GL_TRIANGLE_FAN, DrawCircle, a0, a1, N_AXIS * 4)
    local a0 = a1
    local a1 = a0 + N_ALLIES * da
    glColor(0, 0, 0.5, 0.5)
    glBeginEnd(GL_TRIANGLE_FAN, DrawCircle, a0, a1, N_ALLIES * 4)
    local a0 = a1
    local a1 = a0 + N_NEUTRAL * da
    glColor(0, 0, 0, 0.5)
    glBeginEnd(GL_TRIANGLE_FAN, DrawCircle, a0, a1, N_NEUTRAL * 4)

    -- Place random at mid
    local selTeam = getTeamNumber()
    local R = RADIUS
    local r = math.pi * R / (n - 1)
    glColor(1, 1, 1, 1)
    glTexture('LuaUI/Widgets/faction_change/' .. sidedata[1].sideName .. '.png')
    glTexRect(R - 0.5 * r, R - 0.5 * r,
              R + 0.5 * r, R + 0.5 * r)
    glTexture(false)
    if selTeam == 1 then
        glTexture('LuaUI/Widgets/faction_change/Selected Team.png')
        glTexRect(R - 0.5 * r, R - 0.5 * r,
                  R + 0.5 * r, R + 0.5 * r)
        glTexture(false)
    end
    -- And the rest of factions all around
    local a0 = 0.5 * (N_NEUTRAL + 1) * da  -- Neutrals are placed at top
    for i=2,n do
        local ii = i - 2
        x = R + ((R - 0.7 * r) * math.sin(a0 + ii * 2.0 * math.pi / (n - 1)))
        y = R + ((R - 0.7 * r) * math.cos(a0 + ii * 2.0 * math.pi / (n - 1)))
        glTexture('LuaUI/Widgets/faction_change/' .. sidedata[i].sideName .. '.png')
        glTexRect(x - 0.5 * r, y - 0.5 * r,
                  x + 0.5 * r, y + 0.5 * r)
        glTexture(false)
        if selTeam == i then
            glTexture('LuaUI/Widgets/faction_change/Selected Team.png')
            glTexRect(x - 0.5 * r, y - 0.5 * r,
                      x + 0.5 * r, y + 0.5 * r)
            glTexture(false)
        end
    end
end



function widget:MousePress(mx, my, mButton)

    -- Check we are on the circle
    local R = RADIUS
    local rx = mx - (px + R)
    local ry = my - (py + R)
    if rx*rx + ry*ry >= R*R then
        return
    end

    if (mButton == 2 or mButton == 3) then
        -- Dragging
        return true
    end

    -- Spectator check before any action
    if spGetSpectatingState() then
        widgetHandler:RemoveWidget(self)
        return false
    end

    -- Check if we are selecting a new team
    local sidedata = spGetSideData()
    local n = #sidedata
    local r = math.pi * R / (n - 1)
    if rx*rx + ry*ry <= 0.25 * R * R then
        -- That's the midddle faction (random team)
        mySide = getTeamNameByNumber(1)
        spSendLuaRulesMsg('\138' .. mySide)
        if factionChangeList then
            glDeleteList(factionChangeList)
        end
        factionChangeList = glCreateList(FactionChangeList)
        return true
    end

    -- Get the new team
    local da = 2.0 * math.pi / (n - 1)
    local a0 = 0.5 * N_NEUTRAL * da     -- Neutrals are placed at top
    local a = math.atan2(rx, ry) - a0
    if a < 0.0 then
        a = a + 2.0 * math.pi
    end
    local i = math.floor(a / da) + 2
    mySide = getTeamNameByNumber(i)
    spSendLuaRulesMsg('\138' .. mySide)
    if factionChangeList then
        glDeleteList(factionChangeList)
    end
    factionChangeList = glCreateList(FactionChangeList)
    return true
end

function widget:MouseMove(mx, my, dx, dy, mButton)
    -- Dragging
    if mButton == 2 or mButton == 3 then
        px = px + dx
        py = py + dy
    end
end

function widget:GameStart()
    widgetHandler:RemoveWidget(self)
end

