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
local color = {1, 1, 0.25}
local highlightColor = {1, 1, 0.5}

local function PrivateFirstClass()
    Drawer.DrawTopChevron(color, highlightColor)
end

local function Corporal()
    PrivateFirstClass()
    glPushMatrix()
        glTranslate(0, 0.375, 0)
        PrivateFirstClass()
    glPopMatrix()
end

local function Sergeant()
    Corporal()
    glPushMatrix()
        glTranslate(0, 0.75, 0)
        PrivateFirstClass()
    glPopMatrix()
end

local function StaffSergeant()
    Sergeant()
    Drawer.DrawBottomChevron()
end

local function TechnicalSergeant()
    StaffSergeant()
    glPushMatrix()
        glTranslate(0, -0.375, 0)
        Drawer.DrawBottomChevron()
    glPopMatrix()
end

local function MasterSergeant()
    TechnicalSergeant()
    glPushMatrix()
        glTranslate(0, -0.75, 0)
        Drawer.DrawBottomChevron()
    glPopMatrix()
end

local function FirstSergeant()
    MasterSergeant()
    Drawer.DrawLozenge()
end

local function SecondLieutenant()
    glPushMatrix()
        glScale(1.25, 1.25, 1.25)
        Drawer.DrawVerticalBar({1, 1, 0.25}, {1, 1, 0.75})
    glPopMatrix()
end

local function FirstLieutenant()
    glPushMatrix()
        glScale(1.25, 1.25, 1.25)
        Drawer.DrawVerticalBar({0.5, 0.5, 0.5}, {1, 1, 1})
    glPopMatrix()
end

local function Captain()
    glPushMatrix()
        glTranslate(-0.75, 0, 0)
        FirstLieutenant()
        glTranslate(1.5, 0, 0)
        FirstLieutenant()
    glPopMatrix()
end

local function Major()
    glColor(1, 1, 1, 1)
    glTexture(IMAGE_DIRNAME .. "USMajor.png")
    glTexRect(-2, -2, 2, 2)
    glTexture(false)
end

local function LieutenantColonel()
    glColor(1, 1, 1, 1)
    glTexture(IMAGE_DIRNAME .. "USLtColonel.png")
    glTexRect(-2, -2, 2, 2)
    glTexture(false)
end

local function Colonel()
    glColor(1, 1, 1, 1)
    glTexture(IMAGE_DIRNAME .. "USColonel.png")
    glTexRect(-2, -2, 2, 2)
    glTexture(false)
end

local function BrigadierGeneral()
    Drawer.DrawStar({0.25, 0.25, 0.25}, {1, 1, 1})
end

local function MajorGeneral()
    glPushMatrix()
        glTranslate(-sin(rad(72)), 0, 0)
        BrigadierGeneral()
        glTranslate(sin(rad(72)) * 2, 0, 0)
        BrigadierGeneral()
    glPopMatrix()
end

local function LieutenantGeneral()
    glPushMatrix()
        glTranslate(0, 1, 0)
        BrigadierGeneral()
        glTranslate(0, -2, 0)
        MajorGeneral()
    glPopMatrix()
end

local function General()
    glPushMatrix()
        glTranslate(0, 1, 0)
        MajorGeneral()
        glTranslate(0, -2, 0)
        MajorGeneral()
    glPopMatrix()
end

local function GeneralOfTheArmy()
    local radius = (1 + sin(rad(18))) / sin(rad(126))
    glPushMatrix()
        for i=1,5 do
            glPushMatrix()
                glTranslate(0, radius, 0)
                Drawer.DrawStar({0.25, 0.25, 0.25}, {1, 1, 1})
            glPopMatrix()
            glRotate(72, 0, 0, 1)
        end
    glPopMatrix()
end

return {
    name = "us",
    lists = {
        {0.2, glCreateList(PrivateFirstClass)},
        {0.5, glCreateList(Corporal)},
        {0.75, glCreateList(Sergeant)},
        {1, glCreateList(StaffSergeant)},
        {1.5, glCreateList(TechnicalSergeant)},
        {2, glCreateList(MasterSergeant)},
        {3, glCreateList(FirstSergeant)},
        {5, glCreateList(SecondLieutenant)},
        {8, glCreateList(FirstLieutenant)},
        {12, glCreateList(Captain)},
        {20, 0, Major},
        {25, 0, LieutenantColonel},
        {30, 0, Colonel},
        {40, glCreateList(BrigadierGeneral)},
        {50, glCreateList(MajorGeneral)},
        {60, glCreateList(LieutenantGeneral)},
        {80, glCreateList(General)},
        {100, glCreateList(GeneralOfTheArmy)},
    },
}
