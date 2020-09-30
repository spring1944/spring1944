local Drawer = VFS.Include("LuaUI/Widgets/ranks/utilities/drawing.lua", nil, VFS.RAW_FIRST)
local IMAGE_DIRNAME = LUAUI_DIRNAME .. "Images/Ranks/"

----------------------------------------------------------------
--speedups
----------------------------------------------------------------
local sin, cos, tan = math.sin, math.cos, math.tan
local sqrt = math.sqrt
local rad = math.rad

local glCreateList = gl.CreateList
local glPushMatrix = gl.PushMatrix
local glPopMatrix = gl.PopMatrix
local glTranslate = gl.Translate
local glScale = gl.Scale
local glRotate = gl.Rotate
local glColor = gl.Color
local glTexture = gl.Texture
local glTexRect = gl.TexRect

----------------------------------------------------------------
--gl lists
----------------------------------------------------------------
local darkColor = {0.5, 0.5, 0.5}
local color = {0.75, 0.75, 0.75}
local highlightColor = {1, 1, 1}
local gold = {0.75, 0.75, 0}
local highlightGold = {1, 1, 0}

local function SmallPip(color, highlightColor)
    glPushMatrix()
        glScale(0.25, 0.25, 0.25)
        Drawer.DrawGEPip(color, highlightColor)
    glPopMatrix()
end

local function MediumPip(color, highlightColor)
    glPushMatrix()
        glScale(0.375, 0.375, 0.375)
        Drawer.DrawGEPip(color, highlightColor)
    glPopMatrix()
end

local function LargePip(color, highlightColor)
    glPushMatrix()
        glScale(0.5, 0.5, 0.5)
        Drawer.DrawGEPip(color, highlightColor)
    glPopMatrix()
end

local function Obershutze()
    LargePip(darkColor, highlightColor)
end

local function Gefreiter()
    
    local quadVertices = {
        {v = {-1, 1, 0}, c = color},
        {v = {-0.75, 1, 0}, c = color},
        {v = {0, -1, 0}, c = highlightColor},
        {v = {0, -0.5, 0}, c = highlightColor},
        {v = {1, 1, 0}, c = color},
        {v = {0.75, 1, 0}, c = color},
    }
    
    local lineVertices = {
        {v = {-1, 1, 0}},
        {v = {0, -1, 0}},
        {v = {1, 1, 0}},
        {v = {0.75, 1, 0}},
        {v = {0, -0.5, 0}},
        {v = {-0.75, 1, 0}},
    }
    
    glShape(GL_QUAD_STRIP, quadVertices)
    glColor(0, 0, 0, 1)
    glShape(GL_LINE_LOOP, lineVertices)
end

local function Obergefreiter()
    Gefreiter()
    
    local quadVertices = {
        {v = {-0.625, 1, 0}, c = color},
        {v = {-0.375, 1, 0}, c = color},
        {v = {0, -0.25, 0}, c = highlightColor},
        {v = {0, 0.25, 0}, c = highlightColor},
        {v = {0.625, 1, 0}, c = color},
        {v = {0.375, 1, 0}, c = color},
    }
    
    local lineVertices = {
        {v = {-0.625, 1, 0}},
        {v = {0, -0.25, 0}},
        {v = {0.625, 1, 0}},
        {v = {0.375, 1, 0}},
        {v = {0, 0.25, 0}},
        {v = {-0.375, 1, 0}},
    }
    
    glShape(GL_QUAD_STRIP, quadVertices)
    glColor(0, 0, 0, 1)
    glShape(GL_LINE_LOOP, lineVertices)
end

local function Stabsgefreiter()
    Obergefreiter()
    glPushMatrix()
        glTranslate(0, 1, 0)
        SmallPip(darkColor, highlightColor)
    glPopMatrix()
end

local function Unteroffizer()
    glPushMatrix()
        glScale(2, 2, 2)
        Drawer.DrawShoulder(color, highlightColor)
    glPopMatrix()
end

local function Unterfeldwebel()
    glPushMatrix()
        glScale(2, 2, 2)
        Drawer.DrawShoulder(color, highlightColor)
        Drawer.DrawShoulderBottom(color, highlightColor)
    glPopMatrix()
end

local function Feldwebel()
    Unterfeldwebel()
    glPushMatrix()
        glTranslate(0, -0.5, 0)
        SmallPip(darkColor, highlightColor)
    glPopMatrix()
end

local function Oberfeldwebel()
    Unterfeldwebel()
    glPushMatrix()
        SmallPip(darkColor, highlightColor)
        glTranslate(0, -1, 0)
        SmallPip(darkColor, highlightColor)
    glPopMatrix()
end

local function Stabsfeldwebel()
    Unterfeldwebel()
    glPushMatrix()
        SmallPip(darkColor, highlightColor)
        glTranslate(-0.375, -1, 0)
        SmallPip(darkColor, highlightColor)
        glTranslate(0.75, 0, 0)
        SmallPip(darkColor, highlightColor)
    glPopMatrix()
end

local function Leutnant()
    glPushMatrix()
        glScale(2, 2, 2)
        Drawer.DrawShoulderFull(color, highlightColor)
    glPopMatrix()
end

local function Oberleutnant()
    Leutnant()
    glPushMatrix()
        glTranslate(0, -0.5, 0)
        MediumPip(gold, highlightGold)
    glPopMatrix()
end

local function Hauptman()
    Leutnant()
    glPushMatrix()
        MediumPip(gold, highlightGold)
        glTranslate(0, -1, 0)
        MediumPip(gold, highlightGold)
    glPopMatrix()
end

local function Major()
    glPushMatrix()
        glScale(2, 2, 2)
        Drawer.DrawEpaulette(color, highlightColor, color, highlightColor, 8)
    glPopMatrix()
end

local function Oberstleutnant()
    Major()
    glPushMatrix()
        glTranslate(0, -0.25, 0)
        SmallPip(gold, highlightGold)
    glPopMatrix()
end

local function Oberst()
    Major()
    glPushMatrix()
        glTranslate(0, -0.75, 0)
        SmallPip(gold, highlightGold)
        glTranslate(0, 1, 0)
        SmallPip(gold, highlightGold)
    glPopMatrix()
end

local function Generalmajor()
    glPushMatrix()
        glScale(2, 2, 2)
        Drawer.DrawEpaulette(gold, highlightGold, color, highlightColor, 8)
    glPopMatrix()
end

local function Generalleutnant()
    Generalmajor()
    glPushMatrix()
        glTranslate(0, -0.25, 0)
        SmallPip(darkColor, highlightColor)
    glPopMatrix()
end

local function General()
    Generalmajor()
    glPushMatrix()
        glTranslate(0, -0.75, 0)
        SmallPip(darkColor, highlightColor)
        glTranslate(0, 1, 0)
        SmallPip(darkColor, highlightColor)
    glPopMatrix()
end

local function Generaloberst()
    Generalmajor()
    glPushMatrix()
        glTranslate(0, 0.25, 0)
        SmallPip(darkColor, highlightColor)
        glTranslate(-0.25, -1, 0)
        SmallPip(darkColor, highlightColor)
        glTranslate(0.5, 0, 0)
        SmallPip(darkColor, highlightColor)
    glPopMatrix()
end

return {
    name = "us",
    lists = {
        {0.2, glCreateList(Obershutze)},
        {0.5, glCreateList(Gefreiter)},
        {0.75, glCreateList(Obergefreiter)},
        {1, glCreateList(Stabsgefreiter)},
        {1.5, glCreateList(Unteroffizer)},
        {2, glCreateList(Unterfeldwebel)},
        {3, glCreateList(Feldwebel)},
        {5, glCreateList(Oberfeldwebel)},
        {8, glCreateList(Stabsfeldwebel)},
        {12, glCreateList(Leutnant)},
        {20, glCreateList(Oberleutnant)},
        {25, glCreateList(Hauptman)},
        {30, glCreateList(Major)},
        {35, glCreateList(Oberstleutnant)},
        {40, glCreateList(Oberst)},
        {45, glCreateList(Generalmajor)},
        {50, glCreateList(Generalleutnant)},
        {60, glCreateList(General)},
        {80, glCreateList(Generaloberst)},
        --{100, glCreateList(Generalfeldmarschall)},
    },
}
