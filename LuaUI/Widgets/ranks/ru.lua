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
local darkRed = {0.75, 0, 0}
local red = {1, 0, 0}
local redHighlight = {1, 0.5, 0.5}
local function OneLine()
    glPushMatrix()
        glScale(1, 2, 1)
        Drawer.DrawVerticalLine(red, redHighlight)
    glPopMatrix()
end

local function TwoLines()
    glPushMatrix()
        glScale(1, 2, 1)
        glTranslate(-0.25, 0, 0)
        Drawer.DrawVerticalLine(red, redHighlight)
        glTranslate(0.5, 0, 0)
        Drawer.DrawVerticalLine(red, redHighlight)
    glPopMatrix()
end

local function SmallStar()
    glPushMatrix()
        glScale(0.5, 0.5, 0.5)
        Drawer.DrawStar({0.25, 0.25, 0.25}, {1, 1, 1})
    glPopMatrix()
end

local function MediumStar()
    Drawer.DrawStar(darkRed, red)
end

local function LargeStar()
    glPushMatrix()
        glScale(3, 3, 3)
        Drawer.DrawStar(darkRed, red)
    glPopMatrix()
end

local function Corporal()
    Drawer.DrawHorizontalLine(red, redHighlight)
end

local function JuniorSergeant()
    Corporal()
    glPushMatrix()
        glTranslate(0, -0.375, 0)
        Corporal()
    glPopMatrix()
end

local function Sergeant()
    JuniorSergeant()
    glPushMatrix()
        glTranslate(0, -0.75, 0)
        Corporal()
    glPopMatrix()
end

local function SeniorSergeant()
    Sergeant()
    glPushMatrix()
        glTranslate(0, -0.75, 0)
        Corporal()
    glPopMatrix()
end

local function SergeantMajor()
    SeniorSergeant()
    glPushMatrix()
        glTranslate(0, -2, 0)
        Drawer.DrawVerticalLine(red, redHighlight)
    glPopMatrix()
end

local function JuniorLieutenant()
    OneLine()
    SmallStar()
end

local function Lieutenant()
    OneLine()
    
    glPushMatrix()
        glTranslate(-0.75, 0, 0)
        SmallStar()
        glTranslate(1.5, 0, 0)
        SmallStar()
    glPopMatrix()
end

local function SeniorLieutenant()
    OneLine()
    glPushMatrix()
        glTranslate(0, 0.5, 0)
        SmallStar()
        glTranslate(-0.75, -1, 0)
        SmallStar()
        glTranslate(1.5, 0, 0)
        SmallStar()
    glPopMatrix()
end

local function Captain()
    OneLine()
    glPushMatrix()
        glTranslate(0, 0, 0)
        SmallStar()
        glTranslate(0, 1, 0)
        SmallStar()
        glTranslate(-0.75, -2, 0)
        SmallStar()
        glTranslate(1.5, 0, 0)
        SmallStar()
    glPopMatrix()
end

local function Major()
    TwoLines()
    SmallStar()
end

local function LieutenantColonel()
    TwoLines()
    
    glPushMatrix()
        glTranslate(-0.75, 0, 0)
        SmallStar()
        glTranslate(1.5, 0, 0)
        SmallStar()
    glPopMatrix()
end

local function Colonel()
    TwoLines()
    
    glPushMatrix()
        glTranslate(0, 0.5, 0)
        SmallStar()
        glTranslate(-0.75, -1, 0)
        SmallStar()
        glTranslate(1.5, 0, 0)
        SmallStar()
    glPopMatrix()
end

local function MajorGeneral()
    MediumStar()
end

local function LieutenantGeneral()
    glPushMatrix()
        glTranslate(0, -1, 0)
        MediumStar()
        glTranslate(0, 2, 0)
        MediumStar()
    glPopMatrix()
end

local function ColonelGeneral()
    glPushMatrix()
        glTranslate(0, -2, 0)
        MediumStar()
        glTranslate(0, 2, 0)
        MediumStar()
        glTranslate(0, 2, 0)
        MediumStar()
    glPopMatrix()
end

local function GeneralOfTheArmy()
    glPushMatrix()
        glTranslate(0, -3, 0)
        MediumStar()
        glTranslate(0, 2, 0)
        MediumStar()
        glTranslate(0, 2, 0)
        MediumStar()
        glTranslate(0, 2, 0)
        MediumStar()
    glPopMatrix()
end

local function Marshal()
    LargeStar()
end

local function ChiefMarshal()
    glColor(1, 1, 1, 1)
    glTexture(IMAGE_DIRNAME .. "RUWreath.png")
    glTexRect(-3, -3, 3, 3)
    glTexture(false)
    LargeStar()
end

local function MarshalOfTheSovietUnion()
    glColor(1, 1, 1, 1)
    glTexture(IMAGE_DIRNAME .. "RUMarshal.png")
    glTexRect(-3, -3, 3, 3)
    glTexture(false)
end

return {
    name = "ru",
    lists = {
        {0.2, glCreateList(Corporal)},
        {0.5, glCreateList(JuniorSergeant)},
        {0.75, glCreateList(Sergeant)},
        {1, glCreateList(SeniorSergeant)},
        {1.5, glCreateList(SergeantMajor)},
        {2, glCreateList(JuniorLieutenant)},
        {3, glCreateList(Lieutenant)},
        {5, glCreateList(SeniorLieutenant)},
        {8, glCreateList(Captain)},
        {12, glCreateList(Major)},
        {20, glCreateList(LieutenantColonel)},
        {25, glCreateList(Colonel)},
        {30, glCreateList(MajorGeneral)},
        {35, glCreateList(LieutenantGeneral)},
        {40, glCreateList(ColonelGeneral)},
        {50, glCreateList(GeneralOfTheArmy)},
        {60, glCreateList(Marshal)},
        {80, 0, ChiefMarshal},
        {100, 0, MarshalOfTheSovietUnion},
    },
}
